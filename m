Return-Path: <linux-kernel-owner+w=401wt.eu-S1756955AbYGJLFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbYGJLFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 07:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYGJLFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 07:05:08 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:47240 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbYGJLFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 07:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C/T21T6w+rKUiuiJqPrmNQ2tYR6xXwkBfOLkuXFZnt67noe7QoUHI/7mBwJLf7kwsX
         oTAO+OF2hmo5QECOM6SchHMjHxpochLyBN7sOiEllLiYXTS8R/h1uxZFsOxmj8wbLoGq
         VwQAuocBrwPnn5YD8FZGeBSObU1P2wyFuHNeo=
Date: Thu, 10 Jul 2008 15:02:14 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.26-rc9-git4: Reported regressions from 2.6.25
Message-ID: <20080710110213.GA6688@martell.zuzino.mipt.ru>
References: <4yrA-dRoNlD.A.jcB.ny-cIB@albercik> <200807101725.36175.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807101725.36175.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 05:25:35PM +1000, Nick Piggin wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10629
> > Subject		: 2.6.26-rc1-$sha1: RIP __d_lookup+0x8c/0x160
> > Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
> > Date		: 2008-05-05 09:59 (65 days old)
> > References	: http://lkml.org/lkml/2008/5/5/28
> > Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Attached is my fix for this problem. I don't think it is a regression
> as such, but it can't hurt to go into 2.6.26 IMO.

> PREEMPT_RCU without HOTPLUG_CPU is broken.

Bastard!

rcutorture fixed here, starting cross-compile stuff (without much interest).

> Annoyed this wasn't a crazy obscure error in the algorithm I could fix :)
> I spent all day debugging it and had to make a special test case (rcutorture
> didn't seem to trigger it), and a big RCU state logging infrastructure to log
> millions of RCU state transitions and events. Oh well.

> --- linux-2.6.orig/kernel/rcupreempt.c
> +++ linux-2.6/kernel/rcupreempt.c
> @@ -925,26 +925,22 @@ void rcu_offline_cpu(int cpu)
>  	spin_unlock_irqrestore(&rdp->lock, flags);
>  }
>  
> -void __devinit rcu_online_cpu(int cpu)
> -{
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
> -	cpu_set(cpu, rcu_cpu_online_map);
> -	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
> -}
> -
>  #else /* #ifdef CONFIG_HOTPLUG_CPU */
>  
>  void rcu_offline_cpu(int cpu)
>  {
>  }
>  
> -void __devinit rcu_online_cpu(int cpu)
> +#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
> +
> +void __cpuinit rcu_online_cpu(int cpu)
>  {
> -}
> +	unsigned long flags;
>  
> -#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
> +	spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
> +	cpu_set(cpu, rcu_cpu_online_map);
> +	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
> +}
>  
>  static void rcu_process_callbacks(struct softirq_action *unused)
>  {


