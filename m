Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbZKRM54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbZKRM54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 07:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756368AbZKRM5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 07:57:55 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:44605 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbZKRM5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 07:57:55 -0500
Message-ID: <f9dbd9c6516a5f8e45d3883636b97bd5a9c2c1e5@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
Date: Wed, 18 Nov 2009 12:58:00 -0000
Subject: cxacru usb_bulk_msg() firmware upload 36x slower with OHCI vs. UHCI
From: "Simon Arlott" <simon@fire.lp0.eu>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: accessrunner-general@lists.sourceforge.net
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can anyone explain this speed difference I'm seeing with usb_bulk_msg()?

Increasing the size of the data doesn't improve the speed at all. This
makes firmware loading take significantly longer with OHCI.

I've tested this with two UHCI controllers, two OHCI controllers, and
two different versions of the device. Even on the same system with the
same device the speed difference occurs between OHCI and UHCI.

I've added a debug line to drivers/usb/atm/cxacru.c in cxacru_fw(),
which uploads the firmware in PAGE_SIZE chunks:
+                       printk(KERN_INFO "cxacru: sending fw %#x size %#x to %#x", fw, offb, offd);
                        ret = usb_bulk_msg(usb_dev, usb_sndbulkpipe(usb_dev, CXACRU_EP_CMD),


With OHCI and PAGE_SIZE chunks (4KB):
[2567188.504299] cxacru: sending fw 0x3 size 0x1000 to 0xe00
[2567188.760293] cxacru: sending fw 0x3 size 0x1000 to 0x1c00
[2567189.016258] cxacru: sending fw 0x3 size 0x1000 to 0x2a00
[2567189.272235] cxacru: sending fw 0x3 size 0x1000 to 0x3800
[2567189.528210] cxacru: sending fw 0x3 size 0x1000 to 0x4600
[2567189.784488] cxacru: sending fw 0x3 size 0x1000 to 0x5400
...
[2567233.044134] cxacru: sending fw 0x3 size 0x2c0 to 0x98668

 760293-504299 = 255994us
1016258-760293 = 255965us
 272235- 16258 = 255977us
 528210-272235 = 255975us
 784488-528210 = 256278us
approx. 128,000 bits/s


With UHCI and PAGE_SIZE chunks (4KB):
[  770.148148] cxacru: sending fw 0x3 size 0x1000 to 0xe00
[  770.155163] cxacru: sending fw 0x3 size 0x1000 to 0x1c00
[  770.162146] cxacru: sending fw 0x3 size 0x1000 to 0x2a00
[  770.169136] cxacru: sending fw 0x3 size 0x1000 to 0x3800
[  770.176139] cxacru: sending fw 0x3 size 0x1000 to 0x4600
[  770.183143] cxacru: sending fw 0x3 size 0x1000 to 0x5400
...
[  771.386167] cxacru: sending fw 0x3 size 0x2c0 to #98668

155163-148148 = 7015us
162146-155163 = 6983us
169136-162146 = 6990us
176139-169136 = 7003us
183143-176139 = 7004us
approx. 128,000 bits/s


With OHCI and PAGE_SIZE*8 chunks (32KB):
[ 4731.826738] cxacru: sending fw 0x3 size 0x8000 to 0x7000
[ 4733.874628] cxacru: sending fw 0x3 size 0x8000 to 0xe000
[ 4735.922353] cxacru: sending fw 0x3 size 0x8000 to 0x15000
[ 4737.970153] cxacru: sending fw 0x3 size 0x8000 to 0x1c000
[ 4740.017937] cxacru: sending fw 0x3 size 0x8000 to 0x23000
[ 4742.065814] cxacru: sending fw 0x3 size 0x8000 to 0x2a000
...
[ 4774.830569] cxacru: sending fw 0x3 size 0x62c0 to #98668

33874628-31826738 = 2047890us, /8 = 255986us
35922353-33874628 = 2047725us, /8 = 255966us
37970153-35922353 = 2047800us, /8 = 255975us
40017937-37970153 = 2047784us, /8 = 255973us
42065814-40017937 = 2047877us, /8 = 255985us
approx. 128,000 bits/s


With UHCI and PAGE_SIZE*8 chunks (32KB):
[ 4835.342142] cxacru: sending fw 0x3 size 0x8000 to 0x7000
[ 4835.399307] cxacru: sending fw 0x3 size 0x8000 to 0xe000
[ 4835.456209] cxacru: sending fw 0x3 size 0x8000 to 0x15000
[ 4835.513308] cxacru: sending fw 0x3 size 0x8000 to 0x1c000
[ 4835.570308] cxacru: sending fw 0x3 size 0x8000 to 0x23000
[ 4835.627287] cxacru: sending fw 0x3 size 0x8000 to 0x2a000
...
[ 4836.539297] cxacru: sending fw 0x3 size 0x62c0 to #98668

399307-342142 = 57165us, /8 = 7146us
456209-399307 = 56902us, /8 = 7113us
513308-456209 = 57099us, /8 = 7137us
570308-513308 = 57000us, /8 = 7125us
627287-570308 = 56979us, /8 = 7122us
approx. 4,600,000 bits/s

-- 
Simon Arlott
