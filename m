Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYKQSO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYKQSO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYKQSOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:14:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56278 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbYKQSOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:14:49 -0500
Date: Mon, 17 Nov 2008 19:14:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Tejun Heo <htejun@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] xen: fix scrub_page()
Message-ID: <20081117181422.GA8321@elte.hu>
References: <20081117085807.GF26778@kernel.dk> <20081117093425.GG26778@kernel.dk> <20081117094147.GJ28786@elte.hu> <20081117094551.GI26778@kernel.dk> <20081117111350.GJ26778@kernel.dk> <4921A4F3.1030309@goop.org> <20081117171005.GA25729@elte.hu> <4921A6BE.7000206@goop.org> <alpine.LFD.2.00.0811170922000.3468@nehalem.linux-foundation.org> <4921AB44.4090706@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4921AB44.4090706@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>> Secondly, we actually have a function called "clear_highpage()" 
>> that does this, except it uses kmap_atomic(page, KM_USER0). Which 
>> is _probably better anyway, but I didn't check if there is some 
>> magical reason why it wouldn't work.
>
> OK.

applied it with the changelog below to tip/x86/urgent, thanks guys! 

AFAICS CONFIG_XEN_SCRUB_PAGES=y could not possibly have worked before 
(kunmapping the wrong address is a crasher), so there's little 
practical risk from using an atomic kmap here.

	Ingo

-------------->
>From 26a3e99160cfb06a0a33e25b9fb0d516e2cc680d Mon Sep 17 00:00:00 2001
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Mon, 17 Nov 2008 09:35:00 -0800
Subject: [PATCH] xen: fix scrub_page()

Impact: fix guest kernel crash with CONFIG_XEN_SCRUB_PAGES=y

Jens noticed that scrub_page() has a buggy unmap of the wrong
thing. (virtual address instead of page)

Linus pointed out that the whole scrub_page() code is an unnecessary
reimplementation of clear_highpage() to begin with.

Just use clear_highpage() rather than reimplementing it poorly.

Reported-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/xen/balloon.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index a0fb5ea..526c191 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -122,14 +122,7 @@ static struct timer_list balloon_timer;
 static void scrub_page(struct page *page)
 {
 #ifdef CONFIG_XEN_SCRUB_PAGES
-	if (PageHighMem(page)) {
-		void *v = kmap(page);
-		clear_page(v);
-		kunmap(v);
-	} else {
-		void *v = page_address(page);
-		clear_page(v);
-	}
+	clear_highpage(page);
 #endif
 }
 

