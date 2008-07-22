Return-Path: <linux-kernel-owner+w=401wt.eu-S1757202AbYGVXTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbYGVXTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbYGVXRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:17:51 -0400
Received: from ns.suse.de ([195.135.220.2]:52737 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbYGVXRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:17:49 -0400
Date: Tue, 22 Jul 2008 16:14:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Neil Brown <neilb@suse.de>
Subject: [patch 06/47] md: Fix error paths if md_probe fails.
Message-ID: <20080722231434.GG8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-fix-error-paths-if-md_probe-fails.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Neil Brown <neilb@notabene.brown>

commit 9bbbca3a0ee09293108b67835c6bdf6196d7bcb3 upstream

md_probe can fail (e.g. alloc_disk could fail) without
returning an error (as it alway returns NULL).
So when we call mddev_find immediately afterwards, we need
to check that md_probe actually succeeded.  This means checking
that mdev->gendisk is non-NULL.

Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3804,8 +3804,10 @@ static void autorun_devices(int part)
 
 		md_probe(dev, NULL, NULL);
 		mddev = mddev_find(dev);
-		if (!mddev) {
-			printk(KERN_ERR 
+		if (!mddev || !mddev->gendisk) {
+			if (mddev)
+				mddev_put(mddev);
+			printk(KERN_ERR
 				"md: cannot allocate memory for md drive.\n");
 			break;
 		}

-- 
