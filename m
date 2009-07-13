Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbZGMWBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbZGMWBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 18:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbZGMWBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 18:01:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51906 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756937AbZGMWBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 18:01:43 -0400
Date: Tue, 14 Jul 2009 00:01:37 +0200
From: Karel Zak <kzak@redhat.com>
To: Peter Breitenlohner <peb@mppmu.mpg.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.16-rc2 -- shlib versions
Message-ID: <20090713220137.GG6299@nb.net.home>
References: <20090702181031.GB4122@nb.net.home> <alpine.LNX.2.00.0907131900290.31109@pcl321.mppmu.mpg.de> <alpine.LNX.2.00.0907131913010.31109@pcl321.mppmu.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0907131913010.31109@pcl321.mppmu.mpg.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 07:22:51PM +0200, Peter Breitenlohner wrote:
> The choice of shared library versions from util-linux-ng-2.16-rc2:
> 	libblkid.so.1 -> libblkid.so.1.0.0
> 	libuuid.so.1 -> libuuid.so.1.0.0
> is somewhat unfortunate, because e2fsprogs-1.41.3 has:
> 	libblkid.so.1 -> libblkid.so.1.0
> 	libuuid.so.1 -> libuuid.so.1.2
> with the consequence that as long as the older e2fsprogs libraries are not
> removed, ldconfig will create a symlink to the older libuuid from e2fsprogs
> (I am not sure about the symlink for libblkid).
>
> This problem could safely be avoided if util-linux-ng were to choose at
> least libuuid.so.1.2.0 or maybe even better to be absolutely safe
> libblkid.so.1.1.0 and libuuid.so.1.3.0.

 Fixed. See the patch below.

    Karel


>From dc2b8d87c13c7d6aa4f9735ed9f21c02f241c2d4 Mon Sep 17 00:00:00 2001
From: Karel Zak <kzak@redhat.com>
Date: Mon, 13 Jul 2009 23:44:30 +0200
Subject: [PATCH] build-sys: fix libuuid and libblkid version-info

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 configure.ac                 |   14 ++++++++++++--
 shlibs/blkid/src/Makefile.am |    2 +-
 shlibs/uuid/src/Makefile.am  |    2 +-
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index f352f88..2e77520 100644
--- a/configure.ac
+++ b/configure.ac
@@ -20,9 +20,17 @@ PACKAGE_VERSION_RELEASE=0
 dnl libblkid version
 LIBBLKID_VERSION="$PACKAGE_VERSION_MAJOR.$PACKAGE_VERSION_MINOR.$PACKAGE_VERSION_RELEASE"
 LIBBLKID_DATE="10-Feb-2009"
+LIBBLKID_LT_MAJOR=1
+LIBBLKID_LT_MINOR=1
+LIBBLKID_LT_MICRO=0
+LIBBLKID_VERSION_INFO=`expr $LIBBLKID_LT_MAJOR + $LIBBLKID_LT_MINOR`:$LIBBLKID_LT_MICRO:$LIBBLKID_LT_MINOR
 
 dnl libuuid version
 LIBUUID_VERSION="$PACKAGE_VERSION_MAJOR.$PACKAGE_VERSION_MINOR.$PACKAGE_VERSION_RELEASE"
+LIBUUID_LT_MAJOR=1
+LIBUUID_LT_MINOR=3
+LIBUUID_LT_MICRO=0
+LIBUUID_VERSION_INFO=`expr $LIBUUID_LT_MAJOR + $LIBUUID_LT_MINOR`:$LIBUUID_LT_MICRO:$LIBUUID_LT_MINOR
 
 # Check whether exec_prefix=/usr:
 case $exec_prefix:$prefix in
@@ -259,7 +267,8 @@ AC_ARG_ENABLE([libuuid],
   AS_HELP_STRING([--disable-libuuid], [do not build libuuid and uuid utilities]),
   [], enable_libuuid=yes
 )
-AC_SUBST(LIBUUID_VERSION)
+AC_SUBST([LIBUUID_VERSION])
+AC_SUBST([LIBUUID_VERSION_INFO])
 AM_CONDITIONAL(BUILD_LIBUUID, test "x$enable_libuuid" = xyes)
 have_uuid=yes
 
@@ -311,7 +320,8 @@ AC_ARG_ENABLE([libblkid],
   AS_HELP_STRING([--disable-libblkid], [do not build libblkid and blkid utilities]),
   [], enable_libblkid=yes
 )
-AC_SUBST(LIBBLKID_VERSION)
+AC_SUBST([LIBBLKID_VERSION])
+AC_SUBST([LIBBLKID_VERSION_INFO])
 AM_CONDITIONAL(BUILD_LIBBLKID, test "x$enable_libblkid" = xyes)
 AC_DEFINE_UNQUOTED(LIBBLKID_VERSION, "$LIBBLKID_VERSION", [libblkid version string])
 AC_DEFINE_UNQUOTED(LIBBLKID_DATE, "$LIBBLKID_DATE", [libblkid date string])
diff --git a/shlibs/blkid/src/Makefile.am b/shlibs/blkid/src/Makefile.am
index d9970d2..bd040ce 100644
--- a/shlibs/blkid/src/Makefile.am
+++ b/shlibs/blkid/src/Makefile.am
@@ -36,7 +36,7 @@ libblkid_la_LIBADD = probers/libblkid_probers.la $(common_ldadd)
 libblkid_la_DEPENDENCIES = $(libblkid_la_LIBADD) blkid.sym
 
 libblkid_la_LDFLAGS = -Wl,--version-script=$(ul_libblkid_srcdir)/blkid.sym \
-                      -version-info 1:0:0
+                      -version-info $(LIBBLKID_VERSION_INFO)
 
 tests = test_cache test_config test_dev test_devname test_devno test_getsize \
 	test_read test_resolve test_save test_tag test_verify test_evaluate
diff --git a/shlibs/uuid/src/Makefile.am b/shlibs/uuid/src/Makefile.am
index 1272180..9af1979 100644
--- a/shlibs/uuid/src/Makefile.am
+++ b/shlibs/uuid/src/Makefile.am
@@ -17,7 +17,7 @@ libuuid_la_SOURCES = clear.c compare.c copy.c gen_uuid.c \
 libuuid_la_DEPENDENCIES = uuid.sym
 
 libuuid_la_LDFLAGS = -Wl,--version-script=$(ul_libuuid_srcdir)/uuid.sym \
-                     -version-info 1:0:0
+                     -version-info $(LIBUUID_VERSION_INFO)
 
 EXTRA_DIST = uuid.sym gen_uuid_nt.c
 
-- 
1.6.2.2

