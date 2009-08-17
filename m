Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbZHQHew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbZHQHew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 03:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbZHQHev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 03:34:51 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:37067 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbZHQHev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 03:34:51 -0400
Date: Mon, 17 Aug 2009 09:34:39 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>
Subject: Re: [patch 04/15] cleanup clocksource selection
Message-ID: <20090817093439.60521924@skybase>
In-Reply-To: <1250300540.8269.26.camel@localhost.localdomain>
References: <20090814134717.859098725@de.ibm.com>
	<20090814134808.388024160@de.ibm.com>
	<1250300540.8269.26.camel@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Aug 2009 18:42:20 -0700
john stultz <johnstul@us.ibm.com> wrote:

> Here when you return count, count may have been decremented in the code
> above, which causes the writer to get back fewer bytes then what they
> passed in, causing the last char to be repeatedly sent. This is what
> causes the immediate switch back to the default clocksource (override
> gets set to null), and the hang of the command writing to the sysfs
> file.
> 
> The fix is simply keeping the initial "size_t ret = count;" and the
> final "return ret;"
> 
> 
> Index: linux-2.6-tip/kernel/time/clocksource.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/time/clocksource.c	2009-08-14 17:29:50.000000000 -0400
> +++ linux-2.6-tip/kernel/time/clocksource.c	2009-08-14 17:30:36.000000000 -0400
> @@ -478,6 +478,8 @@
>  					  struct sysdev_attribute *attr,
>  					  const char *buf, size_t count)
>  {
> +	size_t ret = count;
> +
>  	/* strings from sysfs write are not 0 terminated! */
>  	if (count >= sizeof(override_name))
>  		return -EINVAL;
> @@ -495,7 +497,7 @@
> 
>  	spin_unlock_irq(&clocksource_lock);
> 
> -	return count;
> +	return ret;
>  }
> 
>  /**

Opps :-(
Thanks for bisecting & fixing.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

