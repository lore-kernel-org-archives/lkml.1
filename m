Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259Ab0A0LCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab0A0LCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779Ab0A0LCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:02:45 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48712 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042Ab0A0LCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:02:44 -0500
Subject: Re: [PATCH] kmemleak: Do not enable KMEMCHECK_PARTIAL_OK if
	DEBUG_KMEMLEAK
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christian Casteyde <casteyde.christian@free.fr>,
       vegard.nossum@gmail.com
In-Reply-To: <4B5FDD85.5080701@cs.helsinki.fi>
References: <4B5FDD85.5080701@cs.helsinki.fi>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 27 Jan 2010 11:02:06 +0000
Message-Id: <1264590127.15957.14.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jan 2010 11:02:08.0020 (UTC) FILETIME=[2AEA4540:01CA9F40]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Wed, 2010-01-27 at 06:30 +0000, Pekka Enberg wrote:
> Catalin Marinas kirjoitti:
> > diff --git a/lib/Kconfig.kmemcheck b/lib/Kconfig.kmemcheck
> > index 846e039..80660e9 100644
> > --- a/lib/Kconfig.kmemcheck
> > +++ b/lib/Kconfig.kmemcheck
> > @@ -75,7 +75,7 @@ config KMEMCHECK_SHADOW_COPY_SHIFT
> >  config KMEMCHECK_PARTIAL_OK
> >       bool "kmemcheck: allow partially uninitialized memory"
> >       depends on KMEMCHECK
> > -     default y
> > +     default y if !DEBUG_KMEMLEAK
> >       help
> >         This option works around certain GCC optimizations that produce
> >         32-bit reads from 16-bit variables where the upper 16 bits are
> >
> 
> Disabling KMEMCHECK_PARTIAL_OK can cause other false positives so maybe
> we should add a new function to kmemcheck for kmemleak that only reads
> full intervals?

There are two uses of kmemcheck_is_obj_initialized() in kmemleak: (1)
before reading a value to check for valid pointer (sizeof long) and (2)
before computing a CRC sum.

(1) is fine since it only does this for sizeof(long) before reading the
same size. (2) has an issues since kmemleak checks the size of an
allocated memory block while crc32 reads individual u32's.

Is there a way in kmemcheck to mark a false positive?

The alternative, assuming that CRC_LE_BITS is 8 (that's what it seems to
be defined to), the crc32 computation uses u32 values and something like
below should work, though slower (not yet tested):


diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 5b069e4..dfd39ba 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -948,6 +948,25 @@ EXPORT_SYMBOL(kmemleak_no_scan);
 /*
  * Update an object's checksum and return true if it was modified.
  */
+#ifdef CONFIG_KMEMCHECK_PARTIAL_OK
+static bool update_checksum(struct kmemleak_object *object)
+{
+	u32 crc = 0;
+	unsigned long ptr;
+
+	for (ptr = ALIGN(object->pointer, 4);
+	     ptr < ((object->pointer + object->size) & ~3); ptr += 4) {
+		if (!kmemcheck_is_obj_initialized(ptr, 4))
+			continue;
+		crc = crc32(crc, (void *)ptr, 4);
+	}
+
+	if (object->checksum == crc)
+		return false;
+	object->checksum = crc;
+	return true;
+}
+#else	/* !CONFIG_KMEMCHECK_PARTIAL_OK */
 static bool update_checksum(struct kmemleak_object *object)
 {
 	u32 old_csum = object->checksum;
@@ -958,6 +977,7 @@ static bool update_checksum(struct kmemleak_object *object)
 	object->checksum = crc32(0, (void *)object->pointer, object->size);
 	return object->checksum != old_csum;
 }
+#endif	/* CONFIG_KMEMCHECK_PARTIAL_OK */
 
 /*
  * Memory scanning is a long process and it needs to be interruptable. This


-- 
Catalin

