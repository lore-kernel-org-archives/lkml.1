Return-Path: <linux-kernel-owner+w=401wt.eu-S964876AbYBWAvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964876AbYBWAvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761168AbYBWAgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:36:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760455AbYBWAgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:36:20 -0500
Date: Fri, 22 Feb 2008 16:31:35 -0800
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
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 35/38] PCMCIA: Fix station address detection in smc
Message-ID: <20080223003135.GJ7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pcmcia-fix-station-address-detection-in-smc.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Chuck Ebbert <cebbert@redhat.com>

Commit: a1a98b72dbd17e53cd92b8e78f404525ebcfd981

Fix station address detection in smc

Megahertz EM1144 PCMCIA ethernet adapter needs special handling
because it has two VERS_1 tuples and the station address is in
the second one. Conversion to generic handling of these fields
broke it. Reverting that fixes the device.

  https://bugzilla.redhat.com/show_bug.cgi?id=233255

Thanks go to Jon Stanley for not giving up on this one until the
problem was found.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/pcmcia/smc91c92_cs.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/net/pcmcia/smc91c92_cs.c
+++ b/drivers/net/pcmcia/smc91c92_cs.c
@@ -559,8 +559,16 @@ static int mhz_setup(struct pcmcia_devic
 
     /* Read the station address from the CIS.  It is stored as the last
        (fourth) string in the Version 1 Version/ID tuple. */
-    if (link->prod_id[3]) {
-	station_addr = link->prod_id[3];
+    tuple->DesiredTuple = CISTPL_VERS_1;
+    if (first_tuple(link, tuple, parse) != CS_SUCCESS) {
+	rc = -1;
+	goto free_cfg_mem;
+    }
+    /* Ugh -- the EM1144 card has two VERS_1 tuples!?! */
+    if (next_tuple(link, tuple, parse) != CS_SUCCESS)
+	first_tuple(link, tuple, parse);
+    if (parse->version_1.ns > 3) {
+	station_addr = parse->version_1.str + parse->version_1.ofs[3];
 	if (cvt_ascii_address(dev, station_addr) == 0) {
 		rc = 0;
 		goto free_cfg_mem;

-- 
