Return-Path: <linux-kernel-owner+w=401wt.eu-S1765915AbYCFM3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765915AbYCFM3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759549AbYCFM3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:29:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58531 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183AbYCFM3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:29:09 -0500
Date: Thu, 6 Mar 2008 13:28:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Glauber Costa <glommer@gmail.com>, Glauber Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de
Subject: Re: [PATCH 1/1] export native versions of machine_ops functions
Message-ID: <20080306122823.GA20173@elte.hu>
References: <1204739040-18422-1-git-send-email-gcosta@redhat.com> <20080306105500.GK13391@elte.hu> <5d6222a80803060349g69f570f3j9eaab980d7c58da@mail.gmail.com> <20080306121313.GA19613@elte.hu> <47CFE066.7000902@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CFE066.7000902@qumranet.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@qumranet.com> wrote:

>> i mean, i agree in general - but KVM is not a user of any of those 
>> currently static functions. So i've applied your patch but lets make 
>> sure those functions really get used :)
>
> The user will be in my 2.6.26 queue.  Unfortunately it means a 
> dependency between kvm.git and x86.git, again.

a couple of solutions:

- add the same patch to kvm.git (find it below), integrators 
  ought to be able to detect and exclude it

- i could start an x86.git#core tree that would include the for-linus 
  bits and any agreed-upon infrastructure changes [like this one]. (but 
  it would not include any other more experimental x86.git bits) You 
  could base kvm.git on that and track it. This makes integration even 
  easier because the commit IDs would be the same and git would be able 
  to resolve it. [but note, x86.git#core would not be an append-only 
  tree, it's a daily-rebased tree]

	Ingo

------------------>
Subject: x86: export native versions of machine_ops functions
From: Glauber Costa <gcosta@redhat.com>
Date: Wed, 5 Mar 2008 14:44:00 -0300

People overriding machine_ops provided functions may want to
call the native version after its pre-processing. It already
happens for the smp_ops functions, so I don't see a reason
for avoiding it here.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/reboot.c |   10 +++++-----
 include/asm-x86/reboot.h |    5 +++++
 2 files changed, 10 insertions(+), 5 deletions(-)

Index: linux-x86.q/arch/x86/kernel/reboot.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/reboot.c
+++ linux-x86.q/arch/x86/kernel/reboot.c
@@ -326,7 +326,7 @@ static inline void kb_wait(void)
 	}
 }
 
-static void native_machine_emergency_restart(void)
+void native_machine_emergency_restart(void)
 {
 	int i;
 
@@ -376,7 +376,7 @@ static void native_machine_emergency_res
 	}
 }
 
-static void native_machine_shutdown(void)
+void native_machine_shutdown(void)
 {
 	/* Stop the cpus and apics */
 #ifdef CONFIG_SMP
@@ -432,7 +432,7 @@ static void native_machine_shutdown(void
 #endif
 }
 
-static void native_machine_restart(char *__unused)
+void native_machine_restart(char *__unused)
 {
 	printk("machine restart\n");
 
@@ -441,11 +441,11 @@ static void native_machine_restart(char 
 	machine_emergency_restart();
 }
 
-static void native_machine_halt(void)
+void native_machine_halt(void)
 {
 }
 
-static void native_machine_power_off(void)
+void native_machine_power_off(void)
 {
 	if (pm_power_off) {
 		if (!reboot_force)
Index: linux-x86.q/include/asm-x86/reboot.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/reboot.h
+++ linux-x86.q/include/asm-x86/reboot.h
@@ -16,5 +16,10 @@ struct machine_ops
 extern struct machine_ops machine_ops;
 
 void machine_real_restart(unsigned char *code, int length);
+void native_machine_emergency_restart(void);
+void native_machine_shutdown(void);
+void native_machine_restart(char *__unused);
+void native_machine_halt(void);
+void native_machine_power_off(void);
 
 #endif	/* _ASM_REBOOT_H */
