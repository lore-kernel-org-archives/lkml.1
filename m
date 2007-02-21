Return-Path: <linux-kernel-owner+w=401wt.eu-S1423240AbXBUWtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423240AbXBUWtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423257AbXBUWtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:49:51 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42416 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423240AbXBUWtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:49:50 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/21] 2.6.19-stable review
References: <20070221013619.GA30227@kroah.com> <45DC9E1D.40805@redhat.com>
	<20070221114737.a09be761.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0702211208500.4043@woody.linux-foundation.org>
Date: Wed, 21 Feb 2007 15:45:54 -0700
In-Reply-To: <Pine.LNX.4.64.0702211208500.4043@woody.linux-foundation.org>
	(Linus Torvalds's message of "Wed, 21 Feb 2007 12:09:38 -0800 (PST)")
Message-ID: <m1odnnyvrx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert <cebbert@redhat.com> writes:

> We've tested it and found no problems so far.  It's definitely
> better than what's there now. :)

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Would be good to have Eric also ack them as safe and obvious.

Andi Kleen <ak@suse.de> writes:

> I didn't think the problem was serious enough for a backport. Do we have
> user reports? 
>
> It's certainly not trivial obvious patches. 
>
> Eric, what is your opinion? 


Bug reports:
 I have seen a couple of user reports and heard about a few more.  Given
 that Chuck Ebbert appears to have tested them I'm guessing redhat has
 seen a couple of reports as well.  One of the issues is that in
 some cases you can be susceptible and go for weeks without hitting
 this, so the bug reports aren't likely to come back fast.  So this is
 a long term stability issue.

 Even if we just put in my tiny fix that allows us to generally
 survive this condition in stable, it prints a nasty warning message
 so I expect people will want a more complete fix.

Vulnerability:
 I believe it is possible to trigger this bug on any SMP machine.

Obviousness:
 The first patch is obvious, but of course that isn't the interesting
 bit.

 The second patch is still fairly simple, and it appears to have
 undergone testing from people besides myself.  

 So in the interest of a timely if not perfect fix I think it is a
 good patch.  In particular I do not see any area where it would makes
 things worse.

Bugs:
 There is one small issue that is probably worth fixing.
 apic_in_service_vector only works correctly because we never have
 more than one local apic irq in service at the same time, (we keep
 irqs disabled during all of the interrupt routines).  The appended
 incremental patch addresses that.

Outstanding Issues:
 The big outstanding issue I am currently working on is that in my
 testing I have found evidence to suggest that ioapics do not strictly
 follow the pci ordering rules, so exactly when the last interrupt
 sent before we masked the interrupt at the interrupt controller will
 arrive is in question.  So to really be safe we cannot tear down the
 data structures for handling the interrupt in the old location until
 after we have seen the next interrupt showing up in the new location.

 I don't know if it is possible to for the issue I have just described
 to cause problems in practice. I intend to fix this for 2.6.21 if the
 patch will be accepted.  I have a patch that appears to work
 that I am currently testing now.

 I don't think my more complete fix will be as simple to backport
 because it is a more intrusive patch.

Subject: [PATCH] x86_64 irq: Make apic_in_service_vector robust

Currently apic_in_service_vector because it scans isr in the wrong
direction only works reliably because we never enable interrupts
during an interrupt handler.  I had the apic priorities backwards
in my head when I wrote it :(

It turns out that we have already saved off the vector we are servicing
in the irq regs so use that instead to make the code simpler and
more robust.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86_64/kernel/io_apic.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index fc42340..b6f9896 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -1395,15 +1395,9 @@ static int ioapic_retrigger_irq(unsigned int irq)
 
 static unsigned apic_in_service_vector(void)
 {
-	unsigned isr, vector;
+	unsigned vector;
 	/* Figure out which vector we are servicing */
-	for (vector = FIRST_EXTERNAL_VECTOR; vector < FIRST_SYSTEM_VECTOR; vector += 32) {
-		isr = apic_read(APIC_ISR + ((vector/32) * 0x10));
-		if (isr)
-			break;
-	}
-	/* Find the low bits of the vector we are servicing */
-	vector += __ffs(isr);
+	vector = ~get_irq_regs()->orig_rax;
 	return vector;
 }
 
-- 
1.5.0.g53756

