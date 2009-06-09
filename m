Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbZFIKWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbZFIKWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760567AbZFIKSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:18:43 -0400
Received: from kroah.org ([198.145.64.141]:54599 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760600AbZFIKSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:18:41 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:58 2009
Message-Id: <20090609094057.846111783@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:13 -0700
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
       alan@lxorguk.ukuu.org.uk, Breno Leitao <leitao@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 25/87] icom: fix rmmod crash
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=icom-fix-rmmod-crash.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Breno Leitao <leitao@linux.vnet.ibm.com>

commit 95caa0a9bdaf93607bd0cc8932f53112496f2f22 upstream.

Actually the icom driver is crashing when is being removed because
the driver is kfreeing the adapter structure before calling
pci_release_regions(), which result in the following error:

  Unable to handle kernel paging request for data at address 0x6b6b6b6b6b6b6d33
  Faulting instruction address: 0xc000000000246b80
  Oops: Kernel access of bad area, sig: 11 [#1]
  ....
  [c000000012d436a0] [c0000000001002d0] .kfree+0x120/0x34c (unreliable)
  [c000000012d43730] [c000000000246d60] .pci_release_selected_regions+0x3c/0x68
  [c000000012d437c0] [d000000002d54700] .icom_kref_release+0xf4/0x118 [icom]
  [c000000012d43850] [c000000000232e50] .kref_put+0x74/0x94
  [c000000012d438d0] [d000000002d56c58] .icom_remove+0x40/0xa4 [icom]
  [c000000012d43960] [c000000000249e48] .pci_device_remove+0x50/0x90
  [c000000012d439e0] [c0000000002d68d8] .__device_release_driver+0x94/0xd4
  [c000000012d43a70] [c0000000002d7104] .driver_detach+0xf8/0x12c
  [c000000012d43b00] [c0000000002d549c] .bus_remove_driver+0xbc/0x11c
  [c000000012d43b90] [c0000000002d71dc] .driver_unregister+0x60/0x80
  [c000000012d43c20] [c00000000024a07c] .pci_unregister_driver+0x44/0xe8
  [c000000012d43cb0] [d000000002d56bf4] .icom_exit+0x1c/0x40 [icom]
  [c000000012d43d30] [c000000000095fa8] .SyS_delete_module+0x214/0x2a8
  [c000000012d43e30] [c00000000000852c] syscall_exit+0x0/0x40

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/icom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/serial/icom.c
+++ b/drivers/serial/icom.c
@@ -1482,8 +1482,8 @@ static void icom_remove_adapter(struct i
 
 	free_irq(icom_adapter->pci_dev->irq, (void *) icom_adapter);
 	iounmap(icom_adapter->base_addr);
-	icom_free_adapter(icom_adapter);
 	pci_release_regions(icom_adapter->pci_dev);
+	icom_free_adapter(icom_adapter);
 }
 
 static void icom_kref_release(struct kref *kref)


