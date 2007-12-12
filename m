Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbXLLAl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbXLLAl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 19:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbXLLAlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 19:41:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:47001 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbXLLAlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 19:41:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,154,1196668800"; 
   d="scan'208";a="293972509"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] [NET]: Fix Ooops of napi net_rx_action.
Date: Tue, 11 Dec 2007 16:38:37 -0800
Message-ID: <36D9DB17C6DE9E40B059440DB8D95F5203FBAF94@orsmsx418.amr.corp.intel.com>
In-Reply-To: <b25c3fa70712111612o16a62b49g6709aa728f31e27a@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [NET]: Fix Ooops of napi net_rx_action.
Thread-Index: Acg8U9DRPYmzGRLtRnKwyioBbBMfjAAAfBKw
References: <001801c83bd6$2001d410$9c94fea9@jason> <20071211.023218.31965443.davem@davemloft.net> <b25c3fa70712110457g2bf04c6flc387f2b9cb51cf3b@mail.gmail.com> <36D9DB17C6DE9E40B059440DB8D95F5203F82FC3@orsmsx418.amr.corp.intel.com> <b25c3fa70712111612o16a62b49g6709aa728f31e27a@mail.gmail.com>
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Joonwoo Park" <joonwpark81@gmail.com>
Cc: "David Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <herbert@gondor.apana.org.au>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
X-OriginalArrivalTime: 12 Dec 2007 00:38:40.0643 (UTC) FILETIME=[5769C530:01C83C57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonwoo Park wrote:
> 2007/12/12, Brandeburg, Jesse <jesse.brandeburg@intel.com>:
>> 
>> all drivers using NAPI in 2.6.24+ (NNAPI??) must return zero here,
>> after calling netif_rx_complete.  netif_rx_complete plus work_done
>> != 0 causes a bug. 
>> 
> 
> Brandeburg,
> Don't we need to return non-zero work_done after netif_rx_complete if
> work_done != weight?

Actually we just need to make sure we don't return work_done == weight
as it is checked on line 2210 of dev.c.
I should also note that I was wrong above, and that the requirement is
that we MUST not return work_done == weight when indicating
netif_rx_complete.

So, returning 0 when we actually did some work, but are being removed
from the poll list because something like !netif_running, is probably
okay, but I'm sure someone will disagree with me.  Maybe returning like
this would be better
diff --git a/drivers/net/e1000/e1000_main.c
b/drivers/net/e1000/e1000_main.c
index 724f067..76d5e3b 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -3933,6 +3933,10 @@ quit_polling:
                        e1000_set_itr(adapter);
                netif_rx_complete(poll_dev, napi);
                e1000_irq_enable(adapter);
+               if (work_done == weight)
+                       return work_done - 1;
+               else
+                       return work_done;
        }

        return work_done;

Jesse

 
