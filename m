Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbZIUOhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbZIUOhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbZIUOhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:37:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52929 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbZIUOhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:37:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] warn about use of uninstalled kernel headers
Date: Mon, 21 Sep 2009 16:37:12 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-10-generic; KDE/4.3.1; x86_64; ; )
Cc: "Am?rico Wang" <xiyou.wangcong@gmail.com>, Caveh Jalali <ecaveh@gmail.com>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
References: <830a8fa70909161930r518a9644ja954ced2ae5814b4@mail.gmail.com> <2375c9f90909171849n429bc474heabdc4d4fd064226@mail.gmail.com> <20090918045259.GA23333@merkur.ravnborg.org>
In-Reply-To: <20090918045259.GA23333@merkur.ravnborg.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909211637.12983.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18kVk6DbbqYD1yXDVetqzeC1P8npy9OoHNEu0q
 tEjT7/tCFhopBklb437jfjWTJw+ZvSj44lTf37weNhzBxwKCQG
 lWOcU9tKcEUH9ZvyvxzAQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 September 2009, Sam Ravnborg wrote:
> > > I think we should no longer have the include2 directory at all with new kernels.
> > >
> > > LINUXINCLUDE already contains the right path in theory:
> > >
> > > LINUXINCLUDE    := -Iinclude \
> > >                   $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
> > >                   -I$(srctree)/arch/$(hdr-arch)/include               \
> > >                   -include include/linux/autoconf.h
> > 
> > Hmm, at least in mmotm, we still have include2...
> > 
> > Maybe Sam is queueing the patches to remove include2?
> I have them queued - yes.
> But as they never hit -next they will wait another cycle.

Variations of this are starting to turn into a FAQ. How about
printing a useful warning when someone tries to use the kernel
headers without installing them first?

	Arnd <><
---
User applications frequently hit problems when they try to use
the kernel headers directly, rather than the exported headers.

This adds an explicit warning for this case, and points to
a URL holding an explanation of why this is wrong and what
to do about it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/kernel.h     |    6 ++++++
 scripts/headers_install.pl |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d6320a3..f392d72 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -656,6 +656,12 @@ extern int do_sysinfo(struct sysinfo *info);
 
 #endif /* __KERNEL__ */
 
+#ifndef __EXPORTED_HEADERS__
+#ifndef __KERNEL__
+#warning Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders
+#endif /* __KERNEL__ */
+#endif /* __EXPORTED_HEADERS__ */
+
 #define SI_LOAD_SHIFT	16
 struct sysinfo {
 	long uptime;			/* Seconds since boot */
diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
index c6ae405..b89ca2c 100644
--- a/scripts/headers_install.pl
+++ b/scripts/headers_install.pl
@@ -20,7 +20,7 @@ use strict;
 
 my ($readdir, $installdir, $arch, @files) = @ARGV;
 
-my $unifdef = "scripts/unifdef -U__KERNEL__";
+my $unifdef = "scripts/unifdef -U__KERNEL__ -D__EXPORTED_HEADERS__";
 
 foreach my $file (@files) {
 	local *INFILE;
