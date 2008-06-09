Return-Path: <linux-kernel-owner+w=401wt.eu-S1761181AbYFIWZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761181AbYFIWZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbYFIWXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:23:30 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47022 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760182AbYFIWX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:23:28 -0400
Date: Tue, 10 Jun 2008 01:22:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: geert@linux-m68k.org, zippel@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] m68k/atari/debug.c: possible cleanups
Message-ID: <20080609222234.GH1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following possible cleanups:
- make the following needlessly global functions (always) static:
  - atari_mfp_console_write()
  - atari_scc_console_write()
  - atari_midi_console_write()
  - atari_init_mfp_port()
  - atari_init_scc_port()
  - atari_init_midi_port()
- #if 0 the following unused functions:
  - atari_mfp_console_wait_key()
  - atari_scc_console_wait_key()
  - atari_midi_console_wait_key()
- remove the following unused variables:
  - atari_MFP_init_done
  - atari_SCC_init_done

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m68k/atari/debug.c |   37 +++++++------------------------------
 1 file changed, 7 insertions(+), 30 deletions(-)

ba4a365b3f79824768f90a22034eb425a4c8f120 diff --git a/arch/m68k/atari/debug.c b/arch/m68k/atari/debug.c
index 043ddbc..702b15c 100644
--- a/arch/m68k/atari/debug.c
+++ b/arch/m68k/atari/debug.c
@@ -20,14 +20,6 @@
 #include <asm/atarihw.h>
 #include <asm/atariints.h>
 
-/* Flag that Modem1 port is already initialized and used */
-int atari_MFP_init_done;
-EXPORT_SYMBOL(atari_MFP_init_done);
-
-/* Flag that Modem1 port is already initialized and used */
-int atari_SCC_init_done;
-EXPORT_SYMBOL(atari_SCC_init_done);
-
 /* Can be set somewhere, if a SCC master reset has already be done and should
  * not be repeated; used by kgdb */
 int atari_SCC_reset_done;
@@ -47,8 +39,8 @@ static inline void ata_mfp_out(char c)
 	mfp.usart_dta = c;
 }
 
-void atari_mfp_console_write(struct console *co, const char *str,
-			     unsigned int count)
+static void atari_mfp_console_write(struct console *co, const char *str,
+				    unsigned int count)
 {
 	while (count--) {
 		if (*str == '\n')
@@ -66,8 +58,8 @@ static inline void ata_scc_out(char c)
 	scc.cha_b_data = c;
 }
 
-void atari_scc_console_write(struct console *co, const char *str,
-			     unsigned int count)
+static void atari_scc_console_write(struct console *co, const char *str,
+				    unsigned int count)
 {
 	while (count--) {
 		if (*str == '\n')
@@ -83,8 +75,8 @@ static inline void ata_midi_out(char c)
 	acia.mid_data = c;
 }
 
-void atari_midi_console_write(struct console *co, const char *str,
-			      unsigned int count)
+static void atari_midi_console_write(struct console *co, const char *str,
+				     unsigned int count)
 {
 	while (count--) {
 		if (*str == '\n')
@@ -136,7 +128,7 @@ static void atari_par_console_write(struct console *co, const char *str,
 	}
 }
 
-#ifdef CONFIG_SERIAL_CONSOLE
+#if 0
 int atari_mfp_console_wait_key(struct console *co)
 {
 	while (!(mfp.rcv_stat & 0x80))	/* wait for rx buf filled */
@@ -166,11 +158,7 @@ int atari_midi_console_wait_key(struct console *co)
  * SCC serial ports. They're used by the debugging interface, kgdb, and the
  * serial console code.
  */
-#ifndef CONFIG_SERIAL_CONSOLE
 static void __init atari_init_mfp_port(int cflag)
-#else
-void atari_init_mfp_port(int cflag)
-#endif
 {
 	/*
 	 * timer values for 1200...115200 bps; > 38400 select 110, 134, or 150
@@ -193,8 +181,6 @@ void atari_init_mfp_port(int cflag)
 	mfp.tim_dt_d = baud_table[baud];
 	mfp.tim_ct_cd |= 0x01;		/* start timer D, 1:4 */
 	mfp.trn_stat |= 0x01;		/* enable TX */
-
-	atari_MFP_init_done = 1;
 }
 
 #define SCC_WRITE(reg, val)				\
@@ -214,11 +200,7 @@ void atari_init_mfp_port(int cflag)
 			MFPDELAY();			\
 	} while (0)
 
-#ifndef CONFIG_SERIAL_CONSOLE
 static void __init atari_init_scc_port(int cflag)
-#else
-void atari_init_scc_port(int cflag)
-#endif
 {
 	extern int atari_SCC_reset_done;
 	static int clksrc_table[9] =
@@ -277,14 +259,9 @@ void atari_init_scc_port(int cflag)
 	SCC_WRITE(5, reg5 | 8);
 
 	atari_SCC_reset_done = 1;
-	atari_SCC_init_done = 1;
 }
 
-#ifndef CONFIG_SERIAL_CONSOLE
 static void __init atari_init_midi_port(int cflag)
-#else
-void atari_init_midi_port(int cflag)
-#endif
 {
 	int baud = cflag & CBAUD;
 	int csize = ((cflag & CSIZE) == CS8) ? 0x10 : 0x00;

