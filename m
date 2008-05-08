Return-Path: <linux-kernel-owner+w=401wt.eu-S1764031AbYEHRno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764031AbYEHRno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbYEHRnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:43:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:33393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742AbYEHRnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:43:07 -0400
Date: Thu, 8 May 2008 10:41:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: [patch 01/16] 2.6.25 regression: powertop says 120K wakeups/sec
Message-ID: <20080508174153.GB855@suse.de>
References: <20080508173436.454278564@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="2.6.25-regression-powertop-says-120k-wakeups-sec.patch"
In-Reply-To: <20080508174122.GA855@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

commit 0fda6b403f0eca66ad8a7c946b3996e359100443 upstream

Patch to fix huge number of wakeups reported due to recent changes in
processor_idle.c. The problem was that the entry_method determination was
broken due to one of the recent commits (bc71bec91f987) causing
C1 entry to not to go to halt.

http://lkml.org/lkml/2008/3/22/124

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/processor_idle.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -848,6 +848,7 @@ static int acpi_processor_get_power_info
 		/* all processors need to support C1 */
 		pr->power.states[ACPI_STATE_C1].type = ACPI_STATE_C1;
 		pr->power.states[ACPI_STATE_C1].valid = 1;
+		pr->power.states[ACPI_STATE_C1].entry_method = ACPI_CSTATE_HALT;
 	}
 	/* the C0 state only exists as a filler in our array */
 	pr->power.states[ACPI_STATE_C0].valid = 1;
@@ -960,6 +961,9 @@ static int acpi_processor_get_power_info
 				 cx.address);
 		}
 
+		if (cx.type == ACPI_STATE_C1) {
+			cx.valid = 1;
+		}
 
 		obj = &(element->package.elements[2]);
 		if (obj->type != ACPI_TYPE_INTEGER)

-- 
