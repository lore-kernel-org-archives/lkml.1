Return-Path: <linux-kernel-owner+w=401wt.eu-S1762476AbZCNAsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762476AbZCNAsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbZCNAUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:20:07 -0400
Received: from kroah.org ([198.145.64.141]:35054 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753822AbZCNATq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:46 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:52 2009
Message-Id: <20090314000752.023337241@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:33 -0700
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
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com,
       Alexander Graf <agraf@suse.de>
Subject: [patch 85/96] Fix no_timer_check on x86_64
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=fix-no_timer_check-on-x86_64.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexander Graf <agraf@suse.de>

fixed upstream in 2.6.28 in merge of ioapic*.c for x86

In io_apic_32.c the logic of no_timer_check is "always make timer_irq_works
return 1".

Io_apic_64.c on the other hand checks for
  if (!no_timer_check && timer_irq_works())
basically meaning "make timer_irq_works fail" in the crucial first check.

Now, in order to not move too much code, we can just reverse the logic here
and should be fine off, basically rendering no_timer_check useful again.

This issue seems to be resolved as of 2.6.28 by the merge of io_apic*.c,
but still exists for at least 2.6.27.

Signed-off-by: Alexander Graf <agraf@suse.de>
Acked-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 arch/x86/kernel/io_apic_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -1729,7 +1729,7 @@ static inline void __init check_timer(vo
 			setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
 		}
 		unmask_IO_APIC_irq(0);
-		if (!no_timer_check && timer_irq_works()) {
+		if (no_timer_check || timer_irq_works()) {
 			if (nmi_watchdog == NMI_IO_APIC) {
 				setup_nmi();
 				enable_8259A_irq(0);


