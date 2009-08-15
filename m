Return-Path: <linux-kernel-owner+w=401wt.eu-S932174AbZHOBnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbZHOBnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 21:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbZHOBnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 21:43:32 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46855 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494AbZHOBnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 21:43:31 -0400
Subject: Re: [patch 04/15] cleanup clocksource selection
From: john stultz <johnstul@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>
In-Reply-To: <20090814134808.388024160@de.ibm.com>
References: <20090814134717.859098725@de.ibm.com>
	 <20090814134808.388024160@de.ibm.com>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 18:42:20 -0700
Message-Id: <1250300540.8269.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-14 at 15:47 +0200, Martin Schwidefsky wrote:
> plain text document attachment (clocksource-select.diff)
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> If a non high-resolution clocksource is first set as override clock
> and then registered it becomes active even if the system is in
> on-shot mode. Move the override check from sysfs_override_clocksource
> to the clocksource selection. That fixes the bug and simplifies the
> code. The check in clocksource_register for double registration of
> the same clocksource is removed without replacement.
> 
> To find the initial clocksource a new weak function in jiffies.c is
> defined that returns the jiffies clocksource. The architecture code
> can then override the weak function with a more suitable clocksource,
> e.g. the TOD clock on s390.


Hey Martin, 

So I found the issue I sent mail about earlier, this is patch breaks
sysfs clocksource overrides. The suggested fix is below:


> @@ -478,10 +478,6 @@ static ssize_t sysfs_override_clocksourc
>  					  struct sysdev_attribute *attr,
>  					  const char *buf, size_t count)
>  {
> -	struct clocksource *ovr = NULL;
> -	size_t ret = count;
> -	int len;
> -
>  	/* strings from sysfs write are not 0 terminated! */
>  	if (count >= sizeof(override_name))
>  		return -EINVAL;
> @@ -495,41 +491,11 @@ static ssize_t sysfs_override_clocksourc
>  	if (count > 0)
>  		memcpy(override_name, buf, count);
>  	override_name[count] = 0;
> -
> -	len = strlen(override_name);
> -	if (len) {
> -		struct clocksource *cs;
> -
> -		ovr = clocksource_override;
> -		/* try to select it: */
> -		list_for_each_entry(cs, &clocksource_list, list) {
> -			if (strlen(cs->name) == len &&
> -			    !strcmp(cs->name, override_name))
> -				ovr = cs;
> -		}
> -	}
> -
> -	/*
> -	 * Check to make sure we don't switch to a non-highres capable
> -	 * clocksource if the tick code is in oneshot mode (highres or nohz)
> -	 */
> -	if (tick_oneshot_mode_active() && ovr &&
> -	    !(ovr->flags & CLOCK_SOURCE_VALID_FOR_HRES)) {
> -		printk(KERN_WARNING "%s clocksource is not HRT compatible. "
> -			"Cannot switch while in HRT/NOHZ mode\n", ovr->name);
> -		ovr = NULL;
> -		override_name[0] = 0;
> -	}
> -
> -	/* Reselect, when the override name has changed */
> -	if (ovr != clocksource_override) {
> -		clocksource_override = ovr;
> -		next_clocksource = select_clocksource();
> -	}
> +	clocksource_select();
> 
>  	spin_unlock_irq(&clocksource_lock);
> 
> -	return ret;
> +	return count;
>  }

Here when you return count, count may have been decremented in the code
above, which causes the writer to get back fewer bytes then what they
passed in, causing the last char to be repeatedly sent. This is what
causes the immediate switch back to the default clocksource (override
gets set to null), and the hang of the command writing to the sysfs
file.

The fix is simply keeping the initial "size_t ret = count;" and the
final "return ret;"


Index: linux-2.6-tip/kernel/time/clocksource.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/clocksource.c	2009-08-14 17:29:50.000000000 -0400
+++ linux-2.6-tip/kernel/time/clocksource.c	2009-08-14 17:30:36.000000000 -0400
@@ -478,6 +478,8 @@
 					  struct sysdev_attribute *attr,
 					  const char *buf, size_t count)
 {
+	size_t ret = count;
+
 	/* strings from sysfs write are not 0 terminated! */
 	if (count >= sizeof(override_name))
 		return -EINVAL;
@@ -495,7 +497,7 @@
 
 	spin_unlock_irq(&clocksource_lock);
 
-	return count;
+	return ret;
 }
 
 /**


thanks
-john


