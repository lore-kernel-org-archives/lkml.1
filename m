Return-Path: <linux-kernel-owner+w=401wt.eu-S1762940AbZBDTAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762940AbZBDTAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761407AbZBDStd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:33 -0500
Received: from kroah.org ([198.145.64.141]:32806 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761380AbZBDStY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:24 -0500
Date: Wed, 4 Feb 2009 10:46:36 -0800
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
       alan@lxorguk.ukuu.org.uk, Zhao Yakui <yakui.zhao@intel.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>, Thomas Renninger <trenn@suse.de>
Subject: [patch 24/41] ACPI: Avoid array address overflow when _CST MWAIT
	hint bits are set
Message-ID: <20090204184636.GY25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-avoid-array-address-overflow-when-_cst-mwait-hint-bits-are-set.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhao Yakui <yakui.zhao@intel.com>

commit 13b40a1a065824d2d4e55c8b48ea9f3f9d162929 upstream.

The Cx Register address obtained from the _CST object is used as the MWAIT
hints if the register type is FFixedHW. And it is used to check whether
the Cx type is supported or not.

On some boxes the following Cx state package is obtained from _CST object:
    >{
                ResourceTemplate ()
                {
                    Register (FFixedHW,
                        0x01,               // Bit Width
                        0x02,               // Bit Offset
                        0x0000000000889759, // Address
                        0x03,               // Access Size
                        )
                },

                0x03,
                0xF5,
                0x015E }

   In such case we should use the bit[7:4] of Cx address to check whether
the Cx type is supported or not.

mask the MWAIT hint to avoid array address overflow

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Acked-by:Venki Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>

---
 arch/x86/kernel/acpi/cstate.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -56,6 +56,7 @@ static struct cstate_entry *cpu_cstate_e
 static short mwait_supported[ACPI_PROCESSOR_MAX_POWER];
 
 #define MWAIT_SUBSTATE_MASK	(0xf)
+#define MWAIT_CSTATE_MASK	(0xf)
 #define MWAIT_SUBSTATE_SIZE	(4)
 
 #define CPUID_MWAIT_LEAF (5)
@@ -98,7 +99,8 @@ int acpi_processor_ffh_cstate_probe(unsi
 	cpuid(CPUID_MWAIT_LEAF, &eax, &ebx, &ecx, &edx);
 
 	/* Check whether this particular cx_type (in CST) is supported or not */
-	cstate_type = (cx->address >> MWAIT_SUBSTATE_SIZE) + 1;
+	cstate_type = ((cx->address >> MWAIT_SUBSTATE_SIZE) &
+			MWAIT_CSTATE_MASK) + 1;
 	edx_part = edx >> (cstate_type * MWAIT_SUBSTATE_SIZE);
 	num_cstate_subtype = edx_part & MWAIT_SUBSTATE_MASK;
 

