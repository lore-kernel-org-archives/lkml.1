Return-Path: <linux-kernel-owner+w=401wt.eu-S1759678AbYAKIez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbYAKIez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbYAKIes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:34:48 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:16370 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbYAKIer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:34:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xr3r+LfuYKEGtX7DUyEdKFhXdJ4FoFZn8igHGjZmj7tGTqkc9aIATADnH9Cx4U1CjNch+RK2OueIhZN1rQtzG8ikOZeck8riCyWcHK1AwyeMn0dFFe2zwUObuhO5ll0WrErrwxzx7rB/6r/De91YXCa6Qk03Upvwk8ekx4YGL5M=
Message-ID: <86802c440801110034r89339bcrf9d7bd697ec9c3ae@mail.gmail.com>
Date: Fri, 11 Jan 2008 00:34:46 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86-64: disable the GART early v2
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <clameter@sgi.com>, ebiederm@xmission.com,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080111081446.GA6234@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801101914.47967.yinghai.lu@sun.com>
	 <200801102354.46472.yinghai.lu@sun.com>
	 <20080111081446.GA6234@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 11, 2008 12:14 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
>
> > --- a/arch/x86/kernel/aperture_64.c
> > +++ b/arch/x86/kernel/aperture_64.c
> > @@ -218,6 +218,73 @@ static __u32 __init search_agp_bridge(u32 *order, int *valid_agp)
> >       return 0;
> >  }
> >
> > +void __init early_gart_iommu_disable(void)
> > +{
> > +     /*
> > +      * disable it in case it is enabled before, esp for kexec/kdump,
> > +      * previous kernel already enable that. otherwise memset called
> > +      * by allocate_aperture/__alloc_bootmem_nopanic cause restart.
> > +      * or second kernel have different position for GART hole. and new
> > +      * kernel could use hole as RAM that is still used by GART set by
> > +      * first kernel
> > +      */
>
> hm, i'm wondering, instead of modifying the GART, why dont we simply
> _detect_ whatever GART settings we have inherited, and propagate that
> into our e820 maps? I.e. if there's inconsistency, then punch that out
> from the memory maps and just dont use that memory.
>
> that way it would not matter whether the GART settings came from a [old
> or crashing] Linux kernel that has not called gart_iommu_shutdown(), or
> whether it's a BIOS that has set up an aperture hole inconsistent with
> the memory map it passed. (or the memory map we _think_ i tried to pass
> us)
>
good, i will update the patch to check that hole with e820 map.

that also make code short so don't need to check if agp is there or not.

YH
