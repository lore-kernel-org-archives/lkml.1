Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbZJAXly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbZJAXly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbZJAXlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:41:52 -0400
Received: from kroah.org ([198.145.64.141]:42059 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058AbZJAXiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:38:17 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:33:21 2009
Message-Id: <20091001233321.739706856@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:31:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Jones <davej@redhat.com>
Subject: [patch 20/30] [CPUFREQ] Fix NULL ptr regression in powernow-k8
References: <20091001233116.947658905@mini.kroah.org>
Content-Disposition: inline; filename=fix-null-ptr-regression-in-powernow-k8.patch
In-Reply-To: <20091001233504.GA17709@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kurt Roeckx <kurt@roeckx.be>

commit f0adb134d8dc9993a9998dc50845ec4f6ff4fadc upstream.

Fixes bugzilla #13780

From: Kurt Roeckx <kurt@roeckx.be>
Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -618,9 +618,10 @@ static int check_pst_table(struct powern
 	return 0;
 }
 
-static void invalidate_entry(struct powernow_k8_data *data, unsigned int entry)
+static void invalidate_entry(struct cpufreq_frequency_table *powernow_table,
+		unsigned int entry)
 {
-	data->powernow_table[entry].frequency = CPUFREQ_ENTRY_INVALID;
+	powernow_table[entry].frequency = CPUFREQ_ENTRY_INVALID;
 }
 
 static void print_basics(struct powernow_k8_data *data)
@@ -926,13 +927,13 @@ static int fill_powernow_table_pstate(st
 					"bad value %d.\n", i, index);
 			printk(KERN_ERR PFX "Please report to BIOS "
 					"manufacturer\n");
-			invalidate_entry(data, i);
+			invalidate_entry(powernow_table, i);
 			continue;
 		}
 		rdmsr(MSR_PSTATE_DEF_BASE + index, lo, hi);
 		if (!(hi & HW_PSTATE_VALID_MASK)) {
 			dprintk("invalid pstate %d, ignoring\n", index);
-			invalidate_entry(data, i);
+			invalidate_entry(powernow_table, i);
 			continue;
 		}
 
@@ -982,7 +983,7 @@ static int fill_powernow_table_fidvid(st
 		/* verify frequency is OK */
 		if ((freq > (MAX_FREQ * 1000)) || (freq < (MIN_FREQ * 1000))) {
 			dprintk("invalid freq %u kHz, ignoring\n", freq);
-			invalidate_entry(data, i);
+			invalidate_entry(powernow_table, i);
 			continue;
 		}
 
@@ -990,7 +991,7 @@ static int fill_powernow_table_fidvid(st
 		 * BIOSs are using "off" to indicate invalid */
 		if (vid == VID_OFF) {
 			dprintk("invalid vid %u, ignoring\n", vid);
-			invalidate_entry(data, i);
+			invalidate_entry(powernow_table, i);
 			continue;
 		}
 
@@ -1021,7 +1022,7 @@ static int fill_powernow_table_fidvid(st
 				(unsigned int)
 				(data->acpi_data.states[i].core_frequency
 				 * 1000));
-			invalidate_entry(data, i);
+			invalidate_entry(powernow_table, i);
 			continue;
 		}
 	}


