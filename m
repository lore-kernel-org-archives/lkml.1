Return-Path: <linux-kernel-owner+w=401wt.eu-S965380AbXBQXrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965380AbXBQXrt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 18:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965388AbXBQXrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 18:47:48 -0500
Received: from mail.screens.ru ([213.234.233.54]:49597 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965380AbXBQXrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 18:47:48 -0500
Date: Sun, 18 Feb 2007 02:47:28 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Message-ID: <20070217234728.GA679@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <200702171224.46626.rjw@sisk.pl> <20070217213406.GA541@tv-sign.ru> <200702172324.44892.rjw@sisk.pl> <20070217234201.GA591@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217234201.GA591@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18, Oleg Nesterov wrote:
>
> On 02/17, Rafael J. Wysocki wrote:
> >
> > Alternatively, we can move the check into refrigerator(), like this:
> > 
> > --- linux-2.6.20-git13.orig/kernel/power/process.c
> > +++ linux-2.6.20-git13/kernel/power/process.c
> > @@ -39,6 +39,11 @@ void refrigerator(void)
> >  	/* Hmm, should we be allowed to suspend when there are realtime
> >  	   processes around? */
> >  	long save;
> > +
> > +	/* Freeze the task unless there is a vfork completion pending */
> > +	if (current->vfork_done)
> > +		return;
> > +
> 
> This means that "current" returns to user space (get_signal_to_deliver
> will clear TIF_SIGPENDING) and runs. While try_to_freeze_tasks() thinks
> it is frozen.

Ah, sorry. I am wrong, current has no PF_FROZEN yet.

However, this means that sys_vfork() makes impossible to freeze processes
until child exits/execs. Not good.

Oleg.

