Return-Path: <linux-kernel-owner+w=401wt.eu-S1762834AbXEYNVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762834AbXEYNVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 09:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758306AbXEYNV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 09:21:29 -0400
Received: from mail.windriver.com ([147.11.1.11]:59139 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769AbXEYNV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 09:21:28 -0400
Message-ID: <4656E2D3.4050106@windriver.com>
Date: Fri, 25 May 2007 08:21:23 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@o2.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.21 hang in cancel_rearming_delayed_workqueue()
References: <20070525081631.GB985@ff.dom.local>
In-Reply-To: <20070525081631.GB985@ff.dom.local>
Content-Type: multipart/mixed;
 boundary="------------070308060501090404050104"
X-OriginalArrivalTime: 25 May 2007 13:21:23.0937 (UTC) FILETIME=[976E8510:01C79ECF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070308060501090404050104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jarek Poplawski wrote:
> On 25-05-2007 05:21, Jason Wessel wrote:
>   
>> There is a problem with the calling cancel_rearming_delayed_work if the 
>> timer was not yet active.
>>
>>
>> It is possible that the problem exists else where, but I thought I would 
>> ask if this is expected?
>>
>>     
>
>
> " * cancel_rearming_delayed_workqueue - reliably kill off a delayed
>  work whose handler rearms the delayed work."
>
> So, it cannot be used in netpoll_cleanup() if there is no rearming
> during this cancel at all. This is a tricky behaviour of course,
> and is changed in 2.6.22-rc.
>
>   

I had read that as well.  It seems this the API for the cancel is 
restricted such that you cannot call it if there is nothing to cancel.

This means the netpoll code is incorrect and the simple fix is 
attached.  With the change the netpoll_cleanup works correctly in 2.6.21.

Thanks,
Jason.

--------------070308060501090404050104
Content-Type: text/plain;
 name="netpoll_workqueue_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="netpoll_workqueue_fix.patch"


Do not call cancel_rearming_delayed_work() if there is no
pending work.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 net/core/netpoll.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.21/net/core/netpoll.c
===================================================================
--- linux-2.6.21.orig/net/core/netpoll.c
+++ linux-2.6.21/net/core/netpoll.c
@@ -781,8 +781,10 @@ void netpoll_cleanup(struct netpoll *np)
 			if (atomic_dec_and_test(&npinfo->refcnt)) {
 				skb_queue_purge(&npinfo->arp_tx);
 				skb_queue_purge(&npinfo->txq);
-				cancel_rearming_delayed_work(&npinfo->tx_work);
-				flush_scheduled_work();
+				if (delayed_work_pending(&npinfo->tx_work)) {
+					cancel_rearming_delayed_work(&npinfo->tx_work);
+					flush_scheduled_work();
+				}
 
 				kfree(npinfo);
 			}

--------------070308060501090404050104--
