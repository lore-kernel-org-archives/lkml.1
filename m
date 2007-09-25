Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbXIYJt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbXIYJt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbXIYJtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:49:50 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:57448 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbXIYJtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:49:49 -0400
Message-ID: <46F8D9B8.3090806@Arcor.de>
Date: Tue, 25 Sep 2007 11:49:44 +0200
From: Henry Nestler <Henry.Ne@Arcor.de>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: kbuild: LDFLAGS_MODULE unusable for external module builds (2.6.23-rc2)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In reference of git 114f51577724b782a30f4f5ceaee9880de93d776:
>     kbuild: use LDFLAGS_MODULE only for .ko links
>     
>     Sam Ravnborg pointed out that Documentation/kbuild/makefiles.txt already
>     says this is what it's for.  This patch makes the reality live up to the
>     documentation.  This fixes the problem of LDFLAGS_BUILD_ID getting into too
>     many places.

LDFLAGS_MODULE is not usable in module build out of kernel tree since
2.6.23-rc2. LDFLAGS_$@ should use, but does never work. - Not for
external module builds with the option "M=..."

What macro should set for linker parameters of foo.o ? I'm not shure.
Currently found, that only LDFLAGS is usable. But, found LDFLAGS in
modpost calls, there also exist a --start-group/--end-group. Is it right
to use it for external module?

Here examples and the outputs. Host and target is an i686 SMP Linux.

mkdir /tmp/test; cd /tmp/test
cat >Makefile <<EOF
obj-m := name.o
name-objs := foo.o
# Use multipe defines, hope any would work
LDFLAGS_MODULE += --start-group
LDFLAGS_name += --start-group
LDFLAGS_name.o += --start-group
EOF

cat >foo.c <<EOF
#include <linux/module.h>
#include <linux/init.h>
int init_module(void) {return 0;}
void cleanup_module(void) {return;}
EOF

#2.6.22 works. LDFLAGS_MODULE was used:
make V=1 -C src/linux-2.6.22 M=$PWD | grep " ld "
  ld -m elf_i386 -m elf_i386  -r --start-group -o /tmp/name.o /tmp/foo.o
  ld -m elf_i386 -m elf_i386 -r -o /tmp/name.ko /tmp/name.o /tmp/name.mod.o

#2.6.23-rc7 does not work. Nothing from LDFLAGS can seen in linker line:
make V=1 -C src/linux-2.6.23-rc7 M=$PWD | grep " ld "
  ld -m elf_i386 -m elf_i386  -r -o /tmp/name.o /tmp/foo.o
  ld -m elf_i386 -r -m elf_i386   -o /tmp/name.ko /tmp/name.o
/tmp/name.mod.o

------
Perhaps anybody can give better idea for Makefile with
recursive depens of libraries? What I'm missing, is a setup for
--start-group AND the --end-group arrount the lib.a files. Currently 
--start-groups is somether before the first object and has no --end-group.

obj-y := dir1/ dir2/ dir3/
obj-m := name.ko
name-objs = foo.o dir1/lib.a dir2/lib.a dir3/lib.a
LDFLAGS += --start-group # Deal with recursive depens of libraries

-- 
Henry
