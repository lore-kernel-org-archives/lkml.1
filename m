Return-Path: <linux-kernel-owner+w=401wt.eu-S1760964AbZFZS1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964AbZFZS1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 14:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZFZS1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 14:27:39 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:17107 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZFZS1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 14:27:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=Y2qgbyUY8xdxR0lBbNE/sWIGZVIxLCqXoCj6jix9hXpl/3sMj4XFKZWiOGobRPgyy5
         2Zrgnz39K+Q+oOEwQ3l/C4ojN6KMddEYuvf4ctGcdByvXAgwMxNS+vuJBbTjuj3eHOTh
         hAs5rFRdpTHG68at3HRfAMcMgiVIb2wLDaqS0=
MIME-Version: 1.0
Date: Fri, 26 Jun 2009 20:27:40 +0200
X-Google-Sender-Auth: 6b2e4258c6201e7b
Message-ID: <deb7a2310906261127v2fd1564elb823716ae03fc0d4@mail.gmail.com>
Subject: [patch 1/1] personality handling: fix PER_CLEAR_ON_SETID for security 
	reasons
From: Julien Tinnes <jt@cr0.org>
To: hch@infradead.org
Cc: security@kernel.org, taviso@sdf.lonestar.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We have found that the current PER_CLEAR_ON_SETID mask on Linux
doesn't include neither ADDR_COMPAT_LAYOUT, nor MMAP_PAGE_ZERO.

The current mask is READ_IMPLIES_EXEC|ADDR_NO_RANDOMIZE.

We believe it is important to add MMAP_PAGE_ZERO, because by using
this personality it is possible to have the first page mapped inside a
process running as setuid root. This could be used in those scenarios:

- Exploiting a NULL pointer dereference issue in a setuid root binary
- Bypassing the mmap_min_addr restrictions of the Linux kernel: by
running a setuid binary that would drop privileges before giving us
control back (for instance by loading a user-supplied library), we
could get the first page mapped in a process we control. By further
using mremap and mprotect on this mapping, we can then completely
bypass the mmap_min_addr restrictions.

Less importantly, we believe ADDR_COMPAT_LAYOUT should also be added
since on x86 32bits it will in practice disable most of the address
space layout randomization (only the stack will remain randomized).

Signed-off-by: Julien Tinnes <jt@cr0.org> and Tavis Ormandy
<taviso@sdf.lonestar.org>

---


diff -r f70f443c9ead include/linux/personality.h
--- a/include/linux/personality.h	Fri Jun 26 19:59:33 2009 +0200
+++ b/include/linux/personality.h	Fri Jun 26 20:00:40 2009 +0200
@@ -40,7 +40,7 @@ enum {
  * Security-relevant compatibility flags that must be
  * cleared upon setuid or setgid exec:
  */
-#define PER_CLEAR_ON_SETID (READ_IMPLIES_EXEC|ADDR_NO_RANDOMIZE)
+#define PER_CLEAR_ON_SETID
(READ_IMPLIES_EXEC|ADDR_NO_RANDOMIZE|ADDR_COMPAT_LAYOUT|MMAP_PAGE_ZERO)

 /*
  * Personality types.
