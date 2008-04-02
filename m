Return-Path: <linux-kernel-owner+w=401wt.eu-S1761294AbYDBTAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294AbYDBTAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760812AbYDBS74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:59:56 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56202 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760796AbYDBS7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:59:55 -0400
Subject: Re: [PATCH RFC] hotplug-memory: refactor online_pages to separate
	zone growth from page onlining
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <47F3D5D9.1010301@goop.org>
References: <47ED8685.9040409@goop.org>
	 <1206751622.27091.20.camel@nimitz.home.sr71.net>
	 <47EDA4B9.6030801@goop.org>
	 <1206806774.31896.27.camel@nimitz.home.sr71.net>
	 <47EED683.5030200@goop.org>
	 <1206981741.31896.51.camel@nimitz.home.sr71.net>
	 <47F1282E.3020503@goop.org>
	 <1207161962.23710.23.camel@nimitz.home.sr71.net>
	 <47F3D5D9.1010301@goop.org>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 11:59:52 -0700
Message-Id: <1207162792.23710.28.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 11:52 -0700, Jeremy Fitzhardinge wrote:
> > Why don't we just have hotplug work that way?  When we want to take a
> > guest from 1GB to 1GB+1 page (or whatever), we just hotplug the entire
> > section (512MB or 1GB or whatever), actually online the whole thing,
> > then make the balloon driver take it back to where it *should* be.  That
> > way we're completely reusing existing components that have do be able to
> > handle this case anyway.
> >
> > Yeah, this is suboptimal, an it has a possibility of fragmenting the
> > memory, but it will only be used for the x86-32 case.
> >   
> 
> It also requires you actually have the memory on hand to populate the 
> whole area.  512MB is still a significant chunk on a 2GB server; you may 
> end up generating significant overall system memory pressure to scrape 
> together the memory, only to immediately discard it again.

That's a very good point.  Can we make it so that the hypervisors don't
actually allocate the memory to the guest until its first touch?  If the
pages are on the freelist, their *contents* shouldn't be touched at all
during the onlining process.

Maybe we could put a special mark on the pages (please no page flag :)
and the allocator can jump in and ask for the page from the hypervisor
before returning it to the system.  I think Anthony had some ideas
around this area.  It's kinda a poor man's page hinting.

-- Dave

