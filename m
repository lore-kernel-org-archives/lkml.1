Return-Path: <linux-kernel-owner+w=401wt.eu-S1763506AbYAUX2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763506AbYAUX2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbYAUX1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:27:52 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:1390 "EHLO
	outbound5-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758293AbYAUX1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:27:50 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Mon, 21 Jan 2008 16:27:09 -0700
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Arnd Hannemann" <hannemann@i4.informatik.rwth-aachen.de>
cc: "Andres Salomon" <dilinger@queued.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
Message-ID: <20080121232709.GJ10837@cosmic.amd.com>
References: <20080116165606.3ebc06a4@ephemeral>
 <478F25D6.3060503@i4.informatik.rwth-aachen.de>
 <20080117134032.4cc1a1cf@ephemeral>
 <478FB255.5040001@i4.informatik.rwth-aachen.de>
 <20080117211917.GF8244@cosmic.amd.com>
 <478FCDB6.4010708@i4.informatik.rwth-aachen.de>
 <20080117223644.GK8244@cosmic.amd.com>
 <478FDC12.6020505@i4.informatik.rwth-aachen.de>
 <20080117225744.GL8244@cosmic.amd.com>
 <478FE733.2030806@i4.informatik.rwth-aachen.de>
MIME-Version: 1.0
In-Reply-To: <478FE733.2030806@i4.informatik.rwth-aachen.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 21 Jan 2008 23:25:58.0499 (UTC)
 FILETIME=[FA4F2B30:01C85C84]
X-WSS-ID: 6B8BF5A107S8700677-01-01
Content-Type: multipart/mixed;
 boundary=Nq2Wo0NMKNjxTN9z
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Okay - I've been exploring a little bit more.  I talked to the TinyBIOS
developer, and he verified that TinyBIOS shouldn't use any MFGPT timers.
He also told me that the mysterious "MFGPT workaround" was in fact the 
magic MFGPT erasing MSR that was in the old kernel driver.

So with the "MFGPT workaround" turned off, TinyBIOS should be acting like
the OLPC firmware with regards to timers, yet it is not.  So that is 
curious.  I think I might have identified a race condition in the code,
but I'm not 100% sure thats the same problem that the ALIX platform is
seeing.

Anrd and others - will you please try the attached patch on your platform
with the "MFGPT workaround" turned off and mfgpts enabled, and send out
the dmesg?

This will give us some debug information that I can use to ensure that
the interrupts are set up correctly.  You can leave the timer tick disabled
if you want.

Thanks,
Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline;
 filename=mfgpt-debug-spew.patch
Content-Transfer-Encoding: 7bit

diff --git a/arch/x86/kernel/mfgpt_32.c b/arch/x86/kernel/mfgpt_32.c
index 0ab680f..5b4fa24 100644
--- a/arch/x86/kernel/mfgpt_32.c
+++ b/arch/x86/kernel/mfgpt_32.c
@@ -74,18 +74,31 @@ int __init geode_mfgpt_detect(void)
 {
 	int count = 0, i;
 	u16 val;
+	u32 hi, lo;
 
 	if (disable) {
 		printk(KERN_INFO "geode-mfgpt:  Skipping MFGPT setup\n");
 		return 0;
 	}
 
+	rdmsr(0x51400028, lo, hi);
+	printk(KERN_INFO "geode-mfgpt:  IRQ MSR=%x:%x\n", hi, lo);
+
+	rdmsr(0x51400029, lo, hi);
+	printk(KERN_INFO "geode-mfgpt:  NMI MSR=%x:%x\n", hi, lo);
+
+	rdmsr(0x51400022, lo, hi);
+	printk(KERN_INFO "geode-mfgpt:  Unrestricted sources=%x\n", lo);
+
 	for (i = 0; i < MFGPT_MAX_TIMERS; i++) {
 		val = geode_mfgpt_read(i, MFGPT_REG_SETUP);
 		if (!(val & MFGPT_SETUP_SETUP)) {
 			mfgpt_timers[i].flags = F_AVAIL;
 			count++;
 		}
+		else {
+			printk(KERN_INFO "geode-mfgpt:  [%d] is already setup=%x\n", i, val);
+		}
 	}
 
 	/* set up clock event device, if desired */

--Nq2Wo0NMKNjxTN9z--


