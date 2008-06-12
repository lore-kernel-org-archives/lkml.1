Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbYFLNIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbYFLNIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756354AbYFLNIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:08:36 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:31349 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbYFLNIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:08:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lUmo6oDc8oRH3mt8yEl0Obr/2FiCEHPjblpUENHjD1USzvY7fYNT1LSA3dosFkjthw
         6rnhEtXM7m41f3oROuCxMB6gB1/qlLJ5GTWyXv9puigq+A00hYcjz6fosSvb20C8x9UC
         Gq7tYzJ/a7pfG14i5IgcOiEOVj65yt5+mu88M=
Date: Thu, 12 Jun 2008 17:08:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: touch_nmi_watchdog - reset alert counters for
	supported nmi_watchdog modes only
Message-ID: <20080612130816.GA7007@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The checking 'if nmi_watchdog > 0' (ie NMI_NONE) is quite fast but it
has a side effect - it's taken even if nmi_watchdog = NMI_DISABLED.

Nowadays nmi_watchdog is set up to NMI_NONE by default so this condition
is properly taken most the time but we better show this explicitly.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

The patch is over tip/master

	commit 169f18cf265d4107ec8227f278afa0bb7f6f3dc3
	Author: Ingo Molnar <mingo@elte.hu>
	Date:   Tue Jun 10 16:38:41 2008 +0200

	    x86: unify the reserve_bootmem() behavior of early_res_to_bootmem()

Please, review. Any comments are welcome.


Index: linux-2.6.git/arch/x86/kernel/nmi.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi.c	2008-06-12 12:27:04.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi.c	2008-06-12 16:53:26.000000000 +0400
@@ -355,7 +355,8 @@ static DEFINE_PER_CPU(int, nmi_touch);
 
 void touch_nmi_watchdog(void)
 {
-	if (nmi_watchdog > 0) {
+	if (nmi_watchdog == NMI_LOCAL_APIC ||
+		nmi_watchdog == NMI_IO_APIC) {
 		unsigned cpu;
 
 		/*
