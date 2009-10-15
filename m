Return-Path: <linux-kernel-owner+w=401wt.eu-S935463AbZJOUUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935463AbZJOUUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 16:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935384AbZJOUUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 16:20:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933196AbZJOUUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 16:20:10 -0400
Date: Thu, 15 Oct 2009 22:19:16 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Joerg.Abraham@alcatel-lucent.de, linux-kernel@vger.kernel.org
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-rt-users@vger.kernel.org
Subject: Re: 2.6.31.4-rt14 posix message queues problem
In-Reply-To: <alpine.LFD.2.00.0910152105430.8932@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0910152217390.3486@localhost.localdomain>
References: <4AD76126.1000408@alcatel-lucent.de> <520f0cf10910151202k2ba01453r10e96eeb064232e8@mail.gmail.com> <alpine.LFD.2.00.0910152105430.8932@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Oct 2009, John Kacur wrote:

> 
> > From: Joerg Abraham <Joerg.Abraham@alcatel-lucent.de>
> > Date: Thu, Oct 15, 2009 at 7:51 PM
> > Subject: 2.6.31.4-rt14 posix message queues problem
> > To: LKML <linux-kernel@vger.kernel.org>
> > 
> > 
> > Hi,
> > 
> > During some performance measurement I stumbled over unexpected bad
> > results for a posix message queue test case. Which is not surprising
> > since the kernel log shows a "BUG: scheduling while atomic:" on every
> > measurement trigger.
> > 
> > Attached is the kernel log for an embedded 8572ds powerpc system and a
> > condensed user space test appli. The test appli uses 2 processes
> > (mq_server and mq_client) and pingpongs some messages via posix
> > message queues. Please see the c-file header for details (the appli
> > itself makes not much sense but shows the problem).
> > 
> > ./mq_server
> > ./mq_client # just crashes during run
> > 
> > The problem does _not_ occur on kernels 2.6.29.6-rt24, 2.6.29.6
> > vanilla and 2.6.31.4 vanilla. The problem does _also_ show up on an
> > embedded x86_64 system and a full featured fc11 x86_64 system running
> > a 2.6.31.4-rt14 based kernel, so I dont think it's arch dependent.
> > 
> > Can anybody reproduce the crash ???
> > 
> > If you need more info's please let me know.
> > 
> > [And if I'm doing stupid things just forgive me]
> > 
> > Thanx
> > 
> > Joerg
> 
> Hello Joerg
> 
> Does the following patch solve your problem? 
> 
> From 69fde4357db4a054733cbca4158606160e821a3a Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Thu, 15 Oct 2009 20:52:37 +0200
> Subject: [PATCH] preempt_disable_rt(); should be paired with preempt_enable_rt()
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  ipc/mqueue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 63a47f7..ab4df36 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -830,7 +830,7 @@ static inline void pipelined_send(struct mqueue_inode_info *info,
>  	wake_up_process(receiver->task);
>  	smp_wmb();
>  	receiver->state = STATE_READY;
> -	preempt_enable_nort();
> +	preempt_enable_rt();
>  }
>  
>  /* pipelined_receive() - if there is task waiting in sys_mq_timedsend()
> -- 
> 1.6.0.6
> 
>
 
fyi: I completed my testing, and  I was able to reproduce your problem on 
v2.6.31.4-rt14, and it goes away with the above patch.

Cheers

John
