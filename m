Return-Path: <linux-kernel-owner+w=401wt.eu-S932482AbZHUQHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbZHUQHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 12:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932313AbZHUQHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 12:07:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932297AbZHUQHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 12:07:15 -0400
Date: Fri, 21 Aug 2009 09:05:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       a.p.zijlstra@chello.nl, catalin.marinas@arm.com,
       Jens Axboe <jens.axboe@oracle.com>, fweisbec@gmail.com,
       srostedt@redhat.com, tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [tip:tracing/urgent] tracing: Fix too large stack usage in
 do_one_initcall()
In-Reply-To: <tip-4a683bf94b8a10e2bb0da07aec3ac0a55e5de61f@git.kernel.org>
Message-ID: <alpine.LFD.2.01.0908210845540.3158@localhost.localdomain>
References: <new-submission> <tip-4a683bf94b8a10e2bb0da07aec3ac0a55e5de61f@git.kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So I obviously agree with fixing do_one_initcall(), but..

Looking at the other cases, I do note (once more) what a horrible thing 
SCSI is, and that the callchains are not only way too deep, but the SCSI 
routines stand out among the cases that have 100+ bytes of stack frame.

We _really_ should fix these:

>   5)     3444     116   __alloc_pages_nodemask+0xd7/0x550   
>  10)     3216     108   create_object+0x28/0x250
>  18)     2896     128   sd_prep_fn+0x332/0xa70
>  23)     2640     172   blk_execute_rq+0x6b/0xb0
>  46)     1532     108   scsi_add_lun+0x44b/0x460
>  47)     1424     116   scsi_probe_and_add_lun+0x182/0x4e0

I also note that in this case, we'd have gotten rid of a _lot_ of the 
callchain if we had actually just executed this thing asynchronously. 
Because we clearly have that __async_schedule() there in the callchain in 
two places: before the port probing and the disk probing.

But it looks like we hit the MAX_WORK limit. Which sounds odd, since that 
is set to 32768, but I guess it can happen. It sounds a bit unlikely. 
Ingo, do you have something set to disable that?

I do wonder, though. Maybe we should never have that MAX_WORK limit, and 
instead limit the parallelism by actively trying to yield when there's too 
much work? That bootup sequence _does_ tend to have deep callchains (with 
all the crazy device register crud), and maybe we should actively see the 
async work code as not just a way to speed up boot, but also as a way to 
avoid deep callchains.

Hmm?  Comments?

			Linus
