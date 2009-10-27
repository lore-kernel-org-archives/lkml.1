Return-Path: <linux-kernel-owner+w=401wt.eu-S1752992AbZJ0KBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbZJ0KBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 06:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbZJ0KBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 06:01:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:42027 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbZJ0KBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 06:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=PyLARI9l5/wgwdVidZp4vTZmHYEQJbDxHnAztZ1JtkKqhwFi+yHJi3bBoLf4iiZxds
         7XPus6F2CFxq79yNyQj7eJkQvwUnKc3jtWdixG3izpuUojOTnXD1rhR7xUAnJPwEHhHk
         5gAMOPW1ohr0zrajxrb32EZ0tCqnytyIpckvY=
Date: Tue, 27 Oct 2009 11:01:38 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, apic: Clear APIC Timer Initial Count Register on
 shutdown
Message-ID: <20091027100138.GB30802@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit a98f8fd24fb24fcb9a359553e64dd6aac5cf4279 (x86: apic reset
counter on shutdown) set the counter to max to avoid spurious
interrupts when the timer is re-enabled.

(In theory) you'll still get a spurious interrupt if spending more
than 344 seconds with this interrupt disabled and then unmasking it.

The right thing to do is to clear the register. This disables the
interrupt from happening (at least it does on AMD hardware).

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index dce93d4..4c689f4 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -444,7 +444,7 @@ static void lapic_timer_setup(enum clock_event_mode mode,
 		v = apic_read(APIC_LVTT);
 		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
 		apic_write(APIC_LVTT, v);
-		apic_write(APIC_TMICT, 0xffffffff);
+		apic_write(APIC_TMICT, 0);
 		break;
 	case CLOCK_EVT_MODE_RESUME:
 		/* Nothing to do here */
-- 
1.6.2.5

