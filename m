Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbZJSGIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbZJSGIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 02:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbZJSGIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 02:08:48 -0400
Received: from ozlabs.org ([203.10.76.45]:50402 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbZJSGIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 02:08:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Jan Beulich" <JBeulich@novell.com>
Subject: Re: [PATCH] serial/atmel_serial: Fix another fallout of the change to BUILD_BUG_ON
Date: Mon, 19 Oct 2009 16:38:39 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       u.kleine-koenig@pengutronix.de,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@linux.intel.com>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
References: <1255417680-25609-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091013092644.72c78334@hskinnemoen-d830> <4AD44AF10200007800019801@vpn.id2.novell.com>
In-Reply-To: <4AD44AF10200007800019801@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910191638.41299.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009 06:10:01 pm Jan Beulich wrote:
> >>> Haavard Skinnemoen <haavard.skinnemoen@atmel.com> 13.10.09 09:26 >>>
> >Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> >> Commit 8c87df457cb5 fixed BUILD_BUG_ON with the result that some
> >> expressions (e.g. "not really constant" ones) result in a build failure.
> >> 
> >> Some of these were fixed in 8c87df457cb5, but not serial/atmel_serial.
> >
> >This patch fixes the same issue:
> >
> >http://lkml.org/lkml/2009/10/6/305 
> >
> >> -	BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
> >> +	MAYBE_BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
> >
> >What's the difference between BUILD_BUG_ON() and MAYBE_BUILD_BUG_ON()?
> 
> The latter (at present) generally only serves as an annotation. It should
> probably be renamed and converted to the (linking time) detecting
> mechanism Rusty suggested (though I'm not sure that model would
> allow all non-constant [at parsing time] uses to be detected - clearly
> there would remain potential for build issues if the compiler isn't able
> to reduce the expression to a constant during optimization).

How's this?  It's not quite valid C, but it "works":

Subject: [PATCH] Rename, strengthen MAYBE_BUILD_BUG_ON()

There are some cases where we really want the parser to break if it can,
but BUG_ON() if it can't.  We can do that using sizeof() and a BUG_ON():
the compiler will only emit the test if it is non-constant.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -220,7 +220,7 @@ static inline enum zone_type gfp_zone(gf
 					 ((1 << ZONES_SHIFT) - 1);
 
 	if (__builtin_constant_p(bit))
-		MAYBE_BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
+		BUILD_OR_RUNTIME_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
 	else {
 #ifdef CONFIG_DEBUG_VM
 		BUG_ON((GFP_ZONE_BAD >> bit) & 1);
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -686,8 +686,16 @@ struct sysinfo {
 /* Force a compilation error if condition is true */
 #define BUILD_BUG_ON(condition) ((void)BUILD_BUG_ON_ZERO(condition))
 
-/* Force a compilation error if condition is constant and true */
-#define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
+/**
+ * BUILD_OR_RUNTIME_BUG_ON - break compile or BUG_ON() when run.
+ * cond: condition which should be false.
+ *
+ * There are cases where compile should simply break if the compiler
+ * can deduce the condition is true at parse time; if it can't, it
+ * should be tested at runtime.
+ */
+#define BUILD_OR_RUNTIME_BUG_ON(cond) \
+	BUG_ON(sizeof(char[1 - 2 * !!(cond)]) != 1)
 
 /* Force a compilation error if condition is true, but also produce a
    result (of value 0 and type size_t), so the expression can be used
diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
--- a/include/linux/kmemcheck.h
+++ b/include/linux/kmemcheck.h
@@ -152,7 +152,7 @@ static inline bool kmemcheck_is_obj_init
 									\
 		_n = (long) &((ptr)->name##_end)			\
 			- (long) &((ptr)->name##_begin);		\
-		MAYBE_BUILD_BUG_ON(_n < 0);				\
+		BUILD_OR_RUNTIME_BUG_ON(_n < 0);			\
 									\
 		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
 	} while (0)
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -109,7 +109,7 @@ static inline bool virtio_has_feature(co
 				      unsigned int fbit)
 {
 	/* Did you forget to fix assumptions on max features? */
-	MAYBE_BUILD_BUG_ON(fbit >= 32);
+	BUILD_OR_RUNTIME_BUG_ON(fbit >= 32);
 
 	if (fbit < VIRTIO_TRANSPORT_F_START)
 		virtio_check_driver_offered_feature(vdev, fbit);
