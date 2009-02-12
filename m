Return-Path: <linux-kernel-owner+w=401wt.eu-S1758584AbZBLO2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584AbZBLO2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 09:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbZBLO2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 09:28:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:64381 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbZBLO2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 09:28:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H8OEPfeF1VmPxScji1HJjWp43h36PtC+iZBvOdXz0EyUI0Qx1YfnHXfefNbtija7Pi
         Ekf/xXLZetouQO1QjLxLeZi2IKytmNQwpi6p/Xd1KmQEXg+kSicKpCCkqFmBy3ycXkMa
         NHvdy46gptfnbcYQwwO6H3Yiz8xOgpG9jWzxA=
Date: Thu, 12 Feb 2009 15:28:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: Re: [patch] rt: res_counter fix, v2
Message-ID: <20090212142806.GA5865@nowhere>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <20090212005032.GA4788@nowhere> <20090212021257.GB4697@nowhere> <20090212101650.GA1096@elte.hu> <20090212102113.GA10031@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212102113.GA10031@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 11:21:13AM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Frederic, could you try the patch below?
> 
> Please try v2 below - it might even build ;-)
> 
> 	Ingo


Ok, I tested it through 3 bootups and it did not triggered.
But it's absolutely not a guarantee, as I said, I tried to reproduce it
with several bootups yesterday and I couln't see it again.

But by reading the warning and your patch, yes it is supposed to solve it :)

BTW, a small thing:
 
> [   45.228589] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
> [   45.228602] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500


The reason for which I wanted to send an irqsoff trace is that the above lines are false.

addr2line -e vmlinux ffffffff8025449d
/home/me/linux/rt/linux-2.6.29-rc4/kernel/fork.c:1107  (before your patch)

Which is this area in copy_process:

#ifdef CONFIG_NUMA
	p->mempolicy = mpol_dup(p->mempolicy);
 	if (IS_ERR(p->mempolicy)) {
 		retval = PTR_ERR(p->mempolicy);
 		p->mempolicy = NULL;
 		goto bad_fork_cleanup_cgroup;
 	}
	mpol_fix_fork_child_flag(p); // <-- 1107
#endif

Nothing here disables irq.
That's why I wanted to provide an irqsoff trace. But, heh I only had to read
res_counter_charge() :-)

Anyway, there is a problem with these hardirqs/softirqs last disabled...


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

