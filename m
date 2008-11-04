Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbYKDIuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbYKDIuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 03:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYKDIuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 03:50:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45210 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbYKDIuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 03:50:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [linux-pm] [PATCH] hibernation should work ok with memory hotplug
Date: Tue, 4 Nov 2008 09:54:33 +0100
User-Agent: KMail/1.9.9
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       Matt Tolentino <matthew.e.tolentino@intel.com>, linux-pm@lists.osdl.org,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, pavel@suse.cz, Mel Gorman <mel@skynet.ie>,
       Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz> <200811040808.36464.rjw@sisk.pl> <1225784174.12673.547.camel@nimitz>
In-Reply-To: <1225784174.12673.547.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811040954.34969.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 4 of November 2008, Dave Hansen wrote:
> On Tue, 2008-11-04 at 08:08 +0100, Rafael J. Wysocki wrote:
> > A pfn always refers to specific page frame and/or struct page, so yes.
> > However, in one of the nodes these pfns are sort of "invalid" (they point
> > to struct pages belonging to other zones).  AFAICS.
> 
> Part of this problem is getting out of the old zone mindset.  It used to
> be that there were one, two, or three zones, set up at boot, with static
> ranges.  These never had holes, never changed, and were always stacked
> up nice and tightly on top of one another.  It ain't that way no more.

In fact there were two assumptions about zones in the hibernation code,
that they are static and that they don't overlap.  The second one may be
removed by the patch I sent before, but there still is a problem related to
the first one, which is that the memory management structures (bitmaps) used
by us depend on the zones being static.

Of course, we create the image atomically, but the bitmaps are created earlier
with the assumption that the zones won't change aferwards.  Also, if memory
hotplugging is used _after_ the image has been created, the zones may change
in a way that's not compatible with the structure of the bitmaps.

To handle this, I need to know two things:
1) what changes of the zones are possible due to memory hotplugging (i.e.
   can they grow, shring, change boundaries etc.)
2) what kind of locking is needed to prevent zones from changing.

Thanks,
Rafael
