Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087Ab0AMFcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab0AMFcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 00:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402Ab0AMFcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 00:32:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:50468 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab0AMFcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 00:32:16 -0500
Date: Tue, 12 Jan 2010 21:32:05 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dimitrios Apostolou <jimis@gmx.net>, Alex Chiang <achiang@hp.com>,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: High cpu temperature with 2.6.32, bisection shows commit 69d258
 (fwd)
Message-ID: <20100112213205.7d74808a@infradead.org>
In-Reply-To: <20100112160734.89ee6b11.akpm@linux-foundation.org>
References: <alpine.LNX.2.00.1001071941470.1363@localhost.localdomain>
	<20100108171513.GB22713@ldl.fc.hp.com>
	<20100109134352.3dedd4ea@infradead.org>
	<alpine.LNX.2.00.1001100155370.1325@localhost.localdomain>
	<20100109160836.26a344a9@infradead.org>
	<alpine.LNX.2.00.1001100226570.1325@localhost.localdomain>
	<20100109164240.43b21247@infradead.org>
	<alpine.LNX.2.00.1001100251210.1334@localhost.localdomain>
	<20100112160734.89ee6b11.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010 16:07:34 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > While testing your patch, indeed the temperature was not rising and 
> > everything was normal, but the tsc was not marked as unstable so it
> > didn't switch to acpi_pm clocksource, so that was probably the
> > reason.
> > 
> 
> Arjan, can you please prepare a formal version of the fix?  I guess
> the cc:stable will be needed as well.

sure see below
> 
> I assume that the effects which Dimitrios described above were the
> intended ones?

yes absolutely; having a stable tsc is a good thing, and totally expected
if you don't have C2.


Subject: Add two laptops to the C-state DMI table
From: Arjan van de Ven <arjan@linux.intel.com>

CC: stable@kernel.org

Since the rewrite of the CPU idle governor in 2.6.32, two laptops have surfaced
where the BIOS advertises a C2 power state, but for some reason this state is not
functioning (as verified in both cases by powertop before the patch in .32).

The old governor had the accidental behavior that if a non-working state was chosen
too many times, it would end up falling back to C1. The new governor works differently
and this accidental behavior is no longer there; the result is a high temperature
on these two machines.

This patch adds these 2 machines to the DMI table for C state anomalies; by just not using
C2 both these machines are better off (the TSC can be used instead of the pm timer, giving
a performance boost for example).

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>



diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index d1676b1..6c3145b 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -110,6 +110,14 @@ static struct dmi_system_id __cpuinitdata processor_power_dmi_table[] = {
 	  DMI_MATCH(DMI_BIOS_VENDOR,"Phoenix Technologies LTD"),
 	  DMI_MATCH(DMI_BIOS_VERSION,"SHE845M0.86C.0013.D.0302131307")},
 	 (void *)2},
+	{ set_max_cstate, "Pavilion zv5000", {
+	  DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+	  DMI_MATCH(DMI_PRODUCT_NAME,"Pavilion zv5000 (DS502A#ABA)")},
+	 (void *)1},
+	{ set_max_cstate, "Asus L8400B", {
+	  DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+	  DMI_MATCH(DMI_PRODUCT_NAME,"L8400B series Notebook PC")},
+	 (void *)1},
 	{},
 };
 





-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
