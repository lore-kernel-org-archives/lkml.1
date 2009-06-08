Return-Path: <linux-kernel-owner+w=401wt.eu-S1751130AbZFHSXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130AbZFHSXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZFHSXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:23:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbZFHSXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:23:01 -0400
Date: Mon, 8 Jun 2009 11:21:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Chris Clayton <chris2553@googlemail.com>
cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: 2.6.30-rc8 Oops whilst booting
In-Reply-To: <c6b1100b0906081045t47c77b94ubc89d450c3a75147@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0906081120400.6847@localhost.localdomain>
References: <200906061959.55592.chris2553@googlemail.com>  <1244413881.18742.31.camel@ht.satnam>  <2f9e3044bafcae848f74a1492b0ea471.squirrel@neil.brown.name>  <c6b1100b0906080108y191bb157n67ec681ade2a0d13@mail.gmail.com>  <c6b1100b0906080358y4033c402ra236eff3f972d169@mail.gmail.com>
  <1244460875.12644.2.camel@ht.satnam>  <c6b1100b0906080553o2aa77a40pe0077b1b10a7d88a@mail.gmail.com>  <alpine.LFD.2.01.0906080916130.6847@localhost.localdomain>  <1244479879.4079.284.camel@mulgrave.site>  <1244480790.2716.7.camel@ht.satnam>
 <c6b1100b0906081045t47c77b94ubc89d450c3a75147@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Jun 2009, Chris Clayton wrote:
> 
> I can confirm that a kernel built with Jaswinder's patch applied
> survived 200 boots without a panic.

Ok, goodie.

Can you confirm that the further cleanup (removing the pointless 'ret' 
variable and the useless empty checking around 'for_each_entry') also 
works for you?

		Linus

---
 kernel/async.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index 5054030..27235f5 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -92,23 +92,18 @@ extern int initcall_debug;
 static async_cookie_t  __lowest_in_progress(struct list_head *running)
 {
 	struct async_entry *entry;
-	async_cookie_t ret = next_cookie; /* begin with "infinity" value */
 
 	if (!list_empty(running)) {
 		entry = list_first_entry(running,
 			struct async_entry, list);
-		ret = entry->cookie;
+		return entry->cookie;
 	}
 
-	if (!list_empty(&async_pending)) {
-		list_for_each_entry(entry, &async_pending, list)
-			if (entry->running == running) {
-				ret = entry->cookie;
-				break;
-			}
-	}
+	list_for_each_entry(entry, &async_pending, list)
+		if (entry->running == running)
+			return entry->cookie;
 
-	return ret;
+	return next_cookie;	/* "infinity" value */
 }
 
 static async_cookie_t  lowest_in_progress(struct list_head *running)
