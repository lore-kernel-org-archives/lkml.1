Return-Path: <linux-kernel-owner+w=401wt.eu-S934106AbYEUMCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106AbYEUMCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 08:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760339AbYEUMC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 08:02:28 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:43198 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYEUMC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 08:02:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HW5Y+fTxZWXBf+Q4ssR/nXCAP+f/5dC2MCby5+5bVFUhfbxiw2zNoFf6PsjFcHN8QsbHclcJfAAluxFl1CIyK1PQzHgOGqS7hzSREubyTgfhqqrfPJRtCalByVL7B71+E9AclJElowAWKmT2wT/4cV6YW3uTchRq00Yo+uZ4LIs=
Message-ID: <7b9198260805210502i316c9e38lcc9b5561045dd5d@mail.gmail.com>
Date: Wed, 21 May 2008 13:02:24 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Jeff Dike" <jdike@addtoit.com>
Subject: Re: UML fails to locate address space
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080521021502.GB16212@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com>
	 <20080520135238.GB6990@c2.user-mode-linux.org>
	 <Pine.LNX.4.61.0805201117540.12360@chaos.analogic.com>
	 <20080520173503.GA10811@c2.user-mode-linux.org>
	 <Pine.LNX.4.61.0805201751500.13532@chaos.analogic.com>
	 <20080521021502.GB16212@c2.user-mode-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/21 Jeff Dike <jdike@addtoit.com>:
> On Tue, May 20, 2008 at 05:54:34PM -0400, linux-os (Dick Johnson) wrote:
>> Okay, then instead of putting a NULL in the "hint" to mmap() try
>> something else (0x1000?). That may help.
>
> You don't seem to have followed the thread.  For UML, the address
> isn't a hint - it's a requirement.  Tossing random numbers into your
> code until a particular test works isn't really the way to go.  In
> this case, we are looking at mmap_min_addr being set at 0x10000, but
> which may be set to 0x20000 someplace else.
>
>                    Jeff
>

Hi Jeff,

Here is the revised version - I cheered Dijkstra up by getting rid of that goto.

-- Tom

--

From: Tom Spink <tspink@gmail.com>
Date: Wed, 21 May 2008 00:53:54 +0100
Subject: [PATCH] Locate the bottom of the address space

This patch makes os_get_task_size locate the bottom of the address space,
as well as the top.  This is for systems which put a lower limit on mmap
addresses.  It works by manually scanning pages from zero onwards until a
valid page is found.

Because the bottom of the address space may not be zero, it's not sufficient
to assume the top of the address space is the size of the address space.  The
size is the difference between the top address and bottom address.

Signed-off-by: Tom Spink <tspink@gmail.com>
---
 arch/um/os-Linux/sys-i386/task_size.c |   30 ++++++++++++++++++++++--------
 1 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/arch/um/os-Linux/sys-i386/task_size.c
b/arch/um/os-Linux/sys-i386/task_size.c
index ccb49b0..d1e3604 100644
--- a/arch/um/os-Linux/sys-i386/task_size.c
+++ b/arch/um/os-Linux/sys-i386/task_size.c
@@ -1,6 +1,8 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <signal.h>
+#include <fcntl.h>
+#include <unistd.h>
 #include <sys/mman.h>
 #include "longjmp.h"
 #include "kern_constants.h"
@@ -76,9 +78,9 @@ unsigned long os_get_task_size(void)
 	 * hosts, but shouldn't hurt otherwise.
 	 */
 	unsigned long top = 0xffffd000 >> UM_KERN_PAGE_SHIFT;
-	unsigned long test;
+	unsigned long test, original;

-	printf("Locating the top of the address space ... ");
+	printf("Locating the bottom of the address space ... ");
 	fflush(stdout);

 	/*
@@ -93,13 +95,26 @@ unsigned long os_get_task_size(void)
 		exit(1);
 	}

-	if (!page_ok(bottom)) {
-		fprintf(stderr, "Address 0x%x no good?\n",
-			bottom << UM_KERN_PAGE_SHIFT);
+	/* Manually scan the address space, bottom-up, until we find
+	 * the first valid page (or run out of them).
+	 */
+	for (bottom = 0; bottom < top; bottom++) {
+		if (page_ok(bottom))
+			break;
+	}
+
+	/* If we've got this far, we ran out of pages. */
+	if (bottom == top) {
+		fprintf(stderr, "Unable to determine bottom of address space.\n");
 		exit(1);
 	}
+	
+	printf("0x%x\n", bottom << UM_KERN_PAGE_SHIFT);
+	printf("Locating the top of the address space ... ");
+	fflush(stdout);

 	/* This could happen with a 4G/4G split */
+	original = bottom;
 	if (page_ok(top))
 		goto out;

@@ -117,8 +132,7 @@ out:
 		perror("os_get_task_size");
 		exit(1);
 	}
-	top <<= UM_KERN_PAGE_SHIFT;
-	printf("0x%x\n", top);
+	printf("0x%x\n", top << UM_KERN_PAGE_SHIFT);

-	return top;
+	return (top - original) << UM_KERN_PAGE_SHIFT;
 }
-- 
1.5.4.3
