Return-Path: <linux-kernel-owner+w=401wt.eu-S1764296AbYEVVfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764296AbYEVVfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759218AbYEVVem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:34:42 -0400
Received: from rn-out-0910.google.com ([64.233.170.184]:47219 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446AbYEVVel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:34:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=k1tteIdyJerqd7aKBD4oybUXBLr0+7UnBy8+KSFy7e6eUgugOePA9Or+LB0I0UhsXNx+hOt3IrzsvE7z/x64z7le4gHiLlKOPThdt1GLJDlOfQawKstVeFTqhNojE1ubhS0SxA3hyJhKr9OURPnxO0hnVQc+L6vWmyhVqa9afGQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: write_pci_config_byte fix offset
Date: Thu, 22 May 2008 14:35:21 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805210012.35939.yhlu.kernel@gmail.com>
In-Reply-To: <200805210012.35939.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805221435.21969.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


also add write_pci_config_16

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/pci/early.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/early.c
+++ linux-2.6/arch/x86/pci/early.c
@@ -49,7 +49,14 @@ void write_pci_config_byte(u8 bus, u8 sl
 {
 	PDprintk("%x writing to %x: %x\n", slot, offset, val);
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
-	outb(val, 0xcfc);
+	outb(val, 0xcfc + (offset&3));
+}
+
+void write_pci_config_16(u8 bus, u8 slot, u8 func, u8 offset, u16 val)
+{
+	PDprintk("%x writing to %x: %x\n", slot, offset, val);
+	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
+	outw(val, 0xcfc + (offset&2));
 }
 
 int early_pci_allowed(void)
Index: linux-2.6/include/asm-x86/pci-direct.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pci-direct.h
+++ linux-2.6/include/asm-x86/pci-direct.h
@@ -11,6 +11,7 @@ extern u8 read_pci_config_byte(u8 bus, u
 extern u16 read_pci_config_16(u8 bus, u8 slot, u8 func, u8 offset);
 extern void write_pci_config(u8 bus, u8 slot, u8 func, u8 offset, u32 val);
 extern void write_pci_config_byte(u8 bus, u8 slot, u8 func, u8 offset, u8 val);
+extern void write_pci_config_16(u8 bus, u8 slot, u8 func, u8 offset, u16 val);
 
 extern int early_pci_allowed(void);
 
