Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbYFRR4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbYFRR4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 13:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYFRRzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 13:55:52 -0400
Received: from mail-wa4.bigfish.com ([216.32.181.113]:10660 "EHLO
	mail147-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752854AbYFRRzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 13:55:51 -0400
X-Greylist: delayed 1211 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2008 13:55:51 EDT
X-BigFish: VPS27(z21aepz4015Mzz10d3izzz32i6bh87il43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0K2O66J-02-MR2-01
Date: Wed, 18 Jun 2008 11:34:38 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, linux-geode@lists.infradead.org
Subject: [PATCH] geode:  Add a VSA2 ID for General Software
Message-ID: <20080618173438.GA9130@cosmic.amd.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 18 Jun 2008 17:34:38.0976 (UTC) FILETIME=[957BF800:01C8D169]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

We have learned from bitter experience that one of the Geode BIOS vendors,
General Software, uses a different ID for their VSA implementation then
the canonical version from AMD & Insyde.  This patch adds the ID to the
have_geode_vsa2() check, and should make lxfb work again on many GSW
platforms.  If Linus is planning another -rcX revision it would be good
to try and get this in, otherwise please schedule this for the stable
series and 2.6.27.

Thanks,
Jordan

--RnlQjJ0d97Da+TV1
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="add-gsw-id.patch"

[PATCH] geode:  Add a VSA2 ID for General Software

From: Jordan Crouse <jordan.crouse@amd.com>

General Software writes their own VSA2 module for their version
of the Geode BIOS, which returns a different ID then the standard
VSA2.  This was causing the framebuffer driver to break for most
GSW boards.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
---

 arch/x86/kernel/geode_32.c |    5 ++++-
 include/asm-x86/geode.h    |    4 ++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/geode_32.c b/arch/x86/kernel/geode_32.c
index e8edd63..9b08e85 100644
--- a/arch/x86/kernel/geode_32.c
+++ b/arch/x86/kernel/geode_32.c
@@ -166,6 +166,8 @@ int geode_has_vsa2(void)
 	static int has_vsa2 = -1;
 
 	if (has_vsa2 == -1) {
+		u16 val;
+
 		/*
 		 * The VSA has virtual registers that we can query for a
 		 * signature.
@@ -173,7 +175,8 @@ int geode_has_vsa2(void)
 		outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
 		outw(VSA_VR_SIGNATURE, VSA_VRC_INDEX);
 
-		has_vsa2 = (inw(VSA_VRC_DATA) == VSA_SIG);
+		val = inw(VSA_VRC_DATA);
+		has_vsa2 = (val == AMD_VSA_SIG || val == GSW_VSA_SIG);
 	}
 
 	return has_vsa2;
diff --git a/include/asm-x86/geode.h b/include/asm-x86/geode.h
index 6e64588..bb06027 100644
--- a/include/asm-x86/geode.h
+++ b/include/asm-x86/geode.h
@@ -112,8 +112,8 @@ extern int geode_get_dev_base(unsigned int dev);
 #define VSA_VR_UNLOCK		0xFC53	/* unlock virtual register */
 #define VSA_VR_SIGNATURE	0x0003
 #define VSA_VR_MEM_SIZE		0x0200
-#define VSA_SIG			0x4132	/* signature is ascii 'VSA2' */
-
+#define AMD_VSA_SIG		0x4132	/* signature is ascii 'VSA2' */
+#define GSW_VSA_SIG		0x534d  /* General Software signature */
 /* GPIO */
 
 #define GPIO_OUTPUT_VAL		0x00

--RnlQjJ0d97Da+TV1--

