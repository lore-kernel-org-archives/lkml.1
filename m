Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYJPSBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYJPSBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbYJPSAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:00:25 -0400
Received: from mail.suse.de ([195.135.220.2]:36011 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671AbYJPSAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:00:24 -0400
Date: Thu, 16 Oct 2008 10:56:22 -0700
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
       alan@lxorguk.ukuu.org.uk, Stefan Bader <stefan.bader@canonical.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 02/14] x86: Reserve FIRST_DEVICE_VECTOR in used_vectors
	bitmap.
Message-ID: <20081016175622.GC12850@suse.de>
References: <20081016174814.734527827@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-reserve-first_device_vector-in-used_vectors-bitmap.patch"
In-Reply-To: <20081016175525.GA12850@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Stefan Bader <stefan.bader@canonical.com>

Not in upstream above 2.6.27 due to change in the way this code works
(has been fixed differently there.)

Someone from the community found out, that after repeatedly unloading
and loading a device driver that uses MSI IRQs, the system eventually
assigned the vector initially reserved for IRQ0 to the device driver.

The reason for this is, that although IRQ0 is tied to the
FIRST_DEVICE_VECTOR when declaring the irq_vector table, the
corresponding bit in the used_vectors map is not set. So, if vectors are
released and assigned often enough, the vector will get assigned to
another interrupt. This happens more often with MSI interrupts as those
are exclusively using a vector.

Fix this by setting the bit for the FIRST_DEVICE_VECTOR in the bitmap.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/io_apic_32.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -2314,6 +2314,9 @@ void __init setup_IO_APIC(void)
 	for (i = first_system_vector; i < NR_VECTORS; i++)
 		set_bit(i, used_vectors);
 
+	/* Mark FIRST_DEVICE_VECTOR which is assigned to IRQ0 as used. */
+	set_bit(FIRST_DEVICE_VECTOR, used_vectors);
+
 	enable_IO_APIC();
 
 	io_apic_irqs = ~PIC_IRQS;

-- 
