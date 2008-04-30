Return-Path: <linux-kernel-owner+w=401wt.eu-S1758499AbYD3HbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499AbYD3HbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755147AbYD3Haz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:30:55 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:7925 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbYD3Hay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:30:54 -0400
Date: Wed, 30 Apr 2008 09:30:52 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       y-goto@jp.fujitsu.com
Subject: Re: sparc64 bootup regression...
Message-ID: <20080430073052.GA11015@osiris.boeblingen.de.ibm.com>
References: <20080429.231241.221824292.davem@davemloft.net> <20080429233832.168fb6ee.akpm@linux-foundation.org> <20080430161540.bfff2c45.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430161540.bfff2c45.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 04:15:40PM +0900, KAMEZAWA Hiroyuki wrote:
> On Tue, 29 Apr 2008 23:38:32 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Tue, 29 Apr 2008 23:12:41 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
> > > This commit causes bootup failures on sparc64:
> > > 
> > > commit 86f6dae1377523689bd8468fed2f2dd180fc0560
> > > Author: Yasunori Goto <y-goto@jp.fujitsu.com>
> > > Date:   Mon Apr 28 02:13:33 2008 -0700
> > > 
> > >     memory hotplug: allocate usemap on the section with pgdat
> > Thanks.  Does a straightforward revert fix it?  If so, we could do that while heads
> > are being scratched.

That patch broke the s390 port to SPARSEMEM (not upstream yet) as well.
Reverting it does help.
However increasing SECTION_SIZE_BITS to 25 (was: 20) does help too.
But that doesn't seem to help on sparc64 where it is already 30, strange.

> How about this ? If this is messy (or doesn't work), Goto-san will rework
> his own patch by himself. (this patch is against -mm but I think no HUNK to
> git tree)
> 
> ==
> This kind of page allocation, which specifies the address range,
> can fail easily.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiruyo@jp.fujitsu.com>
> 
> Index: mm-2.6.25-mm1/mm/sparse.c
> ===================================================================
> --- mm-2.6.25-mm1.orig/mm/sparse.c
> +++ mm-2.6.25-mm1/mm/sparse.c
> @@ -264,10 +264,16 @@ static unsigned long *__init sparse_earl
>  	 * To solve above issue, this collects all usemap on the same section
>  	 * which has pgdat.
>  	 */
> +#ifdef CONFIG_NUMA /* contig_page_data for !NUMA case is not good to do this */
>  	section_nr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
>  	usemap = alloc_bootmem_section(usemap_size(), section_nr);
>  	if (usemap)
>  		return usemap;
> +#endif
> +	/* above allocation can fail. */
> +	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
> +	if (usemap)
> +		return usemap;
> 
>  	/* Stupid: suppress gcc warning for SPARSEMEM && !NUMA */
>  	nid = 0;

Fixes it on s390 at least.
