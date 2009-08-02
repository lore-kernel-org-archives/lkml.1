Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbZHBRPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbZHBRPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 13:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZHBRPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 13:15:52 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53723 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbZHBRPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 13:15:51 -0400
Date: Sun, 2 Aug 2009 11:15:51 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
Message-ID: <20090802171550.GC3711@parisc-linux.org>
References: <200908021619.48285.rjw@sisk.pl> <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 09:39:58AM -0700, Linus Torvalds wrote:
> Ooh, interesting. I thought that patch was a functionally equivalent 
> cleanup of
> 
> 	pr = pci_find_parent_resource(dev, r);
> 	if (!pr || request_resource(pr, r) < 0) {
> 
> to
> 
> 	if (pci_claim_resource(dev, idx) < 0) {
> 
> but yeah, it's not exactly the same. pci_claim_resource() uses 
> 'insert_resource()' rather than 'request_resource()'.

Yeah, I thought it was going to be the same too.  One way in which it
will differ is if the BIOS has assigned two resources which conflict in
such a way that they will nest if we call insert_resource twice.  I guess
if we fail the allocation, it will get reallocated by the driver later.

> We could certainly revert the commit, but I also wonder whether we should 
> just change 'pci_claim_resource()' to use request_resource() instead.
> 
> I _think_ the use of "insert_resource()" is purely historical, and is 
> because that broken function _used_ to not look up the parent, but instead 
> do that crazy "pcibios_select_root()" thing, and then it really does need 
> to recurse down and "insert" the resource in the right place.
> 
> We should no longer _need_ to do the "insert_resource()" thing, since we 
> are inserting it into the exact parent that we want (as of commit 
> cebd78a8c: "Fix pci_claim_resource").
> 
> And if that "insert_resource()" in pci_claim_resource() ever does anything 
> fancier than the raw "request_resource()", then that's a problem anyway.
> 
> Willy, comments? x86 historically has never used pci_claim_resource() at 
> all (it always open-coded the above) except for some quirk handling. So 
> I'm pretty sure that a patch like the below should be safe and correct. 
> But it's parisc machines that always seem to break.

Oh, parisc won't break on this.  This is a part of the PCI resource
allocation; the parisc problem comes further up in the hierarchy while
we're still dealing with parisc devices.  Something like this:

f0800000 - f08fffff Bus 8
  f0800000 - f08fffff Bus 8/2
    f0800000 - f08fffff PCI Root 8/2/0
      f0800000 - f080ffff PCI Device 0000:0a:1.0

So once we find the PCI Root in pci_claim_resource (and we will), we
don't have to worry about using insert_resource vs request_resource.

Now, I do worry about there being resources requested by some other bit of
code (say ACPI or PNP or something) which will cause failures, when what
should happen is that it should be reparented to the new PCI resource.
But since x86 has never done this, it shouldn't be a problem on x86.
Will it be a problem on any other architecture?  No idea.  But it won't
be a problem on parisc -- all the PCI devices are subordinate to or
disjoint from parisc resources.

> Added Andrew Patterson to the Cc, because his report was what caused us to 
> originally look at pci_claim_resource() and make it use 
> "pci_find_parent_resource()". We just never went whole hog, and we left 
> that broken "insert_resource()" around.
> 
> So Rafael and AndrewP, does this work for you? (I also moved the "dtype" 
> thing around, it bothered me).

It *might* break HP's ia64 machines.  I have this feeling that the serial
ports may be claimed in the resource tree before the PCI resources are
claimed (and then they need to nest under a PCI bus).

How about this variant which will insert_resource for _bus_ resources,
but request_resource for _device_ resources?

(I also got rid of the spurious 'of' in the dev_err message)

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index ec80b88..8384cb3 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -100,17 +100,21 @@ int pci_claim_resource(struct pci_dev *dev, int resource)
 {
 	struct resource *res = &dev->resource[resource];
 	struct resource *root;
-	char *dtype = resource < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
 	int err;
 
 	root = pci_find_parent_resource(dev, res);
 
 	err = -EINVAL;
-	if (root != NULL)
-		err = insert_resource(root, res);
+	if (root != NULL) {
+		if (resource < PCI_BRIDGE_RESOURCES)
+			err = request_resource(root, res);
+		else
+			err = insert_resource(root, res);
+	}
 
 	if (err) {
-		dev_err(&dev->dev, "BAR %d: %s of %s %pR\n",
+		const char *dtype = resource < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
+		dev_err(&dev->dev, "BAR %d: %s %s %pR\n",
 			resource,
 			root ? "address space collision on" :
 				"no parent found for",

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
