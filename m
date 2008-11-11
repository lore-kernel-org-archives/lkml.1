Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbYKKNL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbYKKNL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 08:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYKKNLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 08:11:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57609 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755564AbYKKNLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 08:11:18 -0500
Date: Tue, 11 Nov 2008 13:11:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cbouatmailru@gmail.com, sameo@openedhand.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: Add support for WM8350 PMU
Message-ID: <20081111131116.GA23180@rakim.wolfsonmicro.main>
References: <1225984523-15911-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081110154330.f95ec239.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110154330.f95ec239.akpm@linux-foundation.org>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 03:43:30PM -0800, Andrew Morton wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> An idle question...

[Reordered for conveninece in replying.]

> The above constitutes a sort-of userspace interface.  A number of the
> things which are being reported there are fairly common to the
> technology and other drivers will be able to report them.

> But afaict this interface is unique to this particular driver.  Has any
> thought been given to standardising this interface across all similar
> drivers?  Too messy?

I've got several answers...

> > +		supply = "Battery";
> > +		supply = "USB";
> > +		supply = "Line";
> > +		supply = "Battery and USB";

This sysfs file is just redundant and could be removed.

> > +		charge = "Charger Off";
> > +		charge = "Trickle Charging";
> > +		charge = "Fast Charging";

There's some support for this already (which implemented in the driver)
but it doesn't distinguish between fast and trickle charging.  It's
useful to know for debugging systems but I wasn't able to convince
myself it was generically useful enough to add to the class ABI,
especially given the existing boolean reporting.

> > +		dev_err(wm8350->dev, "battery too hot\n");
> > +		dev_err(wm8350->dev, "battery too cold\n");
> > +		dev_err(wm8350->dev, "battery failed\n");
> > +		dev_err(wm8350->dev, "charger timeout\n");

These are a bit tricky with the WM8350 since the chip gives latched edge
notifications of errors but doesn't provide the current status directly.
There is some generic battery health status reporting in the interface
(though not quite so specific) but I wasn't comfortable supporting it
without being able to read back the current status.

> > +		dev_dbg(wm8350->dev, "charger stopped\n");
> > +		dev_dbg(wm8350->dev, "charger started\n");
> > +		dev_dbg(wm8350->dev, "fast charger ready\n");

On a closer look it appears that started and stopped are already
notified to user space - the driver should be calling
power_supply_changed() when these happen.  Reporting the fast charger
ready status would fall out if a standard interface for polling this
status were implemented.

> > +		dev_warn(wm8350->dev, "battery < 3.9V\n");
> > +		dev_warn(wm8350->dev, "battery < 3.1V\n");
> > +		dev_warn(wm8350->dev, "battery < 2.85V\n");

I'm ambivalent on these ones, especially given that none of the other
health issues are being reported.
