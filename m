Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbZBLKsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbZBLKsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbZBLKsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:48:03 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47532 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbZBLKsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:48:00 -0500
Date: Thu, 12 Feb 2009 19:46:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [patch] rt: res_counter fix, v2
Message-Id: <20090212194644.98d275cf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090212102113.GA10031@elte.hu>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	<20090212005032.GA4788@nowhere>
	<20090212021257.GB4697@nowhere>
	<20090212101650.GA1096@elte.hu>
	<20090212102113.GA10031@elte.hu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Feb 2009 11:21:13 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Frederic, could you try the patch below?
> 
> Please try v2 below - it might even build ;-)
> 
> 	Ingo
> 
> ------------------->
> Subject: rt: res_counter fix
> From: Ingo Molnar <mingo@elte.hu>
> Date: Thu Feb 12 11:11:47 CET 2009
> 
> Frederic Weisbecker reported this warning:
> 
> [   45.228562] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
> [   45.228571] in_atomic(): 0, irqs_disabled(): 1, pid: 4290, name: ntpdate
> [   45.228576] INFO: lockdep is turned off.
> [   45.228580] irq event stamp: 0
> [   45.228583] hardirqs last  enabled at (0): [<(null)>] (null)
> [   45.228589] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
> [   45.228602] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
> [   45.228609] softirqs last disabled at (0): [<(null)>] (null)
> [   45.228617] Pid: 4290, comm: ntpdate Tainted: G        W  2.6.29-rc4-rt1-tip #1
> [   45.228622] Call Trace:
> [   45.228632]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
> [   45.228639]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
> [   45.228646]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
> [   45.228653]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
> [   45.228660]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
> [   45.228667]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
> [   45.228674]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
> [   45.228680]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
> [   45.228688]  [<ffffffff802d94ce>] __do_fault+0x29e/0x4c0
> [   45.228694]  [<ffffffff8077c843>] ? rt_spin_unlock+0x23/0x80
> [   45.228700]  [<ffffffff802db8b5>] handle_mm_fault+0x205/0x890
> [   45.228707]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
> [   45.228714]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
> [   45.228720]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
> [   45.228727]  [<ffffffff8043e1ed>] ? __clear_user+0x3d/0x70
> [   45.228733]  [<ffffffff8043e1d1>] ? __clear_user+0x21/0x70
> 
> The reason is the raw IRQ flag use of kernel/res_counter.c.
> 
> The irq flags tricks there seem a bit pointless: it cannot
> protect the c->parent linkage because local_irq_save() is
> only per CPU.
> 
> So replace it with _nort(). This code needs a second look.
> 
I'm sorry for no knowledge about RT. Could you teach me what
local_irq_save_nort() does ?

Hmm, how about just replacaing _irq() with preempt_disable()/enable() ?
xxx_nort() is better ?

AFAIK, these will not be called from irq context. (Added Balbir to CC:)

Regards,
-Kame


> Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/res_counter.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> Index: tip/kernel/res_counter.c
> ===================================================================
> --- tip.orig/kernel/res_counter.c
> +++ tip/kernel/res_counter.c
> @@ -14,6 +14,7 @@
>  #include <linux/res_counter.h>
>  #include <linux/uaccess.h>
>  #include <linux/mm.h>
> +#include <linux/interrupt.h>
>  
>  void res_counter_init(struct res_counter *counter, struct res_counter *parent)
>  {
> @@ -43,7 +44,7 @@ int res_counter_charge(struct res_counte
>  	struct res_counter *c, *u;
>  
>  	*limit_fail_at = NULL;
> -	local_irq_save(flags);
> +	local_irq_save_nort(flags);
>  	for (c = counter; c != NULL; c = c->parent) {
>  		spin_lock(&c->lock);
>  		ret = res_counter_charge_locked(c, val);
> @@ -62,7 +63,7 @@ undo:
>  		spin_unlock(&u->lock);
>  	}
>  done:
> -	local_irq_restore(flags);
> +	local_irq_restore_nort(flags);
>  	return ret;
>  }
>  
> @@ -79,13 +80,13 @@ void res_counter_uncharge(struct res_cou
>  	unsigned long flags;
>  	struct res_counter *c;
>  
> -	local_irq_save(flags);
> +	local_irq_save_nort(flags);
>  	for (c = counter; c != NULL; c = c->parent) {
>  		spin_lock(&c->lock);
>  		res_counter_uncharge_locked(c, val);
>  		spin_unlock(&c->lock);
>  	}
> -	local_irq_restore(flags);
> +	local_irq_restore_nort(flags);
>  }
>  
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

