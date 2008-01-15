Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbYAOKJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbYAOKJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbYAOKIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:08:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:57784 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450AbYAOKIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:08:51 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] [26/31] CPA: Fix reference counting when changing already changed pages
Date: Tue, 15 Jan 2008 11:04:03 +0100
User-Agent: KMail/1.9.6
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
References: <200801141116.534682000@suse.de> <20080114221659.63C7514F83@wotan.suse.de> <478C8578.76E4.0078.0@novell.com>
In-Reply-To: <478C8578.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801151104.03666.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2008 10:05:44 Jan Beulich wrote:
> >+	ref_prot = canon_pgprot(ref_prot);
> >+	prot = canon_pgprot(prot);
> >+
> > 	if (pgprot_val(prot) != pgprot_val(ref_prot)) { 
> >...
> > 	} else if (level == 4) {
> >...
> > 	} else {
> > 		/*
> > 		 * When you're here you either set the same page to PAGE_KERNEL
> 
> Doesn't this change require modifying the BUG() here into a BUG_ON() so
> that it doesn't trigger if pgprot_val(prot) == pgprot_val(ref_prot) and
> level != 4?

I addressed this in the comment

+               /*
+                * When you're here you either set the same page to PAGE_KERNEL
+                * two times in a row or the page table reference counting is
+                * broken again. To catch the later bug for now (sorry)
+                */

Do you think it's important to handle?  The function already has too many
special cases and setting something several times in a row to PAGE_KERNEL
is usually a bug in the caller anyways (or a cpa bug)

> 
> >+#define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)
> 
> While I remember you stated the inverse, 

I changed my mind regarding not doing this. It was true when I said it originally.

> I continue to think that it'd be 
> safer to mask out the accessed and dirty flags for the comparisons this
> macro is being used for.

A and D should be always set for _PAGE_KERNEL and for kernel mappings in general. 
The problem would only occur if someone made up custom page flags without those.
Didn't think that usage was worth supporting. Perhaps it would be a good idea
to add a WARN_ON for this case though.

Thanks for the review.

-Andi
