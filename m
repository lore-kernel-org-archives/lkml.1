Return-Path: <linux-kernel-owner+w=401wt.eu-S933202AbXBRKtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202AbXBRKtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 05:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbXBRKtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 05:49:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48253 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933202AbXBRKs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 05:48:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Date: Sun, 18 Feb 2007 11:43:31 +0100
User-Agent: KMail/1.9.5
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <20070214144031.GA15257@in.ibm.com> <20070217234201.GA591@tv-sign.ru> <20070217234728.GA679@tv-sign.ru>
In-Reply-To: <20070217234728.GA679@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702181143.32538.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 February 2007 00:47, Oleg Nesterov wrote:
> On 02/18, Oleg Nesterov wrote:
> >
> > On 02/17, Rafael J. Wysocki wrote:
> > >
> > > Alternatively, we can move the check into refrigerator(), like this:
> > > 
> > > --- linux-2.6.20-git13.orig/kernel/power/process.c
> > > +++ linux-2.6.20-git13/kernel/power/process.c
> > > @@ -39,6 +39,11 @@ void refrigerator(void)
> > >  	/* Hmm, should we be allowed to suspend when there are realtime
> > >  	   processes around? */
> > >  	long save;
> > > +
> > > +	/* Freeze the task unless there is a vfork completion pending */
> > > +	if (current->vfork_done)
> > > +		return;
> > > +
> > 
> > This means that "current" returns to user space (get_signal_to_deliver
> > will clear TIF_SIGPENDING) and runs. While try_to_freeze_tasks() thinks
> > it is frozen.
> 
> Ah, sorry. I am wrong, current has no PF_FROZEN yet.
> 
> However, this means that sys_vfork() makes impossible to freeze processes
> until child exits/execs. Not good.

Yes, but this also is the current behavior.

I think the real solution would be to use an interruptible completion in the
vfork code.  It was discussed some time ago and, IIRC, Ingo had an experimental
patch that implemented it.  Still, for the suspend this really is not an issue
in practice, so it wasn't merged.

It may be a good time to solve this problem now. :-)

Greetings,
Rafael
