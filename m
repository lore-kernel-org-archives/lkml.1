Return-Path: <linux-kernel-owner+w=401wt.eu-S1758402AbYKDXxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbYKDXxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757536AbYKDXk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:40:29 -0500
Received: from ns.suse.de ([195.135.220.2]:47779 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217AbYKDXk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:40:27 -0500
Date: Tue, 4 Nov 2008 15:33:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Phil Dibowitz <phil@ipom.com>,
       Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: [patch 43/57] USB: storage: Avoid I/O errors when issuing SCSI
	ioctls to JMicron USB/ATA bridge
Message-ID: <20081104233307.GR659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-storage-avoid-i-o-errors-when-issuing-scsi-ioctls-to-jmicron-usb-ata-bridge.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Phil Dibowitz <phil@ipom.com>

commit 3030ca4cf4abbdd2dd850a14d20e9fca5937ffb5 upstream

USB: storage: Avoid I/O errors when issuing SCSI ioctls to JMicron USB/ATA bridge

Here's the patch that implements the fix you suggested to avoid the
I/O errors that I was running into with my new USB enclosure with a
JMicron USB/ATA bridge, while issuing scsi-io USN or other such
queries used by Fedora's mkinitrd.
http://bugzilla.kernel.org/show_bug.cgi?id=9638#c85


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

Signed-off-by: Phil Dibowitz <phil@ipom.com>
Cc: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1745,6 +1745,15 @@ UNUSUAL_DEV(  0x14cd, 0x6600, 0x0201, 0x
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

-- 
