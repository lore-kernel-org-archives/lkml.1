Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbYCUV0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbYCUV0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759242AbYCUVZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:25:51 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:11428 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372AbYCUVZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:25:50 -0400
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [13/14] vcompound: Use vcompound for swap_map
References: <20080321061703.921169367@sgi.com>
	<20080321061727.269764652@sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 21 Mar 2008 22:25:47 +0100
In-Reply-To: <20080321061727.269764652@sgi.com>
Message-ID: <8763vfixb8.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Mar 2008 21:19:11.0050 (UTC) FILETIME=[34B392A0:01C88B99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> writes:

> Use virtual compound pages for the large swap maps. This only works for
> swap maps that are smaller than a MAX_ORDER block though. If the swap map
> is larger then there is no way around the use of vmalloc.

Have you considered the potential memory wastage from rounding up
to the next page order now? (similar in all the other patches
to change vmalloc). e.g. if the old size was 64k + 1 byte it will
suddenly get 128k now. That is actually not a uncommon situation
in my experience; there are often power of two buffers with 
some small headers.

A long time ago (in 2.4-aa) I did something similar for module loading
as an experiment to avoid too many TLB misses. The module loader
would first try to get a continuous range in the direct mapping and 
only then fall back to vmalloc.

But I used a simple trick to avoid the waste problem: it allocated a
continuous range rounded up to the next page-size order and then freed
the excess pages back into the page allocator. That was called
alloc_exact(). If you replace vmalloc with alloc_pages you should
use something like that too I think.

-Andi

