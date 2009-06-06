Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbZFFGBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbZFFGBs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 02:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbZFFGBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 02:01:40 -0400
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:42332 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750721AbZFFGBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 02:01:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uWPGCUFRGme4cCYpUfdQbKCTehG6LAr9pkg6BHpYNSW1xt3sBWfG24n71978jpujipitFAb3aLRWHFU8gmxAYuJUkb7c+2Fz4/frMFMlAnrIVmVn30d9Sd+aj3NtCRLl8egr3heQmOhQAMtZuaFGqzpVlTwwTJSXNHmghiB1oSo=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: MlKlU8oVM1mJ9Te4T6TUAplPdolOYzKbvvT5w8fCngj6X4SOHyJjjh8bY6O2MIkS4QJq4u1EdRQxnodOqmQdNQUjacadfCDx9BFGzYJzJYi4.sYZoc_UPj4BKrySc1dcEbYABf6._ZJauAP1OECkn8vsZK4vIRK3ofuTFPR4hyJCMDw61WnOUr.CUDahoInQCjYuK_j0wEaQCUYqT5PLwnj3exG6hq2E4U5Jv1MhQ8PtdVgNqDq8kV2avpBGKOjYJJBbC0yBQU3p.5SKlrJq3VfADJvHIfdVkLQD5S8A93Qtjbrn0Gg-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: [PATCH] gpiolib: allow poll on gpio value
Date: Fri, 5 Jun 2009 23:01:39 -0700
User-Agent: KMail/1.9.10
Cc: Daniel =?iso-8859-1?q?Gl=F6ckner?= <dg@emlix.com>,
       linux-kernel@vger.kernel.org
References: <1244212590-15620-1-git-send-email-dg@emlix.com> <1244260002.22690.21.camel@linux-51e8.site>
In-Reply-To: <1244260002.22690.21.camel@linux-51e8.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906052301.39877.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 June 2009, Ben Nizette wrote:
> 
> Hey, good stuff Daniel.  There's a fair few common features missing but
> they can be added at a later date.
> 
> - Ability to honour rising and falling filters even if the hardware only
> supports both-edge (as lots of gpio interrupts do)

I suspect that's inadvisable.  Userspace code will need to know
what trigger model it's using, yes?  Lies are doubleplusungood.


> - Support for polling the gpio at some interval for gpios which don't
> support irqs at all

I had that thought.  Units ... seconds?  Milliseconds mapped to HZ?
Could come later.


> - Debounce support

Software?  Hardware capabilties vary *widely* ... three cases that
come quickly to mind:  (a) twl4030 fixed 30 msec delays, (b) at91
and avr32 "deglitch" filter, just syncs to a clock that's likely
from 30-100 MHz, (c) omap2/omap3, up to 255 cycles of 32 KiHz clock
but appplies entire GPIO banks, (d) DaVinci, no hardware support.

I can imagine a standard software filter option, but that would
need to be a separate sysfs mechanism since it wouldn't always
be desired.  (And separate patch, if needed.)

For hardware options ... do that by hardware-specific sysfs hooks
if they're really needed.


> - Reporting of number of changes since last read

Feels a more than bit overkilled by now.  ;)


> These are all things which exist in many out-of-tree or
> platform-specific implementations of this kind of thing and until
> they're there I reckon people will largely stick with what they've got.
> But that's really their problem of course, this is still valuable.
> 
> Regarding the code itself, not much but:
> 
> On Fri, 2009-06-05 at 16:36 +0200, Daniel Glöckner wrote:
> >  
> > +	"poll_edge" ... reads as either "none", "rising", "falling", or
> 
> IMO this is misleading, sounds like you're polling the gpio. 

So, just name the sysfs attribute "edge"?

 
> > +
> > +	struct sysfs_dirent	*value_sd;
> >  };
> 
> No CONFIG_ option to turn all this off?
> 
> What's the .text and .data impact of this?  Sure it's going to be small,
> but to some people (especially those likely to care about gpio) 1k
> of .data is something worth being able to turn off.

I think it's probably OK to have this covered by the current
GPIO_SYSFS flag.

 
> Using an IDR keyed to the gpio value and just allocating your useful
> data structures when poll_edge != "none" would help too.

Can do that without an IDR, I think...

