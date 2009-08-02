Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZHBQkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZHBQkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 12:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbZHBQkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 12:40:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016AbZHBQkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 12:40:23 -0400
Date: Sun, 2 Aug 2009 09:39:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
In-Reply-To: <200908021619.48285.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain>
References: <200908021619.48285.rjw@sisk.pl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 2 Aug 2009, Rafael J. Wysocki wrote:
>
> Hi Matthew,
> 
> As reported at
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=13891
> 
> there is a problem with allocating PCI resources on HP nx6325 introduced by
> your commit a76117dfd687ec4be0a9a05214f3009cc5f73a42
> (x86: Use pci_claim_resource).

Ooh, interesting. I thought that patch was a functionally equivalent 
cleanup of

	pr = pci_find_parent_resource(dev, r);
	if (!pr || request_resource(pr, r) < 0) {

to

	if (pci_claim_resource(dev, idx) < 0) {

but yeah, it's not exactly the same. pci_claim_resource() uses 
'insert_resource()' rather than 'request_resource()'.

We could certainly revert the commit, but I also wonder whether we should 
just change 'pci_claim_resource()' to use request_resource() instead.

I _think_ the use of "insert_resource()" is purely historical, and is 
because that broken function _used_ to not look up the parent, but instead 
do that crazy "pcibios_select_root()" thing, and then it really does need 
to recurse down and "insert" the resource in the right place.

We should no longer _need_ to do the "insert_resource()" thing, since we 
are inserting it into the exact parent that we want (as of commit 
cebd78a8c: "Fix pci_claim_resource").

And if that "insert_resource()" in pci_claim_resource() ever does anything 
fancier than the raw "request_resource()", then that's a problem anyway.

Willy, comments? x86 historically has never used pci_claim_resource() at 
all (it always open-coded the above) except for some quirk handling. So 
I'm pretty sure that a patch like the below should be safe and correct. 
But it's parisc machines that always seem to break.

Added Andrew Patterson to the Cc, because his report was what caused us to 
originally look at pci_claim_resource() and make it use 
"pci_find_parent_resource()". We just never went whole hog, and we left 
that broken "insert_resource()" around.

So Rafael and AndrewP, does this work for you? (I also moved the "dtype" 
thing around, it bothered me).

			Linus

---
 drivers/pci/setup-res.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index b711fb7..1898c7b 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -100,16 +100,16 @@ int pci_claim_resource(struct pci_dev *dev, int resource)
 {
 	struct resource *res = &dev->resource[resource];
 	struct resource *root;
-	char *dtype = resource < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
 	int err;
 
 	root = pci_find_parent_resource(dev, res);
 
 	err = -EINVAL;
 	if (root != NULL)
-		err = insert_resource(root, res);
+		err = request_resource(root, res);
 
 	if (err) {
+		const char *dtype = resource < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
 		dev_err(&dev->dev, "BAR %d: %s of %s %pR\n",
 			resource,
 			root ? "address space collision on" :
