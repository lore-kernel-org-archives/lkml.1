Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbZL1Q4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbZL1Q4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 11:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbZL1Q4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 11:56:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:46430 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbZL1Q4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 11:56:33 -0500
Subject: Re: [PATCH 05/37] kdb: core for kgdb back end
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, mort@sgi.com, linux-arch@vger.kernel.org
In-Reply-To: <4B38DDC5.4080202@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
	 <1261652672.4937.189.camel@laptop>  <4B38DDC5.4080202@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 17:55:53 +0100
Message-ID: <1262019353.7135.127.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-28 at 10:33 -0600, Jason Wessel wrote:
> Peter Zijlstra wrote:
> > On Wed, 2009-12-23 at 15:19 -0600, Jason Wessel wrote:
> >> +kdb_prio(char *name, struct rt_prio_array *array, kdb_printf_t xxx_printf,
> [..]
> >> +kdb_runqueue(unsigned long cpu, kdb_printf_t xxx_printf)
> [..]
> > 
> > So what is this code supposed to do? It looks like it simply cannot be
> > correct.
> > 
> 
> Beyond the fact that the code may not be right, it is a small part of
> a kdb module which is not included, and these functions can
> immediately disappear.  For reference, the original kdb module was
> called "kdbm_sched" and I believe it was intended as an aid to help
> debug the scheduler and process priorities in earlier versions of the
> kernel.
> 
> I have removed all this code and reduced the patch to kernel/sched.c
> to the following. 

Awesome. Please let me know if in the future you find the need for
similar helpers, I'm sure we can figure out something that'll work as
intended.

>  The reason we need the attached patch is to be able to call
> curr_task() for kdb to perform some basic per cpu task analysis while
> the system is stopped.

Right, so this set_curr_task() thing is way scary, maybe we can simplify
things to only expose curr_task()?

> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9784,9 +9784,9 @@ void normalize_rt_tasks(void)
>  
>  #endif /* CONFIG_MAGIC_SYSRQ */
>  
> -#ifdef CONFIG_IA64
> +#if defined(CONFIG_IA64) || defined(CONFIG_KGDB_KDB)
>  /*
> - * These functions are only useful for the IA64 MCA handling.
> + * These functions are only useful for the IA64 MCA handling, or kdb.
>   *
>   * They can only be called when the whole system has been
>   * stopped - every CPU needs to be quiescent, and no scheduling


