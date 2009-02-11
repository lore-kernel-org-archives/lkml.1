Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbZBKAe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbZBKAe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757664AbZBKA2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:25 -0500
Received: from kroah.org ([198.145.64.141]:51161 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757627AbZBKA2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:21 -0500
Date: Tue, 10 Feb 2009 16:24:56 -0800
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
       alan@lxorguk.ukuu.org.uk, Jarod Wilson <jarod@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 20/56] firewire: sbp2: add workarounds for 2nd and 3rd
	generation iPods
Message-ID: <20090211002456.GU14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="firewire-sbp2-add-workarounds-for-2nd-and-3rd-generation-ipods.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Commit c8c4707cf7ca8ff7dcc1653447e48cb3de0bf114 upstream.

According to https://bugs.launchpad.net/bugs/294391
  - 3rd generation iPods need the "fix capacity" workaround after all
    (apparently they crash after the last sector was accessed),
  - 2nd generation iPods need the "128 kB maximum request size"
    workaround.

Alas both iPod generations feature the same model ID in the config ROM,
hence we can only define a shared quirks list entry for them.  Luckily
the fix capacity workaround did not show a negative effect in Jarod's
tests with 2nd gen. iPod.

A side note:  Apple computers in target mode (or at least an x86 Mac
mini) don't have firmware_version and model_id, hence none of the iPod
quirks list entries is active for them.

Tested-by: Jarod Wilson <jarod@redhat.com>
Acked-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/fw-sbp2.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -350,15 +350,17 @@ static const struct {
 		.model			= ~0,
 		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
 	},
-
 	/*
-	 * There are iPods (2nd gen, 3rd gen) with model_id == 0, but
-	 * these iPods do not feature the read_capacity bug according
-	 * to one report.  Read_capacity behaviour as well as model_id
-	 * could change due to Apple-supplied firmware updates though.
+	 * iPod 2nd generation: needs 128k max transfer size workaround
+	 * iPod 3rd generation: needs fix capacity workaround
 	 */
-
-	/* iPod 4th generation. */ {
+	{
+		.firmware_revision	= 0x0a2700,
+		.model			= 0x000000,
+		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS |
+					  SBP2_WORKAROUND_FIX_CAPACITY,
+	},
+	/* iPod 4th generation */ {
 		.firmware_revision	= 0x0a2700,
 		.model			= 0x000021,
 		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,

