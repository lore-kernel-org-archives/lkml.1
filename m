Return-Path: <linux-kernel-owner+w=401wt.eu-S967125AbZLIBk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967125AbZLIBk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 20:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967112AbZLIBk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 20:40:57 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:62144 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967110AbZLIBk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 20:40:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=bkxz73R9TbVB146u5V0h1ou/8/6jFmhKyks31JKcpVr7x3nD3PYutxvlBStfOo9+NK
         iPPRDWdJU2ZBmNXBgaBeuNuDyS5HMFngfXk0k+lSd41uTLQcEhRUGrS41GU76cQ+KyD7
         gxHfJPhC9y1N41gIu4zVtmqLb6vVPYkMTltbc=
MIME-Version: 1.0
In-Reply-To: <20091208200657.GA12990@linux.vnet.ibm.com>
References: <8b8dd87a0912071058p1ab9ba20y931baa576d370f43@mail.gmail.com>
	 <20091208000819.GA18291@linux.vnet.ibm.com>
	 <8b8dd87a0912080352j36fa24bbvf301a4101d80e434@mail.gmail.com>
	 <8b8dd87a0912080354k69c9f508v8186f0009cf1bf8f@mail.gmail.com>
	 <20091208153557.GD6799@linux.vnet.ibm.com>
	 <8b8dd87a0912080924q3890ea8o23f6d1cfab37e306@mail.gmail.com>
	 <20091208192207.GC6779@linux.vnet.ibm.com>
	 <20091208200657.GA12990@linux.vnet.ibm.com>
Date: Wed, 9 Dec 2009 03:41:00 +0200
Message-ID: <8b8dd87a0912081741q24177e1bt3f624eded1590ca6@mail.gmail.com>
Subject: Re: Badness at kernel/rcutree.c:1228
From: kordex - <kordex@gmail.com>
To: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

I put the debug function under init/main.c after rcu_init(); but there
is no output on dmesg which means that it receives zero value.

Full dmesg: http://xnet.fi/opt/apps/lkml-2.6.32-vanilla.dmesg.rcu-init.txt

--Mikko Kortelainen

2009/12/8 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Tue, Dec 08, 2009 at 11:22:07AM -0800, Paul E. McKenney wrote:
>> At this point, I must defer to those more skilled than I at diagnosing
>> early-boot problems.
>
> Well, that is silly on my part -- the problem seems to appear late in
> boot, and you had no problem capturing that portion of the boot log.
>
> So please see below for a patch providing a rcu_check_beenonline()
> function that, when called after rcu_init(), returns non-zero if the
> beenonline fields have become corrupted.  So put calls of the form:
>
>        WARN_ON_ONCE(rcu_check_beenonline());
>
> in the initialization code path preceding the problem.  Either #include
> rcupdate.h or explicitly declare the function as appropriate.
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>
> diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> index 9642c6b..190a687 100644
> --- a/include/linux/rcutree.h
> +++ b/include/linux/rcutree.h
> @@ -39,6 +39,8 @@ extern int rcu_cpu_notify(struct notifier_block *self,
>  extern int rcu_needs_cpu(int cpu);
>  extern int rcu_expedited_torture_stats(char *page);
>
> +extern int rcu_check_beenonline(void);
> +
>  #ifdef CONFIG_TREE_PREEMPT_RCU
>
>  extern void __rcu_read_lock(void);
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 207125b..27d3722 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -77,6 +77,17 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
>  struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
>  DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
>
> +/*
> + * Ad-hoc diagnostic function, for use only after rcu_init() has
> + * returned.  Assumes that the boot CPU is CPU 0.  Assumes that
> + * the kernel has been built with CONFIG_TREE_RCU.  Not for inclusion.
> + * Usage: "WARN_ON_ONCE(rcu_check_beenonline());"
> + */
> +int rcu_check_beenonline(void)
> +{
> +       return !per_cpu(rcu_sched_data, 0).beenonline ||
> +              !per_cpu(rcu_bh_data, 0).beenonline;
> +}
>
>  /*
>  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
>
