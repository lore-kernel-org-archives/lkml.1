Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbZCDSSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbZCDSSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZCDSRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:17:35 -0500
Received: from [213.79.90.228] ([213.79.90.228]:43914 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751438AbZCDSRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:17:32 -0500
X-Greylist: delayed 1830 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Mar 2009 13:17:31 EST
Date: Wed, 4 Mar 2009 20:46:58 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 02/11] sdhci: Add support for bus-specific IO memory
	accessors
Message-ID: <20090304174658.GA7477@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090206180520.GA16123@oksana.dev.rtsoft.ru> <20090206180645.GB11548@oksana.dev.rtsoft.ru> <20090208215020.46ca5724@mjolnir.drzeus.cx> <20090213144039.GA19572@oksana.dev.rtsoft.ru> <20090221165757.22747648@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090221165757.22747648@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 04:57:57PM +0100, Pierre Ossman wrote:
> On Fri, 13 Feb 2009 17:40:39 +0300
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > 
> > No, on eSDHC the registers are big-endian, 32-bit width, with, for
> > example, two 16-bit "logical" registers packed into it.
> > 
> > That is,
> > 
> >  0x4  0x5 0x6  0x7
> > |~~~~~~~~:~~~~~~~~|
> > | BLKCNT : BLKSZ  |
> > |________:________|
> >  31              0
> > 
> > ( The register looks wrong, right? BLKSZ should be at 0x4. But imagine
> >   that you swapped bytes in this 32 bit register... then the registers
> >   and their byte addresses will look normal. )
> > 
> > So if we try to issue readw(SDHCI_BLOCK_SIZE), i.e. readw(0x4):
> > 
> > - We'll read BLKCNT, while we wanted BLKSZ. This is because the
> >   address bits should be translated before we try word or byte
> >   reads/writes.
> > - On powerpc read{l,w}() convert the read value from little-endian
> >   to big-endian byte order, which is wrong for our case (the
> >   register is big-endian already).
> > 
> > That means that we have to convert address, but we don't want to
> > convert the result of read/write ops.
> > 
> 
> *cries*

:-)

[...]
> > > as far as I'm
> > > concerned, so I'd prefer something like:
> > > 
> > > if (!host->ops->writel)
> > > 	writel(host->ioaddr + reg, val);
> > > else
> > > 	host->ops->writel(host, val, reg);
> > 
> > Surely the overhead isn't measurable... but why we purposely make
> > things worse?
> > 
> 
> We can most likely do some micro-optimisation do make the compare part
> cheaper, but the point was to avoid a function call for all the
> properly implemented controllers out there. We could have a flag so
> that it only has to check host->flags, which will most likely be in the
> cache anyway.
> 
> Overhead for eSDHC is not a concern in my book, what is interesting is
> how much this change slows things down for other controllers.

OK, I see. Will the patch down below make you a little bit more happy
wrt normal controllers? Two #ifdefs, but then there is absolutely
zero overhead for the fully compliant SDHCI controllers.

(So far it's just on top of this series, but I can incorporate it
into the "sdhci: Add support for bus-specific IO memory accessors"
patch, if you like).

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 73b79e1..69bd124 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -37,6 +37,13 @@ config MMC_SDHCI
 
 	  If unsure, say N.
 
+config MMC_SDHCI_IO_ACCESSORS
+	bool
+	depends on MMC_SDHCI
+	help
+	  This is silent Kconfig symbol that is selected by the drivers that
+	  need to overwrite SDHCI IO memory accessors.
+
 config MMC_SDHCI_PCI
 	tristate "SDHCI support on PCI bus"
 	depends on MMC_SDHCI && PCI
@@ -68,6 +75,7 @@ config MMC_RICOH_MMC
 config MMC_SDHCI_OF
 	tristate "SDHCI support on OpenFirmware platforms"
 	depends on MMC_SDHCI && PPC_OF
+	select MMC_SDHCI_IO_ACCESSORS
 	help
 	  This selects the OF support for Secure Digital Host Controller
 	  Interfaces. So far, only the Freescale eSDHC controller is known
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 284bc5d..fb08d3b 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -88,60 +88,6 @@ static void sdhci_dumpregs(struct sdhci_host *host)
  *                                                                           *
 \*****************************************************************************/
 
