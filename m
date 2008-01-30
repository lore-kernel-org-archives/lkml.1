Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbYA3AW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbYA3AW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYA3AWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:22:48 -0500
Received: from relay2.sgi.com ([192.48.171.30]:53174 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754758AbYA3AWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:22:47 -0500
Date: Tue, 29 Jan 2008 16:22:46 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
In-Reply-To: <20080130000559.GB7233@v2.random>
Message-ID: <Pine.LNX.4.64.0801291621380.28027@schroedinger.engr.sgi.com>
References: <20080128202840.974253868@sgi.com> <20080128202923.849058104@sgi.com>
 <20080129162004.GL7233@v2.random> <Pine.LNX.4.64.0801291153520.25300@schroedinger.engr.sgi.com>
 <20080129211759.GV7233@v2.random> <Pine.LNX.4.64.0801291327330.26649@schroedinger.engr.sgi.com>
 <20080129220212.GX7233@v2.random> <Pine.LNX.4.64.0801291407380.27104@schroedinger.engr.sgi.com>
 <20080130000039.GA7233@v2.random> <20080130000559.GB7233@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008, Andrea Arcangeli wrote:

> On Wed, Jan 30, 2008 at 01:00:39AM +0100, Andrea Arcangeli wrote:
> > get_user_pages, regular linux writes don't fault unless it's
> > explicitly writeprotect, which is mandatory in a few archs, x86 not).
> 
> actually get_user_pages doesn't fault either but it calls into
> set_page_dirty, however get_user_pages (unlike a userland-write) at
> least requires mmap_sem in read mode and the PT lock as serialization,
> userland writes don't, they just go ahead and mark the pte in hardware
> w/o faults. Anyway anonymous memory these days always mapped with
> dirty bit set regardless, even for read-faults, after Nick finally
> rightfully cleaned up the zero-page trick.

That is only partially true. pte are created wronly in order to track 
dirty state these days. The first write will lead to a fault that switches 
the pte to writable. When the page undergoes writeback the page again 
becomes write protected. Thus our need to effectively deal with 
page_mkclean.

