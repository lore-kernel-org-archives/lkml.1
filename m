Return-Path: <linux-kernel-owner+w=401wt.eu-S1760742AbYJGBCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760742AbYJGBCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbYJGAqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:46:13 -0400
Received: from ns1.suse.de ([195.135.220.2]:47200 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757999AbYJGAqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:46:12 -0400
Date: Mon, 6 Oct 2008 17:40:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 61/71] sparc64: Fix interrupt register calculations on
	Psycho and Sabre.
Message-ID: <20081007004009.GJ3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0002-sparc64-Fix-interrupt-register-calculations-on-Psyc.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit ebfb2c63405f2410897674f14e41c031c9302909 ]

Use the IMAP offset calculation for OBIO devices as documented in the
programmer's manual.  Which is "0x10000 + ((ino & 0x1f) << 3)"

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/prom.c |  104 ++-------------------------------------------
 1 file changed, 6 insertions(+), 98 deletions(-)

--- a/arch/sparc64/kernel/prom.c
+++ b/arch/sparc64/kernel/prom.c
@@ -156,55 +156,11 @@ static unsigned long psycho_pcislot_imap
 		return PSYCHO_IMAP_B_SLOT0 + (slot * 8);
 }
 
-#define PSYCHO_IMAP_SCSI	0x1000UL
-#define PSYCHO_IMAP_ETH		0x1008UL
-#define PSYCHO_IMAP_BPP		0x1010UL
-#define PSYCHO_IMAP_AU_REC	0x1018UL
-#define PSYCHO_IMAP_AU_PLAY	0x1020UL
-#define PSYCHO_IMAP_PFAIL	0x1028UL
-#define PSYCHO_IMAP_KMS		0x1030UL
-#define PSYCHO_IMAP_FLPY	0x1038UL
-#define PSYCHO_IMAP_SHW		0x1040UL
-#define PSYCHO_IMAP_KBD		0x1048UL
-#define PSYCHO_IMAP_MS		0x1050UL
-#define PSYCHO_IMAP_SER		0x1058UL
-#define PSYCHO_IMAP_TIM0	0x1060UL
-#define PSYCHO_IMAP_TIM1	0x1068UL
-#define PSYCHO_IMAP_UE		0x1070UL
-#define PSYCHO_IMAP_CE		0x1078UL
-#define PSYCHO_IMAP_A_ERR	0x1080UL
-#define PSYCHO_IMAP_B_ERR	0x1088UL
-#define PSYCHO_IMAP_PMGMT	0x1090UL
-#define PSYCHO_IMAP_GFX		0x1098UL
-#define PSYCHO_IMAP_EUPA	0x10a0UL
-
-static unsigned long __psycho_onboard_imap_off[] = {
-/*0x20*/	PSYCHO_IMAP_SCSI,
-/*0x21*/	PSYCHO_IMAP_ETH,
-/*0x22*/	PSYCHO_IMAP_BPP,
-/*0x23*/	PSYCHO_IMAP_AU_REC,
-/*0x24*/	PSYCHO_IMAP_AU_PLAY,
-/*0x25*/	PSYCHO_IMAP_PFAIL,
-/*0x26*/	PSYCHO_IMAP_KMS,
-/*0x27*/	PSYCHO_IMAP_FLPY,
-/*0x28*/	PSYCHO_IMAP_SHW,
-/*0x29*/	PSYCHO_IMAP_KBD,
-/*0x2a*/	PSYCHO_IMAP_MS,
-/*0x2b*/	PSYCHO_IMAP_SER,
-/*0x2c*/	PSYCHO_IMAP_TIM0,
-/*0x2d*/	PSYCHO_IMAP_TIM1,
-/*0x2e*/	PSYCHO_IMAP_UE,
-/*0x2f*/	PSYCHO_IMAP_CE,
-/*0x30*/	PSYCHO_IMAP_A_ERR,
-/*0x31*/	PSYCHO_IMAP_B_ERR,
-/*0x32*/	PSYCHO_IMAP_PMGMT,
-/*0x33*/	PSYCHO_IMAP_GFX,
-/*0x34*/	PSYCHO_IMAP_EUPA,
-};
+#define PSYCHO_OBIO_IMAP_BASE	0x1000UL
+
 #define PSYCHO_ONBOARD_IRQ_BASE		0x20
-#define PSYCHO_ONBOARD_IRQ_LAST		0x34
 #define psycho_onboard_imap_offset(__ino) \
-	__psycho_onboard_imap_off[(__ino) - PSYCHO_ONBOARD_IRQ_BASE]
+	(PSYCHO_OBIO_IMAP_BASE + (((__ino) & 0x1f) << 3))
 
 #define PSYCHO_ICLR_A_SLOT0	0x1400UL
 #define PSYCHO_ICLR_SCSI	0x1800UL
