Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbXIRTdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbXIRTdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbXIRTdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:33:05 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45733 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbXIRTdD (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:33:03 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc6-mm1 - Mostly working, with a kbuild oddity
In-Reply-To: Your message of "Tue, 18 Sep 2007 01:18:41 PDT."
             <20070918011841.2381bd93.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190143977_4811P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Sep 2007 15:32:57 -0400
Message-ID: <7319.1190143977@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190143977_4811P
Content-Type: text/plain; charset=us-ascii

On Tue, 18 Sep 2007 01:18:41 PDT, Andrew Morton said:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/

% uname -a
Linux turing-police.cc.vt.edu 2.6.23-rc6-mm1 #1 SMP PREEMPT Tue Sep 18 12:32:13 EDT 2007 x86_64 x86_64 x86_64 GNU/Linux
% uptime
 15:11:48 up 36 min,  1 user,  load average: 0.05, 0.11, 0.09

Had a few issues, all self-inflicted (the biggie was 2 iptables modules that
needed fixing for the net namespace changes in git-net.patch - stuck an
&init_net in the right 2 places, a new #include line, and all was good).

I *did* have an odd issue with an out-of-tree GPL driver for a webcam.
(It's from http://mxhaard.free.fr/ if anybody cares).

The Makefile does this:

make -C /lib/modules/`uname -r`/build SUBDIRS=/home/valdis/src/gspcav1-20070508 CC=cc modules

and has this sort of stuff in it:

DEFINES   += -DGSPCA_ENABLE_DEBUG
DEFINES   += -DCONFIG_USB_GSPCA_MODULE=1 -DMODULE -D__KERNEL__
DEFINES   += -DVID_HARDWARE_GSPCA=0xFF -DGSPCA_VERSION=\"$(VERSION)\"

In -rc4-mm1, $DEFINES got added to the compile command - in -rc6-mm1, I
had to namually add a 'CFLAGS += $(DEFINES)' or GSPCA_VERSION came up undefined.

The actual problematic code in the Makefile:

-- begin Makefile snippet
ifneq ($(KERNELRELEASE),)   # We were called by kbuild
CFLAGS += $(DEFINES)
obj-m += gspca.o
gspca-objs := gspca_core.o decoder/gspcadecoder.o

else   # We were called from command line

KERNEL_VERSION = `uname -r`
KERNELDIR := /lib/modules/$(KERNEL_VERSION)/build
PWD  := $(shell pwd)
MODULE_INSTALLDIR = /lib/modules/$(KERNEL_VERSION)/kernel/drivers/usb/media/
MODULE_INSTALLDIR2 = /lib/modules/$(KERNEL_VERSION)/kernel/drivers/media/video/

default:
        $(MAKE) -C $(KERNELDIR) SUBDIRS=$(PWD) CC=$(CC) modules

install:
        mkdir -p $(MODULE_INSTALLDIR)
        rm -f $(MODULE_INSTALLDIR)spca5xx.ko
        rm -f $(MODULE_INSTALLDIR2)gspca.ko
        install -c -m 0644 gspca.ko $(MODULE_INSTALLDIR)
        /sbin/depmod -ae

uninstall:
        rm -f $(MODULE_INSTALLDIR)gspca.ko
        /sbin/depmod -aq

endif
--- end Makefile snippet

The Make definitely falls into the 'else' part (verified by adding an 'echo'
to the default: target).  Adding the CFLAGS += to the else, or moving the line
above the if, makes it work.

--==_Exmh_1190143977_4811P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG8CfpcC3lWbTT17ARAl9kAJ9pW9QZSKsOwPfIlBsP7l++EKS3pgCffbfL
eDU6BBGJrUr5b5TA1kq7auE=
=OjvV
-----END PGP SIGNATURE-----

--==_Exmh_1190143977_4811P--
