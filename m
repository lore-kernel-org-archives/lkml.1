Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbXEACq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbXEACq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 22:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbXEACq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 22:46:27 -0400
Received: from smtp-out.google.com ([216.239.45.13]:48518 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbXEACqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 22:46:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=nckvcFPM4v81kEWHXpsgtecKbw9L2r/V0BUsJ+dX1B3Lq+bO8ThKUKH/xx3wlkcdr
	a0Zxz7dHZxdSvIMe0/JtA==
Date: Mon, 30 Apr 2007 19:46:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [patch] pci: type may be unused in pci_access_init()
In-Reply-To: <20070430192250.1967a77b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704301934320.32426@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0704291659480.1822@chino.kir.corp.google.com>
 <20070430192250.1967a77b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007, Andrew Morton wrote:

> On Mon, 30 Apr 2007 07:34:52 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:
> 
> > The automatic 'type' variable is unused in !CONFIG_PCI_DIRECT and
> > !CONFIG_PCI_MMCONFIG.
> > 
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: David Rientjes <rientjes@google.com>
> > ---
> >  arch/i386/pci/init.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/i386/pci/init.c b/arch/i386/pci/init.c
> > --- a/arch/i386/pci/init.c
> > +++ b/arch/i386/pci/init.c
> > @@ -6,7 +6,7 @@
> 
> Please use `diff -p'.
> 

The patch would have appeared the same, pci_access_init() is the first 
function (and there are no prototypes) in arch/i386/pci/init.c and at line 
6 it had not yet begun.

diff -rupN a/init.c b/init.c
--- a/init.c	2007-04-30 19:28:59.887833000 -0700
+++ b/init.c	2007-04-30 19:29:26.615993000 -0700
@@ -6,7 +6,7 @@
    in the right sequence from here. */
 static __init int pci_access_init(void)
 {
-	int type = 0;
+	int type __attribute__((unused)) = 0;
 
 #ifdef CONFIG_PCI_DIRECT
 	type = pci_direct_probe();


> >  #ifdef CONFIG_PCI_DIRECT
> >  	type = pci_direct_probe();
> 
> Of course, one could do 
> 
> 	int type = pci_direct_probe();
> 
> here instead, but that's a bit fragile.
> 

No, because 'type' can be referenced in the !CONFIG_PCI_DIRECT and 
CONFIG_PCI_MMCONFIG case:

static __init int pci_access_init(void)
{
	int type = 0;

#ifdef CONFIG_PCI_DIRECT
	type = pci_direct_probe();
#endif
#ifdef CONFIG_PCI_MMCONFIG
	pci_mmcfg_init(type);
#endif

...

So, due to the whacky implementation of __attribute_used__, we can just do 
this:
---
 arch/i386/pci/init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/i386/pci/init.c b/arch/i386/pci/init.c
index b21b6da..508d6fd 100644
--- a/arch/i386/pci/init.c
+++ b/arch/i386/pci/init.c
@@ -6,7 +6,9 @@
    in the right sequence from here. */
 static __init int pci_access_init(void)
 {
+#if defined(CONFIG_PCI_DIRECT) || defined(CONFIG_PCI_MMCONFIG)
 	int type = 0;
+#endif
 
 #ifdef CONFIG_PCI_DIRECT
 	type = pci_direct_probe();
