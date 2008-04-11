Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbYDKBvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbYDKBvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 21:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758205AbYDKBvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 21:51:41 -0400
Received: from mail.queued.net ([207.210.101.209]:1073 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbYDKBvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 21:51:40 -0400
Date: Thu, 10 Apr 2008 21:53:24 -0400
From: Andres Salomon <dilinger@queued.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       info-linux@geode.amd.com, jordan.crouse@amd.com
Subject: Re: [PATCH 2/3] x86: GEODE: add Virtual Systems Architecture
 detection
Message-ID: <20080410215324.521324c7@ephemeral>
In-Reply-To: <20080410152019.52c55686@core>
References: <20080409223328.5774d6cf@ephemeral>
	<20080410091057.45cbb938@core>
	<20080410094024.5111e108@ephemeral>
	<20080410152019.52c55686@core>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008 15:20:19 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > This is a check for *VSA2* which is not the same as VSA1 (Cyrix one) and
> > > for older systems that actually matters as you may have VSA1 or VSA2 and
> > > they are detected differently.
> > >
> > 
> > Excellent point.  Can we extend this to check for a VSA1-specific
> > string, or does VSA1 not have a similar signature?
> 
> VSA1 requires you grovelling around poking at the video registers to get
> a reliable answer and the only bits we need it for are the DMA bug (where
> we assume all have it) and the sound driver (which uses the PCI space to
> see what audio setup is there).
> 
> X cares but we don't currently.

How about this?





This is generic VSA2 detection.  It's used by OLPC to determine whether or
not the BIOS contains VSA2, but since other BIOSes are coming out that don't
use the VSA (ie, tinybios), it might end up being useful for others.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 include/asm-x86/geode.h |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/geode.h b/include/asm-x86/geode.h
index c208398..6cded63 100644
--- a/include/asm-x86/geode.h
+++ b/include/asm-x86/geode.h
@@ -103,6 +103,14 @@ extern int geode_get_dev_base(unsigned int dev);
 #define PM_AWKD			0x50
 #define PM_SSC			0x54
 
+/* VSA2 magic values */
+
+#define VSA_VRC_INDEX		0xAC1C
+#define VSA_VRC_DATA		0xAC1E
+#define VSA_VR_UNLOCK		0xFC53	/* unlock virtual register */
+#define VSA_VR_SIGNATURE	0x0003
+#define VSA_SIG			0x4132	/* signature is ascii 'VSA2' */
+
 /* GPIO */
 
 #define GPIO_OUTPUT_VAL		0x00
@@ -174,6 +182,17 @@ static inline int is_geode(void)
 	return (is_geode_gx() || is_geode_lx());
 }
 
+/*
+ * The VSA has virtual registers that we can query for a signature.
+ */
+static inline int geode_has_vsa2(void)
+{
+	outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
+	outw(VSA_VR_SIGNATURE, VSA_VRC_INDEX);
+
+	return (inw(VSA_VRC_DATA) == VSA_SIG);
+}
+
 /* MFGPTs */
 
 #define MFGPT_MAX_TIMERS	8
-- 
1.5.4.2

