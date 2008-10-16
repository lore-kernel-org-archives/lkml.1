Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbYJPM6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbYJPM6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 08:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYJPM6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 08:58:12 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54200 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751497AbYJPM6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 08:58:11 -0400
Date: Thu, 16 Oct 2008 07:58:08 -0500
From: Dean Nelson <dcn@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] NULL struct irq_desc's member 'name' in dynamic_irq_cleanup()
Message-ID: <20081016125808.GA24347@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the member 'name' of the irq_desc structure happens to point to a character
string that is resident within a kernel module, problems insue if that module
is rmmod'd (at which time dynamic_irq_cleanup() is called) and then later
show_interrupts() is called by someone. It is also not a good thing if the
character string resided in kmalloc'd space that has been kfree'd (after
having called dynamic_irq_cleanup()). dynamic_irq_cleanup() fails to NULL
the 'name' member and show_interrupts() references it on a few architectures
(like h8300, sh and x86).

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 kernel/irq/chip.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/kernel/irq/chip.c
===================================================================
--- linux.orig/kernel/irq/chip.c	2008-10-15 07:44:31.000000000 -0500
+++ linux/kernel/irq/chip.c	2008-10-16 06:55:56.000000000 -0500
@@ -79,6 +79,7 @@ void dynamic_irq_cleanup(unsigned int ir
 	desc->chip_data = NULL;
 	desc->handle_irq = handle_bad_irq;
 	desc->chip = &no_irq_chip;
+	desc->name = NULL;
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 
