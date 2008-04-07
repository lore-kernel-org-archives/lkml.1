Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbYDGGC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbYDGGC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 02:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbYDGGCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 02:02:46 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:54422
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbYDGGCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 02:02:45 -0400
Date: Mon, 7 Apr 2008 08:02:34 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] mmu notifier #v11
Message-ID: <20080407060234.GD9309@duo.random>
References: <20080402220148.GV19189@duo.random> <Pine.LNX.4.64.0804021503320.31247@schroedinger.engr.sgi.com> <20080402221716.GY19189@duo.random> <Pine.LNX.4.64.0804021821230.639@schroedinger.engr.sgi.com> <20080403151908.GB9603@duo.random> <Pine.LNX.4.64.0804031215050.7480@schroedinger.engr.sgi.com> <20080404202055.GA14784@duo.random> <Pine.LNX.4.64.0804041504310.12396@schroedinger.engr.sgi.com> <20080405002330.GF14784@duo.random> <Pine.LNX.4.64.0804062244110.18148@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804062244110.18148@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2008 at 10:45:41PM -0700, Christoph Lameter wrote:
> That depends on what the notifier is being used for. Some serialization 
> with the external mappings has to be done anyways. And its cleaner to have 

As far as I can tell no, you don't need to serialize against the
secondary mmu page fault in invalidate_page, like you instead have to
do in range_begin if you don't unpin the pages in range_end.

> one API that does a lock/unlock scheme. Atomic operations can easily lead
> to races.

What races? Note that if you don't want to optimize XPMEM and GRU can
feel free to implement their own invalidate_page as this:

     invalidate_page(mm, addr) {
     	range_begin(mm, addr, addr+PAGE_SIZE)
	range_end(mm, addr, addr+PAGE_SIZE)
     }

There's zero risk of adding races if they do this, but I doubt they
want to run as slow as with EMM so I guess they'll exploit the
optimization by going lock-free vs the spte page fault in
invalidate_page.
