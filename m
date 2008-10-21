Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbYJULRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbYJULRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 07:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYJULRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 07:17:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37751 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbYJULRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 07:17:40 -0400
Date: Tue, 21 Oct 2008 13:17:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs"
Message-ID: <20081021111716.GA4476@elte.hu>
References: <20081017171139.GA1792@elte.hu> <87r66ejqla.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r66ejqla.fsf@basil.nowhere.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> >   *	acpi_pm_disable_gpes - Disable the GPEs.
> >   */
> > -static int acpi_pm_disable_gpes(void)
> > +static inline int acpi_pm_disable_gpes(void)
> 
> Just to satisfy my curiosity, what compiler warning does marking 
> functions inline fix?

the commit log below explains the situation. The warning exposed a maze 
of #ifdefs in drivers/acpi/sleep/main.c. It's not the warning we need to 
"fix" but that maze, obviously.

	Ingo

-------------------------------------------->
>From 6ddae344a73fcff60c840dd4e429bf55562b41f3 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 17 Oct 2008 15:44:22 +0200
Subject: [PATCH]  #ifdef complications in drivers/acpi/sleep/main.c

this warning:

  drivers/acpi/sleep/main.c:67: warning: ‘acpi_pm_disable_gpes’ defined but not used
  drivers/acpi/sleep/main.c:92: warning: ‘acpi_pm_prepare’ defined but not used
  drivers/acpi/sleep/main.c:107: warning: ‘acpi_pm_finish’ defined but not used
  drivers/acpi/sleep/main.c:128: warning: ‘acpi_pm_end’ defined but not used

Shows that this code has an identity crisis due to a maze of #ifdefs, in
the PM_SLEEP && !SUSPEND && !HIBERNATION case for example.

Instead of complicating the code with even more #ifdefs, one option
would be to convert these rather trivial wrappers to inline functions
(implemented in this commit). Maybe there's a better solution as well -
such as to reduce the many config options we have in this area?

No size difference with SUSPEND && HIBERNATION turned back on:

drivers/acpi/sleep/main.o:

   text	   data	    bss	    dec	    hex	filename
   2717	    976	     33	   3726	    e8e	main.o.before
   2717	    976	     33	   3726	    e8e	main.o.after

md5:
   44220906eff0ea6e1a3266b35dd82ac2  main.o.before.asm
   44220906eff0ea6e1a3266b35dd82ac2  main.o.after.asm
---
 drivers/acpi/sleep/main.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index d13194a..2276d75 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -63,7 +63,7 @@ void __init acpi_old_suspend_ordering(void)
 /**
  *	acpi_pm_disable_gpes - Disable the GPEs.
  */
-static int acpi_pm_disable_gpes(void)
+static inline int acpi_pm_disable_gpes(void)
 {
 	acpi_hw_disable_all_gpes();
 	return 0;
@@ -75,7 +75,7 @@ static int acpi_pm_disable_gpes(void)
  *	If necessary, set the firmware waking vector and do arch-specific
  *	nastiness to get the wakeup code to the waking vector.
  */
-static int __acpi_pm_prepare(void)
+static inline int __acpi_pm_prepare(void)
 {
 	int error = acpi_sleep_prepare(acpi_target_sleep_state);
 
@@ -88,7 +88,7 @@ static int __acpi_pm_prepare(void)
  *	acpi_pm_prepare - Prepare the platform to enter the target sleep
  *		state and disable the GPEs.
  */
-static int acpi_pm_prepare(void)
+static inline int acpi_pm_prepare(void)
 {
 	int error = __acpi_pm_prepare();
 
@@ -103,7 +103,7 @@ static int acpi_pm_prepare(void)
  *	This is called after we wake back up (or if entering the sleep state
  *	failed).
  */
-static void acpi_pm_finish(void)
+static inline void acpi_pm_finish(void)
 {
 	u32 acpi_state = acpi_target_sleep_state;
 
@@ -124,7 +124,7 @@ static void acpi_pm_finish(void)
 /**
  *	acpi_pm_end - Finish up suspend sequence.
  */
-static void acpi_pm_end(void)
+static inline void acpi_pm_end(void)
 {
 	/*
 	 * This is necessary in case acpi_pm_finish() is not called during a
