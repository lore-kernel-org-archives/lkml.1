Return-Path: <linux-kernel-owner+w=401wt.eu-S933699AbXCUTEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbXCUTEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933727AbXCUTEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:04:15 -0400
Received: from saeurebad.de ([85.214.36.134]:38147 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933699AbXCUTEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:04:14 -0400
Date: Wed, 21 Mar 2007 20:04:00 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Dale Blount <linux-kernel@dale.us>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: PROBLEM: null pointer dereference in cfq_dispatch_requests (2.6.21-rc2 and 2.6.20)
Message-ID: <20070321190359.GD16768@leiferikson>
Mail-Followup-To: Dale Blount <linux-kernel@dale.us>,
	linux-kernel@vger.kernel.org, axboe@kernel.dk
References: <1172685755.5773.6.camel@dwillia2-linux.ch.intel.com> <200703011308.28266.linux@f-seidel.de> <20070301123057.GO23985@kernel.dk> <loom.20070321T135132-397@post.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <loom.20070321T135132-397@post.gmane.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I think I found where the NULL may come from.  Please, anybody, do not
apply this patch before a trustful person reviewed it... Jens? ;)

My thoughts on this are, that there are two possibilities cfqq->next_rq
could be NULL: End of list or a bug when it is set (or not set).
But why does RB_EMPTY_ROOT() as last call in this loop does not trigger?

Did I even get the right place on where the NULL pointer dereference
happens? :)

=Hannes

Signed-off-by: Johannes Weiner <hannes-kernel@saeurebad.de>

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cfq-iosched-NULL-dereference.patch"

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b6491c0..ca84f0b 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -961,8 +961,8 @@ __cfq_dispatch_requests(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		/*
 		 * follow expired path, else get first next available
 		 */
-		if ((rq = cfq_check_fifo(cfqq)) == NULL)
-			rq = cfqq->next_rq;
+		if (!(rq = cfq_check_fifo(cfqq)) && !(rq = cfqq->next_rq))
+			break;
 
 		/*
 		 * finally, insert request into driver dispatch list

--OgqxwSJOaUobr8KG--
