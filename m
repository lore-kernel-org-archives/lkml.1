Return-Path: <linux-kernel-owner+w=401wt.eu-S1751546AbYJSEMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbYJSEMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 00:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbYJSEL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 00:11:56 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:43654 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750701AbYJSELz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 00:11:55 -0400
To: Phil Dibowitz <phil@ipom.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: Avoid I/O errors when issuing SCSI ioctls to JMicron USB/ATA bridge
References: <Pine.LNX.4.44L0.0810141111080.2662-300000@iolanthe.rowland.org>
	<48F4F337.8080104@ipom.com>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Organization: Free thinker, not speaking for University of Campinas
Date: Sun, 19 Oct 2008 02:11:33 -0200
Message-ID: <ormyh1rzpm.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

On Oct 14, 2008, Phil Dibowitz <phil@ipom.com> wrote:

> The patch looks generally good, but you've included every possible revision
> of the hardware. Can you please change your patch to include just the
> revision in question (0x0100) rather than the whole range (0x0000 - 0x9999)?

Here's the patch.  Let's hope that's enough to cover any other
failing variants, past, present and future.


>> Here's the patch that implements the fix you suggested to avoid the
>> I/O errors that I was running into with my new USB enclosure with a
>> JMicron USB/ATA bridge, while issuing scsi-io USN or other such
>> queries used by Fedora's mkinitrd.
>> http://bugzilla.kernel.org/show_bug.cgi?id=9638#c85


/proc/bus/usb/devices:
T:  Bus=01 Lev=01 Prnt=01 Port=07 Cnt=04 Dev#=  5 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=152d ProdID=2329 Rev= 1.00
S:  Manufacturer=JMicron
S:  Product=USB to ATA/ATAPI Bridge
S:  SerialNumber=DE5088854FFF
C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=  2mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

(patch applied and retested on a modified 2.6.27.2-libre.24.rc1.fc10)


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=lxo-usb-jmicron-ignore-residue.patch

--- linux-2.6/drivers/usb/storage/unusual_devs.h~	2008-07-13 18:51:29.000000000 -0300
+++ linux-2.6/drivers/usb/storage/unusual_devs.h	2008-10-07 23:38:38.000000000 -0300
@@ -1694,6 +1694,15 @@
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE ),
 
+/* Reported by Alexandre Oliva <oliva@lsd.ic.unicamp.br>
+ * JMicron responds to USN and several other SCSI ioctls with a
+ * residue that causes subsequent I/O requests to fail.  */
+UNUSUAL_DEV(  0x152d, 0x2329, 0x0100, 0x0100,
+	        "JMicron",
+	        "USB to ATA/ATAPI Bridge",
+	        US_SC_DEVICE, US_PR_DEVICE, NULL,
+	        US_FL_IGNORE_RESIDUE ),
+
 /* Reported by Robert Schedel <r.schedel@yahoo.de>
  * Note: this is a 'super top' device like the above 14cd/6600 device */
 UNUSUAL_DEV(  0x1652, 0x6600, 0x0201, 0x0201,

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


--=20
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
FSFLA Board Member       =C2=A1S=C3=A9 Libre! =3D> http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}

--=-=-=--
