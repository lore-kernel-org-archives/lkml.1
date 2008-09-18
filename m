Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbYIRTiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbYIRTiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 15:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbYIRTiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 15:38:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:23697 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbYIRTiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 15:38:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=YLlLy/6naJWFOC1lwRaSS8mHBhMy001Ly0YfQDbFBoypQqRzYxz+Dv5mDToQMjbcu2
         KkEiwCHlfkaUJmKKepagjqD9v5tIYppfAvIxCTMEH25rY1ENvgNigIwptVxQVHfQMHcN
         sNo+zN6f7TiVepVYui9Xt79zNukMHOX72Ph1Y=
Date: Thu, 18 Sep 2008 23:37:57 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip/master] x86: io-apic - restore_IO_APIC_setup NULL
	pointer quick fix
Message-ID: <20080918193757.GB7294@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check if memory was granted first - we don't like NULL deref.
It's a *quick* fix. Actually it's better to hadle this error
at moment of memory allocation. It's save_mask_IO_APIC_setup
route who allocates this memory (just for the record).

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

I'll handle this in _normal_ way tomorrow. Please review.

Index: linux-2.6.git/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_apic.c	2008-09-18 19:17:16.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/io_apic.c	2008-09-18 23:34:40.000000000 +0400
@@ -852,10 +852,14 @@ void restore_IO_APIC_setup(void)
 {
 	int apic, pin;
 
-	for (apic = 0; apic < nr_ioapics; apic++)
+	for (apic = 0; apic < nr_ioapics; apic++) {
+		/* FIXME: it should be handled at allocation time --cvg */
+		if (!early_ioapic_entries[apic])
+			break;
 		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
 			ioapic_write_entry(apic, pin,
 					   early_ioapic_entries[apic][pin]);
+	}
 }
 
 void reinit_intr_remapped_IO_APIC(int intr_remapping)
