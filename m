Return-Path: <linux-kernel-owner+w=401wt.eu-S1423248AbXBPFMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423248AbXBPFMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 00:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423249AbXBPFMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 00:12:13 -0500
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:36672 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1423248AbXBPFMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 00:12:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UsdfefOIamzLjN5r8omy63DzoX75QKR4uh1TwIPAXO6nljY2OTovzRtH/YNngMxzM4Cb7YLLt7mOMLo9Qh5Ko+eNQ5gGAfddW3tMZz5NUpNYyG0XKW+IISW6FHesNTlKJlyxhpWmkQQHL5xwS5FSZRlbbQAEn/oDZNuY1kOy5Y4=  ;
X-YMail-OSG: ZwNan84VM1l0eYCIULrs4o84zRH0zA7Rp1N6YcydkwebGt24q8UfiBFEY_nAmA.8R8dmygxxSeV8OvxAzODbQCnLIFwuqojuGmEvoPzVDMKtl4ybohlf.yxVFlRYqra8_x3.KvSalkKwsRg-
From: David Brownell <david-b@pacbell.net>
To: Len Brown <lenb@kernel.org>
Subject: Re: loosen dependancy on rtc cmos
Date: Thu, 15 Feb 2007 21:12:08 -0800
User-Agent: KMail/1.7.1
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070214180915.GA6412@redhat.com> <200702141547.36106.david-b@pacbell.net> <200702152338.47151.lenb@kernel.org>
In-Reply-To: <200702152338.47151.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702152112.08970.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 February 2007 8:38 pm, Len Brown wrote:

> So I've taken Andi's advice and checked in the patches below.

OK; that simplifies things for me, good!  I can discard that patch
(broken by Andi's pcspkr change anyway), stop worring about whether
most folk will even see that driver, and make time to look at the
ACPI hooks for RTC wakeup, instead.  :)


But it would be nice to see the PNP bus infrastructure upgraded in
various ways too, now that its availability is less iffy.

 - Add something analagous to platform_driver_probe() so that the
   init code can be removed after it runs.

 - Add shutdown() calls to the PNP bus.  Otherwise e.g. one must
   use shutdown notifiers for PNP interfaces, while normal driver
   model code works for other interfaces to such hardware.

Transitioning from "legacy" drivers to PNP (for PCs) and platform_bus
(other platforms) is a bit awkward because of differences like those.
Drivers still need too many different modes; it's too complicated to
have a core with different bus glues as thin veneers ... the glue must
be thicker (and thus error prone).  Similarly, I/O space resource
reservation acts differently.

I can hope that having PNPACPI be more common will start nudging
more drivers to get rid of their "legacy" modes, or at least focus
on "Real Driver" modes that don't involve poking at hardware and
hoping it doesn't bite back.  ;)

- Dave



> commit 243b66e76ab722cdec1921d7f80c0cb808131c37
> Author: Len Brown <len.brown@intel.com>
> Date:   Thu Feb 15 22:34:36 2007 -0500
> 
>     ACPI: always enable CONFIG_PNPACPI on CONFIG_ACPI kernels
>     
>     We removed the ACPI motherboard driver which handled
>     the ACPI=y, PNP=n case, so now we need to enforce that
>     PNP & PNPACPI are always enabled for ACPI kernels.
>     
>     Most major distros ship this way this already.
>     
>     Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 


> commit 8d4956c201c2f7683289f70095443c59a39f94ef
> Author: Len Brown <len.brown@intel.com>
> Date:   Thu Feb 15 22:46:42 2007 -0500
> 
>     ACPI: remove non-PNPACPI version of get_rtc_dev()
>     
>     It isn't needed in ACPI code anymore because
>     now ACPI always includes PNPACPI.
>     
>     Cc: David Brownell <david-b@pacbell.net>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 

