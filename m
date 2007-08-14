Return-Path: <linux-kernel-owner+w=401wt.eu-S1762696AbXHNOhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762696AbXHNOhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 10:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbXHNOgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 10:36:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33854 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbXHNOgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 10:36:51 -0400
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070814142103.204771292@sgi.com>
References: <20070814142103.204771292@sgi.com>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 16:36:43 +0200
Message-Id: <1187102203.6114.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 07:21 -0700, Christoph Lameter wrote:
> The following patchset implements recursive reclaim. Recursive reclaim
> is necessary if we run out of memory in the writeout patch from reclaim.
> 
> This is f.e. important for stacked filesystems or anything that does
> complicated processing in the writeout path.
> 
> Recursive reclaim works because it limits itself to only reclaim pages
> that do not require writeout. It will only remove clean pages from the LRU.
> The dirty throttling of the VM during regular reclaim insures that the amount
> of dirty pages is limited. 

No it doesn't. All memory can be tied up by anonymous pages - who are
dirty by definition and are not clamped by the dirty limit.

> If recursive reclaim causes too many clean pages
> to be removed then regular reclaim will throttle all processes until the
> dirty ratio is restored. This means that the amount of memory that can
> be reclaimed via recursive reclaim is limited to clean memory. The default
> ratio is 10%. This means that recursive reclaim can reclaim 90% of memory
> before failing. Reclaiming excessive amounts of clean pages may have a
> significant performance impact because this means that executable pages
> will be removed. However, it ensures that we will no longer fail in the
> writeout path.
> 
> A patch is included to test this functionality. The test involved allocating
> 12 Megabytes from the reclaim paths when __PF_MEMALLOC is set. This is enough
> to exhaust the reserves.
> 

