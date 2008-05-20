Return-Path: <linux-kernel-owner+w=401wt.eu-S1765329AbYETTnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765329AbYETTnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759844AbYETTm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:42:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:34860 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759537AbYETTmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:42:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lzAb+7n7p3hcljGJSVhjBTNtel7FjpRJIPHOYWPfpQg19jVIUGCki+W4u25IGkF4CNXBpoHI2pZjjDYU6sVH358UutyIq1aEjLp1ArOkHEgJaQBtxdAi4i332hvmOmwajRN9nI0tOIaaibmz0NsDNf646zpStcN/aONuy91KhSA=
Message-ID: <7b9198260805201242p1adf4651kb4c434d73884b6c1@mail.gmail.com>
Date: Tue, 20 May 2008 20:42:54 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Jeff Dike" <jdike@addtoit.com>
Subject: Re: UML fails to locate address space
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080520192436.GA12102@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com>
	 <20080520135238.GB6990@c2.user-mode-linux.org>
	 <7b9198260805200659p6ed28403t9b0b0ea995f158d5@mail.gmail.com>
	 <20080520161047.GA9598@c2.user-mode-linux.org>
	 <7b9198260805200943x6fb15512o7ba35a40d006b215@mail.gmail.com>
	 <20080520175624.GA10889@c2.user-mode-linux.org>
	 <7b9198260805201101x5b0fabf8h4944a29c6a4cae96@mail.gmail.com>
	 <20080520192436.GA12102@c2.user-mode-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/20 Jeff Dike <jdike@addtoit.com>:
> On Tue, May 20, 2008 at 07:01:02PM +0100, Tom Spink wrote:
>> I'm a hardy.  I bet it's 893f802872c3.
>>
>> http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-hardy.git;a=commitdiff;h=893f802872c3e3c6e4bb40c3be4845784b81b934
>
> Looks right, and mmap_min_addr is in mainline, just with a value of
> zero.  So, it looks like the right thing to do is read the value of
> /proc/sys/vm/mmap_min_addr and start bottom there.
>
>                        Jeff
>
> --
> Work email - jdike at linux dot intel dot com
>

Wuhoo.

tom@holly:~$ cat /proc/sys/vm/mmap_min_addr
65536

And this is what I did:

diff --git a/arch/um/os-Linux/sys-i386/task_size.c
b/arch/um/os-Linux/sys-i386/task_size.c
index ccb49b0..f5ece4b 100644
--- a/arch/um/os-Linux/sys-i386/task_size.c
+++ b/arch/um/os-Linux/sys-i386/task_size.c
@@ -1,10 +1,14 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <signal.h>
+#include <fcntl.h>
+#include <unistd.h>
 #include <sys/mman.h>
 #include "longjmp.h"
 #include "kern_constants.h"

+#define PROC_MMAP_MIN_ADDR "/proc/sys/vm/mmap_min_addr"
+
 static jmp_buf buf;

 static void segfault(int sig)
@@ -63,10 +67,34 @@ static int page_ok(unsigned long page)
 	return ok;
 }

+static unsigned long get_mmap_min_addr(void)
+{
+	unsigned long ret = 0;
+	char mmap_min_addr[8];
+	int fd;
+	struct stat s;
+	
+	/* Determine the minimum mmap address. */
+	if (stat(PROC_MMAP_MIN_ADDR, &s) == 0) {
+		/* Open the proc file, and read in the value. */
+		fd = open(PROC_MMAP_MIN_ADDR, O_RDONLY);
+		if (fd < 0)
+			return ret;
+			
+		read(fd, mmap_min_addr, sizeof(mmap_min_addr));
+		close(fd);
+
+		/* Determine the address. */
+		ret = strtoul(mmap_min_addr, NULL, 0) >> UM_KERN_PAGE_SHIFT;
+	}
+
+	return ret;
+}
+
 unsigned long os_get_task_size(void)
 {
 	struct sigaction sa, old;
-	unsigned long bottom = 0;
+	unsigned long bottom;
 	/*
 	 * A 32-bit UML on a 64-bit host gets confused about the VDSO at
 	 * 0xffffe000.  It is mapped, is readable, can be reprotected writeable
@@ -78,6 +106,10 @@ unsigned long os_get_task_size(void)
 	unsigned long top = 0xffffd000 >> UM_KERN_PAGE_SHIFT;
 	unsigned long test;

+	printf("Determining the bottom of the address space ... ");
+	bottom = get_mmap_min_addr();
+	printf("0x%x\n", bottom);
+
 	printf("Locating the top of the address space ... ");
 	fflush(stdout);
