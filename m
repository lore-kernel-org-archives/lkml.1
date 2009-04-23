Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777AbZDWH3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbZDWH3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbZDWH10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:27:26 -0400
Received: from sous-sol.org ([216.99.217.87]:48158 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754682AbZDWH1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:27:19 -0400
Message-Id: <20090423072123.632556007@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:24 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Elias Oltmanns <eo@nebensachen.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 004/100] ide: Fix code dealing with sleeping devices in do_ide_request()
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=ide-fix-code-dealing-with-sleeping-devices-in-do_ide_request.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Elias Oltmanns <eo@nebensachen.de>

upstream commit: 9010941c5483a7a5bb1f7d97ee62491fb078bb51

Unfortunately, I missed a catch when reviewing the patch committed as
201bffa4. Here is the fix to the currently broken handling of sleeping
devices. In particular, this is required to get the disk shock
protection code working again.

Reported-by: Christian Thaeter <ct@pipapo.org>
Cc: stable@kernel.org
Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/ide/ide-io.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -736,11 +736,10 @@ repeat:
 		prev_port = hwif->host->cur_port;
 		hwif->rq = NULL;
 
-		if (drive->dev_flags & IDE_DFLAG_SLEEPING) {
-			if (time_before(drive->sleep, jiffies)) {
-				ide_unlock_port(hwif);
-				goto plug_device;
-			}
+		if (drive->dev_flags & IDE_DFLAG_SLEEPING &&
+		    time_after(drive->sleep, jiffies)) {
+			ide_unlock_port(hwif);
+			goto plug_device;
 		}
 
 		if ((hwif->host->host_flags & IDE_HFLAG_SERIALIZE) &&

