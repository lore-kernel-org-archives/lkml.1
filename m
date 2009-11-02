Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZKBPZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZKBPZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbZKBPZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:25:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54500 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324AbZKBPZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:25:32 -0500
Date: Mon, 2 Nov 2009 16:25:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
	external to a process (v7)
Message-ID: <20091102152520.GG23776@elte.hu>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091012161342.GA32088@hmsreliant.think-freely.org> <20091012201304.GG32088@hmsreliant.think-freely.org> <20091020005214.GA8886@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020005214.GA8886@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Neil Horman <nhorman@tuxdriver.com> wrote:

> Ok, I give.  I was hoping that some of the requestors of this feature 
> would pipe up and support the use case for the proc file interface to 
> set limits.  clearly they're not that interested, but I still think 
> theres merit in the patch.  So heres version 7 of this patch set.  Its 
> the same as before, but the proc interface has been dropped, leaving 
> only the syscall interface behind.  I've tested the interface on intel 
> 32 and 64 bit, with success
> 
> Summary:
> 
> Its been requested often that we have the ability to read and modify 
> process rlimit values from contexts external to the owning process.  
> Ideally this allows sysadmins to adjust rlimits on long running 
> processes wihout the need to stop and restart those processes, which 
> incurs undesireable downtime.  This patch enables that functionality, 
> It does so in two places.  First it enables process limit setting by 
> writing to the /proc/pid/limits file a string in the format: <limit> 
> <current limit> <max limit> > /proc/<pid>/limits where limit is one of 
> [as,core,cpu,data,fsize,locks,memlock,msgqueue,nice,nofile,nproc,rss,rtprio,rttime]
> 
> Secondly it allows for programatic setting of these limits via 2 new 
> syscalls, getprlimit, and setprlimit, which act in an identical 
> fashion to getrlimit and setrlimit respectively, except that they 
> except a process id as an extra argument, to specify the process id of 
> the rlimit values that you wish to read/write

This looks potentially useful but i think the implementation might be 
too optimistic, from a security POV.

Have you ensured that no rlimit gets propagated during task init into 
some other value - under the previously correct assumption that rlimits 
dont change asynchronously under the feet of tasks?

Also, there's SMP safety: right now all the accesses to 
current->signal->rlim[] are unlocked and assume that if we are executing 
in a syscall those values cannot change. Is this a safe assumption on 
all SMP architectures?

Plus, the locking looks structured in a weird way: why is the 
sighand-lock taken in the procfs code instead of moving it where the 
data structure is updated (the resource limits code).

Also, a patch submission observation: every single patch you submitted 
here had a messed up title that had a 'Re: ' in it, making it hard to 
sort out what is the latest. Some of the patches also had their 
changelog indented. Please use the standard patch submission methods.

So this patch-set needs more work.

Thanks,

	Ingo
