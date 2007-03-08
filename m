Return-Path: <linux-kernel-owner+w=401wt.eu-S1030671AbXCHVrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030671AbXCHVrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:47:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030680AbXCHVrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:47:01 -0500
Received: from ozlabs.org ([203.10.76.45]:60978 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030671AbXCHVrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:47:01 -0500
Date: Thu, 8 Mar 2007 15:46:12 -0600
From: Anton Blanchard <anton@samba.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>, David Brown <dmlb2000@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gdb@sourceware.org
Subject: Re: PAGE_SIZE Availability Inconsistency
Message-ID: <20070308214612.GB4154@kryten>
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com> <20070306092917.GA5226@infradead.org> <200703080318.04631.zippel@linux-m68k.org> <20070308090031.GB7373@infradead.org> <1173369229.3550.2.camel@laptopd505.fenrus.org> <20070308160852.GB9916@infradead.org> <45F0426C.8000009@zytor.com> <20070308175729.GA7054@kryten> <45F05040.4090602@zytor.com> <20070308214236.GA4154@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308214236.GA4154@kryten>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> Our current swap layout has issues with variable page size kernels.
> Instead of using the page size at runtime, base it on the minimum page
> size the architecture supports.

A hacked up patch to userspace utilities to test the kernel patch. BTW
It looks like there are some real bugs here:

            int pagesize = getpagesize();
            int rd;
            char buf[32768];

            rd = pagesize;
            if (rd < 8192)
                    rd = 8192;
            if (rd > sizeof(buf))
                    rd = sizeof(buf);
            if (lseek(fd, 0, SEEK_SET) != 0
                || read(fd, buf, rd) != rd)
                    goto io_error;
            if (may_be_swap(buf+pagesize) ||
                may_be_swap(buf+4096) || may_be_swap(buf+8192))
                    type = "swap";

If page size == 64kB wont we read past the end of buf?

Anton

Index: util-linux-2.12r/disk-utils/mkswap.c
===================================================================
--- util-linux-2.12r.orig/disk-utils/mkswap.c	2007-03-08 14:52:53.000000000 -0600
+++ util-linux-2.12r/disk-utils/mkswap.c	2007-03-08 14:58:09.000000000 -0600
@@ -169,7 +158,11 @@
 #ifdef PAGE_SIZE
 	defined_pagesize = PAGE_SIZE;
 #endif
+#ifdef __powerpc__
+	kernel_pagesize = 4096;
+#else
 	kernel_pagesize = getpagesize();
+#endif
 	pagesize = kernel_pagesize;
 
 	if (user_pagesize) {
Index: util-linux-2.12r/mount/get_label_uuid.c
===================================================================
--- util-linux-2.12r.orig/mount/get_label_uuid.c	2007-03-08 14:52:53.000000000 -0600
+++ util-linux-2.12r/mount/get_label_uuid.c	2007-03-08 14:58:09.000000000 -0600
@@ -79,7 +79,11 @@
 
 static int
 is_v1_swap_partition(int fd, char **label, char *uuid) {
+#ifdef __powerpc__
+	int n = 4096;
+#else
 	int n = getpagesize();
+#endif
 	char *buf = xmalloc(n);
 	struct swap_header_v1_2 *p = (struct swap_header_v1_2 *) buf;
 
Index: util-linux-2.12r/mount/mount_guess_fstype.c
===================================================================
--- util-linux-2.12r.orig/mount/mount_guess_fstype.c	2007-03-08 14:52:53.000000000 -0600
+++ util-linux-2.12r/mount/mount_guess_fstype.c	2007-03-08 14:54:25.000000000 -0600
@@ -462,7 +462,11 @@
     if (!type) {
 	    /* perhaps the user tries to mount the swap space
 	       on a new disk; warn her before she does mke2fs on it */
+#ifdef __powerpc__
+	    int pagesize = 4096;
+#else
 	    int pagesize = getpagesize();
+#endif
 	    int rd;
 	    char buf[32768];
 
Index: util-linux-2.12r/rescuept/rescuept.c
===================================================================
--- util-linux-2.12r.orig/rescuept/rescuept.c	2007-03-08 14:52:53.000000000 -0600
+++ util-linux-2.12r/rescuept/rescuept.c	2007-03-08 14:55:49.000000000 -0600
@@ -510,7 +510,11 @@
 		size = s.st_size / 512;
 	}
 
+#ifdef __powerpc__
+	pagesize = 4096;
+#else
 	pagesize = getpagesize();
+#endif
 	if (pagesize <= 0)
 		pagesize = 4096;
 	else if (pagesize > MAXPAGESZ) {
