Return-Path: <linux-kernel-owner+w=401wt.eu-S932908AbZAOUNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbZAOUNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759420AbZAOUAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:46 -0500
Received: from kroah.org ([198.145.64.141]:48925 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765864AbZAOUAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:34 -0500
Date: Thu, 15 Jan 2009 11:58:00 -0800
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
       alan@lxorguk.ukuu.org.uk, Takahiro Yasui <tyasui@redhat.com>,
       Jonathan Brassow <jbrassow@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 21/94] dm log: fix dm_io_client leak on error paths
Message-ID: <20090115195800.GU14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-log-fix-dm_io_client-leak-on-error-paths.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takahiro Yasui <tyasui@redhat.com>

commit c7a2bd19b7c1e0bd2c7604c53d2583e91e536948 upstream.

In create_log_context function, dm_io_client_destroy function needs
to be called, when memory allocation of disk_header, sync_bits and
recovering_bits failed, but dm_io_client_destroy is not called.

Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
Acked-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-log.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -467,6 +467,7 @@ static int create_log_context(struct dm_
 		lc->disk_header = vmalloc(buf_size);
 		if (!lc->disk_header) {
 			DMWARN("couldn't allocate disk log buffer");
+			dm_io_client_destroy(lc->io_req.client);
 			kfree(lc);
 			return -ENOMEM;
 		}
@@ -482,6 +483,8 @@ static int create_log_context(struct dm_
 		DMWARN("couldn't allocate sync bitset");
 		if (!dev)
 			vfree(lc->clean_bits);
+		else
+			dm_io_client_destroy(lc->io_req.client);
 		vfree(lc->disk_header);
 		kfree(lc);
 		return -ENOMEM;
@@ -495,6 +498,8 @@ static int create_log_context(struct dm_
 		vfree(lc->sync_bits);
 		if (!dev)
 			vfree(lc->clean_bits);
+		else
+			dm_io_client_destroy(lc->io_req.client);
 		vfree(lc->disk_header);
 		kfree(lc);
 		return -ENOMEM;

