Return-Path: <linux-kernel-owner+w=401wt.eu-S1750831AbYEPQcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750831AbYEPQcC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:32:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYEPQbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:31:52 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:44969 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbYEPQbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:31:52 -0400
Date: Fri, 16 May 2008 17:31:45 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jan Beulich <jbeulich@novell.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrea Arcangeli <andrea@qumranet.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove double indirection on tlb parameter to
 free_pgd_range()& Co
In-Reply-To: <482DC4A9.76E4.0078.0@novell.com>
Message-ID: <Pine.LNX.4.64.0805161715390.28836@blonde.site>
References: <482C6917.76E4.0078.0@novell.com> <Pine.LNX.4.64.0805161517510.8758@blonde.site>
 <482DC4A9.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008, Jan Beulich wrote:
> 
> If you want to keep and actively use the double indirection, would you

I'd much rather replace it with something better, but it's not easy
to solve all the problems which Ben and I variously wanted to address.

> guarantee current semantics like ->mm and ->fullmm to always be what
> was specified at the start of the operation?

Of course.  The stopping and restarting of those gathers was never
intended to switch mm midstream, and there's that odd way in which
unmap_vmas saves the current value of fullmm to provide to the next
gathering.  Not the nicest interface, I agree; but it's not widespread.

> Verifying this was what
> made me go through that call tree in the first place, and obviously this
> is harder to verify when there is potential for the whole structure
> pointed to to be replaced by another one.

Or, looking at it from the point of a cpu rather than from the point
of view of the call chain, of course not.  Typically the mmu_gather_t
(in that current implementation) is a per-cpu area, and the call chain
may switch over to a different cpu's mmu_gather_t in between stopping
and restarting, and the original cpu's be used for a different mm.

Hugh
