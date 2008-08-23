Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYHWT3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYHWT3r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 15:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYHWT3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 15:29:35 -0400
Received: from web82105.mail.mud.yahoo.com ([209.191.84.218]:44185 "HELO
	web82105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751783AbYHWT3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 15:29:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=fZCU5DVEaM/PGB7bMXVQkrm7VKNQfYtsmh6cwzgdvmnUTjovuVD0uypGmbqjabONUiXNDSW8ZgCf3IaU5NZj/bLdXQckl6QCcJWS5yUFyi2JRluzZFLj0mm2SEn3UIBlzP9YnKjO/i908io0bBOC7xkEMCo5oLjEq12Y9Xa6Lw8=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Sat, 23 Aug 2008 12:29:33 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>,
       Bill Fink <billfink@mindspring.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <655777.49664.qm@web82105.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> please try attached patch, and send out lspci -vvxxxx again.

I found that your patch was supposed to apply beginning at line 1918,
but the code in v2.6.27-rc4 that corresponded to the patch actually
was located at line 1790.

I also found that it would not compile, but was able to fix it...
hopefully somewhat as you intended:
========================
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 9236e7f..7853a05 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1790,6 +1790,22 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_BROADCOM,
              PCI_DEVICE_ID_NX2_5709S,
              quirk_brcm_570x_limit_vpd);
 
+static void __init quirk_hpet_in_bar(struct pci_dev *pdev)
+{
+        /* int i; */
+    unsigned int base, size;
+
+    /* the BAR1 is the location of the HPET...we must
+     * not touch this, so forcibly insert it into the resource tree */
+    base = pci_resource_start(pdev, 1);
+    size = pci_resource_len(pdev, 1);
+    if (base && size) {
+        insert_resource(&iomem_resource, &pdev->resource[1]);
+        dev_info(&pdev->dev, "HPET at %04x-%04x\n", base, base + size - 1);
+    }
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, 0x3485, quirk_hpet_in_bar);
+
 #ifdef CONFIG_PCI_MSI
 /* Some chipsets do not support MSI. We cannot easily rely on setting
  * PCI_BUS_FLAGS_NO_MSI in its bus flags because there are actually
========================

With these changes, the kernel still hangs at the same point as previous
kernels.

With "hpet=disable", nothing from your dev_info() call appears in 'dmesg'
output.


Dave W.
