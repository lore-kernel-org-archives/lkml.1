Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbZA1XMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbZA1XMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZA1XMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:12:41 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:33132 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbZA1XMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:12:40 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 29 Jan 2009 00:11:59 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH revised] firewire: sbp2: add workarounds for 2nd and 3rd
 generation iPods
To: linux1394-devel@lists.sourceforge.net
cc: Jarod Wilson <jarod@redhat.com>,
       =?iso-8859-1?Q?Kristian__H=F8gsberg?= <krh@bitplanet.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200901281725.25750.jarod@redhat.com>
Message-ID: <tkrat.a24a8ff6f4c5711f@s5r6.in-berlin.de>
References: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de>
 <tkrat.b82b9fbc17b1a032@s5r6.in-berlin.de>
 <200901281718.41873.jarod@redhat.com> <200901281725.25750.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -360,15 +360,17 @@ static const struct {
 		.model			= SBP2_ROM_VALUE_WILDCARD,
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

-- 
Stefan Richter
-=====-==--= ---= ===-=
http://arcgraph.de/sr/

