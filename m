Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbYENIHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbYENIHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 04:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761152AbYENIG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 04:06:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761273AbYENIGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 04:06:22 -0400
Date: Wed, 14 May 2008 01:06:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: AndrewL733 <AndrewL733@aol.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Macbook Pro SATA Drives not seen in 2.6.25
Message-Id: <20080514010618.2e1e510a.akpm@linux-foundation.org>
In-Reply-To: <482A5C19.6090503@aol.com>
References: <482A5C19.6090503@aol.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 23:27:21 -0400 AndrewL733 <AndrewL733@aol.com> wrote:

> I have a couple of Macbook Pros. The newest one -- based on the Penryn 
> Core 2 Duo with ICH8 -- will not boot with any 2.6.25 kernel (I have 
> tried 2.6.25 and 2.6.25.3).

Let's cc linux-ide.

> It boots fine with 2.6.24.7 as well as with 
> 2.6.26-rc2. It also boots fine with 2.6.22. I have specific reasons why 
> I need to run 2.6.25 so I would appreciate any help here. It seems the 
> SATA drives are detected, but then for each partition during bootup I see:
> 
> ata3: SATA link down (SStatus 0 SControl 0)
> 
> The same 2.6.25 kernels boot fine on my older Macbook Pro with ICH7 and 
> I do not see this error.
> 
> I would be happy to run a git bisect to help identify the issue, but if 
> this problem is already well understood (hey, it's fixed in 2.6.26), I 
> can think of better ways to spend my time.

The below went into 2.6.25.1 (or will do so).  It looks hopful.  Can
you test it please?

> Please copy me personally on any replies. I often subscribe to the list 
> but it's too much mail right now. Thanks in advance.

We do that as a matter of course.  Or we should...


From: Tejun Heo <htejun@gmail.com>

commit cb6716c879ecf49e2af344926c6a476821812061 upstream

On certain configurations (certain macbooks), even though all the
conditions for SIDPR access described in the datasheet are met,
actually reading those registers just returns 0 and have no effect on
write.  Verify SIDPR is actually working before enabling it.

This is reported by Ryan Roth in bz#10512.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Ryan Roth <ryan.roth@ch2m.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ata_piix.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1531,6 +1531,8 @@ static void __devinit piix_init_sidpr(st
 {
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 	struct piix_host_priv *hpriv = host->private_data;
+	struct ata_device *dev0 = &host->ports[0]->link.device[0];
+	u32 scontrol;
 	int i;
 
 	/* check for availability */
@@ -1549,6 +1551,29 @@ static void __devinit piix_init_sidpr(st
 		return;
 
 	hpriv->sidpr = pcim_iomap_table(pdev)[PIIX_SIDPR_BAR];
+
+	/* SCR access via SIDPR doesn't work on some configurations.
+	 * Give it a test drive by inhibiting power save modes which
+	 * we'll do anyway.
+	 */
+	scontrol = piix_sidpr_read(dev0, SCR_CONTROL);
+
+	/* if IPM is already 3, SCR access is probably working.  Don't
+	 * un-inhibit power save modes as BIOS might have inhibited
+	 * them for a reason.
+	 */
+	if ((scontrol & 0xf00) != 0x300) {
+		scontrol |= 0x300;
+		piix_sidpr_write(dev0, SCR_CONTROL, scontrol);
+		scontrol = piix_sidpr_read(dev0, SCR_CONTROL);
+
+		if ((scontrol & 0xf00) != 0x300) {
+			dev_printk(KERN_INFO, host->dev, "SCR access via "
+				   "SIDPR is available but doesn't work\n");
+			return;
+		}
+	}
+
 	host->ports[0]->ops = &piix_sidpr_sata_ops;
 	host->ports[1]->ops = &piix_sidpr_sata_ops;
 }

-- 
