Return-Path: <linux-kernel-owner+w=401wt.eu-S1763170AbZJPAV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763170AbZJPAV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 20:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758838AbZJPAV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 20:21:56 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:37274 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758822AbZJPAV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 20:21:56 -0400
X-Trace: 274576163/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.89.236/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.89.236
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEANNY10pPRVns/2dsb2JhbACBUtc3hDAE
X-IronPort-AV: E=Sophos;i="4.44,568,1249254000"; 
   d="scan'208";a="274576163"
Date: Fri, 16 Oct 2009 01:21:14 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: David Rientjes <rientjes@google.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nitin Gupta <ngupta@vflare.org>, hongshin@gmail.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 7/9] swap_info: swap count continuations
In-Reply-To: <alpine.DEB.1.00.0910151414570.25796@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0910160106580.14004@sister.anvils>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
 <Pine.LNX.4.64.0910150153560.3291@sister.anvils>
 <20091015123024.21ca3ef7.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.1.00.0910151414570.25796@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, David Rientjes wrote:
> On Thu, 15 Oct 2009, KAMEZAWA Hiroyuki wrote:
> > Hmm...maybe I don't understand the benefit of this style of data structure.
> > 
> > Do we need fine grain chain ? 
> > Is  array of "unsigned long" counter is bad ?  (too big?)
> 
> I'm wondering if flex_array can be used for this purpose, which can store 
> up to 261632 elements of size unsigned long with 4K pages, or whether 
> finding the first available bit or weight would be too expensive.

When flex_arrays were first mooted, I did briefly wonder if we could
use them instead of vmalloc for the swap_map; but no, their interface
would slow down scan_swap_map() unacceptably.

Extensions of the swap_map are a different matter, they are seldom
referenced, and referenced just an item at a time: much better suited
to a flex_array.  And looking at Jon's Doc, I see they're good for
sparse arrays, that would suit swap_map extensions very well.

However... that limit of 261632 elements rules them out here (or can
we have a flex_array of flex_arrays?), and the lack of support for
__GFP_HIGHMEM is disappointing - the current implementation of swap
count continuations does use highmem (though perhaps these pages
are so rarely needed that it actually doesn't matter).

It seems that the flex_array is a solution in search of a problem,
and that the swap_map extension is not the right problem for it.

Hugh
