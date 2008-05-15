Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbYEOHko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbYEOHko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbYEOHkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:40:07 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45142 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbYEOHkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:40:05 -0400
Message-ID: <482BE8DD.2020101@bull.net>
Date: Thu, 15 May 2008 09:40:13 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [PATCH 7/9] Make idr_remove rcu-safe
References: <20080507113553.395937000@bull.net> <20080507113737.562143000@bull.net> <20080514195925.GA8994@tpepper-t42p.dolavim.us>
In-Reply-To: <20080514195925.GA8994@tpepper-t42p.dolavim.us>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Pepper wrote:
> On Wed 07 May at 13:36:00 +0200 Nadia.Derbey@bull.net said:
> 
>>[PATCH 07/09]
>>
>>This patch introduces the free_layer() routine: it is the one that actually
>>frees memory after a grace period has elapsed.
>>
>>Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
>>
>>---
>> lib/idr.c |   59 ++++++++++++++++++++++++++++++++++++++++++++---------------
>> 1 file changed, 44 insertions(+), 15 deletions(-)
>>
>>Index: linux-2.6.25-mm1/lib/idr.c
>>===================================================================
>>--- linux-2.6.25-mm1.orig/lib/idr.c	2008-05-06 18:06:43.000000000 +0200
>>+++ linux-2.6.25-mm1/lib/idr.c	2008-05-07 09:07:31.000000000 +0200
>>@@ -424,15 +455,13 @@ void idr_remove_all(struct idr *idp)
>>
>> 		id += 1 << n;
>> 		while (n < fls(id)) {
>>-			if (p) {
>>-				memset(p, 0, sizeof *p);
>>-				move_to_free_list(idp, p);
>>-			}
>>+			if (p)
>>+				free_layer(p);
>> 			n += IDR_BITS;
>> 			p = *--paa;
>> 		}
>> 	}
>>-	idp->top = NULL;
>>+	rcu_assign_pointer(idp->top, NULL);
>> 	idp->layers = 0;
>> }
>> EXPORT_SYMBOL(idr_remove_all);
> 
> 
> Does idr_remove_all() need an rcu_dereference() in the loop preceeding the
> above, where it does:
> 
>                 while (n > IDR_BITS && p) {
>                         n -= IDR_BITS;
>                         *paa++ = p;
>      ---->              p = p->ary[(id >> n) & IDR_MASK];
>                 }

I assumed here that idr_remove_all() was called in the "typical cleanup 
sequence" mentioned in the comment describing the routine.
And actually, that's how it is called in drivers/char/drm.

> 
> idr_replace() also has that loop without rcu_derefernce, but I _think_
> I see why that one should be ok.  At least there the comment is clear
> that locking at a higher level should be happening.

I didn't use rcu_dereference here since the caller should anyway 
serialize with other writers. So the tree should remain unchanged during 
the replace operation.

>  And then
> idr_remove_all() is almost unused and it looks like it is only in
> serialized places.
> 
> Otherwise, thanks for redoing...This patch set was much easier to digest
> and looks reasonable to me.
> 
> I've been having some machine issues, but hope to give this patch set a run
> still on a 128way machine and mainline to provide some additional
> datapoints.
> 

That would be kind, indeed (hope I didn't break anything).

Regards,
Nadia

