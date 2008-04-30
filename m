Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbYD3Hm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbYD3Hm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbYD3HmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:42:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59344 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbYD3HmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:42:20 -0400
Date: Wed, 30 Apr 2008 16:44:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       y-goto@jp.fujitsu.com
Subject: Re: sparc64 bootup regression...
Message-Id: <20080430164444.b5b5e6aa.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080430073052.GA11015@osiris.boeblingen.de.ibm.com>
References: <20080429.231241.221824292.davem@davemloft.net>
	<20080429233832.168fb6ee.akpm@linux-foundation.org>
	<20080430161540.bfff2c45.kamezawa.hiroyu@jp.fujitsu.com>
	<20080430073052.GA11015@osiris.boeblingen.de.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 09:30:52 +0200
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > How about this ? If this is messy (or doesn't work), Goto-san will rework
> > his own patch by himself. (this patch is against -mm but I think no HUNK to
> > git tree)
> > 
> > ==
> > This kind of page allocation, which specifies the address range,
> > can fail easily.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiruyo@jp.fujitsu.com>
> > 
> > Index: mm-2.6.25-mm1/mm/sparse.c
> > ===================================================================
> > --- mm-2.6.25-mm1.orig/mm/sparse.c
> > +++ mm-2.6.25-mm1/mm/sparse.c
> > @@ -264,10 +264,16 @@ static unsigned long *__init sparse_earl
> >  	 * To solve above issue, this collects all usemap on the same section
> >  	 * which has pgdat.
> >  	 */
> > +#ifdef CONFIG_NUMA /* contig_page_data for !NUMA case is not good to do this */
> >  	section_nr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
> >  	usemap = alloc_bootmem_section(usemap_size(), section_nr);
> >  	if (usemap)
> >  		return usemap;
> > +#endif
> > +	/* above allocation can fail. */
> > +	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
> > +	if (usemap)
> > +		return usemap;
> > 
> >  	/* Stupid: suppress gcc warning for SPARSEMEM && !NUMA */
> >  	nid = 0;
> 
> Fixes it on s390 at least.
> 
Thanks, much help to understand what happens.
BTW, s390 is CONFIG_NUMA or not ?

Regards,
-Kame

