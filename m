Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZBVIjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZBVIjK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 03:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZBVIi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 03:38:56 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:36435 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZBVIiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 03:38:54 -0500
Date: Sun, 22 Feb 2009 09:38:47 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k: atari - Rename "mfp" to "st_mfp"
Message-ID: <Pine.LNX.4.64.0902220936420.7265@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://kisskb.ellerman.id.au/kisskb/buildresult/72115/:
| net/mac80211/ieee80211_i.h:327: error: syntax error before 'volatile'
| net/mac80211/ieee80211_i.h:350: error: syntax error before '}' token
| net/mac80211/ieee80211_i.h:455: error: field 'sta' has incomplete type
| distcc[19430] ERROR: compile net/mac80211/main.c on sprygo/32 failed

This is caused by

| # define mfp ((*(volatile struct MFP*)MFP_BAS))

in arch/m68k/include/asm/atarihw.h, which conflicts with the new "mfp" enum in
net/mac80211/ieee80211_i.h.

Rename "mfp" to "st_mfp", as it's a way too generic name for a global #define.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
This fixes a conflict in linux-next

 arch/m68k/atari/ataints.c           |   16 ++++++++--------
 arch/m68k/atari/atakeyb.c           |    4 ++--
 arch/m68k/atari/config.c            |    2 +-
 arch/m68k/atari/debug.c             |   22 +++++++++++-----------
 arch/m68k/atari/time.c              |    8 ++++----
 arch/m68k/include/asm/atarihw.h     |    4 ++--
 arch/m68k/include/asm/atariints.h   |    6 +++---
 drivers/block/ataflop.c             |    4 ++--
 drivers/char/scc.h                  |    2 +-
 drivers/parport/parport_atari.c     |    6 +++---
 drivers/video/atafb.c               |   22 +++++++++++-----------
 sound/oss/dmasound/dmasound_atari.c |   16 ++++++++--------
 12 files changed, 56 insertions(+), 56 deletions(-)

diff --git a/arch/m68k/atari/ataints.c b/arch/m68k/atari/ataints.c
index dba4afa..39478dd 100644
--- a/arch/m68k/atari/ataints.c
+++ b/arch/m68k/atari/ataints.c
@@ -187,8 +187,8 @@ __asm__ (__ALIGN_STR "\n"						   \
 "	jbra	ret_from_interrupt\n"					   \
 	 : : "i" (&kstat_cpu(0).irqs[n+8]), "i" (&irq_handler[n+8]),	   \
 	     "n" (PT_OFF_SR), "n" (n),					   \
-	     "i" (n & 8 ? (n & 16 ? &tt_mfp.int_mk_a : &mfp.int_mk_a)	   \
-		        : (n & 16 ? &tt_mfp.int_mk_b : &mfp.int_mk_b)),	   \
+	     "i" (n & 8 ? (n & 16 ? &tt_mfp.int_mk_a : &st_mfp.int_mk_a)   \
+		        : (n & 16 ? &tt_mfp.int_mk_b : &st_mfp.int_mk_b)), \
 	     "m" (preempt_count()), "di" (HARDIRQ_OFFSET)		   \
 );									   \
 	for (;;);			/* fake noreturn */		   \
@@ -366,14 +366,14 @@ void __init atari_init_IRQ(void)
 	/* Initialize the MFP(s) */
 
 #ifdef ATARI_USE_SOFTWARE_EOI
-	mfp.vec_adr  = 0x48;	/* Software EOI-Mode */
+	st_mfp.vec_adr  = 0x48;	/* Software EOI-Mode */
 #else
-	mfp.vec_adr  = 0x40;	/* Automatic EOI-Mode */
+	st_mfp.vec_adr  = 0x40;	/* Automatic EOI-Mode */
 #endif
-	mfp.int_en_a = 0x00;	/* turn off MFP-Ints */
-	mfp.int_en_b = 0x00;
-	mfp.int_mk_a = 0xff;	/* no Masking */
-	mfp.int_mk_b = 0xff;
+	st_mfp.int_en_a = 0x00;	/* turn off MFP-Ints */
+	st_mfp.int_en_b = 0x00;
+	st_mfp.int_mk_a = 0xff;	/* no Masking */
+	st_mfp.int_mk_b = 0xff;
 
 	if (ATARIHW_PRESENT(TT_MFP)) {
 #ifdef ATARI_USE_SOFTWARE_EOI
diff --git a/arch/m68k/atari/atakeyb.c b/arch/m68k/atari/atakeyb.c
index a5f33c0..4add96d 100644
--- a/arch/m68k/atari/atakeyb.c
+++ b/arch/m68k/atari/atakeyb.c
@@ -609,10 +609,10 @@ int atari_keyb_init(void)
 				 ACIA_RHTID : 0);
 
 	/* make sure the interrupt line is up */
