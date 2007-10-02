Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbXJBORR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbXJBORR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 10:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXJBORG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 10:17:06 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:43977 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbXJBORF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 10:17:05 -0400
Date: Tue, 2 Oct 2007 15:16:28 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andi Kleen <ak@suse.de>
cc: discuss@x86-64.org, Thayne Harbaugh <thayne@c2.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [discuss] [PATCH] Inconsistent mmap()/mremap() flags
In-Reply-To: <200710021545.32556.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0710021505400.2156@blonde.wat.veritas.com>
References: <1190958393.5128.85.camel@phantasm.home.enterpriseandprosperity.com>
 <1191308772.5200.66.camel@phantasm.home.enterpriseandprosperity.com>
 <Pine.LNX.4.64.0710021304230.26719@blonde.wat.veritas.com>
 <200710021545.32556.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007, Andi Kleen wrote:
> 
> > First call mmap with a low hint address, the new size you'll be wanting
> > from the mremap, PROT_NONE, MAP_ANONYMOUS, -1, 0.  Then call mremap with
> > old address, old size, new size, MREMAP_MAYMOVE|MREMAP_FIXED, and new
> > address as returned by the preparatory mmap.
> 
> That's racy unfortunately in a multithreaded process. They would need to loop.

Perhaps.  Though I don't see what your loop would be doing;
and the mapping established by the first thread would only
be vulnerable to another thread if that were really set on
interfering (an un-FIXED mmap by another thread will keep
away from the area assigned to the first).

Certainly a two-stage procedure has to be weaker than one stage,
but it is just how MAP_FIXED is normally used (isn't it?): first
stake out an arena for all that's needed without MAP_FIXED, then
fit into it the actual mappings required using MAP_FIXED.  Blind
use of MAP_FIXED is always in danger of unmapping something vital.

But whether the two-stage procedure is good enough for Thayne's
purpose, he'll have to judge for himself.

Hugh
