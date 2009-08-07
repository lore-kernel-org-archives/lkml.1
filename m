Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbZHGSTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbZHGSTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 14:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932146AbZHGSTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 14:19:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929AbZHGSTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 14:19:04 -0400
Date: Fri, 7 Aug 2009 11:15:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Manuel Lauss <mano@roarinelk.homelinux.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
In-Reply-To: <20090805170934.GA32274@roarinelk.homelinux.net>
Message-ID: <alpine.LFD.2.01.0908071051300.3390@localhost.localdomain>
References: <200908021619.48285.rjw@sisk.pl> <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain> <20090803165909.GA12824@roarinelk.homelinux.net> <alpine.LFD.2.01.0908041555120.3270@localhost.localdomain> <20090805155102.GA31646@roarinelk.homelinux.net>
 <alpine.LFD.2.01.0908050902300.3390@localhost.localdomain> <alpine.LFD.2.01.0908050931390.3390@localhost.localdomain> <20090805170934.GA32274@roarinelk.homelinux.net>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 5 Aug 2009, Manuel Lauss wrote:
> 
> On Wed, Aug 05, 2009 at 09:38:52AM -0700, Linus Torvalds wrote:
> > 
> > Manuel, could you compile your kernel with CONFIG_PCI_DEBUG enabled, and
> > then boot it with "pci=earlydump", and send me the dmesg of a kernel boot? 
> 
> Linux version 2.6.31-rc5-00246-g90bc1a6 (mano@scarran) (gcc version 4.3.3 (Gentoo 4.3.3-r2 p1.1) ) #1 Wed Aug 5 18:57:04 CEST 2009

Thanks, sorry for the delay.

> pci 0000:00:1e.0 config space:
>   00: 86 80 48 24 07 01 80 80 83 00 04 06 00 00 01 00
>   10: 00 00 00 00 00 00 00 00 00 02 02 40 d0 d0 80 22
>   20: 60 ff 60 ff a0 de a0 de 00 00 00 00 00 00 00 00

Ok, this is your PCI-PCI bridge to Bus#2, and it has two memory windows:

	pci 0000:00:1e.0: transparent bridge
	pci 0000:00:1e.0: bridge io port: [0xd000-0xdfff]
	pci 0000:00:1e.0: bridge 32bit mmio: [0xff600000-0xff6fffff]
	pci 0000:00:1e.0: bridge 32bit mmio pref: [0xdea00000-0xdeafffff]

so I was wrong - that 0xff600000-0xff6fffff is non-prefetchable.

So I'm really not seeing why you then et that

	pci 0000:02:03.0: BAR 6: address space collision on of device [0xff680000-0xff69ffff]

because while we've marked the ROM window prefetchable, it should fit 
perfectly fine into a non-prefetchable PCI bus window.

Odd.

Mind trying this patch? It hacks up %pR to print out more of the resource 
information, and also makes your failure case print out the root resource 
we're trying to insert into. 

			Linus
---
 drivers/pci/setup-res.c |   19 ++++++++++---------
 lib/vsprintf.c          |    4 +++-
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 1898c7b..ab9ad65 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -98,23 +98,24 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 
 int pci_claim_resource(struct pci_dev *dev, int resource)
 {
+	const char *dtype = resource < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
 	struct resource *res = &dev->resource[resource];
 	struct resource *root;
 	int err;
 
 	root = pci_find_parent_resource(dev, res);
 
-	err = -EINVAL;
-	if (root != NULL)
-		err = request_resource(root, res);
+	if (!root) {
+		dev_err(&dev->dev, "BAR %d: no parent resource for %s resource %pR\n",
+			resource, dtype, res);
+		return -EINVAL;
+	}
+
+	err = request_resource(root, res);
 
 	if (err) {
-		const char *dtype = resource < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
-		dev_err(&dev->dev, "BAR %d: %s of %s %pR\n",
-			resource,
-			root ? "address space collision on" :
-				"no parent found for",
-			dtype, res);
+		dev_err(&dev->dev, "BAR %d: unable to insert %s resource %pR in %pR\n",
+			resource, dtype, res, root);
 	}
 
 	return err;
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 756ccaf..aadf760 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -609,7 +609,7 @@ static char *resource_string(char *buf, char *end, struct resource *res,
 		.flags = SPECIAL | SMALL | ZEROPAD,
 	};
 	/* room for the actual numbers, the two "0x", -, [, ] and the final zero */
-	char sym[4*sizeof(resource_size_t) + 8];
+	char sym[4*sizeof(resource_size_t) + 8 + 9];
 	char *p = sym, *pend = sym + sizeof(sym);
 	int size = -1;
 
@@ -623,6 +623,8 @@ static char *resource_string(char *buf, char *end, struct resource *res,
 	p = number(p, pend, res->start, num_spec);
 	*p++ = '-';
 	p = number(p, pend, res->end, num_spec);
+	*p++ = ':';
+	p = number(p, pend, res->flags, num_spec);
 	*p++ = ']';
 	*p = 0;
 
