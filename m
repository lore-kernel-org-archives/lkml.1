Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbZA0VIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbZA0VIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZA0VHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:07:52 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:39992 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZA0VHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:07:51 -0500
Date: Tue, 27 Jan 2009 13:07:27 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gary Hade <garyhade@us.ibm.com>, Roel Kluin <roel.kluin@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, y-goto@jp.fujitsu.com
Subject: Re: [PATCH] mm: get_nid_for_pfn() returns int
Message-ID: <20090127210727.GA9592@us.ibm.com>
References: <4973AEEC.70504@gmail.com> <20090119175919.GA7476@us.ibm.com> <20090126223350.610b0283.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126223350.610b0283.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 10:33:50PM -0800, Andrew Morton wrote:
> On Mon, 19 Jan 2009 09:59:19 -0800 Gary Hade <garyhade@us.ibm.com> wrote:
> 
> > On Sun, Jan 18, 2009 at 11:36:28PM +0100, Roel Kluin wrote:
> > > get_nid_for_pfn() returns int
> > > 
> > > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > > ---
> > > vi drivers/base/node.c +256
> > > static int get_nid_for_pfn(unsigned long pfn)
> > > 
> > > diff --git a/drivers/base/node.c b/drivers/base/node.c
> > > index 43fa90b..f8f578a 100644
> > > --- a/drivers/base/node.c
> > > +++ b/drivers/base/node.c
> > > @@ -303,7 +303,7 @@ int unregister_mem_sect_under_nodes(struct memory_block *mem_blk)
> > >  	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
> > >  	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
> > >  	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
> > > -		unsigned int nid;
> > > +		int nid;
> > > 
> > >  		nid = get_nid_for_pfn(pfn);
> > >  		if (nid < 0)
> > 
> > My mistake.  Good catch.
> > 
> 
> Presumably the (nid < 0) case has never happened.

We do know that it is happening on one system while creating
a symlink for a memory section so it should also happen on
the same system if unregister_mem_sect_under_nodes() were
called to remove the same symlink.

The test was actually added in response to a problem with an
earlier version reported by Yasunori Goto where one or more
of the leading pages of a memory section on the 2nd node of
one of his systems was uninitialized because I believe they
coincided with a memory hole.  The earlier version did not
ignore uninitialized pages and determined the nid by considering
only the 1st page of each memory section.  This caused the
symlink to the 1st memory section on the 2nd node to be 
incorrectly created in /sys/devices/system/node/node0 instead
of /sys/devices/system/node/node1.  The problem was fixed by
adding the test to skip over uninitialized pages.

I suspect we have not seen any reports of the non-removal
of a symlink due to the incorrect declaration of the nid
variable in unregister_mem_sect_under_nodes() because
  - systems where a memory section could have an uninitialized
    range of leading pages are probably rare.
  - memory remove is probably not done very frequently on the
    systems that are capable of demonstrating the problem.
  - lingering symlink(s) that should have been removed may
    have simply gone unnoticed.
> 
> Should we retain the test?

Yes.

> 
> Is silently skipping the node in that case desirable behaviour?

It actually silently skips pages (not nodes) in it's quest
for valid nids for all the nodes that the memory section scans.
This is definitely desirable.

I hope this answers your questions.

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

