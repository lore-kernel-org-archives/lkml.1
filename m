Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbYKKXZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbYKKXZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 18:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYKKXZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 18:25:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47360 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbYKKXZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 18:25:18 -0500
Date: Wed, 12 Nov 2008 00:25:13 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       chrisw@redhat.com, avi@redhat.com, izike@qumranet.com
Subject: Re: [PATCH 2/4] Add replace_page(), change the mapping of pte from
	one page into another
Message-ID: <20081111232513.GS10818@random.random>
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com> <1226409701-14831-2-git-send-email-ieidus@redhat.com> <1226409701-14831-3-git-send-email-ieidus@redhat.com> <20081111114555.eb808843.akpm@linux-foundation.org> <20081111210655.GG10818@random.random> <Pine.LNX.4.64.0811111522150.27767@quilx.com> <20081111221753.GK10818@random.random> <Pine.LNX.4.64.0811111626520.29222@quilx.com> <20081111231722.GR10818@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111231722.GR10818@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 12:17:22AM +0100, Andrea Arcangeli wrote:
> We don't have to check the page_count vs mapcount later in
> replace_page because we know if anybody started an O_DIRECT read from
> disk, it would have triggered a cow, and the pte_same check that we
> have to do for other reasons would take care of bailing out the
> replace_page.

Ah, for completeness: above I didn't mention the case of O_DIRECT
writes to disk, because we never need to care about those. They're
never a problem. If the page is replaced and the cpu writes to the
page and by doing so triggers a cow that lead to the CPU write to go
in a different page (not the one under dma) it'll be like if the write
to disk completed before the cpu overwritten the page, so result is
undefined. I don't think we've to define the case of somebody doing a
direct read from a location where there's still an o_direct write in
flight either.
