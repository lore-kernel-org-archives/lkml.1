Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbZG1QdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbZG1QdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZG1QdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:33:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:36178 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbZG1QdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:33:18 -0400
Date: Tue, 28 Jul 2009 09:31:21 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: simplify platform_get_resource()
Message-ID: <20090728163121.GB13741@suse.de>
References: <1248718856-22287-1-git-send-email-vapier@gentoo.org>
 <20090728105949.GA16458@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728105949.GA16458@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 11:59:49AM +0100, Mark Brown wrote:
> On Mon, Jul 27, 2009 at 02:20:56PM -0400, Mike Frysinger wrote:
> > The platform_get_resource() function takes a number for the desired index
> > into the resource array, but then does a for loop on the array to get to
> > that index.  Considering the array is linear, the loop overhead is just
> > that -- overhead.  So unless I missed something, convert it into an index
> > check and access the desired resource directly.  Resulting code makes a
> > lot more sense considering its purpose.
> 
> This showed up in linux-next for me today and is causing breakage on at
> least S3C64xx platforms since it changes the resource numbering when
> there's more than one resource type for a device:
> 
> > -	for (i = 0; i < dev->num_resources; i++) {
> > -		struct resource *r = &dev->resource[i];
> > -
> > -		if (type == resource_type(r) && num-- == 0)
> > +	if (num >= 0 && num < dev->num_resources) {
> > +		struct resource *r = &dev->resource[num];
> > +		if (type == resource_type(r))
> 
> Previously the resources were indexed within their type (so you'd get
> I/O resources 0, 1, ..., IRQ resources 0, 1, ... and so on) but now the
> index treats all the resources for a device as a single array, causing
> them to be renumbered for callers.
> 
> This causes drivers doing lookups by number to fail to find their
> resources and not probe, causing widespread breakage.  Reverting the
> patch fixes the problem.

I've now dropped this patch.

thanks,

greg k-h
