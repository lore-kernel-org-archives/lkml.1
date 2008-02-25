Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYBYPu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYBYPu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 10:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbYBYPuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 10:50:50 -0500
Received: from mga06.intel.com ([134.134.136.21]:8360 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753477AbYBYPut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 10:50:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,401,1199692800"; 
   d="scan'208";a="259487056"
Date: Mon, 25 Feb 2008 07:55:38 -0800
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]iova-lockdep-false-alarm-fix.
Message-ID: <20080225155538.GB22018@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20080221003528.GA5566@linux.intel.com> <20080223000512.0c2e469c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223000512.0c2e469c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 12:05:12AM -0800, Andrew Morton wrote:
> 
> > Subject: [PATCH]iova-lockdep-false-alarm-fix.
> 
> Nice English titles, please...
> 
> On Wed, 20 Feb 2008 16:35:28 -0800 mark gross <mgross@linux.intel.com> wrote:
> 
> > lockdep goes off on the iova copy_reserved_iova because it and a
> > function it calls grabs locks in the from, and the to of the copy
> > operation.
> > 
> > This patch gives the reserved_ioval_list locks special lockdep classes.
> > 
> > 
> 
> Confused.  Why not fix the ranking inconsistency instead?

Its not a ranking inconsistency issues the function grab locks of the
same lock classes triggering the warning.  The first lock grabbed is for
the constant reserved areas that is never accessed after early boot.
Technically you could do without grabbing the locks for the "from"
structure its copying reserved areas from.

But dropping the from locks to me looks wrong, even though it would be ok.

The affected code only runs in early boot as its setting up the DMAR
engines.

--mgross

> 
> Your changelog doesn't tell us why this isn't a real bug?
> 
> > Index: linux-2.6.24-mm1/drivers/pci/intel-iommu.c
> > ===================================================================
> > --- linux-2.6.24-mm1.orig/drivers/pci/intel-iommu.c	2008-02-20 15:52:23.000000000 -0800
> > +++ linux-2.6.24-mm1/drivers/pci/intel-iommu.c	2008-02-20 16:08:27.000000000 -0800
> > @@ -1127,6 +1127,8 @@
> >  }
> >  
> >  static struct iova_domain reserved_iova_list;
> > +static struct lock_class_key reserved_alloc_key;
> > +static struct lock_class_key reserved_rbtree_key;
> >  
> >  static void dmar_init_reserved_ranges(void)
> >  {
> > @@ -1137,6 +1139,11 @@
> >  
> >  	init_iova_domain(&reserved_iova_list, DMA_32BIT_PFN);
> >  
> > +	lockdep_set_class(&reserved_iova_list.iova_alloc_lock,
> > +		&reserved_alloc_key);
> > +	lockdep_set_class(&reserved_iova_list.iova_rbtree_lock,
> > +		&reserved_rbtree_key);
> > +
> >  	/* IOAPIC ranges shouldn't be accessed by DMA */
> >  	iova = reserve_iova(&reserved_iova_list, IOVA_PFN(IOAPIC_RANGE_START),
> >  		IOVA_PFN(IOAPIC_RANGE_END));
