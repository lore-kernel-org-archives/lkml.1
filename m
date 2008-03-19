Return-Path: <linux-kernel-owner+w=401wt.eu-S966506AbYCSWin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966506AbYCSWin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764668AbYCSVKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:10:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:3041 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936399AbYCSVKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:10:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:user-agent:cc:references:in-reply-to:mime-version:content-disposition:x-length:x-uid:date:content-type:content-transfer-encoding:message-id:from;
        b=XmJ790phCXqTeBd1Lk7y5jYS6TxVflHvMAuQdaVlkV9CUnFhyS557xvCowmtQJwjUJ1kteydSoreHZeJj3nXPkW8CLZp6Fxm2L+tAtZeq59p/J/yx74ofHjfGm45GNSyLoxrV5EelrBaqOHGRHmHzIv/S1uEUSONYGnAQr4y4yA=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 02/12] mm: fix boundary checking in free_bootmem_core fix
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Christoph Lameter <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>
References: <200803181237.33861.yhlu.kernel@gmail.com>
In-Reply-To: <200803181237.33861.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1823
Date: Wed, 19 Mar 2008 14:03:33 -0700
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803191403.34107.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] mm: fix boundary checking in free_bootmem_core fix

	[PATCH] mm: fix boundary checking in free_bootmem_core

make the free_bootmem_core could handle out of range case. we could use
bdata_list to make sure the range can be freed for sure.

so next time, we don't need to loop online nodes and could use
free_bootmem directly.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/mm/bootmem.c
===================================================================
--- linux-2.6.orig/mm/bootmem.c
+++ linux-2.6/mm/bootmem.c
@@ -432,7 +432,9 @@ int __init reserve_bootmem(unsigned long
 
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
-	free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
+	bootmem_data_t *bdata;
+	list_for_each_entry(bdata, &bdata_list, list)
+		free_bootmem_core(bdata, addr, size);
 }
 
 unsigned long __init free_all_bootmem(void)
