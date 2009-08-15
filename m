Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZHOVEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZHOVEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 17:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbZHOVEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 17:04:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43285 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbZHOVEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 17:04:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 2/3] PM: Asynchronous suspend of devices
Date: Sat, 15 Aug 2009 23:04:59 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <200908122218.13975.rjw@sisk.pl> <200908122221.20568.rjw@sisk.pl> <20090814163509.GK1626@ucw.cz>
In-Reply-To: <20090814163509.GK1626@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908152304.59881.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 August 2009, Pavel Machek wrote:
> > @@ -659,26 +674,61 @@ static pm_message_t resume_event(pm_mess
> >  }
> >  
> >  /**
> > - *	device_suspend_noirq - Shut down one device (late suspend).
> > - *	@dev:	Device.
> > - *	@state: PM transition of the system being carried out.
> > + * __device_suspend_noirq - Execute a "late" suspend callback for given device.
> > + * @dev: Device to suspend.
> > + * @state: PM transition of the system being carried out.
> 
> >   *
> > - *	This is called with interrupts off and only a single CPU running.
> 
> that still looks like useful comment... why delete it?

Because it's not valid any more.

> > + * The driver of the device won't receive interrupts while this function is
> > + * being executed.
> >   */
> > @@ -696,13 +746,19 @@ int dpm_suspend_noirq(pm_message_t state
> >  	suspend_device_irqs();
> >  	mutex_lock(&dpm_list_mtx);
> >  	list_for_each_entry_reverse(dev, &dpm_list, power.entry) {
> > +		dev->power.status = DPM_OFF_IRQ;
> >  		error = device_suspend_noirq(dev, state);
> >  		if (error) {
> >  			pm_dev_err(dev, state, " late", error);
> > +			dev->power.status = DPM_OFF;
> > +			break;
> > +		}
> > +		if (async_error) {
> > +			error = async_error;
> >  			break;
> 
> async_error is 'interesting'. How does locking work in noirq case?

It's racy, a little bit. :-)

If two async drivers return errors exactly at the same time, one of them will
win the race, but it doesn't really matter which one wins as long as
async_error is different from zero as a result.  And it will be, since it's
an 'int' and the integrity of these is guaranteed.

Thanks,
Rafael