@@ -228,10 +184,6 @@ static unsigned int psycho_irq_build(str
 		imap_off = psycho_pcislot_imap_offset(ino);
 	} else {
 		/* Onboard device */
-		if (ino > PSYCHO_ONBOARD_IRQ_LAST) {
-			prom_printf("psycho_irq_build: Wacky INO [%x]\n", ino);
-			prom_halt();
-		}
 		imap_off = psycho_onboard_imap_offset(ino);
 	}
 
@@ -318,23 +270,6 @@ static void sabre_wsync_handler(unsigned
 
 #define SABRE_IMAP_A_SLOT0	0x0c00UL
 #define SABRE_IMAP_B_SLOT0	0x0c20UL
-#define SABRE_IMAP_SCSI		0x1000UL
-#define SABRE_IMAP_ETH		0x1008UL
-#define SABRE_IMAP_BPP		0x1010UL
-#define SABRE_IMAP_AU_REC	0x1018UL
-#define SABRE_IMAP_AU_PLAY	0x1020UL
-#define SABRE_IMAP_PFAIL	0x1028UL
-#define SABRE_IMAP_KMS		0x1030UL
-#define SABRE_IMAP_FLPY		0x1038UL
-#define SABRE_IMAP_SHW		0x1040UL
-#define SABRE_IMAP_KBD		0x1048UL
-#define SABRE_IMAP_MS		0x1050UL
-#define SABRE_IMAP_SER		0x1058UL
-#define SABRE_IMAP_UE		0x1070UL
-#define SABRE_IMAP_CE		0x1078UL
-#define SABRE_IMAP_PCIERR	0x1080UL
-#define SABRE_IMAP_GFX		0x1098UL
-#define SABRE_IMAP_EUPA		0x10a0UL
 #define SABRE_ICLR_A_SLOT0	0x1400UL
 #define SABRE_ICLR_B_SLOT0	0x1480UL
 #define SABRE_ICLR_SCSI		0x1800UL
@@ -364,33 +299,10 @@ static unsigned long sabre_pcislot_imap_
 		return SABRE_IMAP_B_SLOT0 + (slot * 8);
 }
 
-static unsigned long __sabre_onboard_imap_off[] = {
-/*0x20*/	SABRE_IMAP_SCSI,
-/*0x21*/	SABRE_IMAP_ETH,
-/*0x22*/	SABRE_IMAP_BPP,
-/*0x23*/	SABRE_IMAP_AU_REC,
-/*0x24*/	SABRE_IMAP_AU_PLAY,
-/*0x25*/	SABRE_IMAP_PFAIL,
-/*0x26*/	SABRE_IMAP_KMS,
-/*0x27*/	SABRE_IMAP_FLPY,
-/*0x28*/	SABRE_IMAP_SHW,
-/*0x29*/	SABRE_IMAP_KBD,
-/*0x2a*/	SABRE_IMAP_MS,
-/*0x2b*/	SABRE_IMAP_SER,
-/*0x2c*/	0 /* reserved */,
-/*0x2d*/	0 /* reserved */,
-/*0x2e*/	SABRE_IMAP_UE,
-/*0x2f*/	SABRE_IMAP_CE,
-/*0x30*/	SABRE_IMAP_PCIERR,
-/*0x31*/	0 /* reserved */,
-/*0x32*/	0 /* reserved */,
-/*0x33*/	SABRE_IMAP_GFX,
-/*0x34*/	SABRE_IMAP_EUPA,
-};
-#define SABRE_ONBOARD_IRQ_BASE		0x20
-#define SABRE_ONBOARD_IRQ_LAST		0x30
+#define SABRE_OBIO_IMAP_BASE	0x1000UL
+#define SABRE_ONBOARD_IRQ_BASE	0x20
 #define sabre_onboard_imap_offset(__ino) \
-	__sabre_onboard_imap_off[(__ino) - SABRE_ONBOARD_IRQ_BASE]
+	(SABRE_OBIO_IMAP_BASE + (((__ino) & 0x1f) << 3))
 
 #define sabre_iclr_offset(ino)					      \
 	((ino & 0x20) ? (SABRE_ICLR_SCSI + (((ino) & 0x1f) << 3)) :  \
@@ -453,10 +365,6 @@ static unsigned int sabre_irq_build(stru
 		imap_off = sabre_pcislot_imap_offset(ino);
 	} else {
 		/* onboard device */
-		if (ino > SABRE_ONBOARD_IRQ_LAST) {
-			prom_printf("sabre_irq_build: Wacky INO [%x]\n", ino);
-			prom_halt();
-		}
 		imap_off = sabre_onboard_imap_offset(ino);
 	}
 

-- 
