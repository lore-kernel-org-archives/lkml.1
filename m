Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbZDUB1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbZDUB1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZDUB1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:27:02 -0400
Received: from smtp-out.google.com ([216.239.33.17]:44322 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbZDUB1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:27:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=LGRfxA6iljE8kAEb/f6Y4AeVPbTWJC1KGFCeejIw8hyb1sTwYUW9nxxjjwxIskoQV
	eMYxLxeP/l6JXN2mBzLog==
MIME-Version: 1.0
Date: Mon, 20 Apr 2009 18:26:53 -0700
Message-ID: <88cc3e770904201826odfde9baodcf8c221a0296909@mail.gmail.com>
Subject: question regarding the -stable patch queue ?
From: Abhijit Karmarkar <awk@google.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

i am trying to find if a particular upstream commit [1] will appear in
the next -stable release of 2.6.28 kernel.

i see this commit being marked as "-stable candidate". does that mean
it will automatically make it to the next stable release? or should i
submit a patch against the latest 2.6.28 stable series, to have this
patch queued up for next stable release (2.6.28.10). can someone
please advice?

what is the recommend way to do this search ("will upstream patch X be
included in the next stable release")? so i don't bug this list in
future with similar queries.

finally, talking of this particular commit, we have quite a few
machines with such BIOSes and it will be really nice to have this
included in the next stable (2.6.28.10) release. Without this patch,
machines panic in early boot.

thanks!
abhijit


[1] the commit i am specifically interested in is:
===
[upstream commit: 01522df346f846906eaf6ca57148641476209909]

x86, setup: mark %esi as clobbered in E820 BIOS call

Jordan Hargrave diagnosed a BIOS clobbering %esi in the E820 call.
That particular BIOS has been fixed, but there is a possibility that
this is responsible for other occasional reports of early boot
failure, and it does not hurt to add %esi to the clobbers.

-stable candidate patch.

Cc: Justin Forbes <jmforbes@linuxtx.org>
Signed-off-by: Michael K Johnson <johnsonm@rpath.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: stable@kernel.org
---

diff --git a/arch/x86/boot/memory.c b/arch/x86/boot/memory.c
index 8c3c25f..a99dbbe 100644
--- a/arch/x86/boot/memory.c
+++ b/arch/x86/boot/memory.c
@@ -27,13 +27,14 @@ static int detect_memory_e820(void)
 	do {
 		size = sizeof(struct e820entry);

-		/* Important: %edx is clobbered by some BIOSes,
-		   so it must be either used for the error output
+		/* Important: %edx and %esi are clobbered by some BIOSes,
+		   so they must be either used for the error output
 		   or explicitly marked clobbered. */
 		asm("int $0x15; setc %0"
 		    : "=d" (err), "+b" (next), "=a" (id), "+c" (size),
 		      "=m" (*desc)
-		    : "D" (desc), "d" (SMAP), "a" (0xe820));
+		    : "D" (desc), "d" (SMAP), "a" (0xe820)
+		    : "esi");

 		/* BIOSes which terminate the chain with CF = 1 as opposed
 		   to %ebx = 0 don't always report the SMAP signature on
