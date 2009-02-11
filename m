Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbZBKAnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbZBKAnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756422AbZBKA2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:46 -0500
Received: from kroah.org ([198.145.64.141]:51497 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757849AbZBKA2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:44 -0500
Date: Tue, 10 Feb 2009 16:25:42 -0800
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
       alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [patch 42/56] md: Allow metadata_version to be updated for
	externally managed metadata.
Message-ID: <20090211002542.GQ14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-allow-metadata_version-to-be-updated-for-externally-managed-metadata.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: NeilBrown <neilb@suse.de>

commit ea43ddd8491feccf36267349748ea91b1194481e upstream.

For externally managed metadata, the 'metadata_version' sysfs
attribute is really just a channel for user-space programs to
communicate about how the array is being managed.
It can be useful for this to be changed while the array is active.

Normally changes to metadata_version are not permitted while the array
is active.  Change that so that if the metadata is externally managed,
the metadata_version can be changed to a different flavour of external
management.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2960,7 +2960,13 @@ metadata_store(mddev_t *mddev, const cha
 {
 	int major, minor;
 	char *e;
-	if (!list_empty(&mddev->disks))
+	/* Changing the details of 'external' metadata is
+	 * always permitted.  Otherwise there must be
+	 * no devices attached to the array.
+	 */
+	if (mddev->external && strncmp(buf, "external:", 9) == 0)
+		;
+	else if (!list_empty(&mddev->disks))
 		return -EBUSY;
 
 	if (cmd_match(buf, "none")) {

