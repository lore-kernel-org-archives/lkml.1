Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbYD2F3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbYD2F3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 01:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYD2F3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 01:29:14 -0400
Received: from mail.queued.net ([207.210.101.209]:3083 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbYD2F3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 01:29:14 -0400
Date: Tue, 29 Apr 2008 01:32:13 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, jordan.crouse@amd.com
Subject: [PATCH] x86: GEODE: cache results from geode_has_vsa2() and
 uninline
Message-ID: <20080429013213.4084e892@ephemeral>
In-Reply-To: <20080428200651.169f1db1.akpm@linux-foundation.org>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	<20080419031024.GC3503@nineveh.local>
	<20080418202925.b18452c5.akpm@linux-foundation.org>
	<20080419092544.378664a8@ephemeral>
	<20080419133909.5aa6b63e@ephemeral>
	<86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>
	<480C0582.9010509@firmworks.com>
	<86802c440804202015h2605eff7vc733874dd1f22261@mail.gmail.com>
	<480C1286.3040307@firmworks.com>
	<20080421102417.6de71391@ephemeral>
	<1208793253.9212.507.camel@pmac.infradead.org>
	<20080421130320.38b5f505@ephemeral>
	<1208805491.9212.520.camel@pmac.infradead.org>
	<20080421154618.2ed4978f@ephemeral>
	<1208809517.9212.537.camel@pmac.infradead.org>
	<20080421170230.2db18632@ephemeral>
	<20080428200651.169f1db1.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 20:06:51 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 21 Apr 2008 17:02:30 -0400 Andres Salomon <dilinger@queued.net> wrote:
> 
> > +	if (!is_geode() || geode_has_vsa2())
> 
> geode_has_vsa2() is a fairly expensive-looking function and afacit only
> needs to be evaluated once per boot.  Perhaps we should cache it somewhere?
> 

How about this?






This moves geode_has_vsa2 into a .c file, caches the result we get from
the VSA virtual registers, and causes the function to no longer be inline.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 arch/x86/kernel/geode_32.c |   19 +++++++++++++++++++
 include/asm-x86/geode.h    |   11 +----------
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/geode_32.c b/arch/x86/kernel/geode_32.c
index 9dad6ca..1cb8225 100644
--- a/arch/x86/kernel/geode_32.c
+++ b/arch/x86/kernel/geode_32.c
@@ -161,6 +161,25 @@ void geode_gpio_setup_event(unsigned int gpio, int pair, int pme)
 }
 EXPORT_SYMBOL_GPL(geode_gpio_setup_event);
 
+static int has_vsa2 = -1;
+
+int geode_has_vsa2(void)
+{
+	if (has_vsa2 == -1) {
+		/*
+		 * The VSA has virtual registers that we can query for a
+		 * signature.
+		 */
+		outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
+		outw(VSA_VR_SIGNATURE, VSA_VRC_INDEX);
+
+		has_vsa2 = (inw(VSA_VRC_DATA) == VSA_SIG);
+	}
+
+	return has_vsa2;
+}
+EXPORT_SYMBOL_GPL(geode_has_vsa2);
+
 static int __init geode_southbridge_init(void)
 {
 	if (!is_geode())
diff --git a/include/asm-x86/geode.h b/include/asm-x86/geode.h
index 7154dc4..8a53bc8 100644
--- a/include/asm-x86/geode.h
+++ b/include/asm-x86/geode.h
@@ -185,16 +185,7 @@ static inline int is_geode(void)
 	return (is_geode_gx() || is_geode_lx());
 }
 
-/*
- * The VSA has virtual registers that we can query for a signature.
- */
-static inline int geode_has_vsa2(void)
-{
-	outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
-	outw(VSA_VR_SIGNATURE, VSA_VRC_INDEX);
-
-	return (inw(VSA_VRC_DATA) == VSA_SIG);
-}
+extern int geode_has_vsa2(void);
 
 /* MFGPTs */
 
-- 
1.5.5

