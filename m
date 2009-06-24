Return-Path: <linux-kernel-owner+w=401wt.eu-S1762202AbZFXTur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762202AbZFXTur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761188AbZFXTu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:50:29 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46851 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761948AbZFXTu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:50:28 -0400
Date: Wed, 24 Jun 2009 13:50:30 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Justin Mattock <justinmattock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: pci 0000:01:00.0: BAR 6: no parent found for of device
	[0xfffe0000-0xffffffff]
Message-ID: <20090624195030.GS19977@parisc-linux.org>
References: <dd18b0c30906241027u152274b1kd4c854ada4de33dd@mail.gmail.com> <200906242130.07583.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906242130.07583.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 09:30:07PM +0200, Rafael J. Wysocki wrote:
> (Adding CC to linux-pci)

Thanks Rafael.

> On Wednesday 24 June 2009, Justin Mattock wrote:
> > (just pulled the latest git)
> > And am seeing this:
> 
> Where pci 0000:01:00.0 and 0000:02:00.0 are what?
> 
> > [    0.696001] pci 0000:01:00.0: BAR 6: no parent found for of device
> > [0xfffe0000-0xffffffff]

So the message is coming from pci_claim_resource, and
if you bother to bisect, you'll track it back to my commit
a76117dfd687ec4be0a9a05214f3009cc5f73a42 .  What's going on here, since
this is BAR 6, is we have a ROM which has been mapped high, and then
not unmapped.  The BAR doesn't fit in the parent's window, so the code
is rightly declining to allocate the BAR.

Before my patch, we silently didn't allocate the BARs.  Now we print
a message.  I wonder what to do ... we could silence this warning in
pci_claim_resource (patch below).  Or we could declare this to be a bug,
and fix it by disabling the ROM BAR (by clearing bit 0).

I'm agnostic ... anyone have any preferences?

----

Silence spurious warning about ROM BARs

We shouldn't warn about not being able to allocate ROM BARs.  They are
often deliberately mapped outside the range of parent windows in order
to disable them.

Also fix the message to delete the spurious 'of'.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 1240351..d1b980c 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -109,8 +109,8 @@ int pci_claim_resource(struct pci_dev *dev, int resource)
 	if (root != NULL)
 		err = insert_resource(root, res);
 
-	if (err) {
-		dev_err(&dev->dev, "BAR %d: %s of %s %pR\n",
+	if (err && (resource != 6)) {
+		dev_err(&dev->dev, "BAR %d: %s %s %pR\n",
 			resource,
 			root ? "address space collision on" :
 				"no parent found for",

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
