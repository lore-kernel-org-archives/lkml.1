Return-Path: <linux-kernel-owner+w=401wt.eu-S1757738AbYLDBIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738AbYLDBIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 20:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbYLDBHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 20:07:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757540AbYLDBHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 20:07:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] processes: reparent_thread: don't call
	kill_orphaned_pgrp() if task_detached()
In-Reply-To: Oleg Nesterov's message of  Thursday, 20 November 2008 21:28:48 +0100 <20081120202848.GA27241@redhat.com>
References: <20081118175901.GA17134@redhat.com>
	<20081119185148.DC1D31544EB@magilla.localdomain>
	<m1skpncg2b.fsf@frodo.ebiederm.org>
	<20081120145234.GA3325@redhat.com>
	<m13ahm9slb.fsf@frodo.ebiederm.org>
	<20081120200050.GA24467@redhat.com>
	<20081120202848.GA27241@redhat.com>
X-Fcc: ~/Mail/linus
X-Shopping-List: (1) Graphic accusers
   (2) Diabolical itinerants
   (3) Virulent judicious insurgents
Message-Id: <20081204010658.15A93FC053@magilla.sf.frob.com>
Date: Wed,  3 Dec 2008 17:06:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Needs an ack from someone who understands orphaned groups.

I understand what the semantics are supposed to be.
But I'm getting a headache trying to see if I really understand the code.

> If task_detached(p) == T, then either
> 
> 	a) p is not the main thread, we will find the group leader
> 	   on the ->children list.

Correct.

> or
> 	b) p is the group leader but its ->exit_state = EXIT_DEAD.
> 	   This can only happen when the last sub-thread has died,
> 	   but in that case that thread has already called
> 	   kill_orphaned_pgrp() from exit_notify().

I think that's right too.

> @@ -816,6 +816,8 @@ static void reparent_thread(struct task_
>  
>  	list_move_tail(&p->sibling, &p->real_parent->children);
>  
> +	if (task_detached(p))
> +		return;

Seems like it would be cleaner to reorganize the code a little.
reparent_thread has only one caller.  How about we move:

	if (p->pdeath_signal)
		/* We already hold the tasklist_lock here.  */
		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);

	list_move_tail(&p->sibling, &p->real_parent->children);

into forget_original_parent and rename reparent_thread to something else,
called only:

	if (!task_detached(p) && !same_thread_group(p->real_parent, father))
		orphaned_process(p);


Thanks,
Roland
