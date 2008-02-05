Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbYBELG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbYBELG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 06:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbYBELGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 06:06:18 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43004 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753846AbYBELGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 06:06:17 -0500
Date: Tue, 5 Feb 2008 12:06:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Abel Bernabeu <abel.bernabeu@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Arjan van de Ven <arjan@infradead.org>
Subject: [regression] Re: brk randomization breaks columns
Message-ID: <20080205110632.GB3758@elf.ucw.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[some more CCs added]

> > Feb  4 12:29:32 amd kernel: columns-bin[4535]: segfault at 8052000 ip b7f08a9a sp bfb79628 error 6 in
> > libc.so.5.4.33[b7e99000+87000]
> > Just before death, 
> > root@amd:~# cat /proc/4537/maps
> > 08048000-08050000 r-xp 00000000 08:04 246209 /usr/local/bin/columns-bin
> > 08050000-08051000 rwxp 00007000 08:04 246209 /usr/local/bin/columns-bin
> > 08051000-08052000 rwxp 08051000 00:00 0
> > b7f00000-b7f87000 r-xp 00000000 08:04 373330     /lib/libc.so.5.4.33
> > b7f87000-b7f8d000 rwxp 00086000 08:04 373330     /lib/libc.so.5.4.33
> > b7f8d000-b7fc0000 rwxp b7f8d000 00:00 0
> > b7fdb000-b7fdc000 rwxp b7fdb000 00:00 0
> > b7fdc000-b7fe2000 r-xp 00000000 08:04 373339 /lib/ld-linux.so.1.9.11
> > b7fe2000-b7fe3000 rwxp 00005000 08:04 373339 /lib/ld-linux.so.1.9.11
> > bface000-bfae3000 rwxp bffeb000 00:00 0          [stack]
> > ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]
> > root@amd:~#
> 
> Actually, this clearly shows that either prehistoric libc.so.5 or the 
> program itself are broken. 

I believe it shows clear regression in latest 2.6.25 kernel.

> - as you can easily see by repeated invocation of your program, the 
>   arguments to brk() are always the same, no matter to what offset the brk 
>   start gets randomized.

> - i.e. the arguments passed to brk() strace shows clearly indicate that 
>   the binary (or library) is assuming that brk starts in the very next
>   page after code+bss (i.e. at the page following 0x08052000). That is wrong. 
>   The program then accessess unmapped memory, which causes segfault.

You say it is wrong. Manpages imply otherwise:

       int brk(void *end_data_segment);
...
DESCRIPTION
       brk()  sets  the  end  of  the  data  segment  to  the  value specified  by
       end_data_segment, when that value is reasonable, the system does have enough
       memory and the process does not exceed its max data size (see setrlimit(2)).
...

Note it talks about data segment, not about heap, and that seems to
imply that BSS and heap are actually one area. 2.6.25 broke that.

Now, maybe you are right and heap randomization is useful, but
breaking 10year old executables is no-no. (And you should have posted
man page update, too).

There are ways around this:

1) not enable heap randomization unless app asks for it by personality
syscall

or 

2) (hacky!) detect that app asks for brk() below its heap start, which
means it assumes BSS+heap are contiguous, and just map the memory there.

> > ...which is strange. Columns asked for brk, but kernel assigned it no
> > heap. No wonder columns are crashing.
> 
> Now, you are right that the return value from brk() is bogus in these 
> cases. The patch below should make it behave, as you can easily check with 
> strace, right? Does anyone have any comments regarding this patch
 > please?

Yep, will try, sound like a good idea.

> Still, it will probably not fix your particular program crashes, just 
> because it will always assume that brk starts immediately after the end of 
> the bss, which is plain wrong and has never been assured. Could you please 

Can you quote docs that tells me it is plain wrong? It was plain right
in BSD unix, and in all linuxes up to 2.6.25-git. My man pages still
imply it is right.

Hmm, and even the kernel code implies it is right.

								Pavel
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 8295577..1c3b48f 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -241,7 +241,7 @@ asmlinkage unsigned long sys_brk(unsigned long brk)
>  
>  	down_write(&mm->mmap_sem);
>  
> -	if (brk < mm->end_code)
> +	if (brk < mm->start_brk)
>  		goto out;
>  

You see? This assumed end_code == start_brk ;-).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
