Return-Path: <linux-kernel-owner+w=401wt.eu-S1761780AbXGEVnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761780AbXGEVnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760640AbXGEVnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:43:08 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:50436 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760449AbXGEVnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:43:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAP4CjUarR7PE/2dsb2JhbAA
X-IronPort-AV: i="4.16,505,1175497200"; 
   d="scan'208"; a="177267189:sNHT9009370593"
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Cc: "WANG Cong" <xiyou.wangcong@gmail.com>, rolandd@cisco.com,
       mshefty@ichips.intel.com, halr@voltaire.com,
       "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Steve Wise <swise@opengridcomputing.com>
Subject: Re: [-mm Patch] INFINIBAND: check the return value of kmalloc
X-Message-Flag: Warning: May contain useful information
References: <20070704163741.GA2510@localhost.localdomain>
	<9a8748490707041700q18608e3ave4465f1181b97e2f@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 05 Jul 2007 14:42:37 -0700
In-Reply-To: <9a8748490707041700q18608e3ave4465f1181b97e2f@mail.gmail.com> (Jesper Juhl's message of "Thu, 5 Jul 2007 02:00:07 +0200")
Message-ID: <ada1wfm4jea.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Jul 2007 21:42:38.0352 (UTC) FILETIME=[681DD100:01C7BF4D]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, I added Jesper's suggestion to the original patch and queued
this for 2.6.23:

(Steve, let me know if this looks OK or not to you)

commit 8d339921a2cb279457dce79f8a308978e0b41b27
Author: WANG Cong <xiyou.wangcong@gmail.com>
Date:   Thu Jul 5 14:40:32 2007 -0700

    RDMA/cxgb3: Check return of kmalloc() in iwch_register_device()
    
    Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
    [ Also remove cast from void * return of kmalloc() as suggested by
      Jesper Juhl <jesper.juhl@gmail.com>. ]
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index e7c2c39..44b6ad2 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1163,9 +1163,10 @@ int iwch_register_device(struct iwch_dev *dev)
 	dev->ibdev.post_recv = iwch_post_receive;
 
 
-	dev->ibdev.iwcm =
-	    (struct iw_cm_verbs *) kmalloc(sizeof(struct iw_cm_verbs),
-					   GFP_KERNEL);
+	dev->ibdev.iwcm = kmalloc(sizeof(struct iw_cm_verbs), GFP_KERNEL);
+	if (!dev->ibdev.icwm)
+		return -ENOMEM;
+
 	dev->ibdev.iwcm->connect = iwch_connect;
 	dev->ibdev.iwcm->accept = iwch_accept_cr;
 	dev->ibdev.iwcm->reject = iwch_reject_cr;
