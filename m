Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbXBKIN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbXBKIN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 03:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbXBKIN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 03:13:29 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:63568 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbXBKIN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 03:13:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=fuYJWaW5vQ5c1U6yXS12df7c1uYwy9EZjpct4ZZh74Z3nfE8+cxjwwgmU74oeCcuQZcg1biLCFAKZC6/Q9KEM3ES81CLe+DNB26rChOegTH9U6jOfyy1olQUnARYJpGlbEVuP2el7OJnjM56Zbq7DhEGD/70RLHQ1QZ/b92fv/g=
Date: Sun, 11 Feb 2007 11:13:25 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mwave: interesting flags savings
Message-ID: <20070211081325.GA16712@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Flags from spin_lock_irqsave() are saved into global variable and
restored from it. My gut feeling this is very racy.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/char/mwave/3780i.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/char/mwave/3780i.c
+++ b/drivers/char/mwave/3780i.c
@@ -63,8 +63,6 @@ #include "mwavedd.h"
 #include "3780i.h"
 
 static DEFINE_SPINLOCK(dsp_lock);
-static unsigned long flags;
-
 
 static void PaceMsaAccess(unsigned short usDspBaseIO)
 {
@@ -76,6 +74,7 @@ static void PaceMsaAccess(unsigned short
 unsigned short dsp3780I_ReadMsaCfg(unsigned short usDspBaseIO,
                                    unsigned long ulMsaAddr)
 {
+	unsigned long flags;
 	unsigned short val;
 
 	PRINTK_3(TRACE_3780I,
@@ -96,6 +95,7 @@ unsigned short dsp3780I_ReadMsaCfg(unsig
 void dsp3780I_WriteMsaCfg(unsigned short usDspBaseIO,
                           unsigned long ulMsaAddr, unsigned short usValue)
 {
+	unsigned long flags;
 
 	PRINTK_4(TRACE_3780I,
 		"3780i::dsp3780i_WriteMsaCfg entry usDspBaseIO %x ulMsaAddr %lx usValue %x\n",
@@ -175,6 +175,7 @@ int dsp3780I_EnableDSP(DSP_3780I_CONFIG_
                        unsigned short *pIrqMap,
                        unsigned short *pDmaMap)
 {
+	unsigned long flags;
 	unsigned short usDspBaseIO = pSettings->usDspBaseIO;
 	int i;
 	DSP_UART_CFG_1 rUartCfg1;
@@ -354,6 +355,7 @@ int dsp3780I_EnableDSP(DSP_3780I_CONFIG_
 
 int dsp3780I_DisableDSP(DSP_3780I_CONFIG_SETTINGS * pSettings)
 {
+	unsigned long flags;
 	unsigned short usDspBaseIO = pSettings->usDspBaseIO;
 	DSP_ISA_SLAVE_CONTROL rSlaveControl;
 
@@ -383,6 +385,7 @@ int dsp3780I_DisableDSP(DSP_3780I_CONFIG
 
 int dsp3780I_Reset(DSP_3780I_CONFIG_SETTINGS * pSettings)
 {
+	unsigned long flags;
 	unsigned short usDspBaseIO = pSettings->usDspBaseIO;
 	DSP_BOOT_DOMAIN rBootDomain;
 	DSP_HBRIDGE_CONTROL rHBridgeControl;
@@ -427,6 +430,7 @@ int dsp3780I_Reset(DSP_3780I_CONFIG_SETT
 
 int dsp3780I_Run(DSP_3780I_CONFIG_SETTINGS * pSettings)
 {
+	unsigned long flags;
 	unsigned short usDspBaseIO = pSettings->usDspBaseIO;
 	DSP_BOOT_DOMAIN rBootDomain;
 	DSP_HBRIDGE_CONTROL rHBridgeControl;
@@ -473,6 +477,7 @@ int dsp3780I_Run(DSP_3780I_CONFIG_SETTIN
 int dsp3780I_ReadDStore(unsigned short usDspBaseIO, void __user *pvBuffer,
                         unsigned uCount, unsigned long ulDSPAddr)
 {
+	unsigned long flags;
 	unsigned short __user *pusBuffer = pvBuffer;
 	unsigned short val;
 
@@ -514,6 +519,7 @@ int dsp3780I_ReadAndClearDStore(unsigned
                                 void __user *pvBuffer, unsigned uCount,
                                 unsigned long ulDSPAddr)
 {
+	unsigned long flags;
 	unsigned short __user *pusBuffer = pvBuffer;
 	unsigned short val;
 
@@ -555,6 +561,7 @@ int dsp3780I_ReadAndClearDStore(unsigned
 int dsp3780I_WriteDStore(unsigned short usDspBaseIO, void __user *pvBuffer,
                          unsigned uCount, unsigned long ulDSPAddr)
 {
+	unsigned long flags;
 	unsigned short __user *pusBuffer = pvBuffer;
 
 
@@ -596,6 +603,7 @@ int dsp3780I_WriteDStore(unsigned short 
 int dsp3780I_ReadIStore(unsigned short usDspBaseIO, void __user *pvBuffer,
                         unsigned uCount, unsigned long ulDSPAddr)
 {
+	unsigned long flags;
 	unsigned short __user *pusBuffer = pvBuffer;
 
 	PRINTK_5(TRACE_3780I,
@@ -643,6 +651,7 @@ int dsp3780I_ReadIStore(unsigned short u
 int dsp3780I_WriteIStore(unsigned short usDspBaseIO, void __user *pvBuffer,
                          unsigned uCount, unsigned long ulDSPAddr)
 {
+	unsigned long flags;
 	unsigned short __user *pusBuffer = pvBuffer;
 
 	PRINTK_5(TRACE_3780I,
@@ -691,6 +700,7 @@ int dsp3780I_WriteIStore(unsigned short 
 int dsp3780I_GetIPCSource(unsigned short usDspBaseIO,
                           unsigned short *pusIPCSource)
 {
+	unsigned long flags;
 	DSP_HBRIDGE_CONTROL rHBridgeControl;
 	unsigned short temp;
 

