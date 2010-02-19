Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab0BSRBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:01:37 -0500
Received: from kroah.org ([198.145.64.141]:57819 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916Ab0BSRBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:12 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:54 2010
Message-Id: <20100219163254.013659746@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Arjan van de Ven <arjan@linux.intel.com>,
       Len Brown <len.brown@intel.com>
Subject: [83/93] ACPI: fix High cpu temperature with 2.6.32
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arjan van de Ven <arjan@linux.intel.com>

commit 370d5cd88509b93b76eb2f5f97efbd71c25061cb upstream.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/processor_idle.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
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
 


