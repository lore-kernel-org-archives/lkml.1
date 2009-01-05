Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbZAEB44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbZAEB44 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 20:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbZAEB4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 20:56:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:46888 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbZAEB4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 20:56:44 -0500
Date: Sun, 4 Jan 2009 17:58:30 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Zhao Yakui <yakui.zhao@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "fweisbec@gmail.com" <fweisbec@gmail.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] fastboot: make ACPI bus drivers probe asynchronous
Message-ID: <20090104175830.7a7e279e@infradead.org>
In-Reply-To: <1231120992.3967.18.camel@yakui_zhao.sh.intel.com>
References: <20090104092430.7ffd2c41@infradead.org>
	<20090104093103.46167d23@infradead.org>
	<1231120992.3967.18.camel@yakui_zhao.sh.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2009 10:03:12 +0800
Zhao Yakui <yakui.zhao@intel.com> wrote:

> On Sun, 2009-01-04 at 09:31 -0800, Arjan van de Ven wrote:
> > From 20af3efd07b775a27a997e3df1039e20ea18f62b Mon Sep 17 00:00:00
> > 2001 From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Sun, 4 Jan 2009 05:32:28 -0800
> > Subject: [PATCH] fastboot: make ACPI bus drivers probe asynchronous
> > 
> > the various ACPI bus drivers have non-overlapping devices and can
> > each be run asynchronous. Some of the ACPI drivers (especially the
> > battery one, but others as well) can take quite a long time to
> > probe.
> It seems that all the ACPI drivers are registered asynchronously after
> this change. 

they are registered asynchronously compared to the rest of the kernel,
but in strict original sequence compared to eachother.


> > +static void acpi_bus_register_async(void *data, async_cookie_t
> > cookie) +{
> > +	int ret;
> > +	struct acpi_driver *driver = data;
> > +	driver->drv.name = driver->name;
> > +	driver->drv.bus = &acpi_bus_type;
> > +	driver->drv.owner = driver->owner;
> > +
> > +	async_synchronize_cookie(cookie);
> > +
> > +	ret = driver_register(&driver->drv);
> > +	WARN_ON(ret != 0);
> > +}

because of the async_synchronize_cookie() call!

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
