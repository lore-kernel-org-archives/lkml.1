Return-Path: <linux-kernel-owner+w=401wt.eu-S1946024AbXBIC0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946024AbXBIC0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 21:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946026AbXBIC0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 21:26:13 -0500
Received: from smtp-out.google.com ([216.239.45.13]:33975 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946024AbXBIC0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 21:26:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=MLpQ2RBIgE1FZV68HwrgUehKJz0bqwSTVzXmnUE/yU/TvkBW2fCTFvMvFLZx0aRQC
	2P5cRHljJxnoxnsn2nepA==
Date: Thu, 8 Feb 2007 18:25:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Mackall <mpm@selenic.com>
cc: Paul Mundt <lethal@linux-sh.org>, Andrew Morton <akpm@osdl.org>,
       Hugh Dickins <hugh@veritas.com>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3 take2] smaps: extract pte walker from smaps code
In-Reply-To: <20070209020038.GN16722@waste.org>
Message-ID: <Pine.LNX.4.64.0702081816570.31521@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0702062212550.13931@chino.kir.corp.google.com>
 <20070207062934.GA11967@linux-sh.org> <20070209020038.GN16722@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007, Matt Mackall wrote:

> I've been looking at a similar refactoring of other code and I think
> the way to go is a callback per block-of-PTEs with start and end
> pointers. That gets rid of most of the call indirection overhead.
> 

Yes, but only in a limited number of cases (including smaps).  It is not 
always sufficient to do it on the block-of-ptes level.  Many of the the 
pte iterators in the code right now are slightly different on each level: 
the ioremap code, for example, allocates the various directories as it 
progresses in depth.

To have one library pte iterator would only be possible with callback 
functions on each pgd, pud, and pmd level that (at least) ioremap would 
require to be implemented on top of.  That isn't very appealing.

The PTI patchset from July moved these iterators into .h files but did not 
implement a single pte iterator to build on.  It just turned out nicely in 
the smaps case that there was no difference on the pgd, pud, or pmd level 
between the two required iterators.  I added a void *private to carry the 
struct for statistics accumulating in the smaps case but this is worthless 
in the clear_refs case.

		David
