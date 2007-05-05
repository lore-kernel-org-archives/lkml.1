Return-Path: <linux-kernel-owner+w=401wt.eu-S934049AbXEERtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934049AbXEERtG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 13:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934146AbXEERtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 13:49:06 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:19820 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934049AbXEERtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 13:49:04 -0400
Message-ID: <463CC380.3060603@interia.pl>
Date: Sat, 05 May 2007 19:48:48 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Wander Winkelhorst <w.winkelhorst@gmail.com>,
       David Johnson <dj@david-web.co.uk>, linux-kernel@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: cpufreq longhaul locks up
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>	 <200705042320.41278.dj@david-web.co.uk>	 <Pine.LNX.4.61.0705050132410.18504@yvahk01.tjqt.qr>	 <463C18C4.7030304@interia.pl> <5699f8f00705050144s5c00a455s8f7dba9258d83986@mail.gmail.com>
In-Reply-To: <5699f8f00705050144s5c00a455s8f7dba9258d83986@mail.gmail.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-EMID: f4aeaacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I found one line which wasn't were it should be. Probably this will not 
fix Your problem with powersave governor, but it is a bit related. 
Looks like Longhaul isn't skipping frequency transtition when it is asked 
to set f which is already set. Now after first transition it will not 
try to set same frequency again. Second part contains some magic 
because I don't have CN400 datasheet. It is NDA protected :-( Should 
print You one byte in hex and will try to set one register. I don't 
know if anything will change but it is worth testing.

Fingers crossed
Rafa³

---
 arch/i386/kernel/cpu/cpufreq/longhaul.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/i386/kernel/cpu/cpufreq/longhaul.c b/arch/i386/kernel/cpu/cpufreq/longhaul.c
index 2b030d6..5548e5b 100644
--- a/arch/i386/kernel/cpu/cpufreq/longhaul.c
+++ b/arch/i386/kernel/cpu/cpufreq/longhaul.c
@@ -88,6 +88,7 @@ static int clock_ratio[32];
 static int eblcr_table[32];
 static int longhaul_version;
 static struct cpufreq_frequency_table *longhaul_table;
+static unsigned int old_ratio = -1;
 
 #ifdef CONFIG_CPU_FREQ_DEBUG
 static char speedbuffer[8];
@@ -252,7 +253,6 @@ static void longhaul_setstate(unsigned int clock_ratio_index)
 {
 	int speed, mult;
 	struct cpufreq_freqs freqs;
-	static unsigned int old_ratio=-1;
 	unsigned long flags;
 	unsigned int pic1_mask, pic2_mask;
 
@@ -603,7 +603,12 @@ static int enable_arbiter_disable(void)
 		/* Find CN400 V-Link host bridge */
 		if (dev == NULL)
 			dev = pci_find_device(PCI_VENDOR_ID_VIA, 0x7259, NULL);
-
+		if (dev != NULL) {
+			pci_read_config_byte(dev, 0x47, &pci_cmd);
+			printk(KERN_INFO PFX "%#02x\n", pci_cmd);
+			pci_cmd |= 0xf;
+			pci_write_config_byte(dev, 0x47, pci_cmd);
+		}
 	}
 	if (dev != NULL) {
 		/* Enable access to port 0x22 */
-- 



----------------------------------------------------------------------
Po meczu.....kurde...:)
>>> http://link.interia.pl/f1a72

