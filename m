Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbYBDUbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbYBDUbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755870AbYBDUax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:30:53 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42266 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755822AbYBDUaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:30:52 -0500
Date: Mon, 4 Feb 2008 21:31:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: brk randomization breaks columns
Message-ID: <20080204203109.GA1545@elf.ucw.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <20080204130156.GA8730@elte.hu> <Pine.LNX.4.64.0802041528470.30955@jikos.suse.cz> <Pine.LNX.4.64.0802041635000.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802041635000.30955@jikos.suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-02-04 17:12:43, Jiri Kosina wrote:
> On Mon, 4 Feb 2008, Jiri Kosina wrote:
> 
> > I still don't seem to fully understand what is happening here -- 
> > aparently this is triggerable only with old programs linked against 
> > libc.so.5, and I am not able to trigger it with my trivial program when 
> > I link it against old libc.so.5, which just basically does brk() and 
> > checks whether /proc/<pid>/maps are OK. Seems to me that (at least 
> > certain versions) of libc.so.5 (wrongly) assume that end of the bss is 
> > the start of the heap, but I will try to investigate it more.
> 
> And I really think that (at least Pavel's version of) libc.so.5 is making 
> some strange assumptions about memory layout of the process, which could 
> also explain the other failures.
> 
> Pavel, could you please link the source code below against libc.so.5 with 
> brk randomization turned on, and show the output, and if it segfaults, 
> send the backtrace at the time of the crash? I suspect that it will crash 
> somewhere in exit path when calling .dtor functions, as it will try to 
> perform some cleanup in unmapped area. Thanks.
> 
> #include <unistd.h>
> #include <stdio.h>
> #include <stdlib.h>
> 
> int main()
> {
>         int *curr_brk = sbrk(0);
>         char command[1024];
> 
>         sprintf(command, "/bin/cat /proc/%d/maps", getpid());
> 
>         printf("brk set to %p\n", curr_brk);
>         system(command);
> 
>         brk(curr_brk + 0x00001000);
>         curr_brk = sbrk(0);
> 
>         printf("brk set to %p\n", curr_brk);
>         system(command);
>         exit(0);
> }

This one seems to work, even with randomization:

guest@amd:~$ gcc test2.c -nostdlib /lib/libc.so.5.4.33 -o test2
/usr/bin/ld: warning: cannot find entry symbol _start; defaulting to
0000000008048340
guest@amd:~$ ./test2
brk set to 0x8b1b000
08048000-08049000 r-xp 00000000 08:04 423985     /home/guest/test2
08049000-0804a000 rwxp 00000000 08:04 423985     /home/guest/test2
b7eb7000-b7eb8000 rwxp b7eb7000 00:00 0
b7eb8000-b7f3f000 r-xp 00000000 08:04 373330     /lib/libc.so.5.4.33
b7f3f000-b7f45000 rwxp 00086000 08:04 373330     /lib/libc.so.5.4.33
b7f45000-b7f78000 rwxp b7f45000 00:00 0
b7f92000-b7f95000 rwxp b7f92000 00:00 0
b7f95000-b7fb1000 r-xp 00000000 08:04 194956     /lib/ld-2.7.so
b7fb1000-b7fb3000 rwxp 0001b000 08:04 194956     /lib/ld-2.7.so
bf89e000-bf8b2000 rwxp bffeb000 00:00 0          [stack]
bf8b2000-bf8b3000 rw-p bffff000 00:00 0
ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]
brk set to 0x8b1f000
08048000-08049000 r-xp 00000000 08:04 423985     /home/guest/test2
08049000-0804a000 rwxp 00000000 08:04 423985     /home/guest/test2
08b1b000-08b1f000 rwxp 08b1b000 00:00 0          [heap]
b7eb7000-b7eb8000 rwxp b7eb7000 00:00 0
b7eb8000-b7f3f000 r-xp 00000000 08:04 373330     /lib/libc.so.5.4.33
b7f3f000-b7f45000 rwxp 00086000 08:04 373330     /lib/libc.so.5.4.33
b7f45000-b7f78000 rwxp b7f45000 00:00 0
b7f92000-b7f95000 rwxp b7f92000 00:00 0
b7f95000-b7fb1000 r-xp 00000000 08:04 194956     /lib/ld-2.7.so
b7fb1000-b7fb3000 rwxp 0001b000 08:04 194956     /lib/ld-2.7.so
bf89e000-bf8b2000 rwxp bffeb000 00:00 0          [stack]
bf8b2000-bf8b3000 rw-p bffff000 00:00 0
ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]
guest@amd:~$

But if I compile it on my system, test2 uses ld-linux.so.2, not
ld-linux.so.1. columns use ld-linux.so.1, but I can't compile binary
like that with my toolchain.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
