Return-Path: <linux-kernel-owner+w=401wt.eu-S932294AbZHMUHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbZHMUHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbZHMUHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:07:36 -0400
Received: from kroah.org ([198.145.64.141]:41819 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197AbZHMT7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:45 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:30 2009
Message-Id: <20090813195130.514363745@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 40/74] x86: fix assembly constraints in native_save_fl()
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=x86-fix-assembly-constraints-in-native_save_fl.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: H. Peter Anvin <hpa@zytor.com>

commit f1f029c7bfbf4ee1918b90a431ab823bed812504 upstream.

>From Gabe Black in bugzilla 13888:

native_save_fl is implemented as follows:

  11static inline unsigned long native_save_fl(void)
  12{
  13        unsigned long flags;
  14
  15        asm volatile("# __raw_save_flags\n\t"
  16                     "pushf ; pop %0"
  17                     : "=g" (flags)
  18                     : /* no input */
  19                     : "memory");
  20
  21        return flags;
  22}

If gcc chooses to put flags on the stack, for instance because this is
inlined into a larger function with more register pressure, the offset
of the flags variable from the stack pointer will change when the
pushf is performed. gcc doesn't attempt to understand that fact, and
address used for pop will still be the same. It will write to
somewhere near flags on the stack but not actually into it and
overwrite some other value.

I saw this happen in the ide_device_add_all function when running in a
simulator I work on. I'm assuming that some quirk of how the simulated
hardware is set up caused the code path this is on to be executed when
it normally wouldn't.

A simple fix might be to change "=g" to "=r".

Reported-by: Gabe Black <spamforgabe@umich.edu>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -12,9 +12,15 @@ static inline unsigned long native_save_fl(void)
 {
 	unsigned long flags;
 
+	/*
+	 * Note: this needs to be "=r" not "=rm", because we have the
+	 * stack offset from what gcc expects at the time the "pop" is
+	 * executed, and so a memory reference with respect to the stack
+	 * would end up using the wrong address.
+	 */
 	asm volatile("# __raw_save_flags\n\t"
 		     "pushf ; pop %0"
-		     : "=g" (flags)
+		     : "=r" (flags)
 		     : /* no input */
 		     : "memory");
 


