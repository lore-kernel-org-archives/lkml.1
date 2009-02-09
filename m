Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbZBID2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbZBID2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 22:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZBID2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 22:28:06 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:48338 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbZBID2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 22:28:05 -0500
Date: Sun, 8 Feb 2009 20:27:47 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] PCI/MSI: fix msi_mask() (rev. 2)
Message-ID: <20090209032747.GK31509@parisc-linux.org>
References: <498A5348.3090508@jp.fujitsu.com> <20090208112650.GD31509@parisc-linux.org> <498F89A7.9020208@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498F89A7.9020208@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 10:40:55AM +0900, Hidetoshi Seto wrote:
> The commit bffac3c593eba1f9da3efd0199e49ea6558a40ce ("PCI MSI: Fix
> undefined shift by 32") does:

I think the commit message could be worded somewhat better, and I think
I should be credited as the author of the patch.  How about this?

----

From: Matthew Wilcox <willy@linux.intel.com>

Hidetoshi Seto points out that commit
bffac3c593eba1f9da3efd0199e49ea6558a40ce has wrong values in the
array.  Rather than correct the array, we can just use a bounds check
and perform the calculation specified in the comment.  As a bonus, this
will not run off the end of the array if the device specifies an illegal
value in the MSI capcbility.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

----

 drivers/pci/msi.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 44f15ff..baba2eb 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -103,14 +103,12 @@ static void msix_set_enable(struct pci_dev *dev, int enable)
 	}
 }
 
-/*
- * Essentially, this is ((1 << (1 << x)) - 1), but without the
- * undefinedness of a << 32.
- */
 static inline __attribute_const__ u32 msi_mask(unsigned x)
 {
-	static const u32 mask[] = { 1, 2, 4, 0xf, 0xff, 0xffff, 0xffffffff };
-	return mask[x];
+	/* Don't shift by >= width of type */
+	if (x >= 5)
+		return 0xffffffff;
+	return (1 << (1 << x)) - 1;
 }
 
 static void msix_flush_writes(struct irq_desc *desc)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
