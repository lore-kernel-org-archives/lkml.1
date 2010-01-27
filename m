Return-Path: <linux-kernel-owner+w=401wt.eu-S932232Ab0A0XZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab0A0XZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932223Ab0A0XZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:25:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932190Ab0A0XZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:25:50 -0500
Date: Wed, 27 Jan 2010 15:25:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Dimitrios Apostolou <jimis@gmx.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #15040] High cpu temperature with 2.6.32
Message-Id: <20100127152539.eb2c8231.akpm@linux-foundation.org>
In-Reply-To: <201001261343.15685.rjw@sisk.pl>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
	<201001252152.33031.rjw@sisk.pl>
	<20100125214150.1f2e1410@infradead.org>
	<201001261343.15685.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 13:43:15 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday 26 January 2010, Arjan van de Ven wrote:
> > On Mon, 25 Jan 2010 21:52:32 +0100
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > On Monday 25 January 2010, Dimitrios Apostolou wrote:
> > > > I will let you know when this bug is fixed in a regular kernel
> > > > release. I just tested 2.6.32.5 and the bug persists. BTW, Arjan, I
> > > > think this bug will be biting other people too, see the following
> > > > thread: http://bugs.archlinux.org/task/17771
> > > 
> > > I don't think it's fixed, I haven't seen the Arjan's patch anywhere
> > > close to the mainline.
> > > 
> > > Arjan, perhaps send it directly to Linus, please (unless it's already
> > > waiting somewhere for merging)?
> > 
> > I sent it to Len and Andrew (Len as maintainer, Andrew as maintainer of
> > last resort)..... what more would I need?
> 
> Well, Andrew, do you have the patch at http://patchwork.kernel.org/patch/71962/
> in your queue?  It's a regression fix.
> 

I had half of it, as
acpi-add-the-hp-pavilion-zv5000-to-the-power-dmi-table.patch.  Updated.



From: Arjan van de Ven <arjan@linux.intel.com>

Since the rewrite of the CPU idle governor in 2.6.32, two laptops have
surfaced where the BIOS advertises a C2 power state, but for some reason
this state is not functioning (as verified in both cases by powertop
before the patch in .32).

The old governor had the accidental behavior that if a non-working state
was chosen too many times, it would end up falling back to C1.  The new
governor works differently and this accidental behavior is no longer
there; the result is a high temperature on these two machines.

This patch adds these 2 machines to the DMI table for C state anomalies;
by just not using C2 both these machines are better off (the TSC can be
used instead of the pm timer, giving a performance boost for example).

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14742

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Reported-by: <akwatts@ymail.com>
Cc: Dimitrios Apostolou <jimis@gmx.net>
Cc: Alex Chiang <achiang@hp.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/acpi/processor_idle.c~drivers-acpi-processor_idlec-add-two-laptops-to-the-c-state-dmi-table drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~drivers-acpi-processor_idlec-add-two-laptops-to-the-c-state-dmi-table
+++ a/drivers/acpi/processor_idle.c
@@ -110,6 +110,14 @@ static struct dmi_system_id __cpuinitdat
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
 
_

