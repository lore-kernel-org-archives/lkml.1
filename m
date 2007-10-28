Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbXJ1UCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbXJ1UCw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 16:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbXJ1UCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 16:02:44 -0400
Received: from lixom.net ([66.141.50.11]:33163 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbXJ1UCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 16:02:40 -0400
Date: Sun, 28 Oct 2007 15:10:34 -0500
From: Olof Johansson <olof@lixom.net>
To: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] pcmcia: Remove replace kio_addr_t with unsigned int
	everywhere
Message-ID: <20071028201034.GB9472@lixom.net>
References: <20070905142742.GA1760@lixom.net> <20070914034854.1658a9cf.akpm@linux-foundation.org> <20070921221516.GA7926@lixom.net> <20070921233936.2aeb2504@the-village.bc.nu> <20070922062551.GE10625@parisc-linux.org> <20070922091303.GA12525@lst.de> <20071019201720.GA13234@lixom.net> <20071028134414.GF26943@isilmar.linta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028134414.GF26943@isilmar.linta.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pcmcia: Remove replace kio_addr_t with unsigned int everywhere

Remove kio_addr_t, and replace it with unsigned int. No known architecture
needs more than 32 bits for IO addresses and ports and having a separate
type for it is just messy.

This goes on top of the patch switching the io_req_t members from ioaddr_t
to unsigned int.


Signed-off-by: Olof Johansson <olof@lixom.net>

---

On Sun, Oct 28, 2007 at 02:44:14PM +0100, Dominik Brodowski wrote:
> On Fri, Oct 19, 2007 at 03:17:20PM -0500, Olof Johansson wrote:
> > Convert the io_req_t members to unsigned int, to allow use on machines
> > with more than 16 bits worth of IO ports (i.e. secondary busses on
> > ppc64, etc).
> 
> Agreed, though I'd prefer if we got rid of kio_addr_t at the same time, and
> convert its users to unsigned int as well -- as was pointed out earlier in
> this thread, there's no known usage of IO ports larger than 32 bits.

Ok. I prefer to do that as a separate patch though, the former
is a functional change I need for my platform, the second is just
janitorial. The first one still applies to mainline git, so I won't
repost it.


-Olof

diff --git a/Documentation/pcmcia/driver-changes.txt b/Documentation/pcmcia/driver-changes.txt
index 4739c5c..96f155e 100644
--- a/Documentation/pcmcia/driver-changes.txt
+++ b/Documentation/pcmcia/driver-changes.txt
@@ -33,8 +33,8 @@ This file details changes in 2.6 which affect PCMCIA card driver authors:
    and can be used (e.g. for SET_NETDEV_DEV) by using
    handle_to_dev(client_handle_t * handle).
 
-* Convert internal I/O port addresses to unsigned long (as of 2.6.11)
-   ioaddr_t should be replaced by kio_addr_t in PCMCIA card drivers.
+* Convert internal I/O port addresses to unsigned int (as of 2.6.11)
+   ioaddr_t should be replaced by unsigned int in PCMCIA card drivers.
 
 * irq_mask and irq_list parameters (as of 2.6.11)
    The irq_mask and irq_list parameters should no longer be used in
