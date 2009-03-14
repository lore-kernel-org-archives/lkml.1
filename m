Return-Path: <linux-kernel-owner+w=401wt.eu-S1763918AbZCNBh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763918AbZCNBh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbZCNBUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:52 -0400
Received: from kroah.org ([198.145.64.141]:35239 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753582AbZCNBUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:30 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:38 2009
Message-Id: <20090314011038.503177205@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:25 -0700
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
       alan@lxorguk.ukuu.org.uk, Tim Blechmann <tim@klingt.org>,
       Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 048/114] x86: oprofile: dont set counter width from cpuid on Core2
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=x86-oprofile-don-t-set-counter-width-from-cpuid-on-core2.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tim Blechmann <tim@klingt.org>

commit 780eef9492b16a1543a3b2ae9f9526a735fc9856 upstream.

Impact: fix stuck NMIs and non-working oprofile on certain CPUs

Resetting the counter width of the performance counters on Intel's
Core2 CPUs, breaks the delivery of NMIs, when running in x86_64 mode.

This should fix bug #12395:

  http://bugzilla.kernel.org/show_bug.cgi?id=12395

Signed-off-by: Tim Blechmann <tim@klingt.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
LKML-Reference: <20090303100412.GC10085@erda.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -78,8 +78,18 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
 	if (cpu_has_arch_perfmon) {
 		union cpuid10_eax eax;
 		eax.full = cpuid_eax(0xa);
-		if (counter_width < eax.split.bit_width)
-			counter_width = eax.split.bit_width;
+
+		/*
+		 * For Core2 (family 6, model 15), don't reset the
+		 * counter width:
+		 */
+		if (!(eax.split.version_id == 0 &&
+			current_cpu_data.x86 == 6 &&
+				current_cpu_data.x86_model == 15)) {
+
+			if (counter_width < eax.split.bit_width)
+				counter_width = eax.split.bit_width;
+		}
 	}
 
 	/* clear all counters */


