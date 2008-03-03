Return-Path: <linux-kernel-owner+w=401wt.eu-S1762218AbYCCLC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762218AbYCCLC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 06:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYCCLCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 06:02:52 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:28732 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbYCCLCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 06:02:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=FhqIOZxrL+i6Pdck2v8oz+zlro7lWJ53vQNb8VNy4egjoUTxVfudcD82Pm+ObeGCH6KHNeAmrfJMELAYqHck32fGe8r8s9SKBuHFbBMMnEAKWXc/vX2qEEktPNoru+IMRceNTE2ETNtmZyMjh2SZhfbv0klltS98YzX/zL/GZ10=
Message-ID: <47CBD7E3.4020500@gmail.com>
Date: Mon, 03 Mar 2008 19:50:11 +0900
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org
Subject: Re: [patch 07/21] SEQ replacement for anonymous pages
References: <20080228192908.126720629@redhat.com> <20080228192928.492644028@redhat.com>
In-Reply-To: <20080228192928.492644028@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: "barrioskmc@gmail" <minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rik.

static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
  				struct scan_control *sc, int priority, int file)
  {
-	unsigned long pgmoved;
+	unsigned long pgmoved = 0;
  	int pgdeactivate = 0;
  	unsigned long pgscanned;
  	LIST_HEAD(l_hold);	/* The pages which were snipped off */
@@ -1058,12 +1058,25 @@ static void shrink_active_list(unsigned
  		cond_resched();
  		page = lru_to_page(&l_hold);
  		list_del(&page->lru);
-		if (page_referenced(page, 0, sc->mem_cgroup))
-			lru = LRU_ACTIVE_ANON;
+		if (page_referenced(page, 0, sc->mem_cgroup)) {
+			if (file)
+				/* Referenced file pages stay active. */
+				lru = LRU_ACTIVE_ANON;
+			else
+				/* Anonymous pages always get deactivated. */
+				pgmoved++;
+		}
  		list_add(&page->lru, &list[lru]);
  	}

Why do you insert referenced page to LRU_ACTIVE_ANON ?
I have seen picture in your design document 
(http://linux-mm.org/PageReplacementDesign)
If I understand your point well, page referenced is inserted to 
LRU_ACTIVE_FILE.

What am I missing in your point?

Thanks, barrios
