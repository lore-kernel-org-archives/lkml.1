Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbYKDXqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbYKDXqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbYKDXjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:39:04 -0500
Received: from mail.suse.de ([195.135.220.2]:47440 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757503AbYKDXjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:39:01 -0500
Date: Tue, 4 Nov 2008 15:31:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 24/57] firewire: fw-sbp2: delay first login to avoid retries
Message-ID: <20081104233151.GY659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="firewire-fw-sbp2-delay-first-login-to-avoid-retries.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 0dcfeb7e3c8695c5aa3677dda8efb9bef2e7e64d upstream

This optimizes firewire-sbp2's device probe for the case that the local
node and the SBP-2 node were discovered at the same time.  In this case,
fw-core's bus management work and fw-sbp2's login and SCSI probe work
are scheduled in parallel (in the globally shared workqueue and in
fw-sbp2's workqueue, respectively).  The bus reset from fw-core may then
disturb and extremely delay the login and SCSI probe because the latter
fails with several command timeouts and retries and has to be retried
from scratch.

We avoid this particular situation of sbp2_login() and fw_card_bm_work()
running in parallel by delaying the first sbp2_login() a little bit.

This is meant to be a short-term fix for
https://bugzilla.redhat.com/show_bug.cgi?id=466679.  In the long run,
the SCSI probe, i.e. fw-sbp2's call of __scsi_add_device(), should be
parallelized with sbp2_reconnect().

Problem reported and fix tested and confirmed by Alex Kanavin.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/fw-sbp2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -1158,7 +1158,7 @@ static int sbp2_probe(struct device *dev
 
 	/* Do the login in a workqueue so we can easily reschedule retries. */
 	list_for_each_entry(lu, &tgt->lu_list, link)
-		sbp2_queue_work(lu, 0);
+		sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
 	return 0;
 
  fail_tgt_put:

-- 
