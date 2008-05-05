Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbYEEJ1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbYEEJ1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 05:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbYEEJ1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 05:27:40 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49025 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbYEEJ1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 05:27:39 -0400
Message-ID: <481ED2D9.3040801@bull.net>
Date: Mon, 05 May 2008 11:26:49 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, efault@gmx.de
Subject: Re: [PATCH 01/10] Fix idr_remove()
References: <20080429143304.741001000@bull.net>	<20080429143728.563232000@bull.net> <20080429114425.ea0e2f62.akpm@linux-foundation.org>
In-Reply-To: <20080429114425.ea0e2f62.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 29 Apr 2008 16:33:05 +0200
> Nadia.Derbey@bull.net wrote:
> 
> 
>>[PATCH 01/10]
>>
>>This patch fixes idr_remove(): the return inside the loop makes us free only
>>a single layer.
>>
>>Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
>>
>>---
>> lib/idr.c |    2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>>Index: linux-2.6.25-mm1/lib/idr.c
>>===================================================================
>>--- linux-2.6.25-mm1.orig/lib/idr.c	2008-04-25 15:29:00.000000000 +0200
>>+++ linux-2.6.25-mm1/lib/idr.c	2008-04-25 15:48:34.000000000 +0200
>>@@ -385,8 +385,8 @@ void idr_remove(struct idr *idp, int id)
>> 	while (idp->id_free_cnt >= IDR_FREE_MAX) {
>> 		p = alloc_layer(idp);
>> 		kmem_cache_free(idr_layer_cache, p);
>>-		return;
>> 	}
>>+	return;
>> }
>> EXPORT_SYMBOL(idr_remove);
> 
> 
> erk, ancient bug.
> 
> I _think_ the implications of this are that an idr tree will grow fatter
> than it needs to be, but there is no permanent leak: idr_destroy() will
> still free everything, yes?

Yes, exactly. Actually, I've not checked whether all the kernel 
components call idr_destroy() when needed.

> 
> And a consequence of the fix is that idr manipulations will now result in
> more allocs and frees,

Not necessarily more allocs: this loop keeps IDR_FREE_MAX layers in the 
free list. So idr_pre_get() should be a noop.

> but the amount of memory which a tree uses will be
> less?
> 
> 
> 

Regards,
Nadia