-	} while ((mfp.par_dt_reg & 0x10) == 0);
+	} while ((st_mfp.par_dt_reg & 0x10) == 0);
 
 	/* enable ACIA Interrupts */
-	mfp.active_edge &= ~0x10;
+	st_mfp.active_edge &= ~0x10;
 	atari_turnon_irq(IRQ_MFP_ACIA);
 
 	ikbd_self_test = 1;
diff --git a/arch/m68k/atari/config.c b/arch/m68k/atari/config.c
index 49c28cd..ae2d96e 100644
--- a/arch/m68k/atari/config.c
+++ b/arch/m68k/atari/config.c
@@ -258,7 +258,7 @@ void __init config_atari(void)
 			printk("STND_SHIFTER ");
 		}
 	}
-	if (hwreg_present(&mfp.par_dt_reg)) {
+	if (hwreg_present(&st_mfp.par_dt_reg)) {
 		ATARIHW_SET(ST_MFP);
 		printk("ST_MFP ");
 	}
diff --git a/arch/m68k/atari/debug.c b/arch/m68k/atari/debug.c
index 702b15c..28efdc3 100644
--- a/arch/m68k/atari/debug.c
+++ b/arch/m68k/atari/debug.c
@@ -34,9 +34,9 @@ static struct console atari_console_driver = {
 
 static inline void ata_mfp_out(char c)
 {
-	while (!(mfp.trn_stat & 0x80))	/* wait for tx buf empty */
+	while (!(st_mfp.trn_stat & 0x80))	/* wait for tx buf empty */
 		barrier();
-	mfp.usart_dta = c;
+	st_mfp.usart_dta = c;
 }
 
 static void atari_mfp_console_write(struct console *co, const char *str,
@@ -91,7 +91,7 @@ static int ata_par_out(char c)
 	/* This a some-seconds timeout in case no printer is connected */
 	unsigned long i = loops_per_jiffy > 1 ? loops_per_jiffy : 10000000/HZ;
 
-	while ((mfp.par_dt_reg & 1) && --i) /* wait for BUSY == L */
+	while ((st_mfp.par_dt_reg & 1) && --i) /* wait for BUSY == L */
 		;
 	if (!i)
 		return 0;
@@ -131,9 +131,9 @@ static void atari_par_console_write(struct console *co, const char *str,
 #if 0
 int atari_mfp_console_wait_key(struct console *co)
 {
-	while (!(mfp.rcv_stat & 0x80))	/* wait for rx buf filled */
+	while (!(st_mfp.rcv_stat & 0x80))	/* wait for rx buf filled */
 		barrier();
-	return mfp.usart_dta;
+	return st_mfp.usart_dta;
 }
 
 int atari_scc_console_wait_key(struct console *co)
@@ -175,12 +175,12 @@ static void __init atari_init_mfp_port(int cflag)
 		baud = B9600;		/* use default 9600bps for non-implemented rates */
 	baud -= B1200;			/* baud_table[] starts at 1200bps */
 
-	mfp.trn_stat &= ~0x01;		/* disable TX */
-	mfp.usart_ctr = parity | csize | 0x88; /* 1:16 clk mode, 1 stop bit */
-	mfp.tim_ct_cd &= 0x70;		/* stop timer D */
-	mfp.tim_dt_d = baud_table[baud];
-	mfp.tim_ct_cd |= 0x01;		/* start timer D, 1:4 */
-	mfp.trn_stat |= 0x01;		/* enable TX */
+	st_mfp.trn_stat &= ~0x01;	/* disable TX */
+	st_mfp.usart_ctr = parity | csize | 0x88; /* 1:16 clk mode, 1 stop bit */
+	st_mfp.tim_ct_cd &= 0x70;	/* stop timer D */
+	st_mfp.tim_dt_d = baud_table[baud];
+	st_mfp.tim_ct_cd |= 0x01;	/* start timer D, 1:4 */
+	st_mfp.trn_stat |= 0x01;	/* enable TX */
 }
 
 #define SCC_WRITE(reg, val)				\
diff --git a/arch/m68k/atari/time.c b/arch/m68k/atari/time.c
index d076ff8..a0531f3 100644
--- a/arch/m68k/atari/time.c
+++ b/arch/m68k/atari/time.c
@@ -27,9 +27,9 @@ void __init
 atari_sched_init(irq_handler_t timer_routine)
 {
     /* set Timer C data Register */
-    mfp.tim_dt_c = INT_TICKS;
+    st_mfp.tim_dt_c = INT_TICKS;
     /* start timer C, div = 1:100 */
-    mfp.tim_ct_cd = (mfp.tim_ct_cd & 15) | 0x60;
+    st_mfp.tim_ct_cd = (st_mfp.tim_ct_cd & 15) | 0x60;
     /* install interrupt service routine for MFP Timer C */
     if (request_irq(IRQ_MFP_TIMC, timer_routine, IRQ_TYPE_SLOW,
 		    "timer", timer_routine))
@@ -46,11 +46,11 @@ unsigned long atari_gettimeoffset (void)
   unsigned long ticks, offset = 0;
 
   /* read MFP timer C current value */
-  ticks = mfp.tim_dt_c;
+  ticks = st_mfp.tim_dt_c;
   /* The probability of underflow is less than 2% */
   if (ticks > INT_TICKS - INT_TICKS / 50)
     /* Check for pending timer interrupt */
-    if (mfp.int_pn_b & (1 << 5))
+    if (st_mfp.int_pn_b & (1 << 5))
       offset = TICK_SIZE;
 
   ticks = INT_TICKS - ticks;
diff --git a/arch/m68k/include/asm/atarihw.h b/arch/m68k/include/asm/atarihw.h
index 1412b4a..a714e1a 100644
--- a/arch/m68k/include/asm/atarihw.h
+++ b/arch/m68k/include/asm/atarihw.h
@@ -113,7 +113,7 @@ extern struct atari_hw_present atari_hw_present;
  * of nops on various machines. Somebody claimed that the tstb takes 600 ns.
  */
 #define	MFPDELAY() \
-	__asm__ __volatile__ ( "tstb %0" : : "m" (mfp.par_dt_reg) : "cc" );
+	__asm__ __volatile__ ( "tstb %0" : : "m" (st_mfp.par_dt_reg) : "cc" );
 
 /* Do cache push/invalidate for DMA read/write. This function obeys the
  * snooping on some machines (Medusa) and processors: The Medusa itself can
@@ -565,7 +565,7 @@ struct MFP
   u_char char_dummy23;
   u_char usart_dta;
  };
-# define mfp ((*(volatile struct MFP*)MFP_BAS))
+# define st_mfp ((*(volatile struct MFP*)MFP_BAS))
 
 /* TT's second MFP */
 
diff --git a/arch/m68k/include/asm/atariints.h b/arch/m68k/include/asm/atariints.h
index 5748e99..f597892 100644
--- a/arch/m68k/include/asm/atariints.h
+++ b/arch/m68k/include/asm/atariints.h
@@ -113,7 +113,7 @@ static inline int get_mfp_bit( unsigned irq, int type )
 {	unsigned char	mask, *reg;
 
 	mask = 1 << (irq & 7);
-	reg = (unsigned char *)&mfp.int_en_a + type*4 +
+	reg = (unsigned char *)&st_mfp.int_en_a + type*4 +
 		  ((irq & 8) >> 2) + (((irq-8) & 16) << 3);
 	return( *reg & mask );
 }
@@ -123,7 +123,7 @@ static inline void set_mfp_bit( unsigned irq, int type )
 {	unsigned char	mask, *reg;
 
 	mask = 1 << (irq & 7);
-	reg = (unsigned char *)&mfp.int_en_a + type*4 +
+	reg = (unsigned char *)&st_mfp.int_en_a + type*4 +
 		  ((irq & 8) >> 2) + (((irq-8) & 16) << 3);
 	__asm__ __volatile__ ( "orb %0,%1"
 			      : : "di" (mask), "m" (*reg) : "memory" );
@@ -134,7 +134,7 @@ static inline void clear_mfp_bit( unsigned irq, int type )
 {	unsigned char	mask, *reg;
 
 	mask = ~(1 << (irq & 7));
-	reg = (unsigned char *)&mfp.int_en_a + type*4 +
+	reg = (unsigned char *)&st_mfp.int_en_a + type*4 +
 		  ((irq & 8) >> 2) + (((irq-8) & 16) << 3);
 	if (type == MFP_PENDING || type == MFP_SERVICE)
 		__asm__ __volatile__ ( "moveb %0,%1"
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 69e1df7..4234c11 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -1730,7 +1730,7 @@ static int __init fd_test_drive_present( int drive )
 
 	timeout = jiffies + 2*HZ+HZ/2;
 	while (time_before(jiffies, timeout))
-		if (!(mfp.par_dt_reg & 0x20))
+		if (!(st_mfp.par_dt_reg & 0x20))
 			break;
 
 	status = FDC_READ( FDCREG_STATUS );
@@ -1747,7 +1747,7 @@ static int __init fd_test_drive_present( int drive )
 		/* dummy seek command to make WP bit accessible */
 		FDC_WRITE( FDCREG_DATA, 0 );
 		FDC_WRITE( FDCREG_CMD, FDCCMD_SEEK );
-		while( mfp.par_dt_reg & 0x20 )
+		while( st_mfp.par_dt_reg & 0x20 )
 			;
 		status = FDC_READ( FDCREG_STATUS );
 	}
diff --git a/drivers/char/scc.h b/drivers/char/scc.h
index 93998f5..341b114 100644
--- a/drivers/char/scc.h
+++ b/drivers/char/scc.h
@@ -387,7 +387,7 @@ struct scc_port {
 /* The SCC needs 3.5 PCLK cycles recovery time between to register
  * accesses. PCLK runs with 8 MHz on an Atari, so this delay is 3.5 *
  * 125 ns = 437.5 ns. This is too short for udelay().
- * 10/16/95: A tstb mfp.par_dt_reg takes 600ns (sure?) and thus should be
+ * 10/16/95: A tstb st_mfp.par_dt_reg takes 600ns (sure?) and thus should be
  * quite right
  */
 
diff --git a/drivers/parport/parport_atari.c b/drivers/parport/parport_atari.c
index ad4cdd2..0b28fcc 100644
--- a/drivers/parport/parport_atari.c
+++ b/drivers/parport/parport_atari.c
@@ -84,7 +84,7 @@ parport_atari_frob_control(struct parport *p, unsigned char mask,
 static unsigned char
 parport_atari_read_status(struct parport *p)
 {
-	return ((mfp.par_dt_reg & 1 ? 0 : PARPORT_STATUS_BUSY) |
+	return ((st_mfp.par_dt_reg & 1 ? 0 : PARPORT_STATUS_BUSY) |
 		PARPORT_STATUS_SELECT | PARPORT_STATUS_ERROR);
 }
 
@@ -193,9 +193,9 @@ static int __init parport_atari_init(void)
 		sound_ym.wd_data = sound_ym.rd_data_reg_sel | (1 << 5);
 		local_irq_restore(flags);
 		/* MFP port I0 as input. */
-		mfp.data_dir &= ~1;
+		st_mfp.data_dir &= ~1;
 		/* MFP port I0 interrupt on high->low edge. */
-		mfp.active_edge &= ~1;
+		st_mfp.active_edge &= ~1;
 		p = parport_register_port((unsigned long)&sound_ym.wd_data,
 					  IRQ_MFP_BUSY, PARPORT_DMA_NONE,
 					  &parport_atari_ops);
diff --git a/drivers/video/atafb.c b/drivers/video/atafb.c
index 8058572..018850c 100644
--- a/drivers/video/atafb.c
+++ b/drivers/video/atafb.c
@@ -841,7 +841,7 @@ static int tt_detect(void)
 		tt_dmasnd.ctrl = DMASND_CTRL_OFF;
 		udelay(20);		/* wait a while for things to settle down */
 	}
-	mono_moni = (mfp.par_dt_reg & 0x80) == 0;
+	mono_moni = (st_mfp.par_dt_reg & 0x80) == 0;
 
 	tt_get_par(&par);
 	tt_encode_var(&atafb_predefined[0], &par);
@@ -2035,7 +2035,7 @@ static int stste_detect(void)
 		tt_dmasnd.ctrl = DMASND_CTRL_OFF;
 		udelay(20);		/* wait a while for things to settle down */
 	}
-	mono_moni = (mfp.par_dt_reg & 0x80) == 0;
+	mono_moni = (st_mfp.par_dt_reg & 0x80) == 0;
 
 	stste_get_par(&par);
 	stste_encode_var(&atafb_predefined[0], &par);
@@ -2086,20 +2086,20 @@ static void st_ovsc_switch(void)
 		return;
 	local_irq_save(flags);
 
-	mfp.tim_ct_b = 0x10;
-	mfp.active_edge |= 8;
-	mfp.tim_ct_b = 0;
-	mfp.tim_dt_b = 0xf0;
-	mfp.tim_ct_b = 8;
-	while (mfp.tim_dt_b > 1)	/* TOS does it this way, don't ask why */
+	st_mfp.tim_ct_b = 0x10;
+	st_mfp.active_edge |= 8;
+	st_mfp.tim_ct_b = 0;
+	st_mfp.tim_dt_b = 0xf0;
+	st_mfp.tim_ct_b = 8;
+	while (st_mfp.tim_dt_b > 1)	/* TOS does it this way, don't ask why */
 		;
-	new = mfp.tim_dt_b;
+	new = st_mfp.tim_dt_b;
 	do {
 		udelay(LINE_DELAY);
 		old = new;
-		new = mfp.tim_dt_b;
+		new = st_mfp.tim_dt_b;
 	} while (old != new);
-	mfp.tim_ct_b = 0x10;
+	st_mfp.tim_ct_b = 0x10;
 	udelay(SYNC_DELAY);
 
 	if (atari_switches & ATARI_SWITCH_OVSC_IKBD)
diff --git a/sound/oss/dmasound/dmasound_atari.c b/sound/oss/dmasound/dmasound_atari.c
index 57d9f15..38931f2 100644
--- a/sound/oss/dmasound/dmasound_atari.c
+++ b/sound/oss/dmasound/dmasound_atari.c
@@ -847,23 +847,23 @@ static int __init AtaIrqInit(void)
 	   of events. So all we need to keep the music playing is
 	   to provide the sound hardware with new data upon
 	   an interrupt from timer A. */
-	mfp.tim_ct_a = 0;	/* ++roman: Stop timer before programming! */
-	mfp.tim_dt_a = 1;	/* Cause interrupt after first event. */
-	mfp.tim_ct_a = 8;	/* Turn on event counting. */
+	st_mfp.tim_ct_a = 0;	/* ++roman: Stop timer before programming! */
+	st_mfp.tim_dt_a = 1;	/* Cause interrupt after first event. */
+	st_mfp.tim_ct_a = 8;	/* Turn on event counting. */
 	/* Register interrupt handler. */
 	if (request_irq(IRQ_MFP_TIMA, AtaInterrupt, IRQ_TYPE_SLOW, "DMA sound",
 			AtaInterrupt))
 		return 0;
-	mfp.int_en_a |= 0x20;	/* Turn interrupt on. */
-	mfp.int_mk_a |= 0x20;
+	st_mfp.int_en_a |= 0x20;	/* Turn interrupt on. */
+	st_mfp.int_mk_a |= 0x20;
 	return 1;
 }
 
 #ifdef MODULE
 static void AtaIrqCleanUp(void)
 {
-	mfp.tim_ct_a = 0;	/* stop timer */
-	mfp.int_en_a &= ~0x20;	/* turn interrupt off */
+	st_mfp.tim_ct_a = 0;		/* stop timer */
+	st_mfp.int_en_a &= ~0x20;	/* turn interrupt off */
 	free_irq(IRQ_MFP_TIMA, AtaInterrupt);
 }
 #endif /* MODULE */
@@ -1599,7 +1599,7 @@ static int __init dmasound_atari_init(void)
 		is_falcon = 0;
 	    } else
 		return -ENODEV;
-	    if ((mfp.int_en_a & mfp.int_mk_a & 0x20) == 0)
+	    if ((st_mfp.int_en_a & st_mfp.int_mk_a & 0x20) == 0)
 		return dmasound_init();
 	    else {
 		printk("DMA sound driver: Timer A interrupt already in use\n");
-- 
1.5.6.5

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
