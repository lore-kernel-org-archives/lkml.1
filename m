Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbYHNMrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbYHNMrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 08:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbYHNMrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 08:47:13 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:36360 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbYHNMrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 08:47:12 -0400
Date: Thu, 14 Aug 2008 13:47:17 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch] mm: dirty page accounting race fix
In-Reply-To: <1218716318.10800.209.camel@twins>
Message-ID: <Pine.LNX.4.64.0808141328090.11013@blonde.site>
References: <20080814094537.GA741@wotan.suse.de>  <Pine.LNX.4.64.0808141210200.4398@blonde.site>
 <1218716318.10800.209.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008, Peter Zijlstra wrote:
> On Thu, 2008-08-14 at 12:55 +0100, Hugh Dickins wrote:
> 
> > But I got a bit distracted: mprotect's change_pte_range is
> > traditionally where the pte_modify operation has been split up into
> > stages on some arches, that really can be restricting permissions
> > and needs to tread carefully.  Now I go to look there, I see its
> > 		/*
> > 		 * Avoid taking write faults for pages we know to be
> > 		 * dirty.
> > 		 */
> > 		if (dirty_accountable && pte_dirty(ptent))
> > 			ptent = pte_mkwrite(ptent);
> > 
> > and get rather worried: isn't that likely to be giving write permission
> > to a pte in a vma we are precisely taking write permission away from?
> 
> Exactly, we do that because the page is already dirty, therefore we do
> not need to trap on write to mark it dirty - at least, that was the idea
> behind this optimization.

I realized that was the intended optimization, what I'd missed is that
dirty_accountable can only be true there if (vma->vm_flags & VM_WRITE):
that's checked in vma_wants_writenotify(), which is how dirty_accountable
gets to be set.

So those lines are okay, panic over, phew.

Hugh
