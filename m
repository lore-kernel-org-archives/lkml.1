Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbYDAA4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbYDAA4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 20:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYDAA4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 20:56:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:7154 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYDAA4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 20:56:42 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wavelan_cs: stop inlining largish static functions
Date: Tue, 1 Apr 2008 02:56:32 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_AhY8HonbLcS0jds"
Message-Id: <200804010256.32454.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_AhY8HonbLcS0jds
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi John,

Can you please take a look at this patch?

drivers/net/wireless/wavelan_cs.c has unusually large number
of static inline functions - 27.

I looked through them and 20 of them do not seem to warrant inlining.
Some are really big; others call mdelay(1) or busy-wait for a bit
to be set in a hardware register - it's pointless
to optimize such functions for speed.

This patch removes "inline" from these static function
(regardless of number of callsites - gcc nowadays auto-inlines
statics with one callsite).

Size difference for 32bit x86:

   text    data     bss     dec     hex filename
  17020     372       8   17400    43f8 linux-2.6-ALLYES/drivers/net/wireless/wavelan_cs.o
  14032     356       8   14396    383c linux-2.6.inline-ALLYES/drivers/net/wireless/wavelan_cs.o

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_AhY8HonbLcS0jds
Content-Type: text/x-diff;
  charset="us-ascii";
  name="deinline_wavelan_cs.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="deinline_wavelan_cs.diff"

diff -urp -U 10 linux-2.6/drivers/net/wireless/wavelan_cs.c linux-2.6.inline/drivers/net/wireless/wavelan_cs.c
--- linux-2.6/drivers/net/wireless/wavelan_cs.c	2008-03-30 03:27:46.000000000 +0200
+++ linux-2.6.inline/drivers/net/wireless/wavelan_cs.c	2008-04-01 02:34:14.000000000 +0200
@@ -95,21 +95,21 @@ hacr_write(u_long	base,
 	   u_char	hacr)
 {
   outb(hacr, HACR(base));
 } /* hacr_write */
 
 /*------------------------------------------------------------------*/
 /*
  * Write to card's Host Adapter Command Register. Include a delay for
  * those times when it is needed.
  */
-static inline void
+static void
 hacr_write_slow(u_long	base,
 		u_char	hacr)
 {
   hacr_write(base, hacr);
   /* delay might only be needed sometimes */
   mdelay(1);
 } /* hacr_write_slow */
 
 /*------------------------------------------------------------------*/
 /*
@@ -248,59 +248,59 @@ update_psa_checksum(struct net_device *	
   if(crc != 0)
     printk(KERN_WARNING "%s: update_psa_checksum(): CRC does not agree with PSA data (even after recalculating)\n", dev->name);
 #endif /* DEBUG_IOCTL_INFO */
 #endif	/* SET_PSA_CRC */
 } /* update_psa_checksum */
 
 /*------------------------------------------------------------------*/
 /*
  * Write 1 byte to the MMC.
  */
-static inline void
+static void
 mmc_out(u_long		base,
 	u_short		o,
 	u_char		d)
 {
   int count = 0;
 
   /* Wait for MMC to go idle */
   while((count++ < 100) && (inb(HASR(base)) & HASR_MMI_BUSY))
     udelay(10);
 
   outb((u_char)((o << 1) | MMR_MMI_WR), MMR(base));
   outb(d, MMD(base));
 }
 
 /*------------------------------------------------------------------*/
 /*
  * Routine to write bytes to the Modem Management Controller.
  * We start by the end because it is the way it should be !
  */
-static inline void
+static void
 mmc_write(u_long	base,
 	  u_char	o,
 	  u_char *	b,
 	  int		n)
 {
   o += n;
   b += n;
 
   while(n-- > 0 )
     mmc_out(base, --o, *(--b));
 } /* mmc_write */
 
 /*------------------------------------------------------------------*/
 /*
  * Read 1 byte from the MMC.
  * Optimised version for 1 byte, avoid using memory...
  */
