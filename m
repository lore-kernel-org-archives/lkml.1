Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbZHBUPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbZHBUPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbZHBUPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:15:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37420 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbZHBUPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:15:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
Date: Sun, 2 Aug 2009 22:16:10 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Patterson <andrew.patterson@hp.com>
References: <200908021619.48285.rjw@sisk.pl> <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908022216.10681.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 August 2009, Linus Torvalds wrote:
> 
> On Sun, 2 Aug 2009, Rafael J. Wysocki wrote:
> >
> > Hi Matthew,
> > 
> > As reported at
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=13891
> > 
> > there is a problem with allocating PCI resources on HP nx6325 introduced by
> > your commit a76117dfd687ec4be0a9a05214f3009cc5f73a42
> > (x86: Use pci_claim_resource).
> 
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
> 
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
> 
> Added Andrew Patterson to the Cc, because his report was what caused us to 
> originally look at pci_claim_resource() and make it use 
> "pci_find_parent_resource()". We just never went whole hog, and we left 
> that broken "insert_resource()" around.
> 
> So Rafael and AndrewP, does this work for you? (I also moved the "dtype" 
> thing around, it bothered me).

It works, ie. with this patch applied the PCI resources on the nx6325 look
exactly like with commit  a76117dfd687ec4be0a9a05214f3009cc5f73a42 reverted.

Thanks,
Rafael

 
> ---
>  drivers/pci/setup-res.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
> index b711fb7..1898c7b 100644
> --- a/drivers/pci/setup-res.c
> +++ b/drivers/pci/setup-res.c
> @@ -100,16 +100,16 @@ int pci_claim_resource(struct pci_dev *dev, int resource)
>  {
>  	struct resource *res = &dev->resource[resource];
>  	struct resource *root;
> -	char *dtype = resource < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
>  	int err;
>  
>  	root = pci_find_parent_resource(dev, res);
>  
>  	err = -EINVAL;
>  	if (root != NULL)
> -		err = insert_resource(root, res);
> +		err = request_resource(root, res);
>  
>  	if (err) {
> +		const char *dtype = resource < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
>  		dev_err(&dev->dev, "BAR %d: %s of %s %pR\n",
>  			resource,
>  			root ? "address space collision on" :
> 
> 
