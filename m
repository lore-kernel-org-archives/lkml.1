Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbYAIJhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbYAIJhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 04:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYAIJhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 04:37:45 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:34383
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024AbYAIJho convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 04:37:44 -0500
Message-Id: <4784A405.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 09 Jan 2008 09:37:57 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>, "Andi Kleen" <ak@suse.de>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Glauber de Oliveira Costa" <glommer@gmail.com>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
References: <20080108232803.GA19906@elte.hu>
 <20080108234449.GA24274@elte.hu> <20080109000146.GA29095@elte.hu>
 <47841194.2010208@goop.org> <20080109002014.GB31289@elte.hu>
 <20080109002803.GA3732@elte.hu> <20080109003034.GA4658@elte.hu>
 <47841B09.3020507@goop.org> <20080109005914.GA24228@elte.hu>
 <47841E3C.9020106@goop.org> <20080109011233.GD25945@bingen.suse.de>
 <478424DE.3030609@goop.org>
In-Reply-To: <478424DE.3030609@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>The "problem" is a BUG() in pageattr_64.c:change_page_attr(), which to 
>me looks spurious.  It arises because __PAGE_KERNEL_* doesn't contain 
>_PAGE_GLOBAL, but PAGE_KERNEL_* does.  When ioremap() 
>change_page_attr(), it does so in a way that guarentees that the test
>
>	if (pgprot_val(prot) != pgprot_val(ref_prot)) {
>
>in __change_page_attr() always succeeds.  When I folded _PAGE_GLOBAL 
>into the __PAGE_KERNEL_* definitions, it mostly works except it causes 
>this if() to fail, falling into the otherwise dead else clause and 
>triggers a BUG().

Indeed, and my patch version for fixing the ref-counting problem does
away with that (I don't recall whether Andi's version did, too):

	if (!pgprot_match(prot, ref_prot)) {
		if (!pte_huge(*kpte)) {
			set_pte(kpte, pfn_pte(pfn, prot));
		} else {
			BUG_ON(!pgprot_match(old_prot, ref_prot));
			kpte_page = split_large_page(address, prot, ref_prot);
			if (!kpte_page)
				return -ENOMEM;
			set_pte(kpte, mk_pte(kpte_page, PAGE_KERNEL_EXEC));
		}
		if (pgprot_match(old_prot, ref_prot))
			page_private(kpte_page)++;
	} else if (!pgprot_match(ref_prot, old_prot)) {
		BUG_ON(pte_huge(*kpte));
		set_pte(kpte, pfn_pte(pfn, ref_prot));
		BUG_ON(page_private(kpte_page) == 0);
		page_private(kpte_page)--;
	} else
		return 0;

Jan

