Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbXJAKic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbXJAKic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 06:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbXJAKi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 06:38:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:34828 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbXJAKiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 06:38:25 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [patches] [PATCH] [13/50] x86: Fix and reenable CLFLUSH support inchange_page_attr()
Date: Mon, 1 Oct 2007 12:38:10 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, patches@x86-64.org
References: <200709221231.836138000@suse.de> <20070921223211.BB50413DCD@wotan.suse.de> <46F79021.76E4.0078.0@novell.com>
In-Reply-To: <46F79021.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710011238.10318.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 September 2007 10:23:29 Jan Beulich wrote:
> >@@ -162,7 +198,7 @@ __change_page_attr(unsigned long address
> > 	/* on x86-64 the direct mapping set at boot is not using 4k pages */
> >  	BUG_ON(PageReserved(kpte_page));
> > 
> >-	save_page(kpte_page);
> >+	save_page(kpte_page, 0);
> > 	if (page_private(kpte_page) == 0)
> > 		revert_page(address, ref_prot);
> > 	return 0;
> 
> What is the point of continuing to launder kpte_page here? Page table pages
> never get their caching attributes changed, nor would their direct mapping
> ever change. (Same for i386, obviously.)

We can only free the page table after all the TLBs have been flushed;
otherwise other CPUs can walk already overwritten data as page tables (which can 
then cause various problems). This is similar to the lazy TLB flush logic in the 
standard VM.

We don't need to cache flush it though, that is why 0 is passed here.

Admittedly the function argument is a little bogus because the caller
could just do it; didn't change that yet.

-Andi

