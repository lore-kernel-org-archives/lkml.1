Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbYA3Uzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbYA3Uzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYA3Uzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:55:39 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53843 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750932AbYA3Uzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:55:38 -0500
Date: Wed, 30 Jan 2008 12:55:36 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jack Steiner <steiner@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, daniel.blueman@quadrics.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
In-Reply-To: <20080130202918.GB11324@sgi.com>
Message-ID: <Pine.LNX.4.64.0801301251160.32559@schroedinger.engr.sgi.com>
References: <20080129211759.GV7233@v2.random>
 <Pine.LNX.4.64.0801291327330.26649@schroedinger.engr.sgi.com>
 <20080129220212.GX7233@v2.random> <Pine.LNX.4.64.0801291407380.27104@schroedinger.engr.sgi.com>
 <20080130000039.GA7233@v2.random> <Pine.LNX.4.64.0801291620170.28027@schroedinger.engr.sgi.com>
 <20080130002804.GA13840@sgi.com> <20080130133720.GM7233@v2.random>
 <20080130144305.GA25193@sgi.com> <Pine.LNX.4.64.0801301140320.30568@schroedinger.engr.sgi.com>
 <20080130202918.GB11324@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008, Jack Steiner wrote:

> > Seems that we cannot rely on the invalidate_ranges for correctness at all?
> > We need to have invalidate_page() always. invalidate_range() is only an 
> > optimization.
> > 
> 
> I don't understand your point "an optimization". How would invalidate_range
> as currently defined be correctly used?

We are changing definitions. The original patch by Andrea calls 
invalidate_page for each pte that is cleared. So strictly you would not 
need an invalidate_range.

> It _looks_ like it would work only if xpmem/gru/etc takes a refcnt on
> the page & drops it when invalidate_range is called. That may work (not sure)
> for xpmem but not for the GRU.

The refcount is not necessary if we adopt Andrea's approach of a callback 
on the clearing of each pte. At that point the page is still guaranteed to 
exist. If we do the range_invalidate later (as in V3) then the page may 
have been released (see sys_remap_file_pages() f.e.) before we zap the GRU 
ptes. So there will be a time when the GRU may write to a page that has 
been freed and used for another purpose.

Taking a refcount on the page defers the free until the range_invalidate 
runs.

I would prefer a solution that does not require taking refcounts (pins) 
for establishing an external pte and for release (like what the GRU does).

If we could effectively determine that there are no external ptes in a 
range then the invalidate_page() call may return immediately. Maybe it is 
then effective to do these gazillions of invalidate_page() calls when a 
process terminates or an remap is performed.

