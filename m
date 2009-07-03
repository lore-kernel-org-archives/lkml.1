Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbZGCJh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbZGCJh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756396AbZGCJhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:37:34 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34248 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbZGCJha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:37:30 -0400
Subject: Re: [ANNOUNCE] util-linux-ng v2.16-rc2
From: Kay Sievers <kay.sievers@vrfy.org>
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
In-Reply-To: <ac3eb2510907021332l2d0c1908s19d01c994f42b549@mail.gmail.com>
References: <20090702181031.GB4122@nb.net.home>
	 <ac3eb2510907021332l2d0c1908s19d01c994f42b549@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 11:29:41 +0200
Message-Id: <1246613381.1923.9.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 22:32 +0200, Kay Sievers wrote:
> On Thu, Jul 2, 2009 at 20:10, Karel Zak<kzak@redhat.com> wrote:
> >
> > The second util-linux-ng 2.16 release candidate is available at
> >
> >   ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.16/
> >
> > Feedback and bug reports, as always, are welcomed.
> 
> It builds fine on the host, but fails to build in a clean chroot:
> 
> The hack with moving the devel files around to /usr with an install
> hook breaks the values stored in the libblkid.la file and relinking
> fails, because the lib devel files are now no longer in /lib but
> (silently) moved to /usr/lib:
> 
> libtool: relink: gcc -std=gnu99 -shared  .libs/cache.o .libs/dev.o
> .libs/devname.o .libs/devno.o .libs/getsize.o .libs/llseek.o
> .libs/probe.o .libs/read.o .libs/resolve.o .libs/save.o .libs/tag.o
> .libs/version.o .libs/verify.o .libs/encode.o .libs/config.o
> .libs/evaluate.o .libs/blkdev.o .libs/linux_version.o
> .libs/canonicalize.o .libs/md5.o  -Wl,--whole-archive
> probers/.libs/libblkid_probers.a -Wl,--no-whole-archive
> -L/var/tmp/util-linux-2.16-build/lib64 -L/lib64 -luuid
> -Wl,--version-script=../../../shlibs/blkid/src/blkid.sym   -Wl,-soname
> -Wl,libblkid.so.1 -o .libs/libblkid.so.1.0.0
> /usr/lib64/gcc/x86_64-suse-linux/4.4/../../../../x86_64-suse-linux/bin/ld:
> cannot find -luuid
> collect2: ld returned 1 exit status
> 
> That the .so is installed in the root is really the implementation
> detail that should be hidden from anything but the ld loader on the
> system. I guess, we want to keep the original --libdir value, and use
> a --rootlibdir as it's own parameter, or something similar, and just
> move the .so image to the root with the install hook (or the spec
> file), instead of moving the devel stuff, faking the .pc files and
> patching the .la files. :)

This seems to make it work in the chroot.

It turns around the logic, and installs the libs in /usr, and moves
the .so to /, so the devel links and the .la files are not changed.

Thanks,
Kay


diff --git a/shlibs/blkid/src/Makefile.am b/shlibs/blkid/src/Makefile.am
index 8b1f46b..b585f0a 100644
--- a/shlibs/blkid/src/Makefile.am
+++ b/shlibs/blkid/src/Makefile.am
@@ -21,7 +21,7 @@ AM_CPPFLAGS += -I$(ul_libblkid_srcdir) $(common_cflags)
 blkidincdir = $(includedir)/blkid
 blkidinc_HEADERS = blkid.h
 
-lib_LTLIBRARIES = libblkid.la
+usrlibexec_LTLIBRARIES = libblkid.la
 libblkid_la_SOURCES = cache.c dev.c devname.c devno.c getsize.c llseek.c  \
 		     probe.c read.c resolve.c save.c tag.c version.c verify.c \
 		     encode.c blkid.h list.h blkidP.h probers/probers.h \
@@ -49,17 +49,15 @@ test_%: %.c
 	$(COMPILE) -DTEST_PROGRAM $< .libs/libblkid.a -o $@ $(common_ldadd)
 
 
