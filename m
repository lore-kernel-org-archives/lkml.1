Return-Path: <linux-kernel-owner+w=401wt.eu-S1760560AbXEMVE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760560AbXEMVE5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 17:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbXEMVEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 17:04:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33970 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbXEMVEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 17:04:49 -0400
Date: Sun, 13 May 2007 22:04:37 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070513210437.GE14030@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	rusty@rustcorp.com.au, wfg@ustc.edu
References: <20070502172934.GA17782@infradead.org> <20070502203627.GA18733@Krystal> <20070502135336.6d6d3569.akpm@linux-foundation.org> <20070502231104.GA26045@Krystal> <20070502162135.f949e371.akpm@linux-foundation.org> <20070503150415.GC26864@Krystal> <20070503151201.GA27281@infradead.org> <20070503171646.GA506@Krystal> <20070503172546.GA13392@infradead.org> <20070510193936.GA6320@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510193936.GA6320@Krystal>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 03:39:36PM -0400, Mathieu Desnoyers wrote:
> * Christoph Hellwig (hch@infradead.org) wrote:
> > On Thu, May 03, 2007 at 01:16:46PM -0400, Mathieu Desnoyers wrote:
> > > > kprobes does this kind of synchronization internally, so the marker
> > > > wrapper should probabl aswell.
> > > > 
> > > 
> > > The problem appears on heavily loaded systems. Doing 50
> > > synchronize_sched() calls in a row can take up to a few seconds on a
> > > 4-way machine. This is why I prefer to do it in the module to which
> > > the callbacks belong.
> > 
> > We recently had a discussion on batch unreistration interface for
> > kprobes.  I'm not very happy with having so different interfaces for
> > different kind of probe registrations.
> > 
> 
> Ok, I've had a look at the kprobes batch registration mechanisms and..
> well, it does not look well suited for the markers. Adding
> supplementary data structures such as linked lists of probes does not
> look like a good match.
> 
> However, I agree with you that providing a similar API is good.
> 
> Therefore, here is my proposal :
> 
> The goal is to do the synchronize just after we unregister the last
> probe handler provided by a given module. Since the unregistration
> functions iterate on every marker present in the kernel, we can keep a
> count of how many probes provided by the same module are still present.
> If we see that we unregistered the last probe pointing to this module,
> we issue a synchronize_sched().
> 
> It adds no data structure and keeps the same order of complexity as what
> is already there, we only have to do 2 passes in the marker structures :
> the first one finds the module associated with the callback and the
> second disables the callbacks and keep a count of the number of
> callbacks associated with the module.
> 
> Mathieu
> 
> P.S.: here is the code.
> 
> 
> Linux Kernel Markers - Architecture Independant code Provide internal
> synchronize_sched() in batch.
> 
> The goal is to do the synchronize just after we unregister the last
> probe handler provided by a given module. Since the unregistration
> functions iterate on every marker present in the kernel, we can keep a
> count of how many probes provided by the same module are still present.
> If we see that we unregistered the last probe pointing to this module,
> we issue a synchronize_sched().
> 
> It adds no data structure and keeps the same order of complexity as what
> is already there, we only have to do 2 passes in the marker structures : 
> the first one finds the module associated with the callback and the 
> second disables the callbacks and keep a count of the number of
> callbacks associated with the module.

Looks good to me, please incorporate this is the next round of the
markers patch series.

