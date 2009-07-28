Return-Path: <linux-kernel-owner+w=401wt.eu-S1751806AbZG1K7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbZG1K7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZG1K7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:59:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53927 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751320AbZG1K7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:59:50 -0400
Date: Tue, 28 Jul 2009 11:59:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: simplify platform_get_resource()
Message-ID: <20090728105949.GA16458@rakim.wolfsonmicro.main>
References: <1248718856-22287-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248718856-22287-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 02:20:56PM -0400, Mike Frysinger wrote:
> The platform_get_resource() function takes a number for the desired index
> into the resource array, but then does a for loop on the array to get to
> that index.  Considering the array is linear, the loop overhead is just
> that -- overhead.  So unless I missed something, convert it into an index
> check and access the desired resource directly.  Resulting code makes a
> lot more sense considering its purpose.

This showed up in linux-next for me today and is causing breakage on at
least S3C64xx platforms since it changes the resource numbering when
there's more than one resource type for a device:

> -	for (i = 0; i < dev->num_resources; i++) {
> -		struct resource *r = &dev->resource[i];
> -
> -		if (type == resource_type(r) && num-- == 0)
> +	if (num >= 0 && num < dev->num_resources) {
> +		struct resource *r = &dev->resource[num];
> +		if (type == resource_type(r))

Previously the resources were indexed within their type (so you'd get
I/O resources 0, 1, ..., IRQ resources 0, 1, ... and so on) but now the
index treats all the resources for a device as a single array, causing
them to be renumbered for callers.

This causes drivers doing lookups by number to fail to find their
resources and not probe, causing widespread breakage.  Reverting the
patch fixes the problem.
