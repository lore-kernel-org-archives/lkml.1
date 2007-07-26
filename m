Return-Path: <linux-kernel-owner+w=401wt.eu-S935990AbXGZSfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935990AbXGZSfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933711AbXGZSfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:35:22 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:64402 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763152AbXGZSfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:35:20 -0400
Date: Thu, 26 Jul 2007 14:30:06 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ankita Garg <ankita@in.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, linux@bohmer.net,
       LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, zanussi@linux.vnet.ibm.com
Subject: Re: [Question] Hooks for scheduler tracing (CFS)
Message-ID: <20070726183006.GC10324@Krystal>
References: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com> <1184615557.2698.3.camel@laptopd505.fenrus.org> <20070726072858.GC13061@in.ibm.com> <20070726073520.GA12206@elte.hu> <20070726074957.GA19398@in.ibm.com> <20070726075353.GA19885@elte.hu> <20070726095948.GB19398@in.ibm.com> <20070726110504.GB7673@elte.hu> <20070726130632.GB28556@Krystal> <46A8DDD4.9090600@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46A8DDD4.9090600@us.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:28:33 up 9 days, 13:02,  3 users,  load average: 0.93, 1.73, 1.28
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* David J. Wilder (dwilder@us.ibm.com) wrote:
> 
> >I guess they might have to switch to such an asynchronous delivery
> >system if they want to do this properly. Simply put, your polling
> >solution is exactly what I do, but I check a flag set by the writer
> >instead of waking up the readers unconditionally.
> >
> >Mathieu
> >  
> 
> Ingo's solution could call waitqueue_active() inside wakeup_readers() to 
> determine if there are waiters. Right?
> 

Yes and no.. What would be part of it, but also checking if there are
buffers ready to be read would reduce the unnecessary polling even more.
Just checking for waiting readers would be rather inefficient in a
scenario of infrequent events where the readers are always waiting for
data; they would be awakened at every timer tick.

Mathieu


> >  
> >>	Ingo
> >>
> >>------------------------------------->
> >>Subject: relay: fix timer madness
> >>From: Ingo Molnar <mingo@elte.hu>
> >>
> >>remove timer calls (!!!) from deep within the tracing infrastructure.
> >>This was totally bogus code that can cause lockups and worse.
> >>Poll the buffer every 2 jiffies for now.
> >>
> >>Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >>---
> >> kernel/relay.c |   14 +++++---------
> >> 1 file changed, 5 insertions(+), 9 deletions(-)
> >>
> >>Index: linux-rt-rebase.q/kernel/relay.c
> >>===================================================================
> >>--- linux-rt-rebase.q.orig/kernel/relay.c
> >>+++ linux-rt-rebase.q/kernel/relay.c
> >>@@ -319,6 +319,10 @@ static void wakeup_readers(unsigned long
> >> {
> >> 	struct rchan_buf *buf = (struct rchan_buf *)data;
> >> 	wake_up_interruptible(&buf->read_wait);
> >>+	/*
> >>+	 * Stupid polling for now:
> >>+	 */
> >>+	mod_timer(&buf->timer, jiffies + 1);
> >> }
> >> 
> >> /**
> >>@@ -336,6 +340,7 @@ static void __relay_reset(struct rchan_b
> >> 		init_waitqueue_head(&buf->read_wait);
> >> 		kref_init(&buf->kref);
> >> 		setup_timer(&buf->timer, wakeup_readers, (unsigned long)buf);
> >>+		mod_timer(&buf->timer, jiffies + 1);
> >> 	} else
> >> 		del_timer_sync(&buf->timer);
> >> 
> >>@@ -604,15 +609,6 @@ size_t relay_switch_subbuf(struct rchan_
> >> 		buf->subbufs_produced++;
> >> 		buf->dentry->d_inode->i_size += buf->chan->subbuf_size -
> >> 			buf->padding[old_subbuf];
> >>-		smp_mb();
> >>-		if (waitqueue_active(&buf->read_wait))
> >>-			/*
> >>-			 * Calling wake_up_interruptible() from here
> >>-			 * will deadlock if we happen to be logging
> >>-			 * from the scheduler (trying to re-grab
> >>-			 * rq->lock), so defer it.
> >>-			 */
> >>-			__mod_timer(&buf->timer, jiffies + 1);
> >> 	}
> >> 
> >> 	old = buf->data;
> >>    
> >
> >  
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
