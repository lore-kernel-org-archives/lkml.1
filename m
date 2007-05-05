Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbXEEStY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbXEEStY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbXEEStY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:49:24 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754658AbXEEStW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:49:22 -0400
Date: Sat, 5 May 2007 11:48:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: 2.6.21-mm1
Message-Id: <20070505114811.f824c902.akpm@linux-foundation.org>
In-Reply-To: <463CA74C.8080008@gmail.com>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
	<463CA74C.8080008@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 May 2007 17:48:28 +0200 Maciej Rutecki <maciej.rutecki@gmail.com> wrote:

> Andrew Morton pisze:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> > 
> > 
> 
> CC [M]  lib/zlib_deflate/deflate_syms.o
>   LD [M]  lib/zlib_deflate/zlib_deflate.o
>   Building modules, stage 2.
>   MODPOST 791 modules
> ERROR: "ssb_pcihost_register" [drivers/net/b44.ko] undefined!
> ERROR: "ssb_pcihost_unregister" [drivers/net/b44.ko] undefined!
> make[2]: *** [__modpost] Error 1
> make[1]: *** [modules] Error 2
> make[1]: Leaving directory `/usr/src/linux-mm'
> make: *** [debian/stamp-build-kernel] Error 2
> 
> Config:
> http://www.unixy.pl/maciek/download/kernel/2.6.21-mm1/config-2.6.21-mm1.gz
> 

OK, thanks.  I assume that's a Kconfig mistake in the wireless tree.

But it looks like a real minefield:


+static inline void b44_pci_exit(void)
+{
+#ifdef CONFIG_B44_PCI
+	ssb_pcihost_unregister(&b44_pci_driver);
+#endif
+}

and

+#ifdef CONFIG_BCM43XX_MAC80211_PCI
+	ssb_pcihost_unregister(&bcm43xx_pci_driver);
+#endif

and

+#ifdef CONFIG_SSB_PCIHOST
+/* PCI-host wrapper driver */
+extern int ssb_pcihost_register(struct pci_driver *driver);
+static inline void ssb_pcihost_unregister(struct pci_driver *driver)
+{
+	pci_unregister_driver(driver);
+}
+#endif /* CONFIG_SSB_PCIHOST */


That looks waaaaaay more complicated than it needs to be.

I'm thinking that the first two ifdefs should be removed and that third one
needs a #else clause which implements stubs and that b44 Kconfig needs to
be taught about CONFIG_SSB_PCIHOST in some fashion.

Or something like that.
