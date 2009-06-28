Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbZF1REv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbZF1REv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 13:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756448AbZF1RD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 13:03:29 -0400
Received: from storm.alittletooquiet.net ([67.23.28.199]:60073 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbZF1RDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 13:03:25 -0400
Date: Sun, 28 Jun 2009 13:03:28 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg KH <greg@kroah.com>, Larry Finger <Larry.Finger@lwfinger.net>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Woody Suwalski <woodys@xandros.com>,
       =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/8] Integrate drivers/staging/vt6656 into build system.
Message-ID: <20090628170328.GK9143@alittletooquiet.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b3OyYALfe3DXUU4J"
Content-Disposition: inline
In-Reply-To: <200906281759.46152.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b3OyYALfe3DXUU4J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Greg: This patch series does not differ from that which you already have.]

Integrate drivers/staging/vt6656 into build system.

Signed-off-by: Forest Bond <forest@alittletooquiet.net>
---
 drivers/staging/Kconfig         |    2 +
 drivers/staging/Makefile        |    1 +
 drivers/staging/vt6656/Kconfig  |    5 +
 drivers/staging/vt6656/Makefile |  243 ++++++-----------------------------=
---
 4 files changed, 47 insertions(+), 204 deletions(-)
 create mode 100644 drivers/staging/vt6656/Kconfig

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index cefb74f..53fafc0 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -127,5 +127,7 @@ source "drivers/staging/udlfb/Kconfig"
=20
 source "drivers/staging/octeon/Kconfig"
=20
+source "drivers/staging/vt6656/Kconfig"
+
 endif # !STAGING_EXCLUDE_BUILD
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index d110f6f..a1ce926 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -46,3 +46,4 @@ obj-$(CONFIG_USB_CPC)		+=3D cpc-usb/
 obj-$(CONFIG_RDC_17F3101X)	+=3D pata_rdc/
 obj-$(CONFIG_FB_UDL)		+=3D udlfb/
 obj-$(CONFIG_OCTEON_ETHERNET)	+=3D octeon/
