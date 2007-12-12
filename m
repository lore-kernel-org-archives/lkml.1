Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbXLLW7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbXLLW7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 17:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXLLW7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 17:59:09 -0500
Received: from hu-out-0506.google.com ([72.14.214.235]:22324 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXLLW7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 17:59:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Go2vruPJiBim9eBvn5yp/fdBhaqRASzEAtRznUYHFfZb/1pTzPJTHz27A5UxT/cWQQq0HWV523O/6ixeNP3ywNtAJgOInAyXDFc9cV6PmN1h4dbwwgqjYGWy2aHslD2IWL70FwW4o5d7qRyPU2EUad0UajIWhc5WG8Du9ABAEbc=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: Luciano Rocha <luciano@eurotux.com>
Subject: Re: ldminfo compilation
Date: Thu, 13 Dec 2007 00:59:09 +0200
User-Agent: KMail/1.9.7
Cc: ldm@flatcap.org, ntfs-3g-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ntfs-dev@lists.sourceforge.net
References: <9e0cf0bf0712120639r7bd5582bg63f8512164836989@mail.gmail.com> <20071212152953.GA26544@bit.office.eurotux.com> <20071212164059.GA30348@bit.office.eurotux.com>
In-Reply-To: <20071212164059.GA30348@bit.office.eurotux.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712130059.12026.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 December 2007, Luciano Rocha wrote:
> Anyway, how to compile with the sources of:

Thank you so much!!!!
I didn't think of using 2.4 headers... bad me!

Anyway, I can now hack this to compile with uclibc...
I don't know if it works yet, but at least it builds now (26KB)

I had to use newer kernel, as I had some gcc related errors in include/asm/processor.h
and CONFIG_SMP related conflicts.

I truly hope maintainer will find some time to make it regular 2.6.X user mode
application... There are many packages that use kernel headers, but are much
easier to build, without sharing one object between kernel and userspace.

Best Regards,
Alon Bar-Lev

So just for the record...

I am using the following script to build:

ldm=linux-ldm-0.0.8
kernel=linux-2.4.35.4
wget --continue http://downloads.sourceforge.net/linux-ntfs/$ldm.tar.bz2
wget --continue http://www.kernel.org/pub/linux/kernel/v2.4/$kernel.tar.bz2
tar xjf $ldm.tar.bz2
cd $ldm
patch -p1 < ../$ldm-build.diff
tar xjf ../$kernel.tar.bz2
yes n | make -C $kernel ARCH=i386 oldconfig dep
make clean
make KERNEL=$(pwd)/$kernel LDMINFO_LDFLAGS=-static
#make KERNEL=$(pwd)/$kernel LDMINFO_CC=i586-pc-linux-uclibc-gcc

And the following patch:

---

diff -urNp linux-ldm-0.0.8.org/Makefile linux-ldm-0.0.8/Makefile
--- linux-ldm-0.0.8.org/Makefile	2002-03-09 03:58:42.000000000 +0200
+++ linux-ldm-0.0.8/Makefile	2007-12-13 00:38:09.000000000 +0200
@@ -27,7 +27,14 @@ CFLAGS += -fomit-frame-pointer
 CFLAGS += -fno-strict-aliasing
 CFLAGS += -pipe
 CFLAGS += -mpreferred-stack-boundary=2
-CFLAGS += -march=$(shell uname -m)
+
+# libc fixups
+
+CFLAGS += -D__off_t_defined
+CFLAGS += -D__sigset_t_defined
+CFLAGS += -D_TIME_H
+CFLAGS += -D__defined_schedparam
+CFLAGS += -D__sched_param=sched_param
 
 # ld flags
 
diff -urNp linux-ldm-0.0.8.org/test/compat.c linux-ldm-0.0.8/test/compat.c
--- linux-ldm-0.0.8.org/test/compat.c	2002-08-05 18:46:51.000000000 +0300
+++ linux-ldm-0.0.8/test/compat.c	2007-12-13 00:38:09.000000000 +0200
@@ -171,7 +171,7 @@ unsigned char *read_dev_sector (struct b
 	return bh->b_data;
 }
 
-void __free_pages(struct page *page, unsigned int order)
+FASTCALL() void __free_pages(struct page *page, unsigned int order)
 {
 	atomic_dec (&page->count);
 	if (atomic_read (&page->count) < 1) {
diff -urNp linux-ldm-0.0.8.org/test/Makefile linux-ldm-0.0.8/test/Makefile
--- linux-ldm-0.0.8.org/test/Makefile	2002-02-23 18:38:51.000000000 +0200
+++ linux-ldm-0.0.8/test/Makefile	2007-12-13 00:39:58.000000000 +0200
@@ -8,6 +8,8 @@ INFODEP	= $(LDMDEP) compat.o copy.o dump
 
 OUT	= ldminfo sparse
 
+LDMINFO_CC = $(CC)
+
 CFLAGS += -include extra.h
 CFLAGS += -I$(KERNEL)/include
 CFLAGS += -I$(KERNEL)/fs/partitions
@@ -15,13 +17,13 @@ CFLAGS += -I$(KERNEL)/fs/partitions
 all:	$(OUT)
 
 .c.o:
-	$(CC) $(CFLAGS) -c $< -o $@
+	$(LDMINFO_CC) $(CFLAGS) -c $< -o $@
 
 ldminfo: $(INFODEP)
-	$(CC) -o ldminfo $(INFODEP)
+	$(LDMINFO_CC) $(LDMINFO_LDFLAGS) -o ldminfo $(INFODEP)
 
 sparse:
-	$(CC) -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 sparse.c -o $@
+	$(LDMINFO_CC) -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 sparse.c -o $@
 
 clean:
 	$(RM) $(OUT) $(OBJ)
