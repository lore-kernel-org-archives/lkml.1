Return-Path: <linux-kernel-owner+w=401wt.eu-S936423AbXFGUs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936423AbXFGUs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759193AbXFGUss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:48:48 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:34258 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762138AbXFGUsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:48:47 -0400
Message-ID: <46686EFA.1030302@cosmosbay.com>
Date: Thu, 07 Jun 2007 22:47:54 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7> <20070606235906.72439d16@the-village.bc.nu> <alpine.LFD.0.98.0706071240150.4205@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706071240150.4205@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 07 Jun 2007 22:47:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds a écrit :
> 
> On Wed, 6 Jun 2007, Alan Cox wrote:
>> This still all seems really really ugly.
> 
> I do agree that it's ugly. That many new system calls with new prototypes 
> and new glibc support is just nasty.
> 
> So I don't think this is viable.
> 
>> Is there anything wrong with throwing all these extra cases out and 
>> replacing the entire lot with
>>
>> 	prctl(PR_SPARSEFD, 1);
>>
>> to turn on sparse fd allocation for a process ?
> 
> Yes. We really don't want to set global state that affects any random 
> library thing that runs after it.
> 
> HOWEVER.
> 
> I think we could introduce a *single* new system call, which does 
> basically a "run the specified system call with the following flags".
> 
> The flags would literally be local to that *one* system call, and one of 
> the flags could be the semantics for FD allocation.
> 
> [ There are a few other cases where such an indirect system call might be 
>   interesting: temporarily unmasking a signal for just the duration of a 
>   single system call is the reason for things like 'pselect()' and 
>   'sigtimedwait()', and similarly the 'access()' system call is basically 
>   a "temporarily run with my real UID, rather than the effective UID 
>   thing, and quite frankly, it might be perfectly valid to want to do an 
>   'open()' with that rule too, because "access()+open()" is racy! ]
> 
> So maybe the proper solution to this mess is *not* to add fifteen new 
> system calls, but to add *one*, which takes a "flags" value to set certain 
> things:
> 
>  - FD_NONSEQ: "allocate any new fd's nonsequentially"
>  - FD_CLOEXEC: "allocate any new fd's as close-on-exec"
> 
>    Rationale: allow people to open any fd with the flags set a certain 
>    way, regardless of the system call.
> 
>  - LOOKUP_REALUID/GID: "make the fsuid/fsgid temporarily be my _real_ 
>    uid/gid for this single system call"
> 
>    Rationale: avoid the inevitable races that the fundamentally broken 
>    "access()" system call has! 
> 
>  - LOOKUP_NOFOLLOW: "do not follow any symlink at the end of the path"
>    LOOKUP_NOATIME: "don't update atime"
> 
>    Rationale: "open()" already has O_NOFOLLOW/O_NOATIME, and "stat()" has 
>    "lstat()", but a lot of other path-handlign system calls cannot do the 
>    same thing.
> 
>  - LOOKUP_NOSYMLINKS: "do not allow any symlink traversal at *all*"
>    LOOKUP_NODOTDOT: "don't traverse a .. upwards"
>    LOOKUP_NOMOUNT: "don't traverse a mount point"
> 
>    Rationale: for security-conscious things, quite often it's not the 
>    _last_ symlink you want to avoid, it's any symlinks at all, and 
>    sometimes it's things like guaranteeing that you stay in a certain 
>    directory structure - which means not going outside with ".." or some 
>    magic mount-point.
> 
>    People currently literally end up traversing things one path component 
>    at a time, doing a "lstat()" on it, and checking. Even if 99% 
>    of the time you probably don't actually ever hit the problem case. 
>    (Eg Apache at some point used to do something like this if you asked 
>    for security, I'm not sure if it still does).
> 
>  - signal mask for temporarily blocking/unblocking during a single system 
>    call.
> 
>  - something else? The above are things that I know I _personally_ have 
>    occasionally cursed not having had.
> 
> What do people think about that kind of approach? It has the advantage 
> that it does *not* involve multiple kernel entries (just a single entry to 
> a small wrapper that sets some process state temporarily), and that it 
> doesn't have any sticky state that might confuse a library (or a signal 
> handler: even if you end up doing "prctrl(ON) ; syscall(); prctrl(OFF)", a 
> signal handler that happens in between the prctrl's would see unexpected 
> behaviour).
> 
> It has the disadvantage that it would need some per-architecture setup to 
> load the actual real arguments from memory: the system call would probably 
> look something like
> 
> 	syscall_indirect(unsigned long flags, sigset_t *, 
> 			 int syscall, unsigned long args[6]);
> 
> and the rule would be that it would just load the six system call 
> registers from that "args[]" array. Always load the full six registers, to 
> make it simpler and faster, and not having any confusion or ever needing 
> any wrappers that depend on the number of system calls.

This is a nice idea, but 32/64 compat code is going to hate it :)

syscall_indirect() would be writen in assembly for each arch, since there is 
no generic syscall table. Thats really a lot of work, especially if we want to 
mess with signal mask, umask ...


