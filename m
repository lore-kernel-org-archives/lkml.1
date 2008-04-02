Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbYDBVpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbYDBVpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762808AbYDBVnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:43:35 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53029 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762799AbYDBVne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:43:34 -0400
Subject: Re: [PATCH RFC] hotplug-memory: refactor online_pages to separate
	zone growth from page onlining
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <47F3FC2E.7090806@goop.org>
References: <47ED8685.9040409@goop.org>
	 <1206751622.27091.20.camel@nimitz.home.sr71.net>
	 <47EDA4B9.6030801@goop.org>
	 <1206806774.31896.27.camel@nimitz.home.sr71.net>
	 <47EED683.5030200@goop.org>
	 <1206981741.31896.51.camel@nimitz.home.sr71.net>
	 <47F1282E.3020503@goop.org>
	 <1207161962.23710.23.camel@nimitz.home.sr71.net>
	 <47F3D5D9.1010301@goop.org>
	 <1207162792.23710.28.camel@nimitz.home.sr71.net>
	 <47F3F4A0.9010009@goop.org>
	 <1207171050.23710.48.camel@nimitz.home.sr71.net>
	 <47F3FC2E.7090806@goop.org>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 14:43:30 -0700
Message-Id: <1207172610.23710.55.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 14:35 -0700, Jeremy Fitzhardinge wrote:
> Dave Hansen wrote:
> > Oh, once we've let Linux establish ptes to it, we've required that the
> > hypervisor have it around?  How does that work with the balloon driver?
> > Do we destroy the ptes when giving balloon memory back to the
> > hypervisor?
> 
> Yep.  It removes any mapping before handing it back to the hypervisor.

Wow.  So does Xen ever use PSE to map kernel data?  That sucks.

> > If we're talking about i386, then we're set.  We don't map the hot-added
> > memory at all because we only add highmem on i386.  The only time we map
> > these pages is *after* we actually allocate them when they get mapped
> > into userspace or used as vmalloc() or they're kmap()'d.
> 
> Well, the balloon driver can balloon out lowmem pages, so we have to 
> deal with mappings either way.  But balloon+hotplug would work 
> identically on x86-64, so all pages are mapped.

Yeah, but I'm just talking about hotplugged memory.  When we add it, we
don't have to map the added pages (since they're highmem) and don't have
to touch their contents and zero them out, either.  Then, the balloon
driver can notice that the memory is too large, and start to balloon it
down.

> >> I think we're getting off track here; this is a lot of extra complexity 
> >> to justify allowing usermode to use /sys to online a chunk of hotplugged 
> >> memory.
> >>     
> >
> > Either that, or we're going to develop the entire Xen/kvm memory hotplug
> > architecture around the soon-to-be-legacy i386 limitations. :)
> 
> Everything also applies to x86-64.

Not really, though.  We don't have the page->flags shortage or lack of
vmemmap on x86_64.

-- Dave

