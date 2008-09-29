Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbYI2RLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbYI2RLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 13:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbYI2RLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 13:11:08 -0400
Received: from colo.lackof.org ([198.49.126.79]:49883 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbYI2RLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 13:11:06 -0400
Date: Mon, 29 Sep 2008 11:10:49 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: introduce users of ioremap_pcibar()
Message-ID: <20080929171049.GA14409@colo.lackof.org>
References: <20080926163641.288bf868@infradead.org> <20080926163718.32f0867e@infradead.org> <20080929072643.GA28871@colo.lackof.org> <20080929064220.374c68a4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929064220.374c68a4@infradead.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 06:42:20AM -0700, Arjan van de Ven wrote:
...
> > This patch changes that behavior of the device driver so it uses
> > uncacheable instead of cacheable mappings.  This is the only thing
> > I'm uncertain about for this patch.
> 
> ioremap() also is uncachable today.

Ok...it was using cacheable mapping on ia64 until this commit in 2007:
    http://www.gelato.unsw.edu.au/archives/linux-ia64/0703/20211.html

I stopped paying close attention  on ia64 in 2006 for the most part.
It's always been uncacheable on parisc.

After finding willy's patch (March 2006) on lwn.net, I remember the
discussion around changing the behavior of ioremap() to be uncached:
    http://lwn.net/Articles/178084/

And I have to agree with willy/alan, pci_iomap() is already doing this.

However, pci_iomap() isn't quite right either:
        if (flags & IORESOURCE_MEM) {
                if (flags & IORESOURCE_CACHEABLE)
                        return ioremap(start, len);
                return ioremap_nocache(start, len);
        }

I expect it needs to use ioremap_cache() instead of ioremap().
One line patch below fixes that. Build-tested on x86 only.

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>

> > And I have a second issue less important issue.
> > What is the result of ioremap_pcibar(pci, 1) when BAR0 is a 64-bit
> > bar? Given the name, I expect to call "ioremap_pcibar(pci,2)" to get
> > the desired result.  Maybe just document how to handle this correctly
> > in Documentation/pci.txt would be sufficient.
> 
> we should detect this and DTRT inside the implementation, not in the
> drivers.

pci_iomap() is already doing this. See lib/iomap.c:pci_iomap().

thanks,
grant


diff --git a/lib/iomap.c b/lib/iomap.c
index d322293..5565cf9 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -267,7 +267,7 @@ void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 		return ioport_map(start, len);
 	if (flags & IORESOURCE_MEM) {
 		if (flags & IORESOURCE_CACHEABLE)
-			return ioremap(start, len);
+			return ioremap_cache(start, len);
 		return ioremap_nocache(start, len);
 	}
 	/* What? */
