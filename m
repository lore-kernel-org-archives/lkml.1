Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbZFCJlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbZFCJlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZFCJkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:40:42 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:40309 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbZFCJkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:40:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18982.17586.666132.90983@cargo.ozlabs.ibm.com>
Date: Wed, 3 Jun 2009 19:38:58 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] perf_counter: powerpc: Fix event alternative code generation on POWER5/5+
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ef923214 ("perf_counter: powerpc: use u64 for event codes
internally") introduced a bug where the return value from function
find_alternative_bdecode gets put into a u64 variable and later tested
to see if it is < 0.  The effect is that we get extra, bogus event
code alternatives on POWER5 and POWER5+, leading to error messages
such as "oops compute_mmcr failed" being printed and counters not
counting properly.

This fixes it by using s64 for the return type of find_alternative_bdecode
and for the local variable that the caller puts the value in.  It also
makes the event argument a u64 on POWER5+ for consistency.

Signed-off-by: Paul Mackerras <paulus@samba.org>
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
-- 
1.6.0.4