+obj-$(CONFIG_VT6656)		+=3D vt6656/
diff --git a/drivers/staging/vt6656/Kconfig b/drivers/staging/vt6656/Kconfig
new file mode 100644
index 0000000..f823a74
--- /dev/null
+++ b/drivers/staging/vt6656/Kconfig
@@ -0,0 +1,5 @@
+config VT6656
+	tristate "VIA Technologies VT6656 support"
+	---help---
+	This is a vendor-written driver for VIA VT6656.
+
diff --git a/drivers/staging/vt6656/Makefile b/drivers/staging/vt6656/Makef=
ile
index 7d20efe..4467bb1 100644
--- a/drivers/staging/vt6656/Makefile
+++ b/drivers/staging/vt6656/Makefile
@@ -1,204 +1,39 @@
-#
-# Build options:
-#
-#
-
-HOSTAP :=3D 1
-
-
-KSP :=3D 	/lib/modules/$(shell uname -r)/build \
-	/usr/src/linux-$(shell uname -r) \
-	/usr/src/linux-$(shell uname -r | sed 's/-.*//') \
-	/usr/src/kernel-headers-$(shell uname -r) \
-	/usr/src/kernel-source-$(shell uname -r) \
-	/usr/src/linux-$(shell uname -r | sed 's/\([0-9]*\.[0-9]*\)\..*/\1/') \
-	/usr/src/linux
-
-test_dir =3D $(shell [ -e $(dir)/include/linux ] && echo $(dir))
-KSP :=3D $(foreach dir, $(KSP), $(test_dir))
-
-KSRC :=3D $(firstword $(KSP))
-
-ifeq (,$(KSRC))
-  $(error Linux kernel source not found)
-endif
-
-# check kernel version
-KVER :=3D $(shell uname -r | cut -c1-3 | sed 's/2\.[56]/2\.6/')
-KERVER2=3D$(shell uname -r | cut -d. -f2)
-
-ifeq ($(KVER), 2.6)
-# 2.6 kernel
-TARGET =3D vntwusb.ko
-
-else
-TARGET =3D vntwusb.o
-
-endif
-
-INSTDIR	:=3D $(shell find /lib/modules/$(shell uname -r) -name $(TARGET) -=
printf "%h\n" | sort | head -1)
-ifeq (,$(INSTDIR))
-	ifeq (,$(KERVER2))
-		ifneq (,$(wildcard /lib/modules/$(shell uname -r)/kernel))
-			INSTDIR :=3D /lib/modules/$(shell uname -r)/kernel/drivers/net
-		else
-			INSTDIR :=3D /lib/modules/$(shell uname -r)/net
-		endif
-	else
-		ifneq ($(KERVER2),2)
-			INSTDIR :=3D /lib/modules/$(shell uname -r)/kernel/drivers/net
-		else
-			INSTDIR :=3D /lib/modules/$(shell uname -r)/net
-		endif
-	endif
-endif
-
-
-SRC =3D main_usb.c card.c mac.c baseband.c wctl.c 80211mgr.c \
-      wcmd.c wmgr.c bssdb.c  wpa2.c rxtx.c dpc.c power.c datarate.c \
-      mib.c rc4.c tether.c tcrc.c ioctl.c hostap.c wpa.c key.c \
-      tkip.c michael.c rf.c iwctl.c wpactl.c aes_ccmp.c \
-      usbpipe.c channel.c control.c firmware.c int.c
-
-
-ifeq ($(HOSTAP), 1)
-#  CFLAGS +=3D -DHOSTAP
-  EXTRA_CFLAGS +=3D -DHOSTAP
-endif
-
-
-#CFLAGS +=3D -I$(PWD) -I$(PWD)/../include -I$(PWD)/include
-EXTRA_CFLAGS +=3D -I$(PWD) -I$(PWD)/../include -I$(PWD)/include
-
-# build rule
-ifeq ($(KVER), 2.6)
-# 2.6 kernel
-
-ifndef KERNEL_CONF
-KERNEL_CONF=3D	$(KSRC)/.config
-endif
-
-include ${KERNEL_CONF}
-
-obj-m +=3D vntwusb.o
-
-vntwusb-objs :=3D	main_usb.o card.o mac.o baseband.o wctl.o 80211mgr.o \
-	wcmd.o wmgr.o bssdb.o rxtx.o dpc.o power.o datarate.o  \
-	mib.o rc4.o tether.o tcrc.o ioctl.o hostap.o wpa.o key.o tkip.o \
-	michael.o rf.o iwctl.o wpactl.o wpa2.o aes_ccmp.o  \
-	usbpipe.o channel.o control.o firmware.o int.o
-
-.c.o:
-#	$(CC) $(CFLAGS) -o $@ $<
-	$(CC) $(EXTRA_CFLAGS) -o $@ $<
-
-default:
-	make -C $(KSRC) SUBDIRS=3D$(shell pwd) modules
-
-else
-
-# 2.2/2.4 kernel
-OBJS :=3D	main_usb.o card.o mac.o baseband.o wctl.o 80211mgr.o \
-	wcmd.o wmgr.o bssdb.o rxtx.o dpc.o power.o datarate.o \
-	mib.o rc4.o tether.o tcrc.o ioctl.o hostap.o wpa.o key.o tkip.o \
-	michael.o rf.o iwctl.o wpactl.o wpa2.o aes_ccmp.o  \
-	usbpipe.o channel.o control.o
-
-VERSION_FILE :=3D $(KSRC)/include/linux/version.h
-CONFIG_FILE  :=3D $(KSRC)/include/linux/config.h
-
-
-ifeq (,$(wildcard $(VERSION_FILE)))
-  $(error Linux kernel source not configured - missing version.h)
-endif
-
-ifeq (,$(wildcard $(CONFIG_FILE)))
-  $(error Linux kernel source not configured - missing config.h)
-endif
-
-ifneq (,$(findstring egcs-2.91.66, $(shell cat /proc/version)))
-  CC :=3D kgcc gcc cc
-else
-  CC :=3D gcc cc
-endif
-
-test_cc =3D $(shell which $(cc) > /dev/null 2>&1 && echo $(cc))
-CC :=3D $(foreach cc, $(CC), $(test_cc))
-CC :=3D $(firstword $(CC))
-
-#CFLAGS +=3D -Wall -DLINUX -D__KERNEL__ -DMODULE  -DEXPORT_SYMTAB -D__NO_V=
ERSION__ -O2 -pipe
-#CFLAGS +=3D -I$(KSRC)/include -Wstrict-prototypes -fomit-frame-pointer -f=
no-strict-aliasing
-#CFLAGS +=3D $(shell [ -f $(KSRC)/include/linux/modversions.h ] && \
-#            echo "-DMODVERSIONS -include $(KSRC)/include/linux/modversion=
s.h")
-EXTRA_CFLAGS +=3D -Wall -DLINUX -D__KERNEL__ -DMODULE  -DEXPORT_SYMTAB -D_=
_NO_VERSION__ -O2 -pipe
-EXTRA_CFLAGS +=3D -I$(KSRC)/include -Wstrict-prototypes -fomit-frame-point=
er -fno-strict-aliasing
-EXTRA_CFLAGS +=3D $(shell [ -f $(KSRC)/include/linux/modversions.h ] && \
-            echo "-DMODVERSIONS -include $(KSRC)/include/linux/modversions=
=2Eh")
-
-.SILENT: $(TARGET) clean
-
-
-# look for SMP in config.h
-#SMP :=3D $(shell $(CC) $(CFLAGS) -E -dM $(CONFIG_FILE) | \
-#         grep CONFIG_SMP | awk '{ print $$3 }')
-SMP :=3D $(shell $(CC) $(EXTRA_CFLAGS) -E -dM $(CONFIG_FILE) | \
-         grep CONFIG_SMP | awk '{ print $$3 }')
-ifneq ($(SMP),1)
-  SMP :=3D 0
-endif
-
-
-ifeq ($(SMP), 1)
-#  CFLAGS +=3D -D__SMP__
-  EXTRA_CFLAGS +=3D -D__SMP__
-endif
-
-
-
-# check x86_64
-SUBARCH :=3D $(shell uname -m)
-ifeq ($(SUBARCH),x86_64)
-#    CFLAGS +=3D -mcmodel=3Dkernel -mno-red-zone
-    EXTRA_CFLAGS +=3D -mcmodel=3Dkernel -mno-red-zone
-endif
-
-
-$(TARGET): $(filter-out $(TARGET), $(SRC:.c=3D.o))
-	$(LD) -r $^ -o $@
-	echo; echo
-	echo "**************************************************"
-	echo "Build options:"
-	echo "   VERSION    $(KVER)"
-	echo -n "   SMP             "
-	if [ "$(SMP)" =3D "1" ]; \
-		then echo "Enabled"; else echo "Disabled"; fi
-
-
-
-endif # ifeq ($(KVER),2.6)
-
-
-ifeq ($(KVER), 2.6)
-install: default
-else
-install: clean $(TARGET)
-endif
-	mkdir -p $(MOD_ROOT)$(INSTDIR)
-	install -m 644 -o root $(TARGET) $(MOD_ROOT)$(INSTDIR)
-
-ifeq (,$(MOD_ROOT))
-	/sbin/depmod -a || true
-else
-	/sbin/depmod -b $(MOD_ROOT) -a || true
-endif
-
-
-uninstall:
-	rm -f $(INSTDIR)/$(TARGET)
-	/sbin/depmod -a
-
-clean:
-	rm -f $(TARGET) $(SRC:.c=3D.o) *~  *.o
-	rm -f .*.o.d .*.o.cmd .*.ko.cmd *.mod.c *.mod.o
-
--include .depend.mak
+# TODO: all of these should be removed
+EXTRA_CFLAGS +=3D -DLINUX -D__KERNEL__ -DMODULE  -DEXPORT_SYMTAB -D__NO_VE=
RSION__
+EXTRA_CFLAGS +=3D -DHOSTAP
+
+vt6656-y +=3D	main_usb.o \
+			card.o  \
+			mac.o   \
+			baseband.o \
+			wctl.o  \
+			80211mgr.o \
+			wcmd.o\
+			wmgr.o \
+			bssdb.o \
+			wpa2.o \
+			rxtx.o \
+			dpc.o \
+			power.o \
+			datarate.o \
+			mib.o \
+			rc4.o \
+			tether.o \
+			tcrc.o \
+			ioctl.o \
+			hostap.o \
+			wpa.o \
+			key.o \
+			tkip.o \
+			michael.o \
+			rf.o \
+			iwctl.o \
+			wpactl.o \
+			aes_ccmp.o \
+			usbpipe.o \
+			channel.o \
+			control.o \
+			firmware.o \
+			int.o
+
+obj-$(CONFIG_VT6656) +=3D	vt6656.o
--=20
1.5.6.3


--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--b3OyYALfe3DXUU4J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKR6JgRO4fQQdv5AwRAon7AKC5f7kiso/dozPDHCELo5p4z8rmjgCgsxc+
7fecbpJzEd03Z3cnnO/ZywA=
=PCXp
-----END PGP SIGNATURE-----

--b3OyYALfe3DXUU4J--