-# move devel files from $(libdir) to $(usrlibexecdir) if needed
+# move lib from $(usrlibexecdir) to $(libdir) if needed
 install-data-hook:
-	rm  $(DESTDIR)$(libdir)/$(lib_LTLIBRARIES)
 	if test "$(usrlibexecdir)" != "$(libdir)"; then \
-		mkdir -p $(DESTDIR)$(usrlibexecdir); \
+		mkdir -p $(DESTDIR)$(libdir); \
 		mv $(DESTDIR)$(libdir)/libblkid.a $(DESTDIR)$(usrlibexecdir)/; \
-		so_img_name=$$(readlink $(DESTDIR)$(libdir)/libblkid.so); \
-		rm $(DESTDIR)$(libdir)/libblkid.so; \
+		so_img_name=$$(readlink $(DESTDIR)$(usrlibexecdir)/libblkid.so); \
 		so_img_rel_target=$$(echo $(usrlibexecdir) | sed 's,\(^/\|\)[^/][^/]*,..,g'); \
-		ln -sf  $$so_img_rel_target$(libdir)/$$so_img_name \
-			$(DESTDIR)$(usrlibexecdir)/libblkid.so; \
+		ln -sf  $$so_img_rel_target$(libdir)/$$so_img_name $(DESTDIR)$(usrlibexecdir)/libblkid.so; \
+		mv $(DESTDIR)$(usrlibexecdir)/libblkid.so.* $(DESTDIR)$(libdir); \
 	fi
 
 uninstall-hook:
diff --git a/shlibs/uuid/src/Makefile.am b/shlibs/uuid/src/Makefile.am
index fff1152..cdd51db 100644
--- a/shlibs/uuid/src/Makefile.am
+++ b/shlibs/uuid/src/Makefile.am
@@ -10,7 +10,7 @@ tst_uuid_CFLAGS = -I$(ul_libuuid_srcdir)
 uuidincdir = $(includedir)/uuid
 uuidinc_HEADERS = uuid.h
 
-lib_LTLIBRARIES = libuuid.la
+usrlibexec_LTLIBRARIES = libuuid.la
 libuuid_la_SOURCES = clear.c compare.c copy.c gen_uuid.c \
            isnull.c pack.c parse.c unpack.c unparse.c uuidd.h \
            uuidd.h uuidP.h uuid_time.c $(uuidinc_HEADERS)
@@ -30,17 +30,15 @@ test_%: %.c
 	$(COMPILE) -DTEST_PROGRAM $< .libs/libuuid.a -o $@
 
 
-# move devel files from $(libdir) to $(usrlibexecdir) if needed
+# move lib from $(usrlibexecdir) to $(libdir) if needed
 install-data-hook:
-	rm  $(DESTDIR)$(libdir)/$(lib_LTLIBRARIES)
 	if test "$(usrlibexecdir)" != "$(libdir)"; then \
-		mkdir -p $(DESTDIR)$(usrlibexecdir); \
+		mkdir -p $(DESTDIR)$(libdir); \
 		mv $(DESTDIR)$(libdir)/libuuid.a $(DESTDIR)$(usrlibexecdir)/; \
-		so_img_name=$$(readlink $(DESTDIR)$(libdir)/libuuid.so); \
-		rm $(DESTDIR)$(libdir)/libuuid.so; \
+		so_img_name=$$(readlink $(DESTDIR)$(usrlibexecdir)/libuuid.so); \
 		so_img_rel_target=$$(echo $(usrlibexecdir) | sed 's,\(^/\|\)[^/][^/]*,..,g'); \
-		ln -sf  $$so_img_rel_target$(libdir)/$$so_img_name \
-			$(DESTDIR)$(usrlibexecdir)/libuuid.so; \
+		ln -sf  $$so_img_rel_target$(libdir)/$$so_img_name $(DESTDIR)$(usrlibexecdir)/libuuid.so; \
+		mv $(DESTDIR)$(usrlibexecdir)/libuuid.so.* $(DESTDIR)$(libdir); \
 	fi
 
 uninstall-hook:


