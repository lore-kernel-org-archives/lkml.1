Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbYKFPGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbYKFPGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYKFPGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:06:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54840 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbYKFPGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:06:36 -0500
Date: Thu, 6 Nov 2008 16:06:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eduardo Habkost <ehabkost@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] Revert "x86: default to reboot via ACPI"
Message-ID: <20081106150610.GA1644@elte.hu>
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com> <1225915018-6548-16-git-send-email-ehabkost@redhat.com> <20081106071445.GI15731@elte.hu> <20081106124031.GO5247@blackpad> <20081106143021.GD13023@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106143021.GD13023@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > Andrey Borzenkov's patch, for example, adds a new DMI entry 
> > because reboot=acpi breaks his keyboard (even without KVM, I 
> > guess). Andrey, was that the case?
> 
> hm, IIRC the problem was KVM in his case too.

actually, Andrey's problem seems to be unrelated. So i've queued up 
the revert below in tip/x86/urgent for v2.6.28. Thanks guys!

	Ingo

---------------->
>From 8d00450d296dedec9ada38d43b83e79cca6fd5a3 Mon Sep 17 00:00:00 2001
From: Eduardo Habkost <ehabkost@redhat.com>
Date: Tue, 4 Nov 2008 12:52:44 -0200
Subject: [PATCH] Revert "x86: default to reboot via ACPI"

This reverts commit c7ffa6c26277b403920e2255d10df849bd613380.

the assumptio of this change was that this would not break
any existing machine. Andrey Borzenkov reported troubles with
the ACPI reboot method: the system would hang on reboot, necessiating
a power cycle. Probably more systems are affected as well.

Also, there are patches queued up for v2.6.29 to disable virtualization
on emergency_restart() - which was the original motivation of
this change.

Reported-by: Andrey Borzenkov <arvidjaar@mail.ru>
Bisected-by: Andrey Borzenkov <arvidjaar@mail.ru>
Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Acked-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/reboot.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index f4c93f1..724adfc 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -29,11 +29,7 @@ EXPORT_SYMBOL(pm_power_off);
 
 static const struct desc_ptr no_idt = {};
 static int reboot_mode;
-/*
- * Keyboard reset and triple fault may result in INIT, not RESET, which
- * doesn't work when we're in vmx root mode.  Try ACPI first.
- */
-enum reboot_type reboot_type = BOOT_ACPI;
+enum reboot_type reboot_type = BOOT_KBD;
 int reboot_force;
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_SMP)
