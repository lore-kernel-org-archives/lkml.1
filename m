Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbZHOU63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbZHOU63 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 16:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZHOU62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 16:58:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43231 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbZHOU60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 16:58:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 1/3] PM: Asynchronous resume of devices
Date: Sat, 15 Aug 2009 22:59:18 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <200908122218.13975.rjw@sisk.pl> <200908122220.03363.rjw@sisk.pl> <20090814163328.GF1626@ucw.cz>
In-Reply-To: <20090814163328.GF1626@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908152259.18417.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 August 2009, Pavel Machek wrote:
> > The patch below introduces a mechanism allowing some devices to be
> > resumed asynchronously, using completions with the following rules:
> > (1) There is a completion, dev->power.comp, for each device object.
> > (2) All of these completions are reset before suspend as well as
> >     each resume stage (dpm_resume_noirq(), dpm_resume()).
> > (3) If dev->power.async_suspend is set for dev or for its parent, the
> >     PM core waits for the parent's completion before attempting to
> >     run the resume callbacks, appropriate for this particular stage
> >     of resume, for dev.
> 
> at least this needs to go in as a comment.

OK, this is a prototype patch, still under discussion.

> > (4) dev->power.comp is completed for each device after running its
> > @@ -411,9 +412,12 @@ struct dev_pm_info {
> >  	pm_message_t		power_state;
> >  	unsigned int		can_wakeup:1;
> >  	unsigned int		should_wakeup:1;
> > +	unsigned		async_suspend:1;
> >  	enum dpm_state		status;		/* Owned by the PM core */
> 
> unsigned int? Or bool?

unsigned means 'unsigned int'.  I should have added 'int', but again, this is
a prototype patch.

> Should it go under config_pm_sleep?

Not necessaily.  'status' is not there as well.

> >  #ifdef CONFIG_PM_SLEEP
> >  	struct list_head	entry;
> > +	struct completion	comp;
> > +	pm_message_t		async_state;
> >  #endif
> >  }
> >  
> > +static inline void device_enable_async_suspend(struct device *dev, bool enable)
> > +{
> > +	if (dev->power.status == DPM_ON)
> > +		dev->power.async_suspend = enable;
> > +}
> > +
> > @@ -163,6 +166,34 @@ void device_pm_move_last(struct device *
> >  	list_move_tail(&dev->power.entry, &dpm_list);
> >  }
> >  
> > +static void dpm_synchronize_noirq(void)
> > +{
> > +	struct device *dev;
> > +
> > +	async_synchronize_full();
> > +
> > +	list_for_each_entry(dev, &dpm_list, power.entry)
> > +		INIT_COMPLETION(dev->power.comp);
> > +}
> > +
> > +static void dpm_synchronize(void)
> > +{
> > +	struct device *dev;
> > +
> > +	async_synchronize_full();
> > +
> > +	mutex_lock(&dpm_list_mtx);
> > +	list_for_each_entry(dev, &dpm_list, power.entry)
> > +		INIT_COMPLETION(dev->power.comp);
> > +	mutex_unlock(&dpm_list_mtx);
> > +}
> 
> Why is it ok to avoid locking in noirq case?

It's not, but we hold dpm_list_mtx throughout the entire noirq suspend.

> Do we really need async for noirq handlers?

Yes, we do.  Specifically, for PCI.

> >  /**
> > - *	device_resume_noirq - Power on one device (early resume).
> > - *	@dev:	Device.
> > - *	@state: PM transition of the system being carried out.
> > + * __device_resume_noirq - Execute an "early resume" callback for given device.
> > + * @dev: Device to resume.
> > + * @state: PM transition of the system being carried out.
> >   *
> > - *	Must be called with interrupts disabled.
> > + * The driver of the device won't receive interrupts while this function is
> > + * being executed.
> >   */
> 
> You still want it called with interrupts disabled, right?

No.  It's not called with interrupts off now.

Thanks,
Rafael
