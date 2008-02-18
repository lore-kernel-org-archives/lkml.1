Return-Path: <linux-kernel-owner+w=401wt.eu-S1759800AbYBRMgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800AbYBRMgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758518AbYBRMfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:35:54 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:33123
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492AbYBRMfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:35:54 -0500
Date: Mon, 18 Feb 2008 13:35:51 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Robin Holt <holt@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [PATCH] KVM swapping with MMU Notifiers V7
Message-ID: <20080218123551.GS11732@v2.random>
References: <20080215064859.384203497@sgi.com> <20080216104827.GI11732@v2.random> <20080216115138.GA11391@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080216115138.GA11391@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 05:51:38AM -0600, Robin Holt wrote:
> I am doing this in xpmem with a stack-based structure in the function
> calling get_user_pages.  That structure describes the start and
> end address of the range we are doing the get_user_pages on.  If an
> invalidate_range_begin comes in while we are off to the kernel doing
> the get_user_pages, the invalidate_range_begin marks that structure
> indicating an invalidate came in.  When the get_user_pages gets the
> structures relocked, it checks that flag (really a generation counter)
> and if it is set, retries the get_user_pages.  After 3 retries, it
> returns -EAGAIN and the fault is started over from the remote side.

A seqlock sounds a good optimization for the non-swapping fast path, a
per-VM-guest seqlock number can allow us to know when we need to worry
to call get_user_pages a second time, but won't be really a retry like
in 99% of seqlock usages for the reader side, but just a second
get_user_pages to trigger a minor fault. Then if the page is different
in the second run, we'll really retry (so not in function of the
seqlock but in function of the get_user_pages page array), and there's
no risk of livelocks because get_user_pages returning a different page
won't be the common case. The seqlock should be increased first before
the invalidate and a second time once the invalidate is over.
