Return-Path: <linux-kernel-owner+w=401wt.eu-S1761410AbYGAPYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410AbYGAPYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760560AbYGAPWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:22:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:43349 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760530AbYGAPWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:22:31 -0400
Date: Tue, 1 Jul 2008 08:19:18 -0700
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
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 8/9] x86: fix cpu hotplug crash
Message-ID: <20080701151918.GI3536@suse.de>
References: <20080701151057.930340322@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-cpu-hotplug-crash.patch"
In-Reply-To: <20080701151835.GA3536@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Yanmin Zhang <yanmin_zhang@linux.intel.com>

Commit fcb43042ef55d2f46b0efa5d7746967cef38f056 upstream

x86: fix cpu hotplug crash

Vegard Nossum reported crashes during cpu hotplug tests:

  http://marc.info/?l=linux-kernel&m=121413950227884&w=4

In function _cpu_up, the panic happens when calling
__raw_notifier_call_chain at the second time. Kernel doesn't panic when
calling it at the first time. If just say because of nr_cpu_ids, that's
not right.

By checking the source code, I found that function do_boot_cpu is the culprit.
Consider below call chain:
 _cpu_up=>__cpu_up=>smp_ops.cpu_up=>native_cpu_up=>do_boot_cpu.

So do_boot_cpu is called in the end. In do_boot_cpu, if
boot_error==true, cpu_clear(cpu, cpu_possible_map) is executed. So later
on, when _cpu_up calls __raw_notifier_call_chain at the second time to
report CPU_UP_CANCELED, because this cpu is already cleared from
cpu_possible_map, get_cpu_sysdev returns NULL.

Many resources are related to cpu_possible_map, so it's better not to
change it.

Below patch against 2.6.26-rc7 fixes it by removing the bit clearing in
cpu_possible_map.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Tested-by: Vegard Nossum <vegard.nossum@gmail.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 arch/x86/kernel/smpboot_64.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -704,7 +704,6 @@ do_rest:
 		clear_bit(cpu, (unsigned long *)&cpu_initialized); /* was set by cpu_init() */
 		clear_node_cpumask(cpu); /* was set by numa_add_cpu */
 		cpu_clear(cpu, cpu_present_map);
-		cpu_clear(cpu, cpu_possible_map);
 		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
 		return -EIO;
 	}

-- 
