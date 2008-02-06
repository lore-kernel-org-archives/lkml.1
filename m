Return-Path: <linux-kernel-owner+w=401wt.eu-S934195AbYBGA2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195AbYBGA2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932686AbYBGAAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:00:06 -0500
Received: from mail.suse.de ([195.135.220.2]:46639 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932679AbYBGAAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:00:03 -0500
Date: Wed, 6 Feb 2008 15:54:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Gerd v. Egidy" <gerd.von.egidy@intra2net.com>,
       Karsten Keil <kkeil@suse.de>
Subject: [patch 66/73] fix oops on rmmod capidrv
Message-ID: <20080206235423.GO13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-oops-on-rmmod-capidrv.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Karsten Keil <kkeil@suse.de>

patch eb36f4fc019835cecf0788907f6cab774508087b in mainline.

Fix overwriting the stack with the version string
(it is currently 10 bytes + zero) when unloading the
capidrv module. Safeguard against overwriting it
should the version string grow in the future.

Should fix Kernel Bug Tracker Bug 9696.

Signed-off-by: Gerd v. Egidy <gerd.von.egidy@intra2net.com>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/capi/capidrv.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -2306,13 +2306,14 @@ static int __init capidrv_init(void)
 
 static void __exit capidrv_exit(void)
 {
-	char rev[10];
+	char rev[32];
 	char *p;
 
 	if ((p = strchr(revision, ':')) != 0) {
-		strcpy(rev, p + 1);
-		p = strchr(rev, '$');
-		*p = 0;
+		strncpy(rev, p + 1, sizeof(rev));
+		rev[sizeof(rev)-1] = 0;
+		if ((p = strchr(rev, '$')) != 0)
+			*p = 0;
 	} else {
 		strcpy(rev, " ??? ");
 	}

-- 
