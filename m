Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbZGNM4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbZGNM4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 08:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZGNM4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 08:56:13 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:34260 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZGNM4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 08:56:12 -0400
Message-ID: <4A5C8068.6020203@monstr.eu>
Date: Tue, 14 Jul 2009 14:56:08 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, LTP <ltp-list@lists.sourceforge.net>
Subject: access_ok macor
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to solve one thing around access_ok macro.
Microblaze memory map is below
Text address for user app is 0x1000 0000
for library 0x4800 0000
and stack below 0xc000 0000


# cat /proc/1/maps
10000000-10106000 r-xp 00000000 00:01 379        /bin/busybox
10106000-10107000 rw-p 00106000 00:01 379        /bin/busybox
10107000-1012a000 rwxp 00000000 00:00 0          [heap]
48000000-4801c000 r-xp 00000000 00:01 400        /lib/ld-2.3.3.so
4801c000-4801e000 rw-p 0001b000 00:01 400        /lib/ld-2.3.3.so
4801e000-480ec000 r-xp 00000000 00:01 396        /lib/libm-2.3.3.so
480ec000-480ee000 rw-p 000ce000 00:01 396        /lib/libm-2.3.3.so
480ee000-4824c000 r-xp 00000000 00:01 390        /lib/libc-2.3.3.so
4824c000-4824f000 r--p 0015d000 00:01 390        /lib/libc-2.3.3.so
4824f000-48251000 rw-p 00160000 00:01 390        /lib/libc-2.3.3.so
48251000-48255000 rw-p 00000000 00:00 0
bfa38000-bfa4d000 rwxp 00000000 00:00 0          [stack]
#

I found that I can setup text base in binutils/ld/emulparam/elf32mb_linux.sh

The problem which I have is that if I run socketpair, getsockname, getpeername LTP
tests with invalid salen pointer there are addresses close to 0x0. Microblaze
has no text there and the sigsegv fault is generated.

This fault could be fixed by changed access_ok macro where I check bottom limit
at 0x1000 0000 too. After this change the LTP program not failed but I am not sure
if is the right solution because none arch do it. All archs just check upper limit
not lower.

What is the correct solution for it? Moving .text base to 0x0 or is there any other
elegant solution?

Thanks,
Michal




-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
