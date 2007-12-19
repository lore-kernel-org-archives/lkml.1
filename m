Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbXLSAyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbXLSAyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbXLSAyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:54:31 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:36532 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbXLSAya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:54:30 -0500
Date: Wed, 19 Dec 2007 00:53:12 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] unionfs: restructure unionfs_setattr 
In-Reply-To: <200712182309.lBIN9haS032087@agora.fsl.cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0712190030390.5639@blonde.wat.veritas.com>
References: <200712182309.lBIN9haS032087@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007, Erez Zadok wrote:
> In message <Pine.LNX.4.64.0712182213300.28390@blonde.wat.veritas.com>, Hugh Dickins writes:
> > In order to fix unionfs truncation, we need to move the lower notify_change
> > out of the loop in unionfs_setattr.  But when I came to do that, I couldn't
> [...]
> 
> Hugh, I want to understand how patches 3/4 and 4/4 are related.  In patch 3
> you say "in order to fix truncation" but you mention a truncation problem
> only in patch 4; is there a patch ordering problem, or they're both related
> to the same issue (with 3/4 being a code cleanup, and 4/4 actually fixing
> the problem)?

I needed to move that notify_change out of the loop, to fix the truncation
problem, but had great difficulty understanding the loop.  So, just as you
say, made the code cleanup first in 3/4, then fixed the problem in 4/4.

But that cleanup does need your review and testing.

> 
> What tests did you conduct to tickle this truncation problem: I assume
> fsx-linux through unionfs, mounted on tmpfs?

Exactly.  The familiar "fsx foo -q -c 100 -l 10000000" on its own is
enough to trigger it, though my habit is to run that while forcing
swapout and swapoff too.  The problem isn't peculiar to tmpfs,
but I expect other filesystems are more likely just to fail the
fsx test rather than oops.

> Did that include both series
> of patches (your 9 tmpfs patches, plus the two memcgrpoup?).

Any kernel without the unionfs 4/4 should show the problem, but
differently with different sets of patches.  A lot of my testing
was with an earlier set of tmpfs patches for unionfs (I didn't
realize the tmpfs 5/9 issue until later on), and with those it
manifested as fsx failure.

But if you run without any of these patches,
I believe it manifests as shmem_writepage's
		BUG_ON(!(info->flags & SHMEM_TRUNCATE));
or its
		BUG_ON(!entry);
Whereas in tmpfs 4/9 I removed that latter BUG_ON(!entry) -
we don't usually bother to BUG on NULL pointers, just let the
dereference oops.

Hugh
