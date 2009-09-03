Return-Path: <linux-kernel-owner+w=401wt.eu-S932132AbZICQzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbZICQzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 12:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009AbZICQzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 12:55:21 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:39429 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756001AbZICQzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 12:55:20 -0400
Subject: Re: [PATCH v2 4/5] kmemleak: fix sparse warning over overshadowed
	flags
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, mcgrof@gmail.com
In-Reply-To: <1251956140-5499-5-git-send-email-lrodriguez@atheros.com>
References: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
	 <1251956140-5499-5-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 03 Sep 2009 17:55:15 +0100
Message-Id: <1251996915.22485.26.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2009 16:55:16.0132 (UTC) FILETIME=[4FB41640:01CA2CB7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-03 at 01:35 -0400, Luis R. Rodriguez wrote:
> This fixes this sparse warning:
> mm/kmemleak.c:512:31: warning: symbol 'flags' shadows an earlier one
> mm/kmemleak.c:448:23: originally declared here
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  mm/kmemleak.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 58c07b1..24e7a84 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -509,14 +509,14 @@ static void create_object(unsigned long ptr, size_t size, int min_count,
>  	 * random memory blocks.
>  	 */
>  	if (node != &object->tree_node) {
> -		unsigned long flags;
> +		unsigned long flags_object;
>  
>  		kmemleak_stop("Cannot insert 0x%lx into the object search tree "
>  			      "(already existing)\n", ptr);
>  		object = lookup_object(ptr, 1);
> -		spin_lock_irqsave(&object->lock, flags);
> +		spin_lock_irqsave(&object->lock, flags_object);
>  		dump_object_info(object);
> -		spin_unlock_irqrestore(&object->lock, flags);
> +		spin_unlock_irqrestore(&object->lock, flags_object);

As Pekka said, we only need spin_lock() variant here as the interrupts
are already disabled.

-- 
Catalin

