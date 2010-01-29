Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157Ab0A2Rlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0A2Rlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 12:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983Ab0A2Rlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 12:41:35 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34121 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017Ab0A2Rlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 12:41:35 -0500
Subject: Re: [PATCH] kmemleak: Do not enable KMEMCHECK_PARTIAL_OK
	if	DEBUG_KMEMLEAK
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christian Casteyde <casteyde.christian@free.fr>,
       vegard.nossum@gmail.com
In-Reply-To: <4B60573E.7080108@cs.helsinki.fi>
References: <4B60573E.7080108@cs.helsinki.fi>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 29 Jan 2010 17:40:56 +0000
Message-Id: <1264786856.4242.115.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jan 2010 17:40:57.0603 (UTC) FILETIME=[36E25D30:01CAA10A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 15:09 +0000, Pekka Enberg wrote:
> Catalin Marinas wrote:
> > diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> > index 5b069e4..dfd39ba 100644
> > --- a/mm/kmemleak.c
> > +++ b/mm/kmemleak.c
> > @@ -948,6 +948,25 @@ EXPORT_SYMBOL(kmemleak_no_scan);
> >  /*
> >   * Update an object's checksum and return true if it was modified.
> >   */
> > +#ifdef CONFIG_KMEMCHECK_PARTIAL_OK
> > +static bool update_checksum(struct kmemleak_object *object)
> > +{
> > +     u32 crc = 0;
> > +     unsigned long ptr;
> > +
> > +     for (ptr = ALIGN(object->pointer, 4);
> > +          ptr < ((object->pointer + object->size) & ~3); ptr += 4) {
> > +             if (!kmemcheck_is_obj_initialized(ptr, 4))
> > +                     continue;
> > +             crc = crc32(crc, (void *)ptr, 4);
> > +     }
> > +
> > +     if (object->checksum == crc)
> > +             return false;
> > +     object->checksum = crc;
> > +     return true;
> 
> I think it would be better to add a function to _kmemcheck_ that checks
> the full object regardless of CONFIG_KMEMCHECK_PARTIAL_OK and use it here.

IIRC, it's only kmemleak using kmemcheck_is_obj_initialized(), we could
convert this to check the full object. Something like below (again, not
tested yet but if you are ok with the idea I'll test it a bit more and
add a commit log):


diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
index 8cc1833..b3b531a 100644
--- a/arch/x86/mm/kmemcheck/kmemcheck.c
+++ b/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -337,7 +337,7 @@ bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size)
 	if (!shadow)
 		return true;
 
-	status = kmemcheck_shadow_test(shadow, size);
+	status = kmemcheck_shadow_test_all(shadow, size);
 
 	return status == KMEMCHECK_SHADOW_INITIALIZED;
 }
diff --git a/arch/x86/mm/kmemcheck/shadow.c b/arch/x86/mm/kmemcheck/shadow.c
index 3f66b82..16c6d9f 100644
--- a/arch/x86/mm/kmemcheck/shadow.c
+++ b/arch/x86/mm/kmemcheck/shadow.c
@@ -139,13 +139,25 @@ enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size)
 		if (x[i] == KMEMCHECK_SHADOW_INITIALIZED)
 			return x[i];
 	}
+
+	return x[0];
 #else
+	return kmemcheck_shadow_test_all(shadow, size);
+#endif
+}
+
+enum kmemcheck_shadow kmemcheck_shadow_test_all(void *shadow, unsigned int size)
+{
+	uint8_t *x;
+	unsigned int i;
+
+	x = shadow;
+
 	/* All bytes must be initialized. */
 	for (i = 0; i < size; ++i) {
 		if (x[i] != KMEMCHECK_SHADOW_INITIALIZED)
 			return x[i];
 	}
-#endif
 
 	return x[0];
 }
diff --git a/arch/x86/mm/kmemcheck/shadow.h b/arch/x86/mm/kmemcheck/shadow.h
index af46d9a..ff0b2f7 100644
--- a/arch/x86/mm/kmemcheck/shadow.h
+++ b/arch/x86/mm/kmemcheck/shadow.h
@@ -11,6 +11,8 @@ enum kmemcheck_shadow {
 void *kmemcheck_shadow_lookup(unsigned long address);
 
 enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size);
+enum kmemcheck_shadow kmemcheck_shadow_test_all(void *shadow,
+						unsigned int size);
 void kmemcheck_shadow_set(void *shadow, unsigned int size);
 
 #endif


-- 
Catalin

