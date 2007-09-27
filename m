Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbXI0ITi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbXI0ITi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 04:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbXI0ITa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 04:19:30 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:57125 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbXI0IT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 04:19:28 -0400
Message-ID: <46FB6820.2090708@Arcor.de>
Date: Thu, 27 Sep 2007 10:21:52 +0200
From: Henry Nestler <Henry.Ne@Arcor.de>
User-Agent: Thunderbird 1.5.0.13 (X11/20070809)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: kbuild: LDFLAGS_MODULE unusable for external module builds (2.6.23-rc2)
References: <46F8D9B8.3090806@Arcor.de> <20070925192250.GA14689@uranus.ravnborg.org> <46FA2CC0.2000204@Arcor.de> <20070926110130.GA20950@uranus.ravnborg.org> <46FA4313.1060201@Arcor.de>
In-Reply-To: <46FA4313.1060201@Arcor.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam,

Henry Nestler wrote:
> Sam Ravnborg wrote:
>>>>> What macro should set for linker parameters of foo.o ? I'm not shure.
>>>> Have you read:
>>>> Documentation/kbuild/makfilefiles.txt?
>> [...]
>>
>> If your example requires the LDFALGS_$@ I wil introduce it - for now
>> it has not been required (except for vdso support where it was hacked).
> 
> I will check EXTRA_LDFLAGS compatibilities with older kernel versions. 
> Than I come back with results. Currently I no need LDFLAGS_$@.
> 

Ok, EXTRA_LDFLAGS is good. I use it now.

To explain, a full example: function2 to function4 will be locate in
alternated directories A, B and than A again. Without --start-group,
function4 would be missing. That's why we need it.

>>> cat testing.sh >>>
rm -rf /tmp/test; mkdir /tmp/test; cd /tmp/test
mkdir A B

cat >Makefile <<EOF
obj-y := A/ B/
obj-m := module.o
module-objs := file1.o A/lib.a B/lib.a
EXTRA_LDFLAGS := --start-group # Solve circular references in archives
EOF

cat >A/Makefile <<EOF
lib-m := file2.o file4.o
EOF

cat >B/Makefile <<EOF
lib-m := file3.o
EOF

cat >file1.c <<EOF
#include <linux/module.h>
#include <linux/init.h>
void function2(void);
int init_module(void) {function2(); return 0;}
void cleanup_module(void) {return;}
EOF

cat >A/file2.c <<EOF
void function3(void);
void function2(void) {function3();}
EOF

cat >B/file3.c <<EOF
void function4(void);
void function3(void) {function4();}
EOF

cat >A/file4.c <<EOF
#include <linux/module.h>
void function4(void) {printk("done\n");}
EOF

make V=1 -C $HOME/kernel/linux-2.6.git2-smp-repg M=$PWD | grep " ld "
<<< end testing.sh <<<

Output is:
    ld -m elf_i386 -m elf_i386 --start-group -r -o /tmp/test/built-in.o
/tmp/test/A/built-in.o /tmp/test/B/built-in.o
   ld -m elf_i386 -m elf_i386 --start-group -r -o /tmp/test/module.o
/tmp/test/file1.o /tmp/test/A/lib.a /tmp/test/B/lib.a
   ld -m elf_i386 -r -m elf_i386   -o /tmp/test/module.ko
/tmp/test/module.o /tmp/test/module.mod.o


Currently can not put lib.a into EXTRA_LDFLAGS, because "--start-group
... lib.a --end-group" would bring the lib.a before the object list,
with more problems. The other is the path, that this needs. Example:

cat >Makefile <<EOF
obj-y := A/ B/
obj-m := module.o
module-objs := file1.o
EXTRA_LDFLAGS := --start-group \$(KBUILD_EXTMOD)/A/lib.a
\$(KBUILD_EXTMOD)/B/lib.a --end-group
EOF

Result from the make and grep ld:
ld -m elf_i386 -m elf_i386 --start-group /tmp/test/A/lib.a
/tmp/test/B/lib.a --end-group -r -o /tmp/test/module.o /tmp/test/file1.o
WARNING: "function2" [/tmp/test/module.ko] undefined!

Idea for future:
An 'APPEND_LDFLAGS' would be nice to append flags behind the last .o
object. Than can be close the group with --end-group.

Exactly linker call would be with grouping only archives, and the group
block behind the last object, for example:
ld -m elf_i386 -r -o module.o file1.o --start-group A/lib.a B/lib.a
--end-group

But remember: We can very good live with EXTRA_LDFLAGS, it's usable in
all 2.6 kernels.

Many thanks.

-- 
Henry

