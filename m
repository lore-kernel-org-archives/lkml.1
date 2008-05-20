Return-Path: <linux-kernel-owner+w=401wt.eu-S1764869AbYETX5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764869AbYETX5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 19:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbYETX5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 19:57:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:25882 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbYETX5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 19:57:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fqKcsDOq+tzKN+Ev1AnPvj9XLtm9lFH3ahlafV4rISTSu4W2ss7NMsMz5Et1k/s0B34gp0Ebvw03c3T0PL3pZsYPeMwTl+fbBF+SduRY4Ph5IgKKHGOyOA0FAGs5j68a3EsrLXQXGNonsBRV0DIP1BQoBkmmO/t1Int5eMNi9/U=
Message-ID: <7b9198260805201657m19e023a9kabb897acea0d57d4@mail.gmail.com>
Date: Wed, 21 May 2008 00:57:21 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Jeff Dike" <jdike@addtoit.com>
Subject: Re: UML fails to locate address space
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <7b9198260805201503j333963c4ya19b84f16b31d0fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com>
	 <7b9198260805200659p6ed28403t9b0b0ea995f158d5@mail.gmail.com>
	 <20080520161047.GA9598@c2.user-mode-linux.org>
	 <7b9198260805200943x6fb15512o7ba35a40d006b215@mail.gmail.com>
	 <20080520175624.GA10889@c2.user-mode-linux.org>
	 <7b9198260805201101x5b0fabf8h4944a29c6a4cae96@mail.gmail.com>
	 <20080520192436.GA12102@c2.user-mode-linux.org>
	 <7b9198260805201242p1adf4651kb4c434d73884b6c1@mail.gmail.com>
	 <20080520212735.GA13319@c2.user-mode-linux.org>
	 <7b9198260805201503j333963c4ya19b84f16b31d0fd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/20 Tom Spink <tspink@gmail.com>:
> 2008/5/20 Jeff Dike <jdike@addtoit.com>:
>> On Tue, May 20, 2008 at 08:42:54PM +0100, Tom Spink wrote:
>>> And this is what I did:
>>
>> Looks OK, but I need a Signed-off-by.
>>
>> Some style comments, which I can take care of if you don't feel like it:
>>        there's only one use of PROC_MMAP_MIN_ADDR, so you might as
>> well inline the filename
>>        the stat is unnecessary - open failing will tell you what you
>> need to know
>>        the strtoul needs some error checking
>>        I'd change the mmap_min_addr[8] to [sizeof("12345678")] to
>> make it clear what's expected to fit into it
>>
>> On a less-stylistic note, this thing does have to work in the absence
>> of /proc since UML is commonly run inside chroot.  So, I'm thinking we
>> still need the loop looking for the bottom of the address space in
>> this case.  And, if you have it, you might as well use it, as that's
>> less code, and it makes sure the loop is exercised.  That grieves me a
>> little, as I'd like to just read mmap_min_addr and be done with it in
>> the normal case.
>>
>>                        Jeff
>>
>> --
>> Work email - jdike at linux dot intel dot com
>>
>
> I was re-writing the patch, but after reading over the function, is
> the return value correct? I did a quick run through on paper about
> what would happen if the (real) bottom = 5 and the (real) top = 15,
> and the (initial) top = 20.  So this is a size of 10 pages, which is
> what the function should return... but:
>

Here's the new patch, with that size correction in.  Does this look okay?

---

From: Tom Spink <tspink@gmail.com>
Date: Wed, 21 May 2008 00:53:54 +0100
Subject: [PATCH] Read the minimum mmap address from proc

This patch makes os_get_task_size read the minimum mmap address from the proc
entry on the host system, if available.  If not, it resorts to manually
searching for the minimum mmap address by incrementally testing pages from
zero onwards.

Because the bottom of the address space may not be zero, it's not sufficient
to assume the top of the address space is the size of the address space.  The
size is the difference between the top address and bottom address.

Signed-off-by: Tom Spink <tspink@gmail.com>
---
 arch/um/os-Linux/sys-i386/task_size.c |   63 ++++++++++++++++++++++++++++-----
 1 files changed, 54 insertions(+), 9 deletions(-)

diff --git a/arch/um/os-Linux/sys-i386/task_size.c
b/arch/um/os-Linux/sys-i386/task_size.c
index ccb49b0..66811ae 100644
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
@@ -63,6 +65,28 @@ static int page_ok(unsigned long page)
 	return ok;
 }

+static unsigned long get_mmap_min_addr(void)
+{
+	unsigned long mmap_min_addr;
+	int fd;
+	char ma_buffer[sizeof("12345678")];
+
+	/* Open the proc entry for mmap_min_addr. */
+	fd = open("/proc/sys/vm/mmap_min_addr", O_RDONLY);
+	if (fd < 0)
+		return 0;
+
+	read(fd, ma_buffer, sizeof(ma_buffer));
+	close(fd);
+
+	/* Determine the reported minimum address. */
+	mmap_min_addr = strtoul(ma_buffer, NULL, 0);
+	if (mmap_min_addr < 0)
+		return 0;
+
+	return mmap_min_addr >> UM_KERN_PAGE_SHIFT;
+}
+
 unsigned long os_get_task_size(void)
 {
 	struct sigaction sa, old;
@@ -76,11 +100,16 @@ unsigned long os_get_task_size(void)
 	 * hosts, but shouldn't hurt otherwise.
 	 */
 	unsigned long top = 0xffffd000 >> UM_KERN_PAGE_SHIFT;
-	unsigned long test;
+	unsigned long test, original;

-	printf("Locating the top of the address space ... ");
+	printf("Locating the bottom of the address space ... ");
 	fflush(stdout);

+	/* Use our function to try and read the minimum mmap address
+	 * from proc.
+	 */
+	bottom = get_mmap_min_addr();
+
 	/*
 	 * We're going to be longjmping out of the signal handler, so
 	 * SA_DEFER needs to be set.
@@ -93,13 +122,30 @@ unsigned long os_get_task_size(void)
 		exit(1);
 	}

-	if (!page_ok(bottom)) {
-		fprintf(stderr, "Address 0x%x no good?\n",
-			bottom << UM_KERN_PAGE_SHIFT);
-		exit(1);
+	/* If the page from get_mmap_min_addr was okay, then continue. */
+	if (page_ok(bottom))
+		goto found_bottom;
+
+	/* This might happen if UML is running in a chroot, i.e. we
+	 * can't access proc.  So, let's just manually scan until we
+	 * get a valid page (or run out of them).
+	 */
+	for (bottom = 0; bottom < top; bottom++) {
+		if (page_ok(bottom))
+			goto found_bottom;
 	}

+	/* If we've got this far, we ran out of pages. */
+	fprintf(stderr, "Unable to determine bottom of address space.\n");
+	exit(1);
+
+found_bottom:
+	printf("0x%x\n", bottom << UM_KERN_PAGE_SHIFT);
+	printf("Locating the top of the address space ... ");
+	fflush(stdout);
+
 	/* This could happen with a 4G/4G split */
+	original = bottom;
 	if (page_ok(top))
 		goto out;

@@ -117,8 +163,7 @@ out:
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
