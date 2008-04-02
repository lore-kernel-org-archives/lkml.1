Return-Path: <linux-kernel-owner+w=401wt.eu-S1759001AbYDBX2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001AbYDBX2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 19:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbYDBX17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 19:27:59 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53934 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbYDBX16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 19:27:58 -0400
Subject: Re: [PATCH RFC] hotplug-memory: refactor online_pages to separate
	zone growth from page onlining
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <47F404F1.30103@goop.org>
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
	 <1207172610.23710.55.camel@nimitz.home.sr71.net>  <47F404F1.30103@goop.org>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 16:27:55 -0700
Message-Id: <1207178875.23710.70.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 15:13 -0700, Jeremy Fitzhardinge wrote:
> Dave Hansen wrote:
> > Yeah, but I'm just talking about hotplugged memory.  When we add it, we
> > don't have to map the added pages (since they're highmem) and don't have
> > to touch their contents and zero them out, either.  Then, the balloon
> > driver can notice that the memory is too large, and start to balloon it
> > down.
> 
> I didn't think x86-64 had a notion of highmem.

It doesn't.

> How do you prevent the pages from being used before they're ballooned out?

I think there are a few options here.  One is to check on the way out of
the allocator that we're not over some Xen-specific limit.  Basically
that we aren't about to touch a hardware page for which the hypervisor
hasn't allocating backing memory.

Another is to give pages sitting in the allocator some kind of
associated state or keep them on separate lists.  (I think this has
something in common with those s390 CMM patches).  When you want to
allocate a page, you not only pull it off the buddy lists, but you also
have to check with the hypervisor to make sure it has backing store
before you actually return it.  You make it non-volatile in CMM-speak (I
think).

If you can't allocate backing store for a page, you toss it over to the
balloon driver (who's whole job is to keep track of pages without
hypervisor backing anyway) and go back to the allocator for another
one.  

> >> Everything also applies to x86-64.
> >
> > Not really, though.  We don't have the page->flags shortage or lack of
> > vmemmap on x86_64.
> 
> Right now, I'd rather have a single mechanism that works for both.

Yeah, that would be most ideal.  But, at the same time, you don't want
to hobble your rockstar x86_64 implementation with quirks inherited from
the crufy 32-bit junk. :)

-- Dave

