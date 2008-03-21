Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbYCUW41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbYCUW41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762571AbYCUWuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:50:15 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59138 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762974AbYCUWuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:50:09 -0400
Message-Id: <20080321224358.077214520@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:21 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Uli Luckas <u.luckas@road.de>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 31/76] ARM pxa: fix clock lookup to find specific device clocks
Content-Disposition: inline; filename=arm-pxa-fix-clock-lookup-to-find-specific-device-clocks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

Ensure that the clock lookup always finds an entry for a specific
device and ID before it falls back to finding just by ID.  This
fixes a problem reported by Holger Schurig where the BTUART was
assigned the wrong clock.

Tested-by: Holger Schurig <hs4233@mail.mn-solutions.de>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Uli Luckas notes:

  The patch fixes the otherwise unusable bluetooth uart on pxa25x. The
  patch is written by Russell King [1] who also gave his OK for
  stable inclusion [2].  The patch is also available as commit
  a0dd005d1d9f4c3beab52086f3844ef9342d1e67 to Linus' tree.
  
  [1] http://marc.info/?l=linux-arm-kernel&m=120298366510315
  [2] http://marc.info/?l=linux-arm-kernel&m=120384388411097

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/arm/mach-pxa/clock.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/arch/arm/mach-pxa/clock.c
+++ b/arch/arm/mach-pxa/clock.c
@@ -23,18 +23,27 @@ static LIST_HEAD(clocks);
 static DEFINE_MUTEX(clocks_mutex);
 static DEFINE_SPINLOCK(clocks_lock);
 
+static struct clk *clk_lookup(struct device *dev, const char *id)
+{
+	struct clk *p;
+
+	list_for_each_entry(p, &clocks, node)
+		if (strcmp(id, p->name) == 0 && p->dev == dev)
+			return p;
+
+	return NULL;
+}
+
 struct clk *clk_get(struct device *dev, const char *id)
 {
 	struct clk *p, *clk = ERR_PTR(-ENOENT);
 
 	mutex_lock(&clocks_mutex);
-	list_for_each_entry(p, &clocks, node) {
-		if (strcmp(id, p->name) == 0 &&
-		    (p->dev == NULL || p->dev == dev)) {
-			clk = p;
-			break;
-		}
-	}
+	p = clk_lookup(dev, id);
+	if (!p)
+		p = clk_lookup(NULL, id);
+	if (p)
+		clk = p;
 	mutex_unlock(&clocks_mutex);
 
 	return clk;

-- 
