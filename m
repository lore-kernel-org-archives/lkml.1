Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbZKBP4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbZKBP4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbZKBP4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:56:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47183 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbZKBP4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:56:50 -0500
Date: Mon, 2 Nov 2009 15:56:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Antonio Ospite <ospite@studenti.unina.it>, openezx-devel@lists.openezx.org,
       Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       Mike Rapoport <mike@compulab.co.il>, Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: Using statically allocated memory for platform_data.
Message-ID: <20091102155625.GC5785@n2100.arm.linux.org.uk>
References: <20091102112316.16163f6a.ospite@studenti.unina.it> <20091102150011.GB20341@fluff.org.uk> <20091102150525.GB5785@n2100.arm.linux.org.uk> <20091102152500.GD23772@trinity.fluff.org> <20091102155231.GC20341@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102155231.GC20341@fluff.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 03:52:31PM +0000, Ben Dooks wrote:
> On Mon, Nov 02, 2009 at 03:25:00PM +0000, Ben Dooks wrote:
> > On Mon, Nov 02, 2009 at 03:05:25PM +0000, Russell King - ARM Linux wrote:
> > > On Mon, Nov 02, 2009 at 03:00:11PM +0000, Ben Dooks wrote:
> > > > This looks like something is freeing stuff that it did not allocate in
> > > > the first place, which is IMHO bad. The call platform_device_alloc()
> > > > is setting platform_device_release() as the default release function
> > > > but platform_device_release() releases more than platform_device_alloc()
> > > > actually created.
> > > > 
> > > > My view is that platform_device_alloc()'s default release shouldn't
> > > > be freeing the platform data, and that using platform_device_add_data()
> > > > or platform_device_add_resources() should change either the behvaiour 
> > > > of platform_device_release() or it should change the pointer to a new
> > > > release function.
> > > 
> > > That doesn't work - how do those other functions (adding) know what data
> > > has also been added by other functions?  That can't work reliably.
> > 
> > You could wrapper platform device, and each of the add functions could
> > update it, but that would assume the platform device had been allocated
> > with platform_device_alloc().
> 
> Having had a look, all the current users of platform_device_add_data()
> are from a platform_alloc_device() created device. 
> 
> The number of calls to platform_device_add_resources() are many, but
> the ones I checked are from platform_alloc_device().
> 
> However your point being that these add calls may not be used on a
> device that has been created from platform_device_alloc() is one I
> overlooked.

I did not say that.  I said your idea of replacing the release function
on each _add() is impractical when you have multiple _add() functions.

> Having a state machine that changed the release call from
> platform_device_release() to say platform_device_release_resources()
> or platform_device_release_all() and then platform_device_release_all()
> may be another way to do it.

The reason we have platform_device_add_data() is that people think that
the device data needs to persist for the lifetime of the device.  I
personally disagree with that - once you unregister the device, it's
guaranteed that device drivers will have been unregistered, so who's
going to use the platform data?

So we could just fix it by killing off platform_device_add_data() and
removing the kfree of the platform data, and ensuring that data marked
with __initdata either loses that attributation or is kmalloc+copied.
