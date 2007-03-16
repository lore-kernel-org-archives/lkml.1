Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbXCPIvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbXCPIvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932507AbXCPIvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:51:11 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34590 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932404AbXCPIvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:51:06 -0400
Message-ID: <374035058.79498@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070316085051.787637000@mail.ustc.edu.cn>
References: <20070316084856.687942000@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 16 Mar 2007 16:48:58 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] readahead: state based method: decouple readahead_ratio from growth_limit
Content-Disposition: inline; filename=readahead-state-based-method-decouple-readahead_ratio-from-growth_limit.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove readahead_ratio from the growth_limit computing in state based method.

It simplifies the size ramp up rules to:

        ahead_window_size = request_size +
                            current_window_size * 2 +
                            readahead_max / 16;

The first two sizes are apparent. The last one has two effects:

1) Ensure that we get acceptable readahead size in early start up phase.
   It is an analog to the old 'first x4 then x2' trick.

2) Ensure that we reach readahead_max within 8 steps.
   It is good for the laptop mode. A user may set a huge readahead_max, and
   expect the kernel to do large I/Os right away.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21-rc3-mm2.orig/mm/readahead.c
+++ linux-2.6.21-rc3-mm2/mm/readahead.c
@@ -1099,7 +1099,7 @@ state_based_readahead(struct address_spa
 
 	growth_limit = req_size;
 	growth_limit += ra_max / 16;
-	growth_limit += (2 + readahead_ratio / 64) * ra_old;
+	growth_limit += 2 * ra_old;
 	if (growth_limit > ra_max)
 	    growth_limit = ra_max;
 

--
