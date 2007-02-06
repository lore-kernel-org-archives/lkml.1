Return-Path: <linux-kernel-owner+w=401wt.eu-S1751898AbXBFMzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbXBFMzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 07:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbXBFMzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 07:55:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:8164 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbXBFMzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 07:55:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Ehmu59CMUlC9srUym073BHtxLfGTjOUxZxRTOHnutmgW4CdpiQOL5uIeveriOnFglBygnJsq54FVeI4YjVSBX9TzsyV9LfroNs1202AAypGcUmJ/Y8CYlHdjkXx6EE6ggFqYWMymvDkLqCpnbl/Oq1CRJIdkBA12tHdIE+qy0Mo=
Date: Tue, 6 Feb 2007 15:52:59 +0300
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SUN3/3X Lance trivial fix
Message-ID: <20070206125259.GA10088@cvg>
References: <20070205191321.GA12839@cvg> <45C8683C.1070409@gmail.com> <45C86A57.4070308@gmail.com> <45C86AD8.20701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C86AD8.20701@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 12:47:36PM +0100, Jiri Slaby wrote:
| Jiri Slaby napsal(a):
| >Jiri Slaby napsal(a):
| >>Cyrill V. Gorcunov napsal(a):
| >>>This patch adds checking for allocated DVMA
| >>>memory and granted IRQ line.
| >>>
| >>>Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>
| >>>
| >>>---
| >>>
| >>> drivers/net/sun3lance.c |    9 ++++++++-
| >>> 1 files changed, 8 insertions(+), 1 deletions(-)
| >>>
| >>>diff --git a/drivers/net/sun3lance.c b/drivers/net/sun3lance.c
| >>>index c62e85d..e4c2c88 100644
| >>>--- a/drivers/net/sun3lance.c
| >>>+++ b/drivers/net/sun3lance.c
| >>>@@ -336,13 +336,20 @@ static int __init lance_probe( struct 
| >>>net_device *dev)
| >>> 
| >>>     /* XXX - leak? */
| >>>     MEM = dvma_malloc_align(sizeof(struct lance_memory), 0x10000);
| >>>+    if (MEM == NULL) {
| >>>+        printk(KERN_WARNING "SUN3 Lance couldn't allocate DVMA 
| >>>memory\n");
| 
| And also iounmap() here...
| 
| >>>+        return 0;
| >>>+    }
| >>> 
| >>>     lp->iobase = (volatile unsigned short *)ioaddr;
| >>>     dev->base_addr = (unsigned long)ioaddr; /* informational only */
| >>
| >>But now, if it fails (and you return 0=OK state) these are not assigned 
| >
| >Ok, 0 is not OK state, I see it now.
| >
| >>and probably used later.
| >>
| >>> 
| >>>     REGA(CSR0) = CSR0_STOP;
| >>> 
| >>>-    request_irq(LANCE_IRQ, lance_interrupt, IRQF_DISABLED, "SUN3 
| >>>Lance", dev);
| >>>+    if (request_irq(LANCE_IRQ, lance_interrupt, IRQF_DISABLED, "SUN3 
| >>>Lance", dev) < 0) {
| >>>+        printk(KERN_WARNING "SUN3 Lance unable to allocate IRQ\n");
| >
| >But in that case, you want to dvma_free() here?
| 
| And here.
| 
| >>>+        return 0;
| >>>+    }
| >>>     dev->irq = (unsigned short)LANCE_IRQ;
| 
| regards,
| -- 
| http://www.fi.muni.cz/~xslaby/            Jiri Slaby
| faculty of informatics, masaryk university, brno, cz
| e-mail: jirislaby gmail com, gpg pubkey fingerprint:
| B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Thanks a lot,

I'll fix it to get iounmap() used. I don't know is there any reason
to use dvma_free() - it's just a 'return' function. May be for further?
I think you are right - we should use dvma_free() anyway...

		Cyrill

