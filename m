Return-Path: <linux-kernel-owner+w=401wt.eu-S934167AbZJITk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934167AbZJITk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 15:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934112AbZJITk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 15:40:27 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:53236 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271AbZJITk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 15:40:26 -0400
Message-ID: <4ACF9184.9040104@msgid.tls.msk.ru>
Date: Fri, 09 Oct 2009 23:39:48 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: wrong final bzImage build (regading #14270)
References: <4ACF460E.7000901@msgid.tls.msk.ru> <20091009145825.GE5311@lenovo>
In-Reply-To: <20091009145825.GE5311@lenovo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, some more to this.

It turns out dash's built-in echo command interprets \nnn octal
sequences by default, and there's no way to turn that off.  So,
for example, sed-zoffset command from arch/x86/boot/Makefile
(which includes \1 \2 etc substitutions for sed), when echoed
in verbose mode (V=1), produces.. interesting characters (with
ascii code 1 and 2).

It's not practival to replace V=1's echo with /bin/echo I think.

So I'd say it's not a bug in the build system after all, but
a bug in dash.  Well, at least this expanding-by-default didn't
trigger another very-difficult-to-find bug (hopefully), but it
has good potential.

I'll file a bug report against dash.

/mjt

> [Michael Tokarev - Fri, Oct 09, 2009 at 06:17:50PM +0400]
>> Ok, finally the mystery solved.  After a week of
>> digging.
>>
>> The original problem was titled "Cannot boot on
>> a PIII Celeron", and Rafael filed a bug #14270
>> for this.
>>
>> In short, what I observed was that a new kernel
>> (2.6.31) fails to boot on a PIII Celeron machine.
>> But changing just the CPU to plain PIII and voila,
>> it now works.  I don't know why it behaved this
>> way, but I found where was the problem, finally.
>>
>> And the problem is in the last stage of build, when
>> building the bzImage.
>>
>> make -f scripts/Makefile.build obj=arch/x86/boot/compressed arch/x86/boot/compressed/vmlinux
>> ...
>>   (cat arch/x86/boot/compressed/vmlinux.bin | lzma -9 && echo -ne \\x38\\xd6\\x37\\x00) > arch/x86/boot/compressed/vmlinux.bin.lzma
>> ...
>>
>> Note the echo command.
>>
>> Now, Debian switched to dash as /bin/sh.  And dash
>> does not understand the -e option:
>>
>> $ dash -c 'echo -ne \\x38\\xd6\\x37\\x00' | od -x
>> 0000000 6e2d 2065 785c 3833 785c 3664 785c 3733
>> 0000020 785c 3030 000a
>>
>> $ bash -c 'echo -ne \\x38\\xd6\\x37\\x00' | od -x
>> 0000000 d638 0037
>>
>> So the final size (it's the size of uncompressed file)
>> becomes incorrect.  Here's what mkpiggy outputs for
>> this (in arch/x86/boot/compressed/piggy.S):
>>
>>  z_output_len = 170930296
>>
>> while it should be
>>
>>  z_output_len = 3659320
>>
>> And with the former (wrong, larger) size, the whole
>> thing just reboots on a PIII Celeron.  I've no idea
>> why, but the original problem is here.
>>
>> The same thing happens with bzip2 algorithm which is
>> not new, not only with lzma.
>>
>> The whole thing looks quite hackish to me, -- mkpiggy
>> can know the size from the original image just fine,
>> instead of getting it from the end of already compressed
>> file.
>>
>> For now, quick fix is to change echo to printf in there.
>> Correct fix is to re-write mkpiggy to look at the
>> original file for size (IMHO anyway).
>>
>> And this is a very good candidate for -stable as well.
>> The bug is very difficult to find.  And now when more
>> and more people who use Debian are switching to dash,
>> it will be more common.
>>
>> Thanks!

