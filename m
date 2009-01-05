Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbZAECly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbZAECly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 21:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbZAECl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 21:41:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:18429 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbZAECl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 21:41:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,330,1228118400"; 
   d="scan'208";a="654524490"
Subject: Re: [PATCH 4/4] fastboot: make ACPI bus drivers probe asynchronous
From: Zhao Yakui <yakui.zhao@intel.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "fweisbec@gmail.com" <fweisbec@gmail.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <20090104175830.7a7e279e@infradead.org>
References: <20090104092430.7ffd2c41@infradead.org>
	 <20090104093103.46167d23@infradead.org>
	 <1231120992.3967.18.camel@yakui_zhao.sh.intel.com>
	 <20090104175830.7a7e279e@infradead.org>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 10:51:50 +0800
Message-Id: <1231123910.3967.34.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-04 at 17:58 -0800, Arjan van de Ven wrote:
> On Mon, 05 Jan 2009 10:03:12 +0800
> Zhao Yakui <yakui.zhao@intel.com> wrote:
> 
> > On Sun, 2009-01-04 at 09:31 -0800, Arjan van de Ven wrote:
> > > From 20af3efd07b775a27a997e3df1039e20ea18f62b Mon Sep 17 00:00:00
> > > 2001 From: Arjan van de Ven <arjan@linux.intel.com>
> > > Date: Sun, 4 Jan 2009 05:32:28 -0800
> > > Subject: [PATCH] fastboot: make ACPI bus drivers probe asynchronous
> > > 
> > > the various ACPI bus drivers have non-overlapping devices and can
> > > each be run asynchronous. Some of the ACPI drivers (especially the
> > > battery one, but others as well) can take quite a long time to
> > > probe.
> > It seems that all the ACPI drivers are registered asynchronously after
> > this change. 
> 
> they are registered asynchronously compared to the rest of the kernel,
> but in strict original sequence compared to eachother.
> 
> 
> > > +static void acpi_bus_register_async(void *data, async_cookie_t
> > > cookie) +{
> > > +	int ret;
> > > +	struct acpi_driver *driver = data;
> > > +	driver->drv.name = driver->name;
> > > +	driver->drv.bus = &acpi_bus_type;
> > > +	driver->drv.owner = driver->owner;
> > > +
> > > +	async_synchronize_cookie(cookie);
> > > +
> > > +	ret = driver_register(&driver->drv);
> > > +	WARN_ON(ret != 0);
> > > +}
> 
> because of the async_synchronize_cookie() call!
After the async_synchronize_cookie is called, the register sequence will
become strict. 
But there exist multiple threads. It is possible that the function of
acpi_bus_register_async is called on different threads. In such case the
dependency can't be guaranteed. 

Thanks.
> 

