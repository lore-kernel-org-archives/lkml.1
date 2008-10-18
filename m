Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbYJRTUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbYJRTUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYJRTF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:05:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:38730 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbYJRTFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:05:55 -0400
Date: Sat, 18 Oct 2008 11:57:13 -0700
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
Subject: [patch 01/14] x86: Reserve FIRST_DEVICE_VECTOR in used_vectors
	bitmap.
Message-ID: <20081018185713.GB17196@suse.de>
References: <20081018185031.236868964@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-reserve-first_device_vector-in-used_vectors-bitmap.patch"
In-Reply-To: <20081018185658.GA17196@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
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
@@ -2305,6 +2305,9 @@ void __init setup_IO_APIC(void)
 	for (i = FIRST_SYSTEM_VECTOR; i < NR_VECTORS; i++)
 		set_bit(i, used_vectors);
 
+	/* Mark FIRST_DEVICE_VECTOR which is assigned to IRQ0 as used. */
+	set_bit(FIRST_DEVICE_VECTOR, used_vectors);
+
 	enable_IO_APIC();
 
 	if (acpi_ioapic)

-- 
