Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYGGKgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYGGKgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 06:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYGGKgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 06:36:06 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48043 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbYGGKgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 06:36:05 -0400
Date: Mon, 07 Jul 2008 19:24:06 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] Make CONFIG_MIGRATION available for s390
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>
In-Reply-To: <20080707090635.GA6797@shadowen.org>
References: <1215354957.9842.19.camel@localhost.localdomain> <20080707090635.GA6797@shadowen.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080707185433.5A5D.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Index: linux-2.6/include/linux/migrate.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/migrate.h
> > +++ linux-2.6/include/linux/migrate.h
> > @@ -13,6 +13,7 @@ static inline int vma_migratable(struct 
> >  {
> >  	if (vma->vm_flags & (VM_IO|VM_HUGETLB|VM_PFNMAP|VM_RESERVED))
> >  		return 0;
> > +#ifdef CONFIG_NUMA
> >  	/*
> >  	 * Migration allocates pages in the highest zone. If we cannot
> >  	 * do so then migration (at least from node to node) is not
> > @@ -22,6 +23,7 @@ static inline int vma_migratable(struct 
> >  		gfp_zone(mapping_gfp_mask(vma->vm_file->f_mapping))
> >  								< policy_zone)
> >  			return 0;
> > +#endif
> 
> include/linux/mempolicy.h already has a !NUMA section could we not just
> define policy_zone as 0 in that and leave this code unconditionally
> compiled?  Perhaps also adding a NUMA_BUILD && to this 'if' should that
> be clearer.
> 
Ah, yes. It's better. :-)


> But this does make me feel uneasy.  Are we really saying all memory on
> an s390 is migratable.  That seems unlikely. As I understand the NUMA
> case, we only allow migration of memory in the last zone (last two if we
> have a MOVABLE zone) why are things different just because we have a
> single 'node'.  Hmmm.  I suspect strongly that something is missnamed
> more than there is a problem.

If my understanding is correct, even if this policy_zone check is removed,
page isolation will just fail due to some busy pages.
In hotplug case, it means giving up of hotremoving,
and kernel must be rollback to make same condition of previous
starting offline_pages().
This check means just "early" check, but not so effective for hotremoving,
I think....


Thanks.

-- 
Yasunori Goto 


