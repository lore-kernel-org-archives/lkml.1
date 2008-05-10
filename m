Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbYEJVqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbYEJVqz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 17:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbYEJVqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 17:46:45 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:44054 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYEJVqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 17:46:44 -0400
Message-ID: <48261815.2010000@gmail.com>
Date: Sat, 10 May 2008 23:48:05 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Uwe Bugla <uwe.bugla@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Len Brown <len.brown@intel.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] PNP: cleanup pnp_fixup_device()
References: <481FAF79.2030407@keyaccess.nl> <200805061115.56737.bjorn.helgaas@hp.com>
In-Reply-To: <200805061115.56737.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.5 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-05-08 19:15, Bjorn Helgaas wrote:

> It's easier to comment if the patch is inline rather than attached.

I hope that works...

> I'm sort of attached to keeping this similar to pci_do_fixups() and
> keeping the symbol, even though the #ifdef is ugly. I do like getting
> rid of the "0x%p" and adding the PNP ID.

Okay. This better? Makes it a bit more similar even.

===
PNP: cleanup pnp_fixup_device()

Make it look a bit more like pci_fixup_device/pci_do_fixups. Also
print the PnP ID and delete the () from the "foo+0x0/0x1234()".

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
drivers/pnp/quirks.c |   20 ++++++++------------
1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index d049a22..a1af2f9 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -212,20 +212,16 @@ static struct pnp_fixup pnp_fixups[] = {

void pnp_fixup_device(struct pnp_dev *dev)
{
-	int i = 0;
-	void (*quirk)(struct pnp_dev *);
-
-	while (*pnp_fixups[i].id) {
-		if (compare_pnp_id(dev->id, pnp_fixups[i].id)) {
-			quirk = pnp_fixups[i].quirk_function;
+	struct pnp_fixup *f;

+	for (f = pnp_fixups; *f->id; f++) {
+		if (!compare_pnp_id(dev->id, f->id))
+			continue;
#ifdef DEBUG
-			dev_dbg(&dev->dev, "calling ");
-			print_fn_descriptor_symbol("%s()\n",
-				(unsigned long) *quirk);
+		dev_dbg(&dev->dev, "%s: calling ", f->id);
+		print_fn_descriptor_symbol("%s\n",
+				(unsigned long) f->quirk_function);
#endif
-			(*quirk)(dev);
-		}
-		i++;
+		f->quirk_function(dev);
	}
}


