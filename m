Return-Path: <linux-kernel-owner+w=401wt.eu-S932607AbZJPOvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbZJPOvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 10:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759428AbZJPOvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 10:51:10 -0400
Received: from aglcosbs05.cos.agilent.com ([192.25.218.36]:45679 "EHLO
	aglcosbs05.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759421AbZJPOvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 10:51:09 -0400
Message-ID: <4AD88804.4090205@agilent.com>
Date: Fri, 16 Oct 2009 07:49:40 -0700
From: Earl Chew <earl_chew@agilent.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/1] : mm : mmap.c Arithmetic overflow in may_expand_vm()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2009 14:49:44.0253 (UTC) FILETIME=[E61DCED0:01CA4E6F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function may_expand_vm() may return a false positive if the proposed
increment (npages) is sufficient large to overflow the expression:

	cur + npages

Assuming that cur < lim is an invariant, the proposed patch re-arranges
the expression to avoid unsigned arithmetic overflow.

More robustly:

	if (cur > lim || npages > lim - cur)
		return 0;

might be preferred if it cannot be guaranteed that cur < lim.



--- linux-2.6.21_mvlcge500/mm/mmap.c.orig	2008-06-30 22:43:38.000000000 
-0700
+++ linux-2.6.21_mvlcge500/mm/mmap.c	2009-10-16 07:42:23.000000000 -0700
@@ -2303,7 +2303,7 @@ int may_expand_vm(struct mm_struct *mm,

  	lim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;

-	if (cur + npages > lim)
+	if (npages > lim - cur)
  		return 0;
  	return 1;
  }



