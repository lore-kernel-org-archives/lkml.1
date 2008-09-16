Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYIPSya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYIPSya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 14:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbYIPSyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 14:54:22 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:48344 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbYIPSyV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 14:54:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=rcDE78ZpsKNHY73WACa3tS4rqfIDBWF+a4ZDrLeOmXCLuaBC89cnCOgTJAlptbXgBj
         9fTus1D9zi96FtMtD5d0EDXwF6lXRaVwBvUnweF+ZCeP7vlH4mCo8Dwc9P3GNHlddULJ
         4tJ66Tjm1iTlmXc0cpj0tROpNgQ7I+Oya+tIE=
Date: Tue, 16 Sep 2008 21:54:16 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       Pavel Roskin <proski@gnu.org>, pq@iki.fi
Subject: [PATCH 1/7] x86 mmiotrace: fix a rare memory leak.
Message-ID: <20080916215416.16aee2dd@daedalus.pq.iki.fi>
In-Reply-To: <alpine.DEB.1.10.0809151556260.22620@gandalf.stny.rr.com>
References: <48B1D5CA.8000607@gmail.com>
	<c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	<20080827212130.4b8365a8@daedalus.pq.iki.fi>
	<c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
	<20080828214256.296e34ec@daedalus.pq.iki.fi>
	<c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com>
	<20080904203058.7e57729e@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809041407140.2431@gandalf.stny.rr.com>
	<20080915224707.76b2cca0@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809151556260.22620@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From da74191de5e5a3c0adee0604757d19b2faf8ec79 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sat, 23 Aug 2008 14:32:22 +0300
Subject: [PATCH] x86 mmiotrace: fix a rare memory leak.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/mmio-mod.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 635b50e..754bd1e 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -307,8 +307,10 @@ static void ioremap_trace_core(resource_size_t offset, unsigned long size,
 	map.map_id = trace->id;
 
 	spin_lock_irq(&trace_lock);
-	if (!is_enabled())
+	if (!is_enabled()) {
+		kfree(trace);
 		goto not_enabled;
+	}
 
 	mmio_trace_mapping(&map);
 	list_add_tail(&trace->list, &trace_list);
-- 
1.5.6.4

