Return-Path: <linux-kernel-owner+w=401wt.eu-S1761565AbZD3BtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565AbZD3BtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 21:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761455AbZD3Bsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 21:48:47 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:40422 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761526AbZD3Bsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 21:48:45 -0400
Subject: Re: usbutils 0.81 release
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: Valdis.Kletnieks@vt.edu, Mike Frysinger <vapier.adi@gmail.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090429215623.GA27319@kroah.com>
References: <20090427193532.GA2948@kroah.com>
	 <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com>
	 <20090429180735.GA29812@kroah.com>
	 <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com>
	 <ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com>
	 <20090429192309.GA15539@kroah.com>
	 <44275.1241041373@turing-police.cc.vt.edu>
	 <20090429215623.GA27319@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Apr 2009 03:48:41 +0200
Message-Id: <1241056121.18530.31.camel@poy>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 14:56 -0700, Greg KH wrote:

> If youreally want it, you can grab it from the git tree, or wait a day
> or so for me to implement Mike's changes he so nicely sent me, so I can
> do a new release.

How about this? It substitutes the script and the man page with the
given --datadir=.

Git is here:
  git://git.kernel.org/pub/scm/linux/kernel/git/kay/usbutils.git

It installs the update script, which will overwrite the original
location, so we don't need to put several files on the system, and avoid
confusing other packages who look for them.

The right fix for the users of the ids file would probably be to drop a
usbutils pkg-config file which can point users to the location of the
database, so other packages could use that value without starting to
search for the file.

We already need do this silly search in the udev-extras build, and there
seems not two known distros, who share the same location of that
file. :(

Thanks,
Kay


diff --git a/.gitignore b/.gitignore
index fc743f1..cc378da 100644
--- a/.gitignore
+++ b/.gitignore
@@ -15,4 +15,5 @@ depcomp
 install-sh
 missing
 lsusb
-
+lsusb.8
+update-usbids.sh
diff --git a/Makefile.am b/Makefile.am
index 7c20acb..a88c3b4 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -10,6 +10,9 @@ endif
 sbin_PROGRAMS = \
 	lsusb
 
+sbin_SCRIPTS = \
+	update-usbids.sh
+
 lsusb_SOURCES = \
 	lsusb.c \
 	lsusb-t.c \
@@ -25,17 +28,28 @@ lsusb_CPPFLAGS = \
 lsusb_LDADD = \
 	$(LIBUSB_LIBS)
 
-dist_man_MANS = \
+man_MANS = \
 	lsusb.8
 
 EXTRA_DIST = \
-	usb.ids
+	usb.ids \
+	update-usbids.sh.in \
+	lsusb.8.in
+
+update-usbids.sh: update-usbids.sh.in
+	sed 's|@usbids@|$(datadir)/usb.ids|' $< >$@
+	chmod 755 $@
+
+lsusb.8: lsusb.8.in
+	sed 's|@usbids@|$(datadir)/usb.ids|' $< >$@
 
 usb.ids.gz: usb.ids
 	gzip -c -9 usb.ids > usb.ids.gz
 
 clean-local:
 	rm -f usb.ids.gz
+	rm -f lsusb.8
+	rm -f update-usbids.sh
 
 distclean-local:
 	rm -rf autom4te.cache
diff --git a/configure.ac b/configure.ac
index 9bf677c..8b6bd2f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -39,6 +39,7 @@ echo "
 	=============
 
 	prefix:                 ${prefix}
+	datadir:                ${datadir}
 	datarootdir:            ${datarootdir}
 	mandir:                 ${mandir}
 
diff --git a/lsusb.8 b/lsusb.8.in
similarity index 98%
rename from lsusb.8
rename to lsusb.8.in
index 14e662c..1922b0a 100644
--- a/lsusb.8
+++ b/lsusb.8.in
@@ -55,7 +55,7 @@ If the specified device is not found, a non-zero exit code is returned.
 
 .SH FILES
 .TP
-.B /usr/share/usb.ids
+.B @usbids@
 A list of all known USB ID's (vendors, products, classes, subclasses and protocols).
 
 .SH SEE ALSO
diff --git a/update-usbids.sh b/update-usbids.sh.in
similarity index 98%
rename from update-usbids.sh
rename to update-usbids.sh.in
index 3072f03..4a487ed 100755
--- a/update-usbids.sh
+++ b/update-usbids.sh.in
@@ -6,7 +6,7 @@
 
 set -e
 SRC="http://www.linux-usb.org/usb.ids"
-DEST=usb.ids
+DEST=@usbids@
 
 # if usb.ids is read-only (because the filesystem is read-only),
 # then just skip this whole process.

