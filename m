Return-Path: <linux-kernel-owner+w=401wt.eu-S1760745AbYCYXb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745AbYCYXb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbYCYXbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:31:20 -0400
Received: from mail.gmx.net ([213.165.64.20]:54115 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754739AbYCYXbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:31:19 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18bXtAzqEsbgt92DfBUVHgWnlfIzhHp35hqMjNy4W
	fU1PiK29HIOW80
Date: Wed, 26 Mar 2008 00:31:19 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Jeff Garzik <jeff@garzik.org>, Tim Ellis <tim@ngndg.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] Work around breakage introduced in pata_sil680 by switching
 it to MMIO
In-Reply-To: <1203987502.15052.71.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0803260023030.1539@axis700.grange>
References: <32334D99-DB01-4645-97DC-88D2E7BA2BE5@ngndg.com> 
 <1202850129.7410.22.camel@pasglop>  <Pine.LNX.4.64.0802151651340.27735@axis700.grange>
  <20080215155332.2b89c429@core> <1203111956.22915.24.camel@pasglop> 
 <DD1DA785-AD9C-4EFA-94E2-FA7154EECA9F@ngndg.com>  <47C347C3.40404@garzik.org>
 <1203987502.15052.71.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pata_sil680 is broken on Linkstation amd Kurobox HG machines since 2.6.24. 
Work around the breakage until a real fix is found.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

---

On Tue, 26 Feb 2008, Benjamin Herrenschmidt wrote:

> > Yes.
> > 
> > Alan loves to complain about lack of MMIO flush, but in practice this is 
> > rarely the source of problems such as the one you describe.
> > 
> > But if its broken its broken, and we need to revert.  Any luck getting 
> > benh access to the device?
> > 
> 
> Especially since reverting it will break a whole bunch of cell blades,
> which wouldn't be nice (those cannot do PIO and have that controller).
> 
> In the meantime, we might "workaround" with a hack to only enable MMIO
> on those cell
> blades, something like:
> 
> #ifdef CONFIG_PPC64
> 	if (machine_is(cell))
> 		mmio = 1;
> #endif
> 
> That might get us out of the regression until we find the proper
> solution ?

How about the one below? I'd really like to get it in for 2.6.25 to avoid 
a second broken stable kernel on these machines.

Ben, please verify that your cell machines still work.

Thanks
Guennadi

diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 503245a..75179ff 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -335,9 +335,12 @@ static int __devinit sil680_init_one(struct pci_dev *pdev,
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 	static int printed_version;
+#ifdef CONFIG_PPC64
 	struct ata_host *host;
 	void __iomem *mmio_base;
-	int rc, try_mmio;
+	int rc;
+#endif
+	int try_mmio;
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
@@ -350,7 +353,8 @@ static int __devinit sil680_init_one(struct pci_dev *pdev,
 			return -ENODEV;
 	}
 
-	if (!try_mmio)
+#ifdef CONFIG_PPC64
+	if (!try_mmio || !machine_is(cell))
 		goto use_ioports;
 
 	/* Try to acquire MMIO resources and fallback to PIO if
@@ -396,6 +400,7 @@ static int __devinit sil680_init_one(struct pci_dev *pdev,
 				 &sil680_sht);
 
 use_ioports:
+#endif
 	return ata_pci_init_one(pdev, ppi);
 }
 
