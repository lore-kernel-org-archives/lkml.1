Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbYBSItk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbYBSItk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 03:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYBSItb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 03:49:31 -0500
Received: from n22.bullet.mail.mud.yahoo.com ([68.142.200.113]:23554 "HELO
	n22.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750959AbYBSIta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 03:49:30 -0500
X-Yahoo-Newman-Id: 508711.85432.bm@omp411.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=rtYOw+GixagFNvyC+M9houyHzkNUGpKnTSCwTC8b69Vs++sfJW/zxGJYhsSkGJYmsIg0VDR2ssgE5hb0fNut+KeHG6igjHZtRFDqDdB7kSt4YZhxRX+kFH7QYUIRmgKlgYMfphuHya+sjSgB75FzxGwMmslgYdyQjwQbxOWWUWs=  ;
X-YMail-OSG: t1TUOYgVM1nR.7Wlp3o.r4ejEZDbot9Y5GbF1z1QicP_IVGoqv0GLm_OnsKfML80K.rl8xMMzQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 3/6] mmu_notifier: invalidate_page callbacks
Date: Tue, 19 Feb 2008 19:46:10 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
References: <20080215064859.384203497@sgi.com> <20080215193736.9d6e7da3.akpm@linux-foundation.org> <Pine.LNX.4.64.0802161121130.25573@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0802161121130.25573@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200802191946.10695.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 February 2008 06:22, Christoph Lameter wrote:
> On Fri, 15 Feb 2008, Andrew Morton wrote:

> > >  		flush_cache_page(vma, address, pte_pfn(*pte));
> > >  		entry = ptep_clear_flush(vma, address, pte);
> > > +		mmu_notifier(invalidate_page, mm, address);
> >
> > I just don't see how ths can be done if the callee has another thread in
> > the middle of establishing IO against this region of memory.
> > ->invalidate_page() _has_ to be able to block.  Confused.
>
> The page lock is held and that holds off I/O?

I think the actual answer is that "it doesn't matter".

ptes are not exactly the entity via which IO gets established, so
all we really care about here is that after the callback finishes,
we will not get any more reads or writes to the page via the
external mapping.

As far as holding off local IO goes, that is the job of the core
VM. (And no, page lock does not necessarily hold it off FYI -- it
can be writeback IO or even IO directly via buffers).

Holding off IO via the external references I guess is a job for
the notifier driver.

