Return-Path: <linux-kernel-owner+w=401wt.eu-S2992809AbXDYQNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992809AbXDYQNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 12:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992812AbXDYQNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 12:13:38 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:5565 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992809AbXDYQNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 12:13:37 -0400
X-AuditID: d80ac287-ab3e3bb00000590d-77-462f7e314318 
Date: Wed, 25 Apr 2007 17:13:25 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] slub: update cpu after new_slab()
In-Reply-To: <Pine.LNX.4.64.0704250857170.24530@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0704251703360.24086@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0704251613280.19217@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704250824070.24363@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0704251642450.22530@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704250857170.24530@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 25 Apr 2007 16:13:36.0751 (UTC) FILETIME=[ADE04FF0:01C78754]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, Christoph Lameter wrote:
> On Wed, 25 Apr 2007, Hugh Dickins wrote:
> 
> > > Right. local_irq_save does not switch off preemption as I thought.
> > 
> > Strange comment.  Preemption is not possible while IRQs are disabled,
> > but new_slab() rightly reenables them within itself in the __GFP_WAIT
> > case, since it's going off to do a page allocation and may need to wait.
> 
> Yes I expected local_irq_save to increase the preempt count and then 
> local_irq_enable to simply enable interrupts without affecting the preempt 
> count. Thus the process should stay on the same processor.
> 
> Never thought it would be possible to move to a different processor in mid 
> flight.

But, surely you wouldn't have expected it to stay on the processor
throughout the waiting page allocation??  I think you're misremembering
your expectations, and this was just a simple, understandable, oversight.

Quite a serious one, though: it got caught in my case by the NULL
dereference, but it's probably been switching cpu there much more
often - one cpu diddling with what's private to another, with
unpredictable results.

Hugh