diff --git a/drivers/bluetooth/bt3c_cs.c b/drivers/bluetooth/bt3c_cs.c
index a18f9b8..7703d6e 100644
--- a/drivers/bluetooth/bt3c_cs.c
+++ b/drivers/bluetooth/bt3c_cs.c
@@ -704,7 +704,7 @@ static int next_tuple(struct pcmcia_device *handle, tuple_t *tuple, cisparse_t *
 
 static int bt3c_config(struct pcmcia_device *link)
 {
-	static kio_addr_t base[5] = { 0x3f8, 0x2f8, 0x3e8, 0x2e8, 0x0 };
+	static unsigned int base[5] = { 0x3f8, 0x2f8, 0x3e8, 0x2e8, 0x0 };
 	bt3c_info_t *info = link->priv;
 	tuple_t tuple;
 	u_short buf[256];
diff --git a/drivers/bluetooth/btuart_cs.c b/drivers/bluetooth/btuart_cs.c
index 08f48d5..60376df 100644
--- a/drivers/bluetooth/btuart_cs.c
+++ b/drivers/bluetooth/btuart_cs.c
@@ -634,7 +634,7 @@ static int next_tuple(struct pcmcia_device *handle, tuple_t *tuple, cisparse_t *
 
 static int btuart_config(struct pcmcia_device *link)
 {
-	static kio_addr_t base[5] = { 0x3f8, 0x2f8, 0x3e8, 0x2e8, 0x0 };
+	static unsigned int base[5] = { 0x3f8, 0x2f8, 0x3e8, 0x2e8, 0x0 };
 	btuart_info_t *info = link->priv;
 	tuple_t tuple;
 	u_short buf[256];
diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index dd26bc9..ec69df0 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -1408,7 +1408,7 @@ static int cmm_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 		     unsigned long arg)
 {
 	struct cm4000_dev *dev = filp->private_data;
-	unsigned in iobase = dev->p_dev->io.BasePort1;
+	unsigned int iobase = dev->p_dev->io.BasePort1;
 	struct pcmcia_device *link;
 	int size;
 	int rc;
diff --git a/drivers/net/pcmcia/3c574_cs.c b/drivers/net/pcmcia/3c574_cs.c
index 73dcbb7..720bc06 100644
--- a/drivers/net/pcmcia/3c574_cs.c
+++ b/drivers/net/pcmcia/3c574_cs.c
@@ -228,10 +228,11 @@ static char mii_preamble_required = 0;
 static int tc574_config(struct pcmcia_device *link);
 static void tc574_release(struct pcmcia_device *link);
 
-static void mdio_sync(kio_addr_t ioaddr, int bits);
-static int mdio_read(kio_addr_t ioaddr, int phy_id, int location);
-static void mdio_write(kio_addr_t ioaddr, int phy_id, int location, int value);
-static unsigned short read_eeprom(kio_addr_t ioaddr, int index);
+static void mdio_sync(unsigned int ioaddr, int bits);
+static int mdio_read(unsigned int ioaddr, int phy_id, int location);
+static void mdio_write(unsigned int ioaddr, int phy_id, int location,
+		       int value);
+static unsigned short read_eeprom(unsigned int ioaddr, int index);
 static void tc574_wait_for_completion(struct net_device *dev, int cmd);
 
 static void tc574_reset(struct net_device *dev);
@@ -339,7 +340,7 @@ static int tc574_config(struct pcmcia_device *link)
 	tuple_t tuple;
 	unsigned short buf[32];
 	int last_fn, last_ret, i, j;
-	kio_addr_t ioaddr;
+	unsigned int ioaddr;
 	u16 *phys_addr;
 	char *cardname;
 	union wn3_config config;
@@ -512,7 +513,7 @@ static int tc574_resume(struct pcmcia_device *link)
 
 static void dump_status(struct net_device *dev)
 {
-	kio_addr_t ioaddr = dev->base_addr;
+	unsigned int ioaddr = dev->base_addr;
 	EL3WINDOW(1);
 	printk(KERN_INFO "  irq status %04x, rx status %04x, tx status "
 		   "%02x, tx free %04x\n", inw(ioaddr+EL3_STATUS),
@@ -541,7 +542,7 @@ static void tc574_wait_for_completion(struct net_device *dev, int cmd)
 /* Read a word from the EEPROM using the regular EEPROM access register.
    Assume that we are in register window zero.
  */
-static unsigned short read_eeprom(kio_addr_t ioaddr, int index)
+static unsigned short read_eeprom(unsigned int ioaddr, int index)
 {
 	int timer;
 	outw(EEPROM_Read + index, ioaddr + Wn0EepromCmd);
@@ -569,9 +570,9 @@ static unsigned short read_eeprom(kio_addr_t ioaddr, int index)
 
 /* Generate the preamble required for initial synchronization and
    a few older transceivers. */
-static void mdio_sync(kio_addr_t ioaddr, int bits)
+static void mdio_sync(unsigned int ioaddr, int bits)
 {
-	kio_addr_t mdio_addr = ioaddr + Wn4_PhysicalMgmt;
+	unsigned int mdio_addr = ioaddr + Wn4_PhysicalMgmt;
 
 	/* Establish sync by sending at least 32 logic ones. */
 	while (-- bits >= 0) {
@@ -580,12 +581,12 @@ static void mdio_sync(kio_addr_t ioaddr, int bits)
 	}
 }
 
-static int mdio_read(kio_addr_t ioaddr, int phy_id, int location)
+static int mdio_read(unsigned int ioaddr, int phy_id, int location)
 {
 	int i;
 	int read_cmd = (0xf6 << 10) | (phy_id << 5) | location;
 	unsigned int retval = 0;
-	kio_addr_t mdio_addr = ioaddr + Wn4_PhysicalMgmt;
+	unsigned int mdio_addr = ioaddr + Wn4_PhysicalMgmt;
 
 	if (mii_preamble_required)
 		mdio_sync(ioaddr, 32);
@@ -605,10 +606,10 @@ static int mdio_read(kio_addr_t ioaddr, int phy_id, int location)
 	return (retval>>1) & 0xffff;
 }
 
-static void mdio_write(kio_addr_t ioaddr, int phy_id, int location, int value)
+static void mdio_write(unsigned int ioaddr, int phy_id, int location, int value)
 {
 	int write_cmd = 0x50020000 | (phy_id << 23) | (location << 18) | value;
-	kio_addr_t mdio_addr = ioaddr + Wn4_PhysicalMgmt;
+	unsigned int mdio_addr = ioaddr + Wn4_PhysicalMgmt;
 	int i;
 
 	if (mii_preamble_required)
@@ -634,7 +635,7 @@ static void tc574_reset(struct net_device *dev)
 {
 	struct el3_private *lp = netdev_priv(dev);
 	int i;
-	kio_addr_t ioaddr = dev->base_addr;
+	unsigned int ioaddr = dev->base_addr;
 	unsigned long flags;
 
 	tc574_wait_for_completion(dev, TotalReset|0x10);
@@ -738,7 +739,7 @@ static int el3_open(struct net_device *dev)
 static void el3_tx_timeout(struct net_device *dev)
 {
 	struct el3_private *lp = netdev_priv(dev);
-	kio_addr_t ioaddr = dev->base_addr;
+	unsigned int ioaddr = dev->base_addr;
 	
 	printk(KERN_NOTICE "%s: Transmit timed out!\n", dev->name);
 	dump_status(dev);
@@ -753,7 +754,7 @@ static void el3_tx_timeout(struct net_device *dev)
 static void pop_tx_status(struct net_device *dev)
 {
 	struct el3_private *lp = netdev_priv(dev);
-	kio_addr_t ioaddr = dev->base_addr;
+	unsigned int ioaddr = dev->base_addr;
 	int i;
     
 	/* Clear the Tx status stack. */
@@ -776,7 +777,7 @@ static void pop_tx_status(struct net_device *dev)
 
 static int el3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	kio_addr_t ioaddr = dev->base_addr;
+	unsigned int ioaddr = dev->base_addr;
 	struct el3_private *lp = netdev_priv(dev);
 	unsigned long flags;
 
@@ -810,7 +811,7 @@ static irqreturn_t el3_interrupt(int irq, void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct el3_private *lp = netdev_priv(dev);
-	kio_addr_t ioaddr;
+	unsigned int ioaddr;
 	unsigned status;
 	int work_budget = max_interrupt_work;
 	int handled = 0;
@@ -904,7 +905,7 @@ static void media_check(unsigned long arg)
 {
 	struct net_device *dev = (struct net_device *) arg;
 	struct el3_private *lp = netdev_priv(dev);
-	kio_addr_t ioaddr = dev->base_addr;
+	unsigned int ioaddr = dev->base_addr;
 	unsigned long flags;
 	unsigned short /* cable, */ media, partner;
 
@@ -993,7 +994,7 @@ static struct net_device_stats *el3_get_stats(struct net_device *dev)
 static void update_stats(struct net_device *dev)
 {
 	struct el3_private *lp = netdev_priv(dev);
-	kio_addr_t ioaddr = dev->base_addr;
+	unsigned int ioaddr = dev->base_addr;
 	u8 rx, tx, up;
 
 	DEBUG(2, "%s: updating the statistics.\n", dev->name);
@@ -1030,7 +1031,7 @@ static void update_stats(struct net_device *dev)
 static int el3_rx(struct net_device *dev, int worklimit)
 {
 	struct el3_private *lp = netdev_priv(dev);
-	kio_addr_t ioaddr = dev->base_addr;
+	unsigned int ioaddr = dev->base_addr;
 	short rx_status;
 	
 	DEBUG(3, "%s: in rx_packet(), status %4.4x, rx_status %4.4x.\n",
@@ -1091,7 +1092,7 @@ static const struct ethtool_ops netdev_ethtool_ops = {
 static int el3_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
 	struct el3_private *lp = netdev_priv(dev);
-	kio_addr_t ioaddr = dev->base_addr;
+	unsigned int ioaddr = dev->base_addr;
 	u16 *data = (u16 *)&rq->ifr_ifru;
 	int phy = lp->phys & 0x1f;
 
@@ -1145,7 +1146,7 @@ static int el3_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 static void set_rx_mode(struct net_device *dev)
 {
-	kio_addr_t ioaddr = dev->base_addr;
+	unsigned int ioaddr = dev->base_addr;
 
 	if (dev->flags & IFF_PROMISC)
 		outw(SetRxFilter | RxStation | RxMulticast | RxBroadcast | RxProm,
@@ -1158,7 +1159,7 @@ static void set_rx_mode(struct net_device *dev)
 
 static int el3_close(struct net_device *dev)
 {
-	kio_addr_t ioaddr = dev->base_addr;
+	unsigned int ioaddr = dev->base_addr;
 	struct el3_private *lp = netdev_priv(dev);
 	struct pcmcia_device *link = lp->p_dev;
 
diff --git a/drivers/net/pcmcia/3c589_cs.c b/drivers/net/pcmcia/3c589_cs.c
index 32076ca..c9e9b2b 100644
--- a/drivers/net/pcmcia/3c589_cs.c
+++ b/drivers/net/pcmcia/3c589_cs.c
@@ -145,7 +145,7 @@ DRV_NAME ".c " DRV_VERSION " 2001/10/13 00:08:50 (David Hinds)";
 static int tc589_config(struct pcmcia_device *link);
 static void tc589_release(struct pcmcia_device *link);
 
-static u16 read_eeprom(kio_addr_t ioaddr, int index);
+static u16 read_eeprom(unsigned int ioaddr, int index);
 static void tc589_reset(struct net_device *dev);
 static void media_check(unsigned long arg);
 static int el3_config(struct net_device *dev, struct ifmap *map);
@@ -253,7 +253,7 @@ static int tc589_config(struct pcmcia_device *link)
     tuple_t tuple;
     u16 buf[32], *phys_addr;
     int last_fn, last_ret, i, j, multi = 0, fifo;
-    kio_addr_t ioaddr;
+    unsigned int ioaddr;
     char *ram_split[] = {"5:3", "3:1", "1:1", "3:5"};
     DECLARE_MAC_BUF(mac);
     
@@ -402,7 +402,7 @@ static void tc589_wait_for_completion(struct net_device *dev, int cmd)
   Read a word from the EEPROM using the regular EEPROM access register.
   Assume that we are in register window zero.
 */
-static u16 read_eeprom(kio_addr_t ioaddr, int index)
+static u16 read_eeprom(unsigned int ioaddr, int index)
 {
     int i;
     outw(EEPROM_READ + index, ioaddr + 10);
@@ -420,7 +420,7 @@ static u16 read_eeprom(kio_addr_t ioaddr, int index)
 static void tc589_set_xcvr(struct net_device *dev, int if_port)
 {
     struct el3_private *lp = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     
     EL3WINDOW(0);
     switch (if_port) {
@@ -442,7 +442,7 @@ static void tc589_set_xcvr(struct net_device *dev, int if_port)
 
 static void dump_status(struct net_device *dev)
 {
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     EL3WINDOW(1);
     printk(KERN_INFO "  irq status %04x, rx status %04x, tx status "
 	   "%02x  tx free %04x\n", inw(ioaddr+EL3_STATUS),
@@ -458,7 +458,7 @@ static void dump_status(struct net_device *dev)
 /* Reset and restore all of the 3c589 registers. */
 static void tc589_reset(struct net_device *dev)
 {
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     int i;
     
     EL3WINDOW(0);
@@ -566,7 +566,7 @@ static int el3_open(struct net_device *dev)
 static void el3_tx_timeout(struct net_device *dev)
 {
     struct el3_private *lp = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     
     printk(KERN_WARNING "%s: Transmit timed out!\n", dev->name);
     dump_status(dev);
@@ -581,7 +581,7 @@ static void el3_tx_timeout(struct net_device *dev)
 static void pop_tx_status(struct net_device *dev)
 {
     struct el3_private *lp = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     int i;
     
     /* Clear the Tx status stack. */
@@ -603,7 +603,7 @@ static void pop_tx_status(struct net_device *dev)
 
 static int el3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     struct el3_private *priv = netdev_priv(dev);
     unsigned long flags;
 
@@ -640,7 +640,7 @@ static irqreturn_t el3_interrupt(int irq, void *dev_id)
 {
     struct net_device *dev = (struct net_device *) dev_id;
     struct el3_private *lp = netdev_priv(dev);
-    kio_addr_t ioaddr;
+    unsigned int ioaddr;
     __u16 status;
     int i = 0, handled = 1;
     
@@ -726,7 +726,7 @@ static void media_check(unsigned long arg)
 {
     struct net_device *dev = (struct net_device *)(arg);
     struct el3_private *lp = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     u16 media, errs;
     unsigned long flags;
 
@@ -827,7 +827,7 @@ static struct net_device_stats *el3_get_stats(struct net_device *dev)
 static void update_stats(struct net_device *dev)
 {
     struct el3_private *lp = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
 
     DEBUG(2, "%s: updating the statistics.\n", dev->name);
     /* Turn off statistics updates while reading. */
@@ -854,7 +854,7 @@ static void update_stats(struct net_device *dev)
 static int el3_rx(struct net_device *dev)
 {
     struct el3_private *lp = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     int worklimit = 32;
     short rx_status;
     
@@ -908,7 +908,7 @@ static void set_multicast_list(struct net_device *dev)
 {
     struct el3_private *lp = netdev_priv(dev);
     struct pcmcia_device *link = lp->p_dev;
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     u16 opts = SetRxFilter | RxStation | RxBroadcast;
 
     if (!pcmcia_dev_present(link)) return;
@@ -923,7 +923,7 @@ static int el3_close(struct net_device *dev)
 {
     struct el3_private *lp = netdev_priv(dev);
     struct pcmcia_device *link = lp->p_dev;
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     
     DEBUG(1, "%s: shutting down ethercard.\n", dev->name);
 
diff --git a/drivers/net/pcmcia/axnet_cs.c b/drivers/net/pcmcia/axnet_cs.c
index a95a2ca..a05963a 100644
--- a/drivers/net/pcmcia/axnet_cs.c
+++ b/drivers/net/pcmcia/axnet_cs.c
@@ -96,8 +96,8 @@ static irqreturn_t ei_irq_wrapper(int irq, void *dev_id);
 static void ei_watchdog(u_long arg);
 static void axnet_reset_8390(struct net_device *dev);
 
-static int mdio_read(kio_addr_t addr, int phy_id, int loc);
-static void mdio_write(kio_addr_t addr, int phy_id, int loc, int value);
+static int mdio_read(unsigned int addr, int phy_id, int loc);
+static void mdio_write(unsigned int addr, int phy_id, int loc, int value);
 
 static void get_8390_hdr(struct net_device *,
 			 struct e8390_pkt_hdr *, int);
@@ -203,7 +203,7 @@ static void axnet_detach(struct pcmcia_device *link)
 static int get_prom(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     int i, j;
 
     /* This is based on drivers/net/ne.c */
@@ -473,7 +473,7 @@ static int axnet_resume(struct pcmcia_device *link)
 #define MDIO_MASK		0x0f
 #define MDIO_ENB_IN		0x02
 
-static void mdio_sync(kio_addr_t addr)
+static void mdio_sync(unsigned int addr)
 {
     int bits;
     for (bits = 0; bits < 32; bits++) {
@@ -482,7 +482,7 @@ static void mdio_sync(kio_addr_t addr)
     }
 }
 
-static int mdio_read(kio_addr_t addr, int phy_id, int loc)
+static int mdio_read(unsigned int addr, int phy_id, int loc)
 {
     u_int cmd = (0xf6<<10)|(phy_id<<5)|loc;
     int i, retval = 0;
@@ -501,7 +501,7 @@ static int mdio_read(kio_addr_t addr, int phy_id, int loc)
     return (retval>>1) & 0xffff;
 }
 
-static void mdio_write(kio_addr_t addr, int phy_id, int loc, int value)
+static void mdio_write(unsigned int addr, int phy_id, int loc, int value)
 {
     u_int cmd = (0x05<<28)|(phy_id<<23)|(loc<<18)|(1<<17)|value;
     int i;
@@ -575,7 +575,7 @@ static int axnet_close(struct net_device *dev)
 
 static void axnet_reset_8390(struct net_device *dev)
 {
-    kio_addr_t nic_base = dev->base_addr;
+    unsigned int nic_base = dev->base_addr;
     int i;
 
     ei_status.txing = ei_status.dmaing = 0;
@@ -610,8 +610,8 @@ static void ei_watchdog(u_long arg)
 {
     struct net_device *dev = (struct net_device *)(arg);
     axnet_dev_t *info = PRIV(dev);
-    kio_addr_t nic_base = dev->base_addr;
-    kio_addr_t mii_addr = nic_base + AXNET_MII_EEP;
+    unsigned int nic_base = dev->base_addr;
+    unsigned int mii_addr = nic_base + AXNET_MII_EEP;
     u_short link;
 
     if (!netif_device_present(dev)) goto reschedule;
@@ -681,7 +681,7 @@ static int axnet_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
     axnet_dev_t *info = PRIV(dev);
     u16 *data = (u16 *)&rq->ifr_ifru;
-    kio_addr_t mii_addr = dev->base_addr + AXNET_MII_EEP;
+    unsigned int mii_addr = dev->base_addr + AXNET_MII_EEP;
     switch (cmd) {
     case SIOCGMIIPHY:
 	data[0] = info->phy_id;
@@ -703,7 +703,7 @@ static void get_8390_hdr(struct net_device *dev,
 			 struct e8390_pkt_hdr *hdr,
 			 int ring_page)
 {
-    kio_addr_t nic_base = dev->base_addr;
+    unsigned int nic_base = dev->base_addr;
 
     outb_p(0, nic_base + EN0_RSARLO);		/* On page boundary */
     outb_p(ring_page, nic_base + EN0_RSARHI);
@@ -721,7 +721,7 @@ static void get_8390_hdr(struct net_device *dev,
 static void block_input(struct net_device *dev, int count,
 			struct sk_buff *skb, int ring_offset)
 {
-    kio_addr_t nic_base = dev->base_addr;
+    unsigned int nic_base = dev->base_addr;
     int xfer_count = count;
     char *buf = skb->data;
 
@@ -744,7 +744,7 @@ static void block_input(struct net_device *dev, int count,
 static void block_output(struct net_device *dev, int count,
 			 const u_char *buf, const int start_page)
 {
-    kio_addr_t nic_base = dev->base_addr;
+    unsigned int nic_base = dev->base_addr;
 
 #ifdef PCMCIA_DEBUG
     if (ei_debug > 4)
diff --git a/drivers/net/pcmcia/fmvj18x_cs.c b/drivers/net/pcmcia/fmvj18x_cs.c
index 6284467..7d7d7a0 100644
--- a/drivers/net/pcmcia/fmvj18x_cs.c
+++ b/drivers/net/pcmcia/fmvj18x_cs.c
@@ -298,7 +298,8 @@ do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
 static int mfc_try_io_port(struct pcmcia_device *link)
 {
     int i, ret;
-    static const kio_addr_t serial_base[5] = { 0x3f8, 0x2f8, 0x3e8, 0x2e8, 0x0 };
+    static const unsigned int serial_base[5] =
+	{ 0x3f8, 0x2f8, 0x3e8, 0x2e8, 0x0 };
 
     for (i = 0; i < 5; i++) {
 	link->io.BasePort2 = serial_base[i];
@@ -316,7 +317,7 @@ static int mfc_try_io_port(struct pcmcia_device *link)
 static int ungermann_try_io_port(struct pcmcia_device *link)
 {
     int ret;
-    kio_addr_t ioaddr;
+    unsigned int ioaddr;
     /*
 	Ungermann-Bass Access/CARD accepts 0x300,0x320,0x340,0x360
 	0x380,0x3c0 only for ioport.
@@ -342,7 +343,7 @@ static int fmvj18x_config(struct pcmcia_device *link)
     cisparse_t parse;
     u_short buf[32];
     int i, last_fn = 0, last_ret = 0, ret;
-    kio_addr_t ioaddr;
+    unsigned int ioaddr;
     cardtype_t cardtype;
     char *card_name = "unknown";
     u_char *node_id;
@@ -610,7 +611,7 @@ static int fmvj18x_setup_mfc(struct pcmcia_device *link)
     u_char __iomem *base;
     int i, j;
     struct net_device *dev = link->priv;
-    kio_addr_t ioaddr;
+    unsigned int ioaddr;
 
     /* Allocate a small memory window */
     req.Attributes = WIN_DATA_WIDTH_8|WIN_MEMORY_TYPE_AM|WIN_ENABLE;
@@ -735,7 +736,7 @@ static irqreturn_t fjn_interrupt(int irq, void *dev_id)
 {
     struct net_device *dev = dev_id;
     local_info_t *lp = netdev_priv(dev);
-    kio_addr_t ioaddr;
+    unsigned int ioaddr;
     unsigned short tx_stat, rx_stat;
 
     if (lp == NULL) {
@@ -794,7 +795,7 @@ static irqreturn_t fjn_interrupt(int irq, void *dev_id)
 static void fjn_tx_timeout(struct net_device *dev)
 {
     struct local_info_t *lp = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
 
     printk(KERN_NOTICE "%s: transmit timed out with status %04x, %s?\n",
 	   dev->name, htons(inw(ioaddr + TX_STATUS)),
@@ -824,7 +825,7 @@ static void fjn_tx_timeout(struct net_device *dev)
 static int fjn_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
     struct local_info_t *lp = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     short length = skb->len;
     
     if (length < ETH_ZLEN)
@@ -897,7 +898,7 @@ static int fjn_start_xmit(struct sk_buff *skb, struct net_device *dev)
 static void fjn_reset(struct net_device *dev)
 {
     struct local_info_t *lp = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     int i;
 
     DEBUG(4, "fjn_reset(%s) called.\n",dev->name);
@@ -976,7 +977,7 @@ static void fjn_reset(struct net_device *dev)
 static void fjn_rx(struct net_device *dev)
 {
     struct local_info_t *lp = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     int boguscount = 10;	/* 5 -> 10: by agy 19940922 */
 
     DEBUG(4, "%s: in rx_packet(), rx_status %02x.\n",
@@ -1130,7 +1131,7 @@ static int fjn_close(struct net_device *dev)
 {
     struct local_info_t *lp = netdev_priv(dev);
     struct pcmcia_device *link = lp->p_dev;
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
 
     DEBUG(4, "fjn_close('%s').\n", dev->name);
 
@@ -1173,7 +1174,7 @@ static struct net_device_stats *fjn_get_stats(struct net_device *dev)
 
 static void set_rx_mode(struct net_device *dev)
 {
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     u_char mc_filter[8];		 /* Multicast hash filter */
     u_long flags;
     int i;
diff --git a/drivers/net/pcmcia/nmclan_cs.c b/drivers/net/pcmcia/nmclan_cs.c
index a355a93..3bdb320 100644
--- a/drivers/net/pcmcia/nmclan_cs.c
+++ b/drivers/net/pcmcia/nmclan_cs.c
@@ -518,7 +518,7 @@ mace_read
 	assuming that during normal operation, the MACE is always in
 	bank 0.
 ---------------------------------------------------------------------------- */
-static int mace_read(mace_private *lp, kio_addr_t ioaddr, int reg)
+static int mace_read(mace_private *lp, unsigned int ioaddr, int reg)
 {
   int data = 0xFF;
   unsigned long flags;
@@ -545,7 +545,7 @@ mace_write
 	are assuming that during normal operation, the MACE is always in
 	bank 0.
 ---------------------------------------------------------------------------- */
-static void mace_write(mace_private *lp, kio_addr_t ioaddr, int reg, int data)
+static void mace_write(mace_private *lp, unsigned int ioaddr, int reg, int data)
 {
   unsigned long flags;
 
@@ -567,7 +567,7 @@ static void mace_write(mace_private *lp, kio_addr_t ioaddr, int reg, int data)
 mace_init
 	Resets the MACE chip.
 ---------------------------------------------------------------------------- */
-static int mace_init(mace_private *lp, kio_addr_t ioaddr, char *enet_addr)
+static int mace_init(mace_private *lp, unsigned int ioaddr, char *enet_addr)
 {
   int i;
   int ct = 0;
@@ -657,7 +657,7 @@ static int nmclan_config(struct pcmcia_device *link)
   tuple_t tuple;
   u_char buf[64];
   int i, last_ret, last_fn;
-  kio_addr_t ioaddr;
+  unsigned int ioaddr;
   DECLARE_MAC_BUF(mac);
 
   DEBUG(0, "nmclan_config(0x%p)\n", link);
@@ -839,7 +839,7 @@ mace_open
 ---------------------------------------------------------------------------- */
 static int mace_open(struct net_device *dev)
 {
-  kio_addr_t ioaddr = dev->base_addr;
+  unsigned int ioaddr = dev->base_addr;
   mace_private *lp = netdev_priv(dev);
   struct pcmcia_device *link = lp->p_dev;
 
@@ -862,7 +862,7 @@ mace_close
 ---------------------------------------------------------------------------- */
 static int mace_close(struct net_device *dev)
 {
-  kio_addr_t ioaddr = dev->base_addr;
+  unsigned int ioaddr = dev->base_addr;
   mace_private *lp = netdev_priv(dev);
   struct pcmcia_device *link = lp->p_dev;
 
@@ -935,7 +935,7 @@ static void mace_tx_timeout(struct net_device *dev)
 static int mace_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
   mace_private *lp = netdev_priv(dev);
-  kio_addr_t ioaddr = dev->base_addr;
+  unsigned int ioaddr = dev->base_addr;
 
   netif_stop_queue(dev);
 
@@ -996,7 +996,7 @@ static irqreturn_t mace_interrupt(int irq, void *dev_id)
 {
   struct net_device *dev = (struct net_device *) dev_id;
   mace_private *lp = netdev_priv(dev);
-  kio_addr_t ioaddr;
+  unsigned int ioaddr;
   int status;
   int IntrCnt = MACE_MAX_IR_ITERATIONS;
 
@@ -1140,7 +1140,7 @@ mace_rx
 static int mace_rx(struct net_device *dev, unsigned char RxCnt)
 {
   mace_private *lp = netdev_priv(dev);
-  kio_addr_t ioaddr = dev->base_addr;
+  unsigned int ioaddr = dev->base_addr;
   unsigned char rx_framecnt;
   unsigned short rx_status;
 
@@ -1302,7 +1302,7 @@ update_stats
 	card's SRAM fast enough.  If this happens, something is
 	seriously wrong with the hardware.
 ---------------------------------------------------------------------------- */
-static void update_stats(kio_addr_t ioaddr, struct net_device *dev)
+static void update_stats(unsigned int ioaddr, struct net_device *dev)
 {
   mace_private *lp = netdev_priv(dev);
 
@@ -1448,7 +1448,7 @@ static void restore_multicast_list(struct net_device *dev)
   mace_private *lp = netdev_priv(dev);
   int num_addrs = lp->multicast_num_addrs;
   int *ladrf = lp->multicast_ladrf;
-  kio_addr_t ioaddr = dev->base_addr;
+  unsigned int ioaddr = dev->base_addr;
   int i;
 
   DEBUG(2, "%s: restoring Rx mode to %d addresses.\n",
@@ -1540,7 +1540,7 @@ static void set_multicast_list(struct net_device *dev)
 
 static void restore_multicast_list(struct net_device *dev)
 {
-  kio_addr_t ioaddr = dev->base_addr;
+  unsigned int ioaddr = dev->base_addr;
   mace_private *lp = netdev_priv(dev);
 
   DEBUG(2, "%s: restoring Rx mode to %d addresses.\n", dev->name,
diff --git a/drivers/net/pcmcia/pcnet_cs.c b/drivers/net/pcmcia/pcnet_cs.c
index 9d45e96..1f71ae3 100644
--- a/drivers/net/pcmcia/pcnet_cs.c
+++ b/drivers/net/pcmcia/pcnet_cs.c
@@ -348,7 +348,7 @@ static hw_info_t *get_hwinfo(struct pcmcia_device *link)
 static hw_info_t *get_prom(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     u_char prom[32];
     int i, j;
 
@@ -424,7 +424,7 @@ static hw_info_t *get_dl10019(struct pcmcia_device *link)
 static hw_info_t *get_ax88190(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     int i, j;
 
     /* Not much of a test, but the alternatives are messy */
@@ -755,7 +755,7 @@ static int pcnet_resume(struct pcmcia_device *link)
 #define MDIO_DATA_READ		0x10
 #define MDIO_MASK		0x0f
 
-static void mdio_sync(kio_addr_t addr)
+static void mdio_sync(unsigned int addr)
 {
     int bits, mask = inb(addr) & MDIO_MASK;
     for (bits = 0; bits < 32; bits++) {
@@ -764,7 +764,7 @@ static void mdio_sync(kio_addr_t addr)
     }
 }
 
-static int mdio_read(kio_addr_t addr, int phy_id, int loc)
+static int mdio_read(unsigned int addr, int phy_id, int loc)
 {
     u_int cmd = (0x06<<10)|(phy_id<<5)|loc;
     int i, retval = 0, mask = inb(addr) & MDIO_MASK;
@@ -783,7 +783,7 @@ static int mdio_read(kio_addr_t addr, int phy_id, int loc)
     return (retval>>1) & 0xffff;
 }
 
-static void mdio_write(kio_addr_t addr, int phy_id, int loc, int value)
+static void mdio_write(unsigned int addr, int phy_id, int loc, int value)
 {
     u_int cmd = (0x05<<28)|(phy_id<<23)|(loc<<18)|(1<<17)|value;
     int i, mask = inb(addr) & MDIO_MASK;
@@ -817,10 +817,10 @@ static void mdio_write(kio_addr_t addr, int phy_id, int loc, int value)
 
 #define DL19FDUPLX	0x0400	/* DL10019 Full duplex mode */
 
-static int read_eeprom(kio_addr_t ioaddr, int location)
+static int read_eeprom(unsigned int ioaddr, int location)
 {
     int i, retval = 0;
-    kio_addr_t ee_addr = ioaddr + DLINK_EEPROM;
+    unsigned int ee_addr = ioaddr + DLINK_EEPROM;
     int read_cmd = location | (EE_READ_CMD << 8);
 
     outb(0, ee_addr);
@@ -851,10 +851,10 @@ static int read_eeprom(kio_addr_t ioaddr, int location)
     In ASIC mode, EE_ADOT is used to output the data to the ASIC.
 */
 
-static void write_asic(kio_addr_t ioaddr, int location, short asic_data)
+static void write_asic(unsigned int ioaddr, int location, short asic_data)
 {
 	int i;
-	kio_addr_t ee_addr = ioaddr + DLINK_EEPROM;
+	unsigned int ee_addr = ioaddr + DLINK_EEPROM;
 	short dataval;
 	int read_cmd = location | (EE_READ_CMD << 8);
 
@@ -896,7 +896,7 @@ static void write_asic(kio_addr_t ioaddr, int location, short asic_data)
 
 static void set_misc_reg(struct net_device *dev)
 {
-    kio_addr_t nic_base = dev->base_addr;
+    unsigned int nic_base = dev->base_addr;
     pcnet_dev_t *info = PRIV(dev);
     u_char tmp;
 
@@ -935,7 +935,7 @@ static void set_misc_reg(struct net_device *dev)
 static void mii_phy_probe(struct net_device *dev)
 {
     pcnet_dev_t *info = PRIV(dev);
-    kio_addr_t mii_addr = dev->base_addr + DLINK_GPIO;
+    unsigned int mii_addr = dev->base_addr + DLINK_GPIO;
     int i;
     u_int tmp, phyid;
 
@@ -1013,7 +1013,7 @@ static int pcnet_close(struct net_device *dev)
 
 static void pcnet_reset_8390(struct net_device *dev)
 {
-    kio_addr_t nic_base = dev->base_addr;
+    unsigned int nic_base = dev->base_addr;
     int i;
 
     ei_status.txing = ei_status.dmaing = 0;
@@ -1073,8 +1073,8 @@ static void ei_watchdog(u_long arg)
 {
     struct net_device *dev = (struct net_device *)arg;
     pcnet_dev_t *info = PRIV(dev);
-    kio_addr_t nic_base = dev->base_addr;
-    kio_addr_t mii_addr = nic_base + DLINK_GPIO;
+    unsigned int nic_base = dev->base_addr;
+    unsigned int mii_addr = nic_base + DLINK_GPIO;
     u_short link;
 
     if (!netif_device_present(dev)) goto reschedule;
@@ -1176,7 +1176,7 @@ static int ei_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
     pcnet_dev_t *info = PRIV(dev);
     u16 *data = (u16 *)&rq->ifr_ifru;
-    kio_addr_t mii_addr = dev->base_addr + DLINK_GPIO;
+    unsigned int mii_addr = dev->base_addr + DLINK_GPIO;
     switch (cmd) {
     case SIOCGMIIPHY:
 	data[0] = info->phy_id;
@@ -1198,7 +1198,7 @@ static void dma_get_8390_hdr(struct net_device *dev,
 			     struct e8390_pkt_hdr *hdr,
 			     int ring_page)
 {
-    kio_addr_t nic_base = dev->base_addr;
+    unsigned int nic_base = dev->base_addr;
 
     if (ei_status.dmaing) {
 	printk(KERN_NOTICE "%s: DMAing conflict in dma_block_input."
@@ -1229,7 +1229,7 @@ static void dma_get_8390_hdr(struct net_device *dev,
 static void dma_block_input(struct net_device *dev, int count,
 			    struct sk_buff *skb, int ring_offset)
 {
-    kio_addr_t nic_base = dev->base_addr;
+    unsigned int nic_base = dev->base_addr;
     int xfer_count = count;
     char *buf = skb->data;
 
@@ -1284,7 +1284,7 @@ static void dma_block_input(struct net_device *dev, int count,
 static void dma_block_output(struct net_device *dev, int count,
 			     const u_char *buf, const int start_page)
 {
-    kio_addr_t nic_base = dev->base_addr;
+    unsigned int nic_base = dev->base_addr;
     pcnet_dev_t *info = PRIV(dev);
 #ifdef PCMCIA_DEBUG
     int retries = 0;
diff --git a/drivers/net/pcmcia/smc91c92_cs.c b/drivers/net/pcmcia/smc91c92_cs.c
index 58d716f..ceba4a2 100644
--- a/drivers/net/pcmcia/smc91c92_cs.c
+++ b/drivers/net/pcmcia/smc91c92_cs.c
@@ -295,7 +295,7 @@ static int s9k_config(struct net_device *dev, struct ifmap *map);
 static void smc_set_xcvr(struct net_device *dev, int if_port);
 static void smc_reset(struct net_device *dev);
 static void media_check(u_long arg);
-static void mdio_sync(kio_addr_t addr);
+static void mdio_sync(unsigned int addr);
 static int mdio_read(struct net_device *dev, int phy_id, int loc);
 static void mdio_write(struct net_device *dev, int phy_id, int loc, int value);
 static int smc_link_ok(struct net_device *dev);
@@ -601,8 +601,8 @@ static void mot_config(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
     struct smc_private *smc = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
-    kio_addr_t iouart = link->io.BasePort2;
+    unsigned int ioaddr = dev->base_addr;
+    unsigned int iouart = link->io.BasePort2;
 
     /* Set UART base address and force map with COR bit 1 */
     writeb(iouart & 0xff,        smc->base + MOT_UART + CISREG_IOBASE_0);
@@ -621,7 +621,7 @@ static void mot_config(struct pcmcia_device *link)
 static int mot_setup(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     int i, wait, loop;
     u_int addr;
 
@@ -754,7 +754,7 @@ free_cfg_mem:
 static int osi_config(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
-    static const kio_addr_t com[4] = { 0x3f8, 0x2f8, 0x3e8, 0x2e8 };
+    static const unsigned int com[4] = { 0x3f8, 0x2f8, 0x3e8, 0x2e8 };
     int i, j;
 
     link->conf.Attributes |= CONF_ENABLE_SPKR;
@@ -900,7 +900,7 @@ static int smc91c92_resume(struct pcmcia_device *link)
 static int check_sig(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     int width;
     u_short s;
 
@@ -960,7 +960,7 @@ static int smc91c92_config(struct pcmcia_device *link)
     struct smc_private *smc = netdev_priv(dev);
     char *name;
     int i, j, rev;
-    kio_addr_t ioaddr;
+    unsigned int ioaddr;
     u_long mir;
     DECLARE_MAC_BUF(mac);
 
@@ -1136,7 +1136,7 @@ static void smc91c92_release(struct pcmcia_device *link)
 #define MDIO_DATA_WRITE1	(MDIO_DIR_WRITE | MDIO_DATA_OUT)
 #define MDIO_DATA_READ		0x02
 
-static void mdio_sync(kio_addr_t addr)
+static void mdio_sync(unsigned int addr)
 {
     int bits;
     for (bits = 0; bits < 32; bits++) {
@@ -1147,7 +1147,7 @@ static void mdio_sync(kio_addr_t addr)
 
 static int mdio_read(struct net_device *dev, int phy_id, int loc)
 {
-    kio_addr_t addr = dev->base_addr + MGMT;
+    unsigned int addr = dev->base_addr + MGMT;
     u_int cmd = (0x06<<10)|(phy_id<<5)|loc;
     int i, retval = 0;
 
@@ -1167,7 +1167,7 @@ static int mdio_read(struct net_device *dev, int phy_id, int loc)
 
 static void mdio_write(struct net_device *dev, int phy_id, int loc, int value)
 {
-    kio_addr_t addr = dev->base_addr + MGMT;
+    unsigned int addr = dev->base_addr + MGMT;
     u_int cmd = (0x05<<28)|(phy_id<<23)|(loc<<18)|(1<<17)|value;
     int i;
 
@@ -1193,7 +1193,7 @@ static void mdio_write(struct net_device *dev, int phy_id, int loc, int value)
 #ifdef PCMCIA_DEBUG
 static void smc_dump(struct net_device *dev)
 {
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     u_short i, w, save;
     save = inw(ioaddr + BANK_SELECT);
     for (w = 0; w < 4; w++) {
@@ -1248,7 +1248,7 @@ static int smc_close(struct net_device *dev)
 {
     struct smc_private *smc = netdev_priv(dev);
     struct pcmcia_device *link = smc->p_dev;
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
 
     DEBUG(0, "%s: smc_close(), status %4.4x.\n",
 	  dev->name, inw(ioaddr + BANK_SELECT));
@@ -1285,7 +1285,7 @@ static void smc_hardware_send_packet(struct net_device * dev)
 {
     struct smc_private *smc = netdev_priv(dev);
     struct sk_buff *skb = smc->saved_skb;
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     u_char packet_no;
 
     if (!skb) {
@@ -1349,7 +1349,7 @@ static void smc_hardware_send_packet(struct net_device * dev)
 static void smc_tx_timeout(struct net_device *dev)
 {
     struct smc_private *smc = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
 
     printk(KERN_NOTICE "%s: SMC91c92 transmit timed out, "
 	   "Tx_status %2.2x status %4.4x.\n",
@@ -1364,7 +1364,7 @@ static void smc_tx_timeout(struct net_device *dev)
 static int smc_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
     struct smc_private *smc = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     u_short num_pages;
     short time_out, ir;
     unsigned long flags;
@@ -1434,7 +1434,7 @@ static int smc_start_xmit(struct sk_buff *skb, struct net_device *dev)
 static void smc_tx_err(struct net_device * dev)
 {
     struct smc_private *smc = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     int saved_packet = inw(ioaddr + PNR_ARR) & 0xff;
     int packet_no = inw(ioaddr + FIFO_PORTS) & 0x7f;
     int tx_status;
@@ -1478,7 +1478,7 @@ static void smc_tx_err(struct net_device * dev)
 static void smc_eph_irq(struct net_device *dev)
 {
     struct smc_private *smc = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     u_short card_stats, ephs;
 
     SMC_SELECT_BANK(0);
@@ -1513,7 +1513,7 @@ static irqreturn_t smc_interrupt(int irq, void *dev_id)
 {
     struct net_device *dev = dev_id;
     struct smc_private *smc = netdev_priv(dev);
-    kio_addr_t ioaddr;
+    unsigned int ioaddr;
     u_short saved_bank, saved_pointer, mask, status;
     unsigned int handled = 1;
     char bogus_cnt = INTR_WORK;		/* Work we are willing to do. */
@@ -1633,7 +1633,7 @@ irq_done:
 static void smc_rx(struct net_device *dev)
 {
     struct smc_private *smc = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     int rx_status;
     int packet_length;	/* Caution: not frame length, rather words
 			   to transfer from the chip. */
@@ -1738,7 +1738,7 @@ static void fill_multicast_tbl(int count, struct dev_mc_list *addrs,
 
 static void set_rx_mode(struct net_device *dev)
 {
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     struct smc_private *smc = netdev_priv(dev);
     u_int multicast_table[ 2 ] = { 0, };
     unsigned long flags;
@@ -1804,7 +1804,7 @@ static int s9k_config(struct net_device *dev, struct ifmap *map)
 static void smc_set_xcvr(struct net_device *dev, int if_port)
 {
     struct smc_private *smc = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     u_short saved_bank;
 
     saved_bank = inw(ioaddr + BANK_SELECT);
@@ -1827,7 +1827,7 @@ static void smc_set_xcvr(struct net_device *dev, int if_port)
 
 static void smc_reset(struct net_device *dev)
 {
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     struct smc_private *smc = netdev_priv(dev);
     int i;
 
@@ -1904,7 +1904,7 @@ static void media_check(u_long arg)
 {
     struct net_device *dev = (struct net_device *) arg;
     struct smc_private *smc = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     u_short i, media, saved_bank;
     u_short link;
     unsigned long flags;
@@ -2021,7 +2021,7 @@ reschedule:
 
 static int smc_link_ok(struct net_device *dev)
 {
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     struct smc_private *smc = netdev_priv(dev);
 
     if (smc->cfg & CFG_MII_SELECT) {
@@ -2035,7 +2035,7 @@ static int smc_link_ok(struct net_device *dev)
 static int smc_netdev_get_ecmd(struct net_device *dev, struct ethtool_cmd *ecmd)
 {
     u16 tmp;
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
 
     ecmd->supported = (SUPPORTED_TP | SUPPORTED_AUI |
 	SUPPORTED_10baseT_Half | SUPPORTED_10baseT_Full);
@@ -2057,7 +2057,7 @@ static int smc_netdev_get_ecmd(struct net_device *dev, struct ethtool_cmd *ecmd)
 static int smc_netdev_set_ecmd(struct net_device *dev, struct ethtool_cmd *ecmd)
 {
     u16 tmp;
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
 
     if (ecmd->speed != SPEED_10)
     	return -EINVAL;
@@ -2100,7 +2100,7 @@ static void smc_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
 static int smc_get_settings(struct net_device *dev, struct ethtool_cmd *ecmd)
 {
 	struct smc_private *smc = netdev_priv(dev);
-	kio_addr_t ioaddr = dev->base_addr;
+	unsigned int ioaddr = dev->base_addr;
 	u16 saved_bank = inw(ioaddr + BANK_SELECT);
 	int ret;
 
@@ -2118,7 +2118,7 @@ static int smc_get_settings(struct net_device *dev, struct ethtool_cmd *ecmd)
 static int smc_set_settings(struct net_device *dev, struct ethtool_cmd *ecmd)
 {
 	struct smc_private *smc = netdev_priv(dev);
-	kio_addr_t ioaddr = dev->base_addr;
+	unsigned int ioaddr = dev->base_addr;
 	u16 saved_bank = inw(ioaddr + BANK_SELECT);
 	int ret;
 
@@ -2136,7 +2136,7 @@ static int smc_set_settings(struct net_device *dev, struct ethtool_cmd *ecmd)
 static u32 smc_get_link(struct net_device *dev)
 {
 	struct smc_private *smc = netdev_priv(dev);
-	kio_addr_t ioaddr = dev->base_addr;
+	unsigned int ioaddr = dev->base_addr;
 	u16 saved_bank = inw(ioaddr + BANK_SELECT);
 	u32 ret;
 
@@ -2164,7 +2164,7 @@ static int smc_nway_reset(struct net_device *dev)
 {
 	struct smc_private *smc = netdev_priv(dev);
 	if (smc->cfg & CFG_MII_SELECT) {
-		kio_addr_t ioaddr = dev->base_addr;
+		unsigned int ioaddr = dev->base_addr;
 		u16 saved_bank = inw(ioaddr + BANK_SELECT);
 		int res;
 
@@ -2196,7 +2196,7 @@ static int smc_ioctl (struct net_device *dev, struct ifreq *rq, int cmd)
 	struct mii_ioctl_data *mii = if_mii(rq);
 	int rc = 0;
 	u16 saved_bank;
-	kio_addr_t ioaddr = dev->base_addr;
+	unsigned int ioaddr = dev->base_addr;
 
 	if (!netif_running(dev))
 		return -EINVAL;
diff --git a/drivers/net/pcmcia/xirc2ps_cs.c b/drivers/net/pcmcia/xirc2ps_cs.c
index c3b6960..2e98922 100644
--- a/drivers/net/pcmcia/xirc2ps_cs.c
+++ b/drivers/net/pcmcia/xirc2ps_cs.c
@@ -273,12 +273,12 @@ INT_MODULE_PARM(lockup_hack,	0);  /* anti lockup hack */
 static unsigned maxrx_bytes = 22000;
 
 /* MII management prototypes */
-static void mii_idle(kio_addr_t ioaddr);
-static void mii_putbit(kio_addr_t ioaddr, unsigned data);
-static int  mii_getbit(kio_addr_t ioaddr);
-static void mii_wbits(kio_addr_t ioaddr, unsigned data, int len);
-static unsigned mii_rd(kio_addr_t ioaddr, u_char phyaddr, u_char phyreg);
-static void mii_wr(kio_addr_t ioaddr, u_char phyaddr, u_char phyreg,
+static void mii_idle(unsigned int ioaddr);
+static void mii_putbit(unsigned int ioaddr, unsigned data);
+static int  mii_getbit(unsigned int ioaddr);
+static void mii_wbits(unsigned int ioaddr, unsigned data, int len);
+static unsigned mii_rd(unsigned int ioaddr, u_char phyaddr, u_char phyreg);
+static void mii_wr(unsigned int ioaddr, u_char phyaddr, u_char phyreg,
 		   unsigned data, int len);
 
 /*
@@ -403,7 +403,7 @@ next_tuple(struct pcmcia_device *handle, tuple_t *tuple, cisparse_t *parse)
 static void
 PrintRegisters(struct net_device *dev)
 {
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
 
     if (pc_debug > 1) {
 	int i, page;
@@ -439,7 +439,7 @@ PrintRegisters(struct net_device *dev)
  * Turn around for read
  */
 static void
-mii_idle(kio_addr_t ioaddr)
+mii_idle(unsigned int ioaddr)
 {
     PutByte(XIRCREG2_GPR2, 0x04|0); /* drive MDCK low */
     udelay(1);
@@ -451,7 +451,7 @@ mii_idle(kio_addr_t ioaddr)
  * Write a bit to MDI/O
  */
 static void
-mii_putbit(kio_addr_t ioaddr, unsigned data)
+mii_putbit(unsigned int ioaddr, unsigned data)
 {
   #if 1
     if (data) {
@@ -484,7 +484,7 @@ mii_putbit(kio_addr_t ioaddr, unsigned data)
  * Get a bit from MDI/O
  */
 static int
-mii_getbit(kio_addr_t ioaddr)
+mii_getbit(unsigned int ioaddr)
 {
     unsigned d;
 
@@ -497,7 +497,7 @@ mii_getbit(kio_addr_t ioaddr)
 }
 
 static void
-mii_wbits(kio_addr_t ioaddr, unsigned data, int len)
+mii_wbits(unsigned int ioaddr, unsigned data, int len)
 {
     unsigned m = 1 << (len-1);
     for (; m; m >>= 1)
@@ -505,7 +505,7 @@ mii_wbits(kio_addr_t ioaddr, unsigned data, int len)
 }
 
 static unsigned
-mii_rd(kio_addr_t ioaddr,	u_char phyaddr, u_char phyreg)
+mii_rd(unsigned int ioaddr,	u_char phyaddr, u_char phyreg)
 {
     int i;
     unsigned data=0, m;
@@ -527,7 +527,8 @@ mii_rd(kio_addr_t ioaddr,	u_char phyaddr, u_char phyreg)
 }
 
 static void
-mii_wr(kio_addr_t ioaddr, u_char phyaddr, u_char phyreg, unsigned data, int len)
+mii_wr(unsigned int ioaddr, u_char phyaddr, u_char phyreg, unsigned data,
+       int len)
 {
     int i;
 
@@ -726,7 +727,7 @@ xirc2ps_config(struct pcmcia_device * link)
     local_info_t *local = netdev_priv(dev);
     tuple_t tuple;
     cisparse_t parse;
-    kio_addr_t ioaddr;
+    unsigned int ioaddr;
     int err, i;
     u_char buf[64];
     cistpl_lan_node_id_t *node_id = (cistpl_lan_node_id_t*)parse.funce.data;
@@ -1104,7 +1105,7 @@ xirc2ps_interrupt(int irq, void *dev_id)
 {
     struct net_device *dev = (struct net_device *)dev_id;
     local_info_t *lp = netdev_priv(dev);
-    kio_addr_t ioaddr;
+    unsigned int ioaddr;
     u_char saved_page;
     unsigned bytes_rcvd;
     unsigned int_status, eth_status, rx_status, tx_status;
@@ -1209,7 +1210,7 @@ xirc2ps_interrupt(int irq, void *dev_id)
 		    unsigned i;
 		    u_long *p = skb_put(skb, pktlen);
 		    register u_long a;
-		    kio_addr_t edpreg = ioaddr+XIRCREG_EDP-2;
+		    unsigned int edpreg = ioaddr+XIRCREG_EDP-2;
 		    for (i=0; i < len ; i += 4, p++) {
 			a = inl(edpreg);
 			__asm__("rorl $16,%0\n\t"
@@ -1346,7 +1347,7 @@ static int
 do_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
     local_info_t *lp = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     int okay;
     unsigned freespace;
     unsigned pktlen = skb->len;
@@ -1415,7 +1416,7 @@ do_get_stats(struct net_device *dev)
 static void
 set_addresses(struct net_device *dev)
 {
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     local_info_t *lp = netdev_priv(dev);
     struct dev_mc_list *dmi = dev->mc_list;
     unsigned char *addr;
@@ -1459,7 +1460,7 @@ set_addresses(struct net_device *dev)
 static void
 set_multicast_list(struct net_device *dev)
 {
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
 
     SelectPage(0x42);
     if (dev->flags & IFF_PROMISC) { /* snoop */
@@ -1543,7 +1544,7 @@ static int
 do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
     local_info_t *local = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     u16 *data = (u16 *)&rq->ifr_ifru;
 
     DEBUG(1, "%s: ioctl(%-.6s, %#04x) %04x %04x %04x %04x\n",
@@ -1575,7 +1576,7 @@ static void
 hardreset(struct net_device *dev)
 {
     local_info_t *local = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
 
     SelectPage(4);
     udelay(1);
@@ -1592,7 +1593,7 @@ static void
 do_reset(struct net_device *dev, int full)
 {
     local_info_t *local = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     unsigned value;
 
     DEBUG(0, "%s: do_reset(%p,%d)\n", dev? dev->name:"eth?", dev, full);
@@ -1753,7 +1754,7 @@ static int
 init_mii(struct net_device *dev)
 {
     local_info_t *local = netdev_priv(dev);
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     unsigned control, status, linkpartner;
     int i;
 
@@ -1826,7 +1827,7 @@ static void
 do_powerdown(struct net_device *dev)
 {
 
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
 
     DEBUG(0, "do_powerdown(%p)\n", dev);
 
@@ -1838,7 +1839,7 @@ do_powerdown(struct net_device *dev)
 static int
 do_stop(struct net_device *dev)
 {
-    kio_addr_t ioaddr = dev->base_addr;
+    unsigned int ioaddr = dev->base_addr;
     local_info_t *lp = netdev_priv(dev);
     struct pcmcia_device *link = lp->p_dev;
 
diff --git a/drivers/net/wireless/netwave_cs.c b/drivers/net/wireless/netwave_cs.c
index 2402cb8..90f736a 100644
--- a/drivers/net/wireless/netwave_cs.c
+++ b/drivers/net/wireless/netwave_cs.c
@@ -195,7 +195,7 @@ static int netwave_pcmcia_config(struct pcmcia_device *arg); /* Runs after card
 static void netwave_detach(struct pcmcia_device *p_dev);    /* Destroy instance */
 
 /* Hardware configuration */
-static void netwave_doreset(kio_addr_t iobase, u_char __iomem *ramBase);
+static void netwave_doreset(unsigned int iobase, u_char __iomem *ramBase);
 static void netwave_reset(struct net_device *dev);
 
 /* Misc device stuff */
@@ -309,7 +309,7 @@ static inline void wait_WOC(unsigned int iobase)
 }
 
 static void netwave_snapshot(netwave_private *priv, u_char __iomem *ramBase, 
-			     kio_addr_t iobase) {
+			     unsigned int iobase) {
     u_short resultBuffer;
 
     /* if time since last snapshot is > 1 sec. (100 jiffies?)  then take 
@@ -340,7 +340,7 @@ static void netwave_snapshot(netwave_private *priv, u_char __iomem *ramBase,
 static struct iw_statistics *netwave_get_wireless_stats(struct net_device *dev)
 {	
     unsigned long flags;
-    kio_addr_t iobase = dev->base_addr;
+    unsigned int iobase = dev->base_addr;
     netwave_private *priv = netdev_priv(dev);
     u_char __iomem *ramBase = priv->ramBase;
     struct iw_statistics* wstats;
@@ -471,7 +471,7 @@ static int netwave_set_nwid(struct net_device *dev,
 			    char *extra)
 {
 	unsigned long flags;
-	kio_addr_t iobase = dev->base_addr;
+	unsigned int iobase = dev->base_addr;
 	netwave_private *priv = netdev_priv(dev);
 	u_char __iomem *ramBase = priv->ramBase;
 
@@ -518,7 +518,7 @@ static int netwave_set_scramble(struct net_device *dev,
 				char *key)
 {
 	unsigned long flags;
-	kio_addr_t iobase = dev->base_addr;
+	unsigned int iobase = dev->base_addr;
 	netwave_private *priv = netdev_priv(dev);
 	u_char __iomem *ramBase = priv->ramBase;
 
@@ -621,7 +621,7 @@ static int netwave_get_snap(struct net_device *dev,
 			    char *extra)
 {
 	unsigned long flags;
-	kio_addr_t iobase = dev->base_addr;
+	unsigned int iobase = dev->base_addr;
 	netwave_private *priv = netdev_priv(dev);
 	u_char __iomem *ramBase = priv->ramBase;
 
@@ -874,7 +874,7 @@ static int netwave_resume(struct pcmcia_device *link)
  *
  *    Proper hardware reset of the card.
  */
-static void netwave_doreset(kio_addr_t ioBase, u_char __iomem *ramBase)
+static void netwave_doreset(unsigned int ioBase, u_char __iomem *ramBase)
 {
     /* Reset card */
     wait_WOC(ioBase);
@@ -892,7 +892,7 @@ static void netwave_reset(struct net_device *dev) {
     /* u_char state; */
     netwave_private *priv = netdev_priv(dev);
     u_char __iomem *ramBase = priv->ramBase;
-    kio_addr_t iobase = dev->base_addr;
+    unsigned int iobase = dev->base_addr;
 
     DEBUG(0, "netwave_reset: Done with hardware reset\n");
 
@@ -973,7 +973,7 @@ static int netwave_hw_xmit(unsigned char* data, int len,
 	
     netwave_private *priv = netdev_priv(dev);
     u_char __iomem * ramBase = priv->ramBase;
-    kio_addr_t iobase = dev->base_addr;
+    unsigned int iobase = dev->base_addr;
 
     /* Disable interrupts & save flags */
     spin_lock_irqsave(&priv->spinlock, flags);
@@ -1065,7 +1065,7 @@ static int netwave_start_xmit(struct sk_buff *skb, struct net_device *dev) {
  */
 static irqreturn_t netwave_interrupt(int irq, void* dev_id)
 {
-    kio_addr_t iobase;
+    unsigned int iobase;
     u_char __iomem *ramBase;
     struct net_device *dev = (struct net_device *)dev_id;
     struct netwave_private *priv = netdev_priv(dev);
@@ -1235,7 +1235,7 @@ static int netwave_rx(struct net_device *dev)
 {
     netwave_private *priv = netdev_priv(dev);
     u_char __iomem *ramBase = priv->ramBase;
-    kio_addr_t iobase = dev->base_addr;
+    unsigned int iobase = dev->base_addr;
     u_char rxStatus;
     struct sk_buff *skb = NULL;
     unsigned int curBuffer,
@@ -1388,7 +1388,7 @@ module_exit(exit_netwave_cs);
  */
 static void set_multicast_list(struct net_device *dev)
 {
-    kio_addr_t iobase = dev->base_addr;
+    unsigned int iobase = dev->base_addr;
     netwave_private *priv = netdev_priv(dev);
     u_char __iomem * ramBase = priv->ramBase;
     u_char  rcvMode = 0;
diff --git a/drivers/net/wireless/wavelan_cs.c b/drivers/net/wireless/wavelan_cs.c
index 577c647..06888d4 100644
--- a/drivers/net/wireless/wavelan_cs.c
+++ b/drivers/net/wireless/wavelan_cs.c
@@ -170,7 +170,7 @@ psa_write(struct net_device *	dev,
   net_local *lp = netdev_priv(dev);
   u_char __iomem *ptr = lp->mem + PSA_ADDR + (o << 1);
   int		count = 0;
-  kio_addr_t	base = dev->base_addr;
+  unsigned int	base = dev->base_addr;
   /* As there seem to have no flag PSA_BUSY as in the ISA model, we are
    * oblige to verify this address to know when the PSA is ready... */
   volatile u_char __iomem *verify = lp->mem + PSA_ADDR +
@@ -729,7 +729,7 @@ static void wl_update_history(wavepoint_history *wavepoint, unsigned char sigqua
 /* Perform a handover to a new WavePoint */
 static void wv_roam_handover(wavepoint_history *wavepoint, net_local *lp)
 {
-  kio_addr_t		base = lp->dev->base_addr;
+  unsigned int		base = lp->dev->base_addr;
   mm_t                  m;
   unsigned long         flags;
 
@@ -842,7 +842,7 @@ wv_82593_cmd(struct net_device *	dev,
 	     int	cmd,
 	     int	result)
 {
-  kio_addr_t	base = dev->base_addr;
+  unsigned int	base = dev->base_addr;
   int		status;
   int		wait_completed;
   long		spin;
@@ -966,7 +966,7 @@ read_ringbuf(struct net_device *	dev,
 	     char *	buf,
 	     int	len)
 {
-  kio_addr_t	base = dev->base_addr;
+  unsigned int	base = dev->base_addr;
   int		ring_ptr = addr;
   int		chunk_len;
   char *	buf_ptr = buf;
@@ -1117,7 +1117,7 @@ wv_psa_show(psa_t *	p)
 static void
 wv_mmc_show(struct net_device *	dev)
 {
-  kio_addr_t	base = dev->base_addr;
+  unsigned int	base = dev->base_addr;
   net_local *	lp = netdev_priv(dev);
   mmr_t		m;
 
@@ -1296,7 +1296,7 @@ wv_packet_info(u_char *		p,		/* Packet to dump */
 static inline void
 wv_init_info(struct net_device *	dev)
 {
-  kio_addr_t	base = dev->base_addr;
+  unsigned int	base = dev->base_addr;
   psa_t		psa;
   DECLARE_MAC_BUF(mac);
 
@@ -1315,7 +1315,7 @@ wv_init_info(struct net_device *	dev)
 
 #ifdef DEBUG_BASIC_SHOW
   /* Now, let's go for the basic stuff */
-  printk(KERN_NOTICE "%s: WaveLAN: port %#lx, irq %d, "
+  printk(KERN_NOTICE "%s: WaveLAN: port %#x, irq %d, "
 	 "hw_addr %s",
 	 dev->name, base, dev->irq,
 	 print_mac(mac, dev->dev_addr));
@@ -1849,7 +1849,7 @@ static int wavelan_set_nwid(struct net_device *dev,
 			    union iwreq_data *wrqu,
 			    char *extra)
 {
-	kio_addr_t base = dev->base_addr;
+	unsigned int base = dev->base_addr;
 	net_local *lp = netdev_priv(dev);
 	psa_t psa;
 	mm_t m;
@@ -1939,7 +1939,7 @@ static int wavelan_set_freq(struct net_device *dev,
 			    union iwreq_data *wrqu,
 			    char *extra)
 {
-	kio_addr_t base = dev->base_addr;
+	unsigned int base = dev->base_addr;
 	net_local *lp = netdev_priv(dev);
 	unsigned long flags;
 	int ret;
@@ -1969,7 +1969,7 @@ static int wavelan_get_freq(struct net_device *dev,
 			    union iwreq_data *wrqu,
 			    char *extra)
 {
-	kio_addr_t base = dev->base_addr;
+	unsigned int base = dev->base_addr;
 	net_local *lp = netdev_priv(dev);
 	psa_t psa;
 	unsigned long flags;
@@ -2015,7 +2015,7 @@ static int wavelan_set_sens(struct net_device *dev,
 			    union iwreq_data *wrqu,
 			    char *extra)
 {
-	kio_addr_t base = dev->base_addr;
+	unsigned int base = dev->base_addr;
 	net_local *lp = netdev_priv(dev);
 	psa_t psa;
 	unsigned long flags;
@@ -2081,7 +2081,7 @@ static int wavelan_set_encode(struct net_device *dev,
 			      union iwreq_data *wrqu,
 			      char *extra)
 {
-	kio_addr_t base = dev->base_addr;
+	unsigned int base = dev->base_addr;
 	net_local *lp = netdev_priv(dev);
 	unsigned long flags;
 	psa_t psa;
@@ -2151,7 +2151,7 @@ static int wavelan_get_encode(struct net_device *dev,
 			      union iwreq_data *wrqu,
 			      char *extra)
 {
-	kio_addr_t base = dev->base_addr;
+	unsigned int base = dev->base_addr;
 	net_local *lp = netdev_priv(dev);
 	psa_t psa;
 	unsigned long flags;
@@ -2370,7 +2370,7 @@ static int wavelan_get_range(struct net_device *dev,
 			     union iwreq_data *wrqu,
 			     char *extra)
 {
-	kio_addr_t base = dev->base_addr;
+	unsigned int base = dev->base_addr;
 	net_local *lp = netdev_priv(dev);
 	struct iw_range *range = (struct iw_range *) extra;
 	unsigned long flags;
@@ -2446,7 +2446,7 @@ static int wavelan_set_qthr(struct net_device *dev,
 			    union iwreq_data *wrqu,
 			    char *extra)
 {
-	kio_addr_t base = dev->base_addr;
+	unsigned int base = dev->base_addr;
 	net_local *lp = netdev_priv(dev);
 	psa_t psa;
 	unsigned long flags;
@@ -2722,7 +2722,7 @@ static const struct iw_handler_def	wavelan_handler_def =
 static iw_stats *
 wavelan_get_wireless_stats(struct net_device *	dev)
 {
-  kio_addr_t		base = dev->base_addr;
+  unsigned int		base = dev->base_addr;
   net_local *		lp = netdev_priv(dev);
   mmr_t			m;
   iw_stats *		wstats;
@@ -2785,7 +2785,7 @@ wv_start_of_frame(struct net_device *	dev,
 		  int		rfp,	/* end of frame */
 		  int		wrap)	/* start of buffer */
 {
-  kio_addr_t	base = dev->base_addr;
+  unsigned int	base = dev->base_addr;
   int		rp;
   int		len;
 
@@ -2946,7 +2946,7 @@ wv_packet_read(struct net_device *		dev,
 static inline void
 wv_packet_rcv(struct net_device *	dev)
 {
-  kio_addr_t	base = dev->base_addr;
+  unsigned int	base = dev->base_addr;
   net_local *	lp = netdev_priv(dev);
   int		newrfp;
   int		rp;
@@ -3083,7 +3083,7 @@ wv_packet_write(struct net_device *	dev,
 		short		length)
 {
   net_local *		lp = netdev_priv(dev);
-  kio_addr_t		base = dev->base_addr;
+  unsigned int		base = dev->base_addr;
   unsigned long		flags;
   int			clen = length;
   register u_short	xmtdata_base = TX_BASE;
@@ -3204,7 +3204,7 @@ wavelan_packet_xmit(struct sk_buff *	skb,
 static inline int
 wv_mmc_init(struct net_device *	dev)
 {
-  kio_addr_t	base = dev->base_addr;
+  unsigned int	base = dev->base_addr;
   psa_t		psa;
   mmw_t		m;
   int		configured;
@@ -3398,7 +3398,7 @@ wv_mmc_init(struct net_device *	dev)
 static int
 wv_ru_stop(struct net_device *	dev)
 {
-  kio_addr_t	base = dev->base_addr;
+  unsigned int	base = dev->base_addr;
   net_local *	lp = netdev_priv(dev);
   unsigned long	flags;
   int		status;
@@ -3461,7 +3461,7 @@ wv_ru_stop(struct net_device *	dev)
 static int
 wv_ru_start(struct net_device *	dev)
 {
-  kio_addr_t	base = dev->base_addr;
+  unsigned int	base = dev->base_addr;
   net_local *	lp = netdev_priv(dev);
   unsigned long	flags;
 
@@ -3549,7 +3549,7 @@ wv_ru_start(struct net_device *	dev)
 static int
 wv_82593_config(struct net_device *	dev)
 {
-  kio_addr_t			base = dev->base_addr;
+  unsigned int			base = dev->base_addr;
   net_local *			lp = netdev_priv(dev);
   struct i82593_conf_block	cfblk;
   int				ret = TRUE;
@@ -3786,7 +3786,7 @@ static int
 wv_hw_config(struct net_device *	dev)
 {
   net_local *		lp = netdev_priv(dev);
-  kio_addr_t		base = dev->base_addr;
+  unsigned int		base = dev->base_addr;
   unsigned long		flags;
   int			ret = FALSE;
 
@@ -4072,7 +4072,7 @@ wavelan_interrupt(int		irq,
 {
   struct net_device *	dev = dev_id;
   net_local *	lp;
-  kio_addr_t	base;
+  unsigned int	base;
   int		status0;
   u_int		tx_status;
 
@@ -4331,7 +4331,7 @@ static void
 wavelan_watchdog(struct net_device *	dev)
 {
   net_local *		lp = netdev_priv(dev);
-  kio_addr_t		base = dev->base_addr;
+  unsigned int		base = dev->base_addr;
   unsigned long		flags;
   int			aborted = FALSE;
 
@@ -4407,7 +4407,7 @@ wavelan_open(struct net_device *	dev)
 {
   net_local *	lp = netdev_priv(dev);
   struct pcmcia_device *	link = lp->link;
-  kio_addr_t	base = dev->base_addr;
+  unsigned int	base = dev->base_addr;
 
 #ifdef DEBUG_CALLBACK_TRACE
   printk(KERN_DEBUG "%s: ->wavelan_open(dev=0x%x)\n", dev->name,
@@ -4461,7 +4461,7 @@ static int
 wavelan_close(struct net_device *	dev)
 {
   struct pcmcia_device *	link = ((net_local *)netdev_priv(dev))->link;
-  kio_addr_t	base = dev->base_addr;
+  unsigned int	base = dev->base_addr;
 
 #ifdef DEBUG_CALLBACK_TRACE
   printk(KERN_DEBUG "%s: ->wavelan_close(dev=0x%x)\n", dev->name,
diff --git a/drivers/pcmcia/i82092.c b/drivers/pcmcia/i82092.c
index df21e2d..7495155 100644
--- a/drivers/pcmcia/i82092.c
+++ b/drivers/pcmcia/i82092.c
@@ -82,7 +82,7 @@ struct socket_info {
 				    1 = empty socket, 
 				    2 = card but not initialized,
 				    3 = operational card */
-	kio_addr_t io_base; 	/* base io address of the socket */
+	unsigned int io_base; 	/* base io address of the socket */
 	
 	struct pcmcia_socket socket;
 	struct pci_dev *dev;	/* The PCI device for the socket */
diff --git a/drivers/pcmcia/i82365.c b/drivers/pcmcia/i82365.c
index 839bb1c..40ad7ed 100644
--- a/drivers/pcmcia/i82365.c
+++ b/drivers/pcmcia/i82365.c
@@ -164,7 +164,7 @@ struct i82365_socket {
     u_short		type, flags;
     struct pcmcia_socket	socket;
     unsigned int	number;
-    kio_addr_t		ioaddr;
+    unsigned int	ioaddr;
     u_short		psock;
     u_char		cs_irq, intr;
     union {
@@ -238,7 +238,7 @@ static u_char i365_get(u_short sock, u_short reg)
     unsigned long flags;
     spin_lock_irqsave(&bus_lock,flags);
     {
-	kio_addr_t port = socket[sock].ioaddr;
+	unsigned int port = socket[sock].ioaddr;
 	u_char val;
 	reg = I365_REG(socket[sock].psock, reg);
 	outb(reg, port); val = inb(port+1);
@@ -252,7 +252,7 @@ static void i365_set(u_short sock, u_short reg, u_char data)
     unsigned long flags;
     spin_lock_irqsave(&bus_lock,flags);
     {
-	kio_addr_t port = socket[sock].ioaddr;
+	unsigned int port = socket[sock].ioaddr;
 	u_char val = I365_REG(socket[sock].psock, reg);
 	outb(val, port); outb(data, port+1);
 	spin_unlock_irqrestore(&bus_lock,flags);
@@ -588,7 +588,7 @@ static int to_cycles(int ns)
 
 /*====================================================================*/
 
-static int __init identify(kio_addr_t port, u_short sock)
+static int __init identify(unsigned int port, u_short sock)
 {
     u_char val;
     int type = -1;
@@ -659,7 +659,7 @@ static int __init identify(kio_addr_t port, u_short sock)
 static int __init is_alive(u_short sock)
 {
     u_char stat;
-    kio_addr_t start, stop;
+    unsigned int start, stop;
     
     stat = i365_get(sock, I365_STATUS);
     start = i365_get_pair(sock, I365_IO(0)+I365_W_START);
@@ -678,7 +678,7 @@ static int __init is_alive(u_short sock)
 
 /*====================================================================*/
 
-static void __init add_socket(kio_addr_t port, int psock, int type)
+static void __init add_socket(unsigned int port, int psock, int type)
 {
     socket[sockets].ioaddr = port;
     socket[sockets].psock = psock;
@@ -772,7 +772,7 @@ static struct pnp_dev *i82365_pnpdev;
 static void __init isa_probe(void)
 {
     int i, j, sock, k, ns, id;
-    kio_addr_t port;
+    unsigned int port;
 #ifdef CONFIG_PNP
     struct isapnp_device_id *devid;
     struct pnp_dev *dev;
diff --git a/drivers/pcmcia/m32r_cfc.c b/drivers/pcmcia/m32r_cfc.c
index 91da15b..3616da2 100644
--- a/drivers/pcmcia/m32r_cfc.c
+++ b/drivers/pcmcia/m32r_cfc.c
@@ -58,7 +58,7 @@ typedef struct pcc_socket {
 	u_short			type, flags;
 	struct pcmcia_socket	socket;
 	unsigned int		number;
- 	kio_addr_t		ioaddr;
+	unsigned int		ioaddr;
 	u_long			mapaddr;
 	u_long			base;	/* PCC register base */
 	u_char			cs_irq1, cs_irq2, intr;
@@ -298,7 +298,8 @@ static int __init is_alive(u_short sock)
 	return 0;
 }
 
-static void add_pcc_socket(ulong base, int irq, ulong mapaddr, kio_addr_t ioaddr)
+static void add_pcc_socket(ulong base, int irq, ulong mapaddr,
+			   unsigned int ioaddr)
 {
 	pcc_socket_t *t = &socket[pcc_sockets];
 
@@ -738,7 +739,7 @@ static int __init init_m32r_pcc(void)
 #else	/* CONFIG_PLAT_USRV */
 	{
 		ulong base, mapaddr;
-		kio_addr_t ioaddr;
+		unsigned int ioaddr;
 
 		for (i = 0 ; i < M32R_MAX_PCC ; i++) {
 			base = (ulong)PLD_CFRSTCR;
diff --git a/drivers/pcmcia/m32r_pcc.c b/drivers/pcmcia/m32r_pcc.c
index c5e0d89..93379eb 100644
--- a/drivers/pcmcia/m32r_pcc.c
+++ b/drivers/pcmcia/m32r_pcc.c
@@ -65,7 +65,7 @@ typedef struct pcc_socket {
 	u_short			type, flags;
 	struct pcmcia_socket	socket;
 	unsigned int		number;
- 	kio_addr_t		ioaddr;
+	unsigned int		ioaddr;
 	u_long			mapaddr;
 	u_long			base;	/* PCC register base */
 	u_char			cs_irq, intr;
@@ -310,7 +310,8 @@ static int __init is_alive(u_short sock)
 	return 0;
 }
 
-static void add_pcc_socket(ulong base, int irq, ulong mapaddr, kio_addr_t ioaddr)
+static void add_pcc_socket(ulong base, int irq, ulong mapaddr,
+			   unsigned int ioaddr)
 {
   	pcc_socket_t *t = &socket[pcc_sockets];
 
diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index bfcaad6..e92331f 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -186,11 +186,12 @@ static int sub_interval(struct resource_map *map, u_long base, u_long num)
 ======================================================================*/
 
 #ifdef CONFIG_PCMCIA_PROBE
-static void do_io_probe(struct pcmcia_socket *s, kio_addr_t base, kio_addr_t num)
+static void do_io_probe(struct pcmcia_socket *s, unsigned int base,
+			unsigned int num)
 {
     struct resource *res;
     struct socket_data *s_data = s->resource_data;
-    kio_addr_t i, j, bad;
+    unsigned int i, j, bad;
     int any;
     u_char *b, hole, most;
 
diff --git a/drivers/serial/serial_cs.c b/drivers/serial/serial_cs.c
index 5afcb2f..fe9b4e2 100644
--- a/drivers/serial/serial_cs.c
+++ b/drivers/serial/serial_cs.c
@@ -389,7 +389,7 @@ static void serial_detach(struct pcmcia_device *link)
 /*====================================================================*/
 
 static int setup_serial(struct pcmcia_device *handle, struct serial_info * info,
-			kio_addr_t iobase, int irq)
+			unsigned int iobase, int irq)
 {
 	struct uart_port port;
 	int line;
@@ -456,7 +456,7 @@ next_tuple(struct pcmcia_device *handle, tuple_t * tuple, cisparse_t * parse)
 
 static int simple_config(struct pcmcia_device *link)
 {
-	static const kio_addr_t base[5] = { 0x3f8, 0x2f8, 0x3e8, 0x2e8, 0x0 };
+	static const unsigned int base[5] = { 0x3f8, 0x2f8, 0x3e8, 0x2e8, 0x0 };
 	static const int size_table[2] = { 8, 16 };
 	struct serial_info *info = link->priv;
 	struct serial_cfg_mem *cfg_mem;
@@ -480,7 +480,7 @@ static int simple_config(struct pcmcia_device *link)
 	/* If the card is already configured, look up the port and irq */
 	i = pcmcia_get_configuration_info(link, &config);
 	if ((i == CS_SUCCESS) && (config.Attributes & CONF_VALID_CLIENT)) {
-		kio_addr_t port = 0;
+		unsigned int port = 0;
 		if ((config.BasePort2 != 0) && (config.NumPorts2 == 8)) {
 			port = config.BasePort2;
 			info->slave = 1;
diff --git a/include/pcmcia/cs_types.h b/include/pcmcia/cs_types.h
index c1d1629..39db396 100644
--- a/include/pcmcia/cs_types.h
+++ b/include/pcmcia/cs_types.h
@@ -27,7 +27,6 @@ typedef u_int   ioaddr_t;
 #else
 typedef u_short	ioaddr_t;
 #endif
-typedef unsigned long kio_addr_t;
 
 typedef u_short	socket_t;
 typedef u_int	event_t;
diff --git a/include/pcmcia/ss.h b/include/pcmcia/ss.h
index 6e84258..f95dca0 100644
--- a/include/pcmcia/ss.h
+++ b/include/pcmcia/ss.h
@@ -92,7 +92,7 @@ typedef struct pccard_io_map {
     u_char	map;
     u_char	flags;
     u_short	speed;
-    kio_addr_t	start, stop;
+    u_int	start, stop;
 } pccard_io_map;
 
 typedef struct pccard_mem_map {
@@ -155,7 +155,7 @@ extern struct pccard_resource_ops pccard_iodyn_ops;
 struct pcmcia_socket;
 
 typedef struct io_window_t {
-	kio_addr_t		InUse, Config;
+	u_int			InUse, Config;
 	struct resource		*res;
 } io_window_t;
 
@@ -208,7 +208,7 @@ struct pcmcia_socket {
 	u_int				features;
 	u_int				irq_mask;
 	u_int				map_size;
-	kio_addr_t			io_offset;
+	u_int				io_offset;
 	u_char				pci_irq;
 	struct pci_dev *		cb_dev;
 
