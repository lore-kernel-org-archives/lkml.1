Return-Path: <linux-kernel-owner+w=401wt.eu-S1764014AbZCNBij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764014AbZCNBij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbZCNBUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:53 -0400
Received: from kroah.org ([198.145.64.141]:35260 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753691AbZCNBUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:32 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:38 2009
Message-Id: <20090314011038.802911946@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:27 -0700
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
       alan@lxorguk.ukuu.org.uk, Lubomir Rintel <lkundrak@v3.sk>,
       Dave Airlie <airlied@linux.ie>
Subject: [patch 050/114] intel-agp: fix a panic with 1M of shared memory, no GTT entries
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=intel-agp-fix-a-panic-with-1m-of-shared-memory-no-gtt-entries.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lubomir Rintel <lkundrak@v3.sk>

commit 9c1e8a4ebcc04226cb6f3a1bf1d72f4cafd6b089 upstream.

When GTT size is equal to amount of video memory, the amount of GTT
entries is computed lower than zero, which is invalid and leads to
off-by-one error in intel_i915_configure()

Originally posted here:
http://bugzilla.kernel.org/show_bug.cgi?id=12539
http://bugzilla.redhat.com/show_bug.cgi?id=445592

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Lubomir Rintel <lkundrak@v3.sk>
Cc: Dave Airlie <airlied@linux.ie>
Reviewed-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/intel-agp.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -633,13 +633,15 @@ static void intel_i830_init_gtt_entries(
 			break;
 		}
 	}
-	if (gtt_entries > 0)
+	if (gtt_entries > 0) {
 		dev_info(&agp_bridge->dev->dev, "detected %dK %s memory\n",
 		       gtt_entries / KB(1), local ? "local" : "stolen");
-	else
+		gtt_entries /= KB(4);
+	} else {
 		dev_info(&agp_bridge->dev->dev,
 		       "no pre-allocated video memory detected\n");
-	gtt_entries /= KB(4);
+		gtt_entries = 0;
+	}
 
 	intel_private.gtt_entries = gtt_entries;
 }


