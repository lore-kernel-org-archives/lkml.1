Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbYC0WhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbYC0WhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 18:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYC0Wgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 18:36:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751709AbYC0Wgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 18:36:54 -0400
Date: Thu, 27 Mar 2008 15:34:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
cc: Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, pm@debian.org
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
In-Reply-To: <20080327221851.GA9675@jurassic.park.msu.ru>
Message-ID: <alpine.LFD.1.00.0803271529100.14670@woody.linux-foundation.org>
References: <20080326135458.GA27621@elte.hu> <20080326180701.GA6249@us.ibm.com> <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org> <20080326203012.GB6249@us.ibm.com> <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org>
 <20080326205828.GA15225@jurassic.park.msu.ru> <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org> <20080326232922.GA15784@jurassic.park.msu.ru> <alpine.LFD.1.00.0803261638350.2775@woody.linux-foundation.org> <alpine.LFD.1.00.0803271004380.2775@woody.linux-foundation.org>
 <20080327221851.GA9675@jurassic.park.msu.ru>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Mar 2008, Ivan Kokshaysky wrote:
> 
> Sounds good to me. So here we go (completely untested, just for review).
[...]
> -	/* The bridge resources are special, as their
> -	   size != alignment. Sizing routines return
> -	   required alignment in the "start" field. */
> -	align = (resno < PCI_BRIDGE_RESOURCES) ? size : res->start;
> +
> +	align = resource_alignment(res);
> +	BUG_ON(!align);

Don't do the BUG_ON(). That would just cause a broken machine, and makes 
it much harder to report this issue. BUG_ON() should be used only for 
totally unfixable things.

In this case, the easy thing to do is to just return an error, possibly 
with a printk() about bogus resources (ignoring it as a resource, the way 
we do it in pdev_sort_resource()).

But other than that, the thing doesn't look horrible.

		Linus