-void sdhci_writel(struct sdhci_host *host, u32 val, int reg)
-{
-	if (unlikely(host->ops->writel))
-		host->ops->writel(host, val, reg);
-	else
-		writel(val, host->ioaddr + reg);
-}
-EXPORT_SYMBOL_GPL(sdhci_writel);
-
-void sdhci_writew(struct sdhci_host *host, u16 val, int reg)
-{
-	if (unlikely(host->ops->writew))
-		host->ops->writew(host, val, reg);
-	else
-		writew(val, host->ioaddr + reg);
-}
-EXPORT_SYMBOL_GPL(sdhci_writew);
-
-void sdhci_writeb(struct sdhci_host *host, u8 val, int reg)
-{
-	if (unlikely(host->ops->writeb))
-		host->ops->writeb(host, val, reg);
-	else
-		writeb(val, host->ioaddr + reg);
-}
-EXPORT_SYMBOL_GPL(sdhci_writeb);
-
-u32 sdhci_readl(struct sdhci_host *host, int reg)
-{
-	if (unlikely(host->ops->readl))
-		return host->ops->readl(host, reg);
-	else
-		return readl(host->ioaddr + reg);
-}
-EXPORT_SYMBOL_GPL(sdhci_readl);
-
-u16 sdhci_readw(struct sdhci_host *host, int reg)
-{
-	if (unlikely(host->ops->readw))
-		return host->ops->readw(host, reg);
-	else
-		return readw(host->ioaddr + reg);
-}
-EXPORT_SYMBOL_GPL(sdhci_readw);
-
-u8 sdhci_readb(struct sdhci_host *host, int reg)
-{
-	if (unlikely(host->ops->readb))
-		return host->ops->readb(host, reg);
-	else
-		return readb(host->ioaddr + reg);
-}
-EXPORT_SYMBOL_GPL(sdhci_readb);
-
 static void sdhci_clear_set_irqs(struct sdhci_host *host, u32 clear, u32 set)
 {
 	u32 ier;
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 1697e01..b6675df 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -281,12 +281,14 @@ struct sdhci_host {
 
 
 struct sdhci_ops {
+#ifdef CONFIG_MMC_SDHCI_IO_ACCESSORS
 	u32		(*readl)(struct sdhci_host *host, int reg);
 	u16		(*readw)(struct sdhci_host *host, int reg);
 	u8		(*readb)(struct sdhci_host *host, int reg);
 	void		(*writel)(struct sdhci_host *host, u32 val, int reg);
 	void		(*writew)(struct sdhci_host *host, u16 val, int reg);
 	void		(*writeb)(struct sdhci_host *host, u8 val, int reg);
+#endif
 
 	void	(*set_clock)(struct sdhci_host *host, unsigned int clock);
 
@@ -295,12 +297,89 @@ struct sdhci_ops {
 	unsigned int	(*get_timeout_clock)(struct sdhci_host *host);
 };
 
-extern void sdhci_writel(struct sdhci_host *host, u32 val, int reg);
-extern void sdhci_writew(struct sdhci_host *host, u16 val, int reg);
-extern void sdhci_writeb(struct sdhci_host *host, u8 val, int reg);
-extern u32 sdhci_readl(struct sdhci_host *host, int reg);
-extern u16 sdhci_readw(struct sdhci_host *host, int reg);
-extern u8 sdhci_readb(struct sdhci_host *host, int reg);
+#ifdef CONFIG_MMC_SDHCI_IO_ACCESSORS
+
+static inline void sdhci_writel(struct sdhci_host *host, u32 val, int reg)
+{
+	if (unlikely(host->ops->writel))
+		host->ops->writel(host, val, reg);
+	else
+		writel(val, host->ioaddr + reg);
+}
+
+static inline void sdhci_writew(struct sdhci_host *host, u16 val, int reg)
+{
+	if (unlikely(host->ops->writew))
+		host->ops->writew(host, val, reg);
+	else
+		writew(val, host->ioaddr + reg);
+}
+
+static inline void sdhci_writeb(struct sdhci_host *host, u8 val, int reg)
+{
+	if (unlikely(host->ops->writeb))
+		host->ops->writeb(host, val, reg);
+	else
+		writeb(val, host->ioaddr + reg);
+}
+
+static inline u32 sdhci_readl(struct sdhci_host *host, int reg)
+{
+	if (unlikely(host->ops->readl))
+		return host->ops->readl(host, reg);
+	else
+		return readl(host->ioaddr + reg);
+}
+
+static inline u16 sdhci_readw(struct sdhci_host *host, int reg)
+{
+	if (unlikely(host->ops->readw))
+		return host->ops->readw(host, reg);
+	else
+		return readw(host->ioaddr + reg);
+}
+
+static inline u8 sdhci_readb(struct sdhci_host *host, int reg)
+{
+	if (unlikely(host->ops->readb))
+		return host->ops->readb(host, reg);
+	else
+		return readb(host->ioaddr + reg);
+}
+
+#else
+
+static inline void sdhci_writel(struct sdhci_host *host, u32 val, int reg)
+{
+	writel(val, host->ioaddr + reg);
+}
+
+static inline void sdhci_writew(struct sdhci_host *host, u16 val, int reg)
+{
+	writew(val, host->ioaddr + reg);
+}
+
+static inline void sdhci_writeb(struct sdhci_host *host, u8 val, int reg)
+{
+	writeb(val, host->ioaddr + reg);
+}
+
+static inline u32 sdhci_readl(struct sdhci_host *host, int reg)
+{
+	return readl(host->ioaddr + reg);
+}
+
+static inline u16 sdhci_readw(struct sdhci_host *host, int reg)
+{
+	return readw(host->ioaddr + reg);
+}
+
+static inline u8 sdhci_readb(struct sdhci_host *host, int reg)
+{
+	return readb(host->ioaddr + reg);
+}
+
+#endif /* CONFIG_MMC_SDHCI_IO_ACCESSORS */
 
 extern struct sdhci_host *sdhci_alloc_host(struct device *dev,
 	size_t priv_size);
