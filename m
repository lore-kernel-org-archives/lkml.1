Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYLBWjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYLBWjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYLBWjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:39:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43504 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbYLBWjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:39:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Tue, 2 Dec 2008 23:38:50 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, greg@kroah.com, mingo@elte.hu,
       jbarnes@virtuousgeek.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
       tiwai@suse.de, akpm@linux-foundation.org
References: <200812020320.31876.rjw@sisk.pl> <200812020513.42243.elendil@planet.nl> <alpine.LFD.2.00.0812012026520.3256@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812012026520.3256@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812022338.51284.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 2 of December 2008, Linus Torvalds wrote:
> 
> That's why I'd like to see what the layout differences are for Rafael with 
> and without his patch (and also both before and after hibernate/resume). 
> Maybe both layouts are "correct", but the non-working one can give us a 
> clue about what may be triggering the problem.

OK

Sorry for the delay, it took me more time than expected to generate all the
data.

* dmesg output including one hibernation-resume cycle from 2.6.28-rc7 with the
  debug patch (appended for completness):

  http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc7/dmesg-rc7-patched-prep.log

* dmesg output including one hibernation-resume cycle from 2.6.28-rc7 without
  the debug patch:

  http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc7/dmesg-rc7-nopatch-prep.log

* diff between the two:

  http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc7/dmesg-rc7_nopatch-rc7_patched.diff

This part of the diff  (+ is the patched one) seems to be particularly
interesting to me, especially the overlapping MEM windows for 0000:00:1e.0 and
0000:03:0b.0 (may that be the reason for the observed failures?):

@@ -276,0 +277,4 @@
+bad alignment flags 21200 4000000 (0)
+pci 0000:03:0b.0: BAR 9 bad alignment 0: [0x000000-0x3ffffff]
+bad alignment flags 20200 4000000 (0)
+pci 0000:03:0b.0: BAR 10 bad alignment 0: [0x000000-0x3ffffff]
@@ -288,2 +291,0 @@
-pci 0000:03:0b.0:   PREFETCH window: 0x88000000-0x8bffffff
-pci 0000:03:0b.0:   MEM window: 0x8c000000-0x8fffffff
@@ -292,2 +294,2 @@
-pci 0000:00:1e.0:   MEM window: 0x8c000000-0x91ffffff
-pci 0000:00:1e.0:   PREFETCH window: 0x00000088000000-0x0000008bffffff
+pci 0000:00:1e.0:   MEM window: 0x88000000-0x880fffff
+pci 0000:00:1e.0:   PREFETCH window: disabled
@@ -312,2 +314,2 @@
-bus: 03 index 1 mmio: [0x8c000000-0x91ffffff]
-bus: 03 index 2 mmio: [0x88000000-0x8bffffff]
+bus: 03 index 1 mmio: [0x88000000-0x880fffff]
+bus: 03 index 2 mmio: [0x0-0x0]
@@ -318,2 +320,2 @@
-bus: 04 index 2 mmio: [0x88000000-0x8bffffff]
-bus: 04 index 3 mmio: [0x8c000000-0x8fffffff]
+bus: 04 index 2 mmio: [0x0-0x3ffffff]
+bus: 04 index 3 mmio: [0x0-0x3ffffff]

* the output of 'lspci -vv'

  http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc7/lspci-vv.txt

* diff between /proc/iomem between 2.6.28-rc7 without and with the patch
  (+ is from the patched kernel):

diff -U 0 -r rc7-nopatch//iomem rc7-patched//iomem
--- rc7-nopatch//iomem	2008-12-02 22:57:34.000000000 +0100
+++ rc7-patched//iomem	2008-12-02 23:07:02.000000000 +0100
@@ -7,2 +7,2 @@
-  00200000-00450496 : Kernel code
-  00450497-00603c37 : Kernel data
+  00200000-00450526 : Kernel code
+  00450527-00603c37 : Kernel data
@@ -14,15 +14,14 @@
-88000000-8bffffff : PCI Bus 0000:03
-  88000000-8bffffff : PCI CardBus 0000:04
-8c000000-91ffffff : PCI Bus 0000:03
-  8c000000-8fffffff : PCI CardBus 0000:04
-  90000000-90003fff : 0000:03:0b.1
-  90004000-90004fff : 0000:03:0b.0
-    90004000-90004fff : yenta_socket
-  90005000-900057ff : 0000:03:0b.1
-    90005000-900057ff : firewire_ohci
-  90005800-900058ff : 0000:03:0b.3
-    90005800-900058ff : mmc0
-92000000-9207ffff : 0000:00:02.1
-92080000-92083fff : 0000:00:1b.0
-  92080000-92083fff : ICH HD audio
-92084000-92084fff : Intel Flush Page
+88000000-880fffff : PCI Bus 0000:03
+  88000000-88003fff : 0000:03:0b.1
+  88004000-88004fff : 0000:03:0b.0
+    88004000-88004fff : yenta_socket
+  88005000-880057ff : 0000:03:0b.1
+    88005000-880057ff : firewire_ohci
+  88005800-880058ff : 0000:03:0b.3
+    88005800-880058ff : mmc0
+88100000-8817ffff : 0000:00:02.1
+88180000-88183fff : 0000:00:1b.0
+  88180000-88183fff : ICH HD audio
+88184000-88184fff : Intel Flush Page
+88400000-887fffff : PCI CardBus 0000:04
+88800000-88bfffff : PCI CardBus 0000:04

All of the files above plus some more data are available from
http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc7/

HTH

Thanks,
Rafael
