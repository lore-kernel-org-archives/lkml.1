Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbZFCJwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbZFCJwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbZFCJwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:52:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:60260 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbZFCJwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:52:02 -0400
Date: Wed, 3 Jun 2009 09:51:30 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, eranian@googlemail.com,
       jkacur@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, eranian@googlemail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <18982.17586.666132.90983@cargo.ozlabs.ibm.com>
References: <18982.17586.666132.90983@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: powerpc: Fix event alternative code generation on POWER5/5+
Message-ID: <tip-6984efb692e97ce5f75f26e595685c04c2061bac@git.kernel.org>
Git-Commit-ID: 6984efb692e97ce5f75f26e595685c04c2061bac
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 09:51:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6984efb692e97ce5f75f26e595685c04c2061bac
Gitweb:     http://git.kernel.org/tip/6984efb692e97ce5f75f26e595685c04c2061bac
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Wed, 3 Jun 2009 19:38:58 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 11:49:52 +0200

perf_counter: powerpc: Fix event alternative code generation on POWER5/5+

Commit ef923214 ("perf_counter: powerpc: use u64 for event
codes internally") introduced a bug where the return value from
function find_alternative_bdecode gets put into a u64 variable
and later tested to see if it is < 0.  The effect is that we
get extra, bogus event code alternatives on POWER5 and POWER5+,
leading to error messages such as "oops compute_mmcr failed"
being printed and counters not counting properly.

This fixes it by using s64 for the return type of
find_alternative_bdecode and for the local variable that the
caller puts the value in.  It also makes the event argument a
u64 on POWER5+ for consistency.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
Cc: Stephane Eranian <eranian@googlemail.com>
LKML-Reference: <18982.17586.666132.90983@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/power5+-pmu.c |    4 ++--
 arch/powerpc/kernel/power5-pmu.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/power5+-pmu.c b/arch/powerpc/kernel/power5+-pmu.c
index c6cdfc1..8471e3c 100644
--- a/arch/powerpc/kernel/power5+-pmu.c
+++ b/arch/powerpc/kernel/power5+-pmu.c
@@ -242,7 +242,7 @@ static const unsigned char bytedecode_alternatives[4][4] = {
  * event code for those that do, or -1 otherwise.  This also handles
  * alternative PCMSEL values for add events.
  */
-static int find_alternative_bdecode(unsigned int event)
+static s64 find_alternative_bdecode(u64 event)
 {
 	int pmc, altpmc, pp, j;
 
@@ -277,7 +277,7 @@ static int power5p_get_alternatives(u64 event, unsigned int flags, u64 alt[])
 {
 	int i, j, nalt = 1;
 	int nlim;
-	u64 ae;
+	s64 ae;
 
 	alt[0] = event;
 	nalt = 1;
diff --git a/arch/powerpc/kernel/power5-pmu.c b/arch/powerpc/kernel/power5-pmu.c
index d534496..1b44c5f 100644
--- a/arch/powerpc/kernel/power5-pmu.c
+++ b/arch/powerpc/kernel/power5-pmu.c
@@ -250,7 +250,7 @@ static const unsigned char bytedecode_alternatives[4][4] = {
  * PMCSEL values on other counters.  This returns the alternative
  * event code for those that do, or -1 otherwise.
  */
-static u64 find_alternative_bdecode(u64 event)
+static s64 find_alternative_bdecode(u64 event)
 {
 	int pmc, altpmc, pp, j;
 
@@ -272,7 +272,7 @@ static u64 find_alternative_bdecode(u64 event)
 static int power5_get_alternatives(u64 event, unsigned int flags, u64 alt[])
 {
 	int i, j, nalt = 1;
-	u64 ae;
+	s64 ae;
 
 	alt[0] = event;
 	nalt = 1;
