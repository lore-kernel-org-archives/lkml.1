Return-Path: <linux-kernel-owner+w=401wt.eu-S933784AbYAaNWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784AbYAaNWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 08:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761304AbYAaNW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 08:22:26 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:61553 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733AbYAaNWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 08:22:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ij746QPVG2nQX0AdhjgB3wsmDAFVfvyR0gp3eswYE2X6vYa+OOtnYt30L+7MKv/I0bkzCmy1YHPTpofBAX2rt480IBlw5JzS2fGPEjwgob4ZMI47AIOTqWp4eUl+eL8Ie7AR/oIRpjTKadszqAkw2yq9IVSeaTqj1UEs1KOMEsQ=
Message-ID: <851fc09e0801310522s2d690c3ejef661e5ce6847f73@mail.gmail.com>
Date: Thu, 31 Jan 2008 21:22:20 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH 4/5] x86: add executable mapping support to ioremap
Cc: "Huang, Ying" <ying.huang@intel.com>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.00.0801311324270.9204@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201764967.12950.25.camel@caritas-dev.intel.com>
	 <alpine.LFD.1.00.0801311324270.9204@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008 9:00 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 31 Jan 2008, Huang, Ying wrote:
>
> > This patch makes ioremap() can be used to map pages as executable,
> > this is needed by EFI support.
>
> > +extern void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
> > +                            enum ioremap_mode mode,
> > +                            enum ioremap_xmode xmode);
> > +
>
> Why do you want to add a new API?
>
>     addr = ioremap(phys_addr, len);
>     set_memory_x(addr);
>
> should do what you want already. I think Arjan was not very clear in
> his reply yesterday.

In current implementation, change_page_attr() can be used to change
identity map only.  At least I can find __pa() are used in
change_page_attr_addr() to get physical address. So I think
change_page_attr() should be fixed firstly.

> We tried to avoid the intermingling of ioremap and the page attribute
> settings. We just kept the cached/uncached part.
>
> Now thinking about it further, we should probably fully decouple the
> mapping and the attribute change and remove the enum argument from
> __ioremap and change the implementations of ioremap_cached and
> ioremap_uncached to do the attribute setting after the remap.
>
> That way ioremap_chached and ioremap_uncached just would become what
> they should be: conveniance functions for the developers.

If the memory area be ioremap() has identity map too. We need two
set_memory_xxx(addr). That is, we need:

addr = ioremap(phys_addr, len);
set_memory_x(addr);
if (phys_addr < (end_pfn_mapped >> PAGE_SHIFT))
        set_memory_x(__va(phys_addr));

Maybe we can hide the fact of identity map into set_memory_xxx(), just
specify the physical address to set_memory_xxx() too.

Best Regards,
Huang Ying
