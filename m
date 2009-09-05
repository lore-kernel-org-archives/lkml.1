Return-Path: <linux-kernel-owner+w=401wt.eu-S934341AbZIEAdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934341AbZIEAdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934545AbZIEAUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:20:32 -0400
Received: from kroah.org ([198.145.64.141]:42048 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934544AbZIEAUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:30 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:47 2009
Message-Id: <20090905001447.558632285@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:13:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 04/71] x86: dont send an IPI to the empty set of CPUs
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=x86-don-t-send-an-ipi-to-the-empty-set-of-cpu-s.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit 83d349f35e1ae72268c5104dbf9ab2ae635425d4 upstream.

The default_send_IPI_mask_logical() function uses the "flat" APIC mode
to send an IPI to a set of CPU's at once, but if that set happens to be
empty, some older local APIC's will apparently be rather unhappy.  So
just warn if a caller gives us an empty mask, and ignore it.

This fixes a regression in 2.6.30.x, due to commit 4595f9620 ("x86:
change flush_tlb_others to take a const struct cpumask"), documented
here:

	http://bugzilla.kernel.org/show_bug.cgi?id=13933

which causes a silent lock-up.  It only seems to happen on PPro, P2, P3
and Athlon XP cores.  Most developers sadly (or not so sadly, if you're
a developer..) have more modern CPU's.  Also, on x86-64 we don't use the
flat APIC mode, so it would never trigger there even if the APIC didn't
like sending an empty IPI mask.

Reported-by: Pavel Vilim <wylda@volny.cz>
Reported-and-tested-by: Thomas Björnell <thomas.bjornell@gmail.com>
Reported-and-tested-by: Martin Rogge <marogge@onlinehome.de>
Cc: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/ipi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -106,6 +106,9 @@ void default_send_IPI_mask_logical(const
 	unsigned long mask = cpumask_bits(cpumask)[0];
 	unsigned long flags;
 
+	if (WARN_ONCE(!mask, "empty IPI mask"))
+		return;
+
 	local_irq_save(flags);
 	WARN_ON(mask & ~cpumask_bits(cpu_online_mask)[0]);
 	__default_send_IPI_dest_field(mask, vector, apic->dest_logical);


