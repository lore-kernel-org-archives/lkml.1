Return-Path: <linux-kernel-owner+w=401wt.eu-S1762352AbYDBSqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762352AbYDBSqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758915AbYDBSqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:46:08 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34899 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762264AbYDBSqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:46:06 -0400
Subject: Re: [PATCH RFC] hotplug-memory: refactor online_pages to separate
	zone growth from page onlining
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <47F1282E.3020503@goop.org>
References: <47ED8685.9040409@goop.org>
	 <1206751622.27091.20.camel@nimitz.home.sr71.net>
	 <47EDA4B9.6030801@goop.org>
	 <1206806774.31896.27.camel@nimitz.home.sr71.net>
	 <47EED683.5030200@goop.org>
	 <1206981741.31896.51.camel@nimitz.home.sr71.net>
	 <47F1282E.3020503@goop.org>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 11:46:02 -0700
Message-Id: <1207161962.23710.23.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-31 at 11:06 -0700, Jeremy Fitzhardinge wrote:
> >> That said, if (partial-)sections were much smaller - say 2-4 meg -
> and 
> >> page migration/defrag worked reliably, then we could probably do
> without 
> >> the balloon driver and do it all in terms of memory hot plug/unplug.  
> >> That would give us a general mechanism which could either be driven from 
> >> userspace, and/or have in-kernel Xen/kvm/s390/etc policy modules.  Aside 
> >> from small sections, the only additional requirement would be an online 
> >> hook which can actually attach backing memory to the pages being 
> >> onlined, rather than just assuming an underlying DIMM as current code does.
> >>     
> >
> > Even with 1MB sections
> 
> 1MB is too small.  It shouldn't be smaller than the size of a large page.

Oh, I was just using 1MB as an easy-to-do-math-on-a-napkin number. :)

> >  and a flat sparsemem map, you're only looking at
> > ~500k of overhead for the sparsemem storage.  Less if you use vmemmap.  
> >   
> 
> At the moment my concern is 32-bit x86, which doesn't support vmemmap or 
> sections smaller than 512MB because of the shortage of page flags bits.

Yeah, I forgot that we didn't have vmemmap on x86-32.  Ugh.

OK, here's another idea: Xen (and the balloon driver) already handle a
case where a guest boots up with 2GB of memory but only needs 1GB,
right?  It will balloon the guest down to 1GB from 2GB.

Why don't we just have hotplug work that way?  When we want to take a
guest from 1GB to 1GB+1 page (or whatever), we just hotplug the entire
section (512MB or 1GB or whatever), actually online the whole thing,
then make the balloon driver take it back to where it *should* be.  That
way we're completely reusing existing components that have do be able to
handle this case anyway.

Yeah, this is suboptimal, an it has a possibility of fragmenting the
memory, but it will only be used for the x86-32 case.

-- Dave

