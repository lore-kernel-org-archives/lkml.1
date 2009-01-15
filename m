Return-Path: <linux-kernel-owner+w=401wt.eu-S1761767AbZAOUNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761767AbZAOUNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765959AbZAOUAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:45 -0500
Received: from kroah.org ([198.145.64.141]:48916 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765847AbZAOUAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:33 -0500
Date: Thu, 15 Jan 2009 11:57:58 -0800
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
       alan@lxorguk.ukuu.org.uk, Milan Broz <mbroz@redhat.com>,
       Jonathan Brassow <jbrassow@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 20/94] dm raid1: fix error count
Message-ID: <20090115195758.GT14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-raid1-fix-error-count.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jonathan Brassow <jbrassow@redhat.com>

commit d460c65a6a9ec9e0d284864ec3a9a2d1b73f0e43 upstream.

Always increase the error count when I/O on a leg of a mirror fails.

The error count is used to decide whether to select an alternative
mirror leg.  If the target doesn't use the "handle_errors" feature, the
error count is not updated and the bio can get requeued forever by the
read callback.

Fix it by increasing error_count before the handle_errors feature
checking.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-raid1.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -197,9 +197,6 @@ static void fail_mirror(struct mirror *m
 	struct mirror_set *ms = m->ms;
 	struct mirror *new;
 
-	if (!errors_handled(ms))
-		return;
-
 	/*
 	 * error_count is used for nothing more than a
 	 * simple way to tell if a device has encountered
@@ -210,6 +207,9 @@ static void fail_mirror(struct mirror *m
 	if (test_and_set_bit(error_type, &m->error_type))
 		return;
 
+	if (!errors_handled(ms))
+		return;
+
 	if (m != get_default_mirror(ms))
 		goto out;
 

