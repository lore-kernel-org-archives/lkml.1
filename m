Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbYF2GSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbYF2GSN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 02:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYF2GSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 02:18:00 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:41394 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbYF2GR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 02:17:59 -0400
Date: Sun, 29 Jun 2008 07:16:49 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] block: GFP_ATOMIC is __GFP_HIGH
In-Reply-To: <20080629043827.135f39d7@linux360.ro>
Message-ID: <Pine.LNX.4.64.0806290700160.7279@blonde.site>
References: <Pine.LNX.4.64.0806290052350.18327@blonde.site>
 <20080629043827.135f39d7@linux360.ro>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008, Eduard - Gabriel Munteanu wrote:
> On Sun, 29 Jun 2008 00:54:27 +0100 (BST)
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > GFP_ATOMIC is __GFP_HIGH: no need for alloc_io_context() to add that.
> > 
> > -		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC |
> > __GFP_HIGH);
> > +		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC);
> 
> I'm not sure this is a good idea: GFP_ATOMIC and __GFP_HIGH are
> semantically different, even though they are equivalent at the moment.
> Have you seen GFP_NOWAIT's definition?
> /* This equals 0, but use constants in case they ever change */
> #define GFP_NOWAIT      (GFP_ATOMIC & ~__GFP_HIGH)
> 
> I think it's best to look at what that code intends to do, not at what
> it does at the moment. Definitions for gfp flags might change in the
> future.
> 
> If the code does not _semantically_ need __GFP_HIGH, then your commit
> message should indicate so, rather than comparing it with GFP_ATOMIC.

I disagree.  It is somewhat accidental that GFP_ATOMIC sets no other
bit than __GFP_HIGH - there might have been a __GFP_ATOMIC bit - which
is why the GFP_NOWAIT definition makes some sense; but it is not
accidental that GFP_ATOMIC includes __GFP_HIGH - it's precisely when
we're atomic that we need access to those extra reserves; and where
we don't actually want them then we do say GFP_NOWAIT not GFP_ATOMIC.

I expect the gfp flags will change in the future; but unless I missed
somewhere, amongst all the places which specify GFP_ATOMIC throughout
the kernel, this is the only one which ors in __GFP_HIGH too.  I don't
believe it expected access to extra extra reserves!  So I thought we'd
do best to remove the anomaly.

(But what I'd actually intended to grep for was __GFP_HIGHMEM.)

Hugh
