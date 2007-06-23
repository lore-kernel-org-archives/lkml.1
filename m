Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbXFWW0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbXFWW0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 18:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbXFWW0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 18:26:37 -0400
Received: from aeimail.aei.ca ([206.123.6.84]:53521 "EHLO aeimail.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbXFWW0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 18:26:36 -0400
X-Greylist: delayed 4395 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jun 2007 18:26:35 EDT
From: Ed Tomlinson <edt@aei.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 0/5 v2] Convert all tasklets to workqueues V2
Date: Sat, 23 Jun 2007 17:15:55 -0400
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
References: <20070622182051.859570787@goodmis.org>
In-Reply-To: <20070622182051.859570787@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706231715.56375.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Applied this to 2.6.21-5 along with an older version of dyntick and cfs v18, durring boot I got:

[   54.154077] hci_usb_isoc_rx_submit: hci0 isoc rx submit failed urb ffff81004ec55628 err -38
[   54.154086] hci_usb_isoc_rx_submit: hci0 isoc rx submit failed urb ffff81004ec55628 err -38
[   54.168147] BUG: at kernel/mutex.c:132 __mutex_lock_common()
[   54.170801]
[   54.170802] Call Trace:
[   54.175975]  [<ffffffff801790a0>] check_preempt_curr_fair+0x70/0x90
[   54.178694]  [<ffffffff8015b11f>] __mutex_lock_slowpath+0x6f/0x200
[   54.181417]  [<ffffffff8015b2c9>] mutex_lock+0x19/0x20
[   54.184165]  [<ffffffff80185c01>] flush_workqueue+0x31/0x50
[   54.186975]  [<ffffffff80190e75>] tasklet_disable+0x15/0x20
[   54.189829]  [<ffffffff8815289f>] :bluetooth:hci_cc_host_ctl+0x17f/0x240
[   54.192767]  [<ffffffff88153e4c>] :bluetooth:hci_event_packet+0x139c/0x1560
[   54.195712]  [<ffffffff88154d24>] :bluetooth:hci_send_to_sock+0x134/0x180
[   54.198657]  [<ffffffff8815073f>] :bluetooth:hci_rx_task+0x9f/0x270
[   54.201588]  [<ffffffff80190df0>] work_tasklet_exec+0x0/0x50
[   54.204473]  [<ffffffff80190e2c>] work_tasklet_exec+0x3c/0x50
[   54.207282]  [<ffffffff801488d4>] run_workqueue+0x94/0x130
[   54.210032]  [<ffffffff80145c59>] worker_thread+0x149/0x190
[   54.212781]  [<ffffffff80177430>] default_wake_function+0x0/0x10
[   54.215539]  [<ffffffff80145b10>] worker_thread+0x0/0x190
[   54.218241]  [<ffffffff801300f3>] kthread+0xd3/0x110
[   54.220880]  [<ffffffff801581c8>] child_rip+0xa/0x12
[   54.223484]  [<ffffffff80130020>] kthread+0x0/0x110
[   54.226075]  [<ffffffff801581be>] child_rip+0x0/0x12

Has this patch uncovered a problem in bluetooth or is it a problem with the patch?

TIA,
Ed Tomlinson

On Friday 22 June 2007 14:20, Steven Rostedt wrote:
> -- 
> 
> This is version 2 of the tasklet to workqueue conversion.
> 
> Changes from version 1.
> 
> - removed config option and simply replace the old implementation
>   with the work queue one (recommended by Ingo Molnar).
> 
> - replaced clear_bit with test_and_clear_bit to avoid the race of
>   executing the tasklet function twice. (thanks to Oleg Nesterov
>   for pointing that out).
> 
> - Removed most of the pr_debug prints. (Kept one)
>   (recommended by Ingo Molnar)
> 
> - Removed call to softirq_init.
> 
> - Added Author credit to Dipankar Sarma for the RCU tasklet to
>   softirq conversion.
> 
> - Tested on my Powerbook to add another arch to the mix :-)
>   Funny that booting with this change was the first time that
>   the bcm43xx didn't get stuck for several seconds on bootup.
>   It's also one of the few drivers that use tasklet_disable_nosync.
>   So either this shows that the change fixed something, or that
>   it broke something (or was just a fluke).
> 
> 
> -- Steve
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
