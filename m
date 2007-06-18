Return-Path: <linux-kernel-owner+w=401wt.eu-S1761830AbXFRKvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761830AbXFRKvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760335AbXFRKvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 06:51:15 -0400
Received: from www19.your-server.de ([213.133.104.19]:2195 "EHLO
	www19.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657AbXFRKvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 06:51:15 -0400
From: Uli Luckas <u.luckas@road.de>
Organization: Road GmbH
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 2/2] PM: Disable usermode helper before hibernation and suspend
Date: Mon, 18 Jun 2007 12:51:09 +0200
User-Agent: KMail/1.9.7
References: <200706042325.28965.rjw@sisk.pl> <200706152336.46278.rjw@sisk.pl> <200706172124.13550.rjw@sisk.pl>
In-Reply-To: <200706172124.13550.rjw@sisk.pl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706181251.10170.u.luckas@road.de>
X-Authenticated-Sender: webmaster@road.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17. June 2007, you wrote:
> On Friday, 15 June 2007 23:36, Rafael J. Wysocki wrote:
> > On Friday, 15 June 2007 15:08, Uli Luckas wrote:
> > > On Monday, 4. June 2007, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > >
> > > > Use a hibernation and suspend notifier to disable the user mode
> > > > helper before a hibernation/suspend and enable it after the
> > > > operation.
> > >
> > > Hi Rafael,
> > > I have a couple of questions, regarding this patch ...

> > > 2) how does your patch prevent wait_for_completion(&done) to hang
> > > during freezing if usermodehelper_pm_callback is called _after_ the
> > > above check?
> >
> > It doesn't.  Once the helper is running, we can't distinguish it from any
> > other user land process.
> >
> > Still, it narrows the window quite a bit.
>
> Okay, I think we can help it a bit.  Please tell me what you think of the
> following patch (on top of 2.6.22-rc4-mm2).
>
Hi Rafael,
Thanks for your work. I haven't found the time to actually test your patch but 
in general it looks like a valid aproach.
I think there is one problem though. You need to have your wait queue woken up 
when you update (atomic_dec) running_helpers. Otherwise you end up always 
waiting the full RUNNING_HELPERS_TIMEOUT.

> Index: linux-2.6.22-rc4-mm2/kernel/kmod.c
> ===================================================================
> --- linux-2.6.22-rc4-mm2.orig/kernel/kmod.c
> +++ linux-2.6.22-rc4-mm2/kernel/kmod.c
> @@ -49,6 +49,15 @@ static struct workqueue_struct *khelper_
>   */
>  static int usermodehelper_disabled;
>
> +/* Number of helpers running */
> +static atomic_t running_helpers = ATOMIC_INIT(0);
> +
> +/*
> + * Time to wait for running_helpers to become zero before the setting of
> + * usermodehelper_disabled in usermodehelper_pm_callback() fails
> + */
> +#define RUNNING_HELPERS_TIMEOUT	(5 * HZ)
> +
>  #ifdef CONFIG_KMOD
>
>  /*
> @@ -279,11 +288,20 @@ static int usermodehelper_pm_callback(st
>  					unsigned long action,
>  					void *ignored)
>  {
> +	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waiting);
> +
>  	switch (action) {
>  	case PM_HIBERNATION_PREPARE:
>  	case PM_SUSPEND_PREPARE:
>  		usermodehelper_disabled = 1;
> -		return NOTIFY_OK;
> +		wait_event_timeout(waiting, atomic_read(&running_helpers) == 0,
> +					RUNNING_HELPERS_TIMEOUT);
> +		if (atomic_read(&running_helpers) == 0) {
> +			return NOTIFY_OK;
> +		} else {
> +			usermodehelper_disabled = 0;
> +			return NOTIFY_BAD;
> +		}
>  	case PM_POST_HIBERNATION:
>  	case PM_POST_SUSPEND:
>  		usermodehelper_disabled = 0;
> @@ -397,12 +415,13 @@ int call_usermodehelper_exec(struct subp
>  	DECLARE_COMPLETION_ONSTACK(done);
>  	int retval;
>
> +	atomic_inc(&running_helpers);
>  	if (sub_info->path[0] == '\0') {
>  		retval = 0;
>  		goto out;
>  	}
>
> -	if (!khelper_wq || usermodehelper_disabled) {
> +	if (!khelper_wq || (wait != UMH_NO_WAIT && usermodehelper_disabled)) {
>  		retval = -EBUSY;
>  		goto out;
>  	}
> @@ -418,6 +437,7 @@ int call_usermodehelper_exec(struct subp
>
>    out:
>  	call_usermodehelper_freeinfo(sub_info);
> +	atomic_dec(&running_helpers);
>  	return retval;
>  }
>  EXPORT_SYMBOL(call_usermodehelper_exec);

-- 

------- ROAD ...the handyPC Company - - -  ) ) )

Uli Luckas
Software Development

ROAD GmbH
Bennigsenstr. 14 | 12159 Berlin | Germany
fon: +49 (30) 230069 - 64 | fax: +49 (30) 230069 - 69
url: www.road.de

Amtsgericht Charlottenburg: HRB 96688 B
Managing directors: Hans-Peter Constien, Hubertus von Streit
