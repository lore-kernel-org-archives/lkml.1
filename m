Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbZHBQ72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbZHBQ72 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 12:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZHBQ71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 12:59:27 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59041 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbZHBQ70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 12:59:26 -0400
Date: Sun, 2 Aug 2009 10:59:26 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Wilcox <willy@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
Message-ID: <20090802165926.GB3711@parisc-linux.org>
References: <200908021619.48285.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908021619.48285.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 04:19:47PM +0200, Rafael J. Wysocki wrote:
> Hi Matthew,
> 
> As reported at
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=13891
> 
> there is a problem with allocating PCI resources on HP nx6325 introduced by
> your commit a76117dfd687ec4be0a9a05214f3009cc5f73a42
> (x86: Use pci_claim_resource).
> 
> On this particular box it causes the audio adapter's PCI memory space to
> be allocated for something else.

Could you also attach lspci -v?  It seems that the 0000:00:12.0 resource
is nesting inside the 0000:00:14.2 resource, which is just not possible.

Also, could you boot -rc5 (without
a76117dfd687ec4be0a9a05214f3009cc5f73a42 reverted) with this patch
applied?  It may give us some idea of what's going wrong.

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index ec80b88..3f422db 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -105,6 +105,10 @@ int pci_claim_resource(struct pci_dev *dev, int resource)
 
 	root = pci_find_parent_resource(dev, res);
 
+if (root)
+ printk("Inserting resource %s %pR (BAR %d) inside resource %s %pR\n", res->name, res, resource, root->name, root);
+else
+ printk("No parent found for resource %s %pR\n", res->name, res);
 	err = -EINVAL;
 	if (root != NULL)
 		err = insert_resource(root, res);

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
