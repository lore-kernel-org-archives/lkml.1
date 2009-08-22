Return-Path: <linux-kernel-owner+w=401wt.eu-S933253AbZHVVpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbZHVVpv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 17:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932761AbZHVVpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 17:45:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46261 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932646AbZHVVpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 17:45:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 2/3] PM: Asynchronous suspend of devices
Date: Sat, 22 Aug 2009 23:46:49 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <200908122218.13975.rjw@sisk.pl> <200908152304.59881.rjw@sisk.pl> <20090822092554.GD11448@elf.ucw.cz>
In-Reply-To: <20090822092554.GD11448@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908222346.49736.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 August 2009, Pavel Machek wrote:
> > > > + * The driver of the device won't receive interrupts while this function is
> > > > + * being executed.
> > > >   */
> > > > @@ -696,13 +746,19 @@ int dpm_suspend_noirq(pm_message_t state
> > > >  	suspend_device_irqs();
> > > >  	mutex_lock(&dpm_list_mtx);
> > > >  	list_for_each_entry_reverse(dev, &dpm_list, power.entry) {
> > > > +		dev->power.status = DPM_OFF_IRQ;
> > > >  		error = device_suspend_noirq(dev, state);
> > > >  		if (error) {
> > > >  			pm_dev_err(dev, state, " late", error);
> > > > +			dev->power.status = DPM_OFF;
> > > > +			break;
> > > > +		}
> > > > +		if (async_error) {
> > > > +			error = async_error;
> > > >  			break;
> > > 
> > > async_error is 'interesting'. How does locking work in noirq case?
> > 
> > It's racy, a little bit. :-)
> > 
> > If two async drivers return errors exactly at the same time, one of them will
> > win the race, but it doesn't really matter which one wins as long as
> > async_error is different from zero as a result.  And it will be, since it's
> > an 'int' and the integrity of these is guaranteed.
> 
> Rather than relying on atomicity of 'int' (where half of kernel
> hackers says it is and second half says it is not), can we just use
> atomic_t? It compiles to same code on sane architectures, and serves
> as documentation/warning...

I used atomic_t for that in the updated patches, already sent a few days ago.
Please refer to that code.

Thanks,
Rafael
