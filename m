Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbXHNLQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbXHNLQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 07:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757159AbXHNLQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 07:16:37 -0400
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:47274 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100AbXHNLQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 07:16:35 -0400
Date: Tue, 14 Aug 2007 13:15:57 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: spontaneous disconnect with "usb-storage: implement autosuspend"
Message-ID: <20070814131557.5653d991@localhost>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_ln/Tohcq8Ug1fnm5u+WVIZJ"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_ln/Tohcq8Ug1fnm5u+WVIZJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

with "CONFIG_USB_SUSPEND=y", since commit:

8dfe4b14869fd185ca25ee88b02ada58a3005eaf
    usb-storage: implement autosuspend
    
    This patch (as930) implements autosuspend for usb-storage.  It is
    adapted from a patch by Oliver Neukum.  Autosuspend is allowed except
    during LUN scanning, resets, and command execution.


my USB photo-camera gets automagically disconnected before I can do
anything with it ;)


Relevant dmesg (what I get by just attaching it):

[   70.722898] scsi 8:0:0:0: Direct-Access     HP       PHOTOSMART E317  A001 PQ: 0 ANSI: 0 CCS
[   70.727880] sd 8:0:0:0: [sdb] 488448 512-byte hardware sectors (250 MB)
[   70.730876] sd 8:0:0:0: [sdb] Write Protect is off
[   70.730879] sd 8:0:0:0: [sdb] Mode Sense: 00 46 00 00
[   70.730882] sd 8:0:0:0: [sdb] Assuming drive cache: write through
[   70.742874] sd 8:0:0:0: [sdb] 488448 512-byte hardware sectors (250 MB)
[   70.745873] sd 8:0:0:0: [sdb] Write Protect is off
[   70.745876] sd 8:0:0:0: [sdb] Mode Sense: 00 46 00 00
[   70.745878] sd 8:0:0:0: [sdb] Assuming drive cache: write through
[   70.745882]  sdb: sdb1
[   70.755192] sd 8:0:0:0: [sdb] Attached SCSI removable disk
[   70.755446] sd 8:0:0:0: Attached scsi generic sg3 type 0
[   70.755657] usb-storage: device scan complete
[   73.071490] usb 6-2: usb auto-suspend
[   73.321445] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0004
[   73.321453] uhci_hcd 0000:00:1d.1: port 2 portsc 108a,00
[   73.321462] hub 6-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
[   73.321465] usb 6-2: USB disconnect, address 2
[   73.321467] usb 6-2: unregistering device



The relevant differences of dmesg between pre and post "autosuspend"
patch:

@@ -1,4 +1,4 @@
- Linux version 2.6.22-gb0e2a705 ...
+ Linux version 2.6.22-g8dfe4b14 ...
@@ -606,6 +606,12 @@
  hub 1-0:1.0: hub_suspend
  usb usb1: bus auto-suspend
  ehci_hcd 0000:00:1a.7: suspend root hub
+ hub 4-0:1.0: hub_suspend
+ usb usb4: bus auto-suspend
+ usb usb4: suspend_rh
+ hub 5-0:1.0: hub_suspend
+ usb usb5: bus auto-suspend
+ usb usb5: suspend_rh
  hub 6-0:1.0: hub_suspend
  usb usb6: bus auto-suspend
  usb usb6: suspend_rh
@@ -618,12 +624,6 @@
  hub 3-0:1.0: hub_suspend
  usb usb3: bus auto-suspend
  usb usb3: suspend_rh
- hub 4-0:1.0: hub_suspend
- usb usb4: bus auto-suspend
- usb usb4: suspend_rh
- hub 5-0:1.0: hub_suspend
- usb usb5: bus auto-suspend
- usb usb5: suspend_rh
  usb usb3: uevent
  usb 3-0:1.0: uevent
  usb 3-0:1.0: uevent
@@ -686,6 +686,7 @@
  usb-storage 6-2:1.0: usb_probe_interface - got id
  scsi8 : SCSI emulation for USB Mass Storage devices
  drivers/usb/core/inode.c: creating file '002'
+ hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0004
  usb-storage: device found at 2
  usb-storage: waiting for device to settle before scanning
  hub 2-0:1.0: hub_suspend
@@ -704,3 +705,22 @@
  sd 8:0:0:0: [sdb] Attached SCSI removable disk
  sd 8:0:0:0: Attached scsi generic sg3 type 0
  usb-storage: device scan complete
+ usb 6-2: usb auto-suspend
+ hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0004
+ uhci_hcd 0000:00:1d.1: port 2 portsc 108a,00
+ hub 6-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
+ usb 6-2: USB disconnect, address 2
+ usb 6-2: unregistering device
+ usb 6-2: usb_disable_device nuking all URBs
+ usb 6-2: unregistering interface 6-2:1.0
+ usb_endpoint usbdev6.2_ep82: ep_device_release called for usbdev6.2_ep82
+ usb_endpoint usbdev6.2_ep03: ep_device_release called for usbdev6.2_ep03
+ usb 6-2:1.0: uevent
+ usb 6-2:1.0: uevent
+ usb_endpoint usbdev6.2_ep00: ep_device_release called for usbdev6.2_ep00
+ usb 6-2: uevent
+ hub 6-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
+ usb usb6: suspend_rh (auto-stop)
+ hub 6-0:1.0: hub_suspend
+ usb usb6: bus auto-suspend
+ usb usb6: suspend_rh


config for 2.6.22-gb0e2a705 attached

-- 
	Paolo Ornati
	Linux 2.6.23-rc3 on x86_64

--MP_ln/Tohcq8Ug1fnm5u+WVIZJ
Content-Type: application/x-gzip; name=config-usb.gz
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=config-usb.gz

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

--MP_ln/Tohcq8Ug1fnm5u+WVIZJ--