-static inline u_char
+static u_char
 mmc_in(u_long	base,
        u_short	o)
 {
   int count = 0;
 
   while((count++ < 100) && (inb(HASR(base)) & HASR_MMI_BUSY))
     udelay(10);
   outb(o << 1, MMR(base));		/* Set the read address */
 
   outb(0, MMD(base));			/* Required dummy write */
@@ -311,21 +311,21 @@ mmc_in(u_long	base,
 }
 
 /*------------------------------------------------------------------*/
 /*
  * Routine to read bytes from the Modem Management Controller.
  * The implementation is complicated by a lack of address lines,
  * which prevents decoding of the low-order bit.
  * (code has just been moved in the above function)
  * We start by the end because it is the way it should be !
  */
-static inline void
+static void
 mmc_read(u_long		base,
 	 u_char		o,
 	 u_char *	b,
 	 int		n)
 {
   o += n;
   b += n;
 
   while(n-- > 0)
     *(--b) = mmc_in(base, --o);
@@ -343,23 +343,22 @@ mmc_encr(u_long		base)	/* i/o port of th
   temp = mmc_in(base, mmroff(0, mmr_des_avail));
   if((temp != MMR_DES_AVAIL_DES) && (temp != MMR_DES_AVAIL_AES))
     return 0;
   else
     return temp;
 }
 
 /*------------------------------------------------------------------*/
 /*
  * Wait for the frequency EEprom to complete a command...
- * I hope this one will be optimally inlined...
  */
-static inline void
+static void
 fee_wait(u_long		base,	/* i/o port of the card */
 	 int		delay,	/* Base delay to wait for */
 	 int		number)	/* Number of time to wait */
 {
   int		count = 0;	/* Wait only a limited time */
 
   while((count++ < number) &&
 	(mmc_in(base, mmroff(0, mmr_fee_status)) & MMR_FEE_STATUS_BUSY))
     udelay(delay);
 }
@@ -731,23 +730,23 @@ static void wv_roam_handover(wavepoint_h
   mmc_write(base, (char *)&m.w.mmw_netw_id_l - (char *)&m, (unsigned char *)&m.w.mmw_netw_id_l, 2);
   
   /* ReEnable interrupts & restore flags */
   spin_unlock_irqrestore(&lp->spinlock, flags);
 
   wv_nwid_filter(!NWID_PROMISC,lp);
   lp->curr_point=wavepoint;
 }
 
 /* Called when a WavePoint beacon is received */
-static inline void wl_roam_gather(struct net_device *  dev,
-				  u_char *  hdr,   /* Beacon header */
-				  u_char *  stats) /* SNR, Signal quality 
+static void wl_roam_gather(struct net_device *  dev,
+			   u_char *  hdr,   /* Beacon header */
+			   u_char *  stats) /* SNR, Signal quality 
 						      of packet */
 {
   wavepoint_beacon *beacon= (wavepoint_beacon *)hdr; /* Rcvd. Beacon */
   unsigned short nwid=ntohs(beacon->nwid);  
   unsigned short sigqual=stats[2] & MMR_SGNL_QUAL;   /* SNR of beacon */
   wavepoint_history *wavepoint=NULL;                /* WavePoint table entry */
   net_local *lp = netdev_priv(dev);              /* Device info */
 
 #ifdef I_NEED_THIS_FEATURE
   /* Some people don't need this, some other may need it */
@@ -787,21 +786,21 @@ static inline void wl_roam_gather(struct
       wv_nwid_filter(!NWID_PROMISC,lp);
   
 out:
   lp->wavepoint_table.locked=0;                        /* </MUTEX>   :-) */
 }
 
 /* Test this MAC frame a WavePoint beacon */
 static inline int WAVELAN_BEACON(unsigned char *data)
 {
   wavepoint_beacon *beacon= (wavepoint_beacon *)data;
-  static wavepoint_beacon beacon_template={0xaa,0xaa,0x03,0x08,0x00,0x0e,0x20,0x03,0x00};
+  static const wavepoint_beacon beacon_template={0xaa,0xaa,0x03,0x08,0x00,0x0e,0x20,0x03,0x00};
   
   if(memcmp(beacon,&beacon_template,9)==0)
     return 1;
   else
     return 0;
 }
 #endif	/* WAVELAN_ROAMING */
 
 /************************ I82593 SUBROUTINES *************************/
 /*
@@ -973,21 +972,21 @@ read_ringbuf(struct net_device *	dev,
 
 /*------------------------------------------------------------------*/
 /*
  * Reconfigure the i82593, or at least ask for it...
  * Because wv_82593_config use the transmission buffer, we must do it
  * when we are sure that there is no transmission, so we do it now
  * or in wavelan_packet_xmit() (I can't find any better place,
  * wavelan_interrupt is not an option...), so you may experience
  * some delay sometime...
  */
-static inline void
+static void
 wv_82593_reconfig(struct net_device *	dev)
 {
   net_local *		lp = netdev_priv(dev);
   struct pcmcia_device *		link = lp->link;
   unsigned long		flags;
 
   /* Arm the flag, will be cleard in wv_82593_config() */
   lp->reconfig_82593 = TRUE;
 
   /* Check if we can do it now ! */
@@ -1226,21 +1225,21 @@ wv_local_show(struct net_device *	dev)
    */
   printk("\n");
 } /* wv_local_show */
 #endif	/* DEBUG_DEVICE_SHOW */
 
 #if defined(DEBUG_RX_INFO) || defined(DEBUG_TX_INFO)
 /*------------------------------------------------------------------*/
 /*
  * Dump packet header (and content if necessary) on the screen
  */
-static inline void
+static void
 wv_packet_info(u_char *		p,		/* Packet to dump */
 	       int		length,		/* Length of the packet */
 	       char *		msg1,		/* Name of the device */
 	       char *		msg2)		/* Name of the function */
 {
   int		i;
   int		maxi;
   DECLARE_MAC_BUF(mac);
 
   printk(KERN_DEBUG "%s: %s(): dest %s, length %d\n",
@@ -1265,21 +1264,21 @@ wv_packet_info(u_char *		p,		/* Packet t
   printk(KERN_DEBUG "\n");
 #endif	/* DEBUG_PACKET_DUMP */
 }
 #endif	/* defined(DEBUG_RX_INFO) || defined(DEBUG_TX_INFO) */
 
 /*------------------------------------------------------------------*/
 /*
  * This is the information which is displayed by the driver at startup
  * There  is a lot of flag to configure it at your will...
  */
-static inline void
+static void
 wv_init_info(struct net_device *	dev)
 {
   unsigned int	base = dev->base_addr;
   psa_t		psa;
   DECLARE_MAC_BUF(mac);
 
   /* Read the parameter storage area */
   psa_read(dev, 0, (unsigned char *) &psa, sizeof(psa));
 
 #ifdef DEBUG_PSA_SHOW
@@ -1502,21 +1501,21 @@ wavelan_set_mac_address(struct net_devic
   return 0;
 }
 #endif	/* SET_MAC_ADDRESS */
 
 
 /*------------------------------------------------------------------*/
 /*
  * Frequency setting (for hardware able of it)
  * It's a bit complicated and you don't really want to look into it...
  */
-static inline int
+static int
 wv_set_frequency(u_long		base,	/* i/o port of the card */
 		 iw_freq *	frequency)
 {
   const int	BAND_NUM = 10;	/* Number of bands */
   long		freq = 0L;	/* offset to 2.4 GHz in .5 MHz */
 #ifdef DEBUG_IOCTL_INFO
   int		i;
 #endif
 
   /* Setting by frequency */
@@ -1699,21 +1698,21 @@ wv_set_frequency(u_long		base,	/* i/o po
       return 0;
     }
   else
     return -EINVAL;		/* Bah, never get there... */
 }
 
 /*------------------------------------------------------------------*/
 /*
  * Give the list of available frequencies
  */
-static inline int
+static int
 wv_frequency_list(u_long	base,	/* i/o port of the card */
 		  iw_freq *	list,	/* List of frequency to fill */
 		  int		max)	/* Maximum number of frequencies */
 {
   u_short	table[10];	/* Authorized frequency table */
   long		freq = 0L;	/* offset to 2.4 GHz in .5 MHz + 12 MHz */
   int		i;		/* index in the table */
   const int	BAND_NUM = 10;	/* Number of bands */
   int		c = 0;		/* Channel number */
 
@@ -2752,21 +2751,21 @@ wavelan_get_wireless_stats(struct net_de
  * The interrupt handler get an interrupt when a packet has been
  * successfully received and called this part...
  */
 
 /*------------------------------------------------------------------*/
 /*
  * Calculate the starting address of the frame pointed to by the receive
  * frame pointer and verify that the frame seem correct
  * (called by wv_packet_rcv())
  */
-static inline int
+static int
 wv_start_of_frame(struct net_device *	dev,
 		  int		rfp,	/* end of frame */
 		  int		wrap)	/* start of buffer */
 {
   unsigned int	base = dev->base_addr;
   int		rp;
   int		len;
 
   rp = (rfp - 5 + RX_SIZE) % RX_SIZE;
   outb(rp & 0xff, PIORL(base));
@@ -2814,21 +2813,21 @@ wv_start_of_frame(struct net_device *	de
  * header structure) from the WaveLAN card to an sk_buff chain that
  * will be passed up to the network interface layer. NOTE: We
  * currently don't handle trailer protocols (neither does the rest of
  * the network interface), so if that is needed, it will (at least in
  * part) be added here.  The contents of the receive ring buffer are
  * copied to a message chain that is then passed to the kernel.
  *
  * Note: if any errors occur, the packet is "dropped on the floor"
  * (called by wv_packet_rcv())
  */
-static inline void
+static void
 wv_packet_read(struct net_device *		dev,
 	       int		fd_p,
 	       int		sksize)
 {
   net_local *		lp = netdev_priv(dev);
   struct sk_buff *	skb;
 
 #ifdef DEBUG_RX_TRACE
   printk(KERN_DEBUG "%s: ->wv_packet_read(0x%X, %d)\n",
 	 dev->name, fd_p, sksize);
@@ -2915,21 +2914,21 @@ wv_packet_read(struct net_device *		dev,
 /*
  * This routine is called by the interrupt handler to initiate a
  * packet transfer from the card to the network interface layer above
  * this driver.  This routine checks if a buffer has been successfully
  * received by the WaveLAN card.  If so, the routine wv_packet_read is
  * called to do the actual transfer of the card's data including the
  * ethernet header into a packet consisting of an sk_buff chain.
  * (called by wavelan_interrupt())
  * Note : the spinlock is already grabbed for us and irq are disabled.
  */
-static inline void
+static void
 wv_packet_rcv(struct net_device *	dev)
 {
   unsigned int	base = dev->base_addr;
   net_local *	lp = netdev_priv(dev);
   int		newrfp;
   int		rp;
   int		len;
   int		f_start;
   int		status;
   int		i593_rfp;
@@ -3049,21 +3048,21 @@ wv_packet_rcv(struct net_device *	dev)
  * checked in wavelan_interrupt()
  */
 
 /*------------------------------------------------------------------*/
 /*
  * This routine fills in the appropriate registers and memory
  * locations on the WaveLAN card and starts the card off on
  * the transmit.
  * (called in wavelan_packet_xmit())
  */
-static inline void
+static void
 wv_packet_write(struct net_device *	dev,
 		void *		buf,
 		short		length)
 {
   net_local *		lp = netdev_priv(dev);
   unsigned int		base = dev->base_addr;
   unsigned long		flags;
   int			clen = length;
   register u_short	xmtdata_base = TX_BASE;
 
@@ -3173,21 +3172,21 @@ wavelan_packet_xmit(struct sk_buff *	skb
 /********************** HARDWARE CONFIGURATION **********************/
 /*
  * This part do the real job of starting and configuring the hardware.
  */
 
 /*------------------------------------------------------------------*/
 /*
  * Routine to initialize the Modem Management Controller.
  * (called by wv_hw_config())
  */
-static inline int
+static int
 wv_mmc_init(struct net_device *	dev)
 {
   unsigned int	base = dev->base_addr;
   psa_t		psa;
   mmw_t		m;
   int		configured;
   int		i;		/* Loop counter */
 
 #ifdef DEBUG_CONFIG_TRACE
   printk(KERN_DEBUG "%s: ->wv_mmc_init()\n", dev->name);
@@ -3692,21 +3691,21 @@ wv_82593_config(struct net_device *	dev)
 
 /*------------------------------------------------------------------*/
 /*
  * Read the Access Configuration Register, perform a software reset,
  * and then re-enable the card's software.
  *
  * If I understand correctly : reset the pcmcia interface of the
  * wavelan.
  * (called by wv_config())
  */
-static inline int
+static int
 wv_pcmcia_reset(struct net_device *	dev)
 {
   int		i;
   conf_reg_t	reg = { 0, CS_READ, CISREG_COR, 0 };
   struct pcmcia_device *	link = ((net_local *)netdev_priv(dev))->link;
 
 #ifdef DEBUG_CONFIG_TRACE
   printk(KERN_DEBUG "%s: ->wv_pcmcia_reset()\n", dev->name);
 #endif
 
@@ -3857,21 +3856,21 @@ wv_hw_config(struct net_device *	dev)
 }
 
 /*------------------------------------------------------------------*/
 /*
  * Totally reset the wavelan and restart it.
  * Performs the following actions:
  * 	1. Call wv_hw_config()
  *	2. Start the LAN controller's receive unit
  * (called by wavelan_event(), wavelan_watchdog() and wavelan_open())
  */
-static inline void
+static void
 wv_hw_reset(struct net_device *	dev)
 {
   net_local *	lp = netdev_priv(dev);
 
 #ifdef DEBUG_CONFIG_TRACE
   printk(KERN_DEBUG "%s: ->wv_hw_reset()\n", dev->name);
 #endif
 
   lp->nresets++;
   lp->configured = 0;
@@ -3888,21 +3887,21 @@ wv_hw_reset(struct net_device *	dev)
 #endif
 }
 
 /*------------------------------------------------------------------*/
 /*
  * wv_pcmcia_config() is called after a CARD_INSERTION event is
  * received, to configure the PCMCIA socket, and to make the ethernet
  * device available to the system.
  * (called by wavelan_event())
  */
-static inline int
+static int
 wv_pcmcia_config(struct pcmcia_device *	link)
 {
   struct net_device *	dev = (struct net_device *) link->priv;
   int			i;
   win_req_t		req;
   memreq_t		mem;
   net_local *		lp = netdev_priv(dev);
 
 
 #ifdef DEBUG_CONFIG_TRACE
diff -urp -U 10 linux-2.6/drivers/net/wireless/wavelan_cs.p.h linux-2.6.inline/drivers/net/wireless/wavelan_cs.p.h
--- linux-2.6/drivers/net/wireless/wavelan_cs.p.h	2008-03-30 03:27:46.000000000 +0200
+++ linux-2.6.inline/drivers/net/wireless/wavelan_cs.p.h	2008-04-01 02:46:19.000000000 +0200
@@ -630,46 +630,46 @@ struct net_local
   wavepoint_history *	curr_point;		/* Current wavepoint */
   int			cell_search;		/* Searching for new cell? */
   struct timer_list	cell_timer;		/* Garbage collection */
 #endif	/* WAVELAN_ROAMING */
   void __iomem *mem;
 };
 
 /* ----------------- MODEM MANAGEMENT SUBROUTINES ----------------- */
 static inline u_char		/* data */
 	hasr_read(u_long);	/* Read the host interface : base address */
-static inline void
+static void
 	hacr_write(u_long,	/* Write to host interface : base address */
 		   u_char),	/* data */
 	hacr_write_slow(u_long,
 		   u_char);
 static void
 	psa_read(struct net_device *,	/* Read the Parameter Storage Area */
 		 int,		/* offset in PSA */
 		 u_char *,	/* buffer to fill */
 		 int),		/* size to read */
 	psa_write(struct net_device *,	/* Write to the PSA */
 		  int,		/* Offset in psa */
 		  u_char *,	/* Buffer in memory */
 		  int);		/* Length of buffer */
-static inline void
+static void
 	mmc_out(u_long,		/* Write 1 byte to the Modem Manag Control */
 		u_short,
 		u_char),
 	mmc_write(u_long,	/* Write n bytes to the MMC */
 		  u_char,
 		  u_char *,
 		  int);
-static inline u_char		/* Read 1 byte from the MMC */
+static u_char			/* Read 1 byte from the MMC */
 	mmc_in(u_long,
 	       u_short);
-static inline void
+static void
 	mmc_read(u_long,	/* Read n bytes from the MMC */
 		 u_char,
 		 u_char *,
 		 int),
 	fee_wait(u_long,	/* Wait for frequency EEprom : base address */
 		 int,		/* Base delay to wait for */
 		 int);		/* Number of time to wait */
 static void
 	fee_read(u_long,	/* Read the frequency EEprom : base address */
 		 u_short,	/* destination offset */
@@ -681,63 +681,63 @@ static int
 		     char *,
 		     int,
 		     int);
 static inline int
 	wv_diag(struct net_device *);	/* Diagnostique the i82593 */
 static int
 	read_ringbuf(struct net_device *,	/* Read a receive buffer */
 		     int,
 		     char *,
 		     int);
-static inline void
+static void
 	wv_82593_reconfig(struct net_device *);	/* Reconfigure the controller */
 /* ------------------- DEBUG & INFO SUBROUTINES ------------------- */
-static inline void
+static void
 	wv_init_info(struct net_device *);	/* display startup info */
 /* ------------------- IOCTL, STATS & RECONFIG ------------------- */
 static en_stats	*
 	wavelan_get_stats(struct net_device *);	/* Give stats /proc/net/dev */
 static iw_stats *
 	wavelan_get_wireless_stats(struct net_device *);
 /* ----------------------- PACKET RECEPTION ----------------------- */
-static inline int
+static int
 	wv_start_of_frame(struct net_device *,	/* Seek beggining of current frame */
 			  int,	/* end of frame */
 			  int);	/* start of buffer */
-static inline void
+static void
 	wv_packet_read(struct net_device *,	/* Read a packet from a frame */
 		       int,
 		       int),
 	wv_packet_rcv(struct net_device *);	/* Read all packets waiting */
 /* --------------------- PACKET TRANSMISSION --------------------- */
-static inline void
+static void
 	wv_packet_write(struct net_device *,	/* Write a packet to the Tx buffer */
 			void *,
 			short);
 static int
 	wavelan_packet_xmit(struct sk_buff *,	/* Send a packet */
 			    struct net_device *);
 /* -------------------- HARDWARE CONFIGURATION -------------------- */
-static inline int
+static int
 	wv_mmc_init(struct net_device *);	/* Initialize the modem */
 static int
 	wv_ru_stop(struct net_device *),	/* Stop the i82593 receiver unit */
 	wv_ru_start(struct net_device *);	/* Start the i82593 receiver unit */
 static int
 	wv_82593_config(struct net_device *);	/* Configure the i82593 */
-static inline int
+static int
 	wv_pcmcia_reset(struct net_device *);	/* Reset the pcmcia interface */
 static int
 	wv_hw_config(struct net_device *);	/* Reset & configure the whole hardware */
-static inline void
+static void
 	wv_hw_reset(struct net_device *);	/* Same, + start receiver unit */
-static inline int
+static int
 	wv_pcmcia_config(struct pcmcia_device *);	/* Configure the pcmcia interface */
 static void
 	wv_pcmcia_release(struct pcmcia_device *);/* Remove a device */
 /* ---------------------- INTERRUPT HANDLING ---------------------- */
 static irqreturn_t
 	wavelan_interrupt(int,	/* Interrupt handler */
 			  void *);
 static void
 	wavelan_watchdog(struct net_device *);	/* Transmission watchdog */
 /* ------------------- CONFIGURATION CALLBACKS ------------------- */

--Boundary-00=_AhY8HonbLcS0jds--
