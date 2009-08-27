Return-Path: <linux-kernel-owner+w=401wt.eu-S1751596AbZH0H7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbZH0H7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 03:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZH0H7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 03:59:05 -0400
Received: from pan.madism.org ([88.191.52.104]:45125 "EHLO hermes.madism.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbZH0H7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 03:59:04 -0400
Date: Thu, 27 Aug 2009 09:59:02 +0200
From: Pierre Habouzit <pierre.habouzit@intersec.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH v2] perf tools: do not complain if root is owning perf.data
Message-ID: <20090827075902.GF19653@laphroaig.corp>
References: <1251291926-27174-1-git-send-email-pierre.habouzit@intersec.com>
 <20090826182459.GD13632@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090826182459.GD13632@elte.hu>
X-Face: $(^e[V4D-[`f2EmMGz@fgWK!e.B~2g.{08lKPU(nc1J~z\4B>*JEVq:E]7G-\6$Ycr4<;Z!|VY6Grt]+RsS$IMV)f>2)M="tY:ZPcU;&%it2D81X^kNya0=L]"vZmLP+UmKhgq+u*\.dJ8G!N&=EvlD
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This improves patch fa6963b24 so that perf.data stuff that has been dumped
as root can be read (annotate/report) by a user without the use of the
--force.

Rationale is that root has plenty of ways to screw us (usually) that do
not require twisted schemes involving specially crafting a perf.data.

Signed-off-by: Pierre Habouzit <pierre.habouzit@intersec.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
Cc: <stable@kernel.org>
---
    On Wed, Aug 26, 2009 at 08:24:59PM +0200, Ingo Molnar wrote:
    > Ok, this makes sense - but i think we should do this in .32 only, 
    > with a Cc: <stable@kernel.org> backport tag for .31.1.

    You're the boss ;)

    > Mind doing it against the latest perfcounters tree, which can be 
    > found in -tip:
    > 
    >   http://people.redhat.com/mingo/tip.git/README
    > 
    > your current version does not apply cleanly as the surrounding code 
    > has changed a bit already.

    Here it is, against perfcounters/core which I assume is the proper
    tip branch. Note that I'd suggest adding a README.Devel under
    tools/perf to explicit how patches should be submitted, at least to
    explain against which tree it's best to do our patches for
    submission, it could help people avoiding losing your time with
    unnecessary back-and-forth mails just to rebase a patch ;)

 tools/perf/builtin-annotate.c |    4 ++--
 tools/perf/builtin-report.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 4ac618b..4c7bc44 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -984,8 +984,8 @@ static int __cmd_annotate(void)
 		exit(-1);
 	}
 
-	if (!force && (input_stat.st_uid != geteuid())) {
-		fprintf(stderr, "file: %s not owned by current user\n", input_name);
+	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
+		fprintf(stderr, "file: %s not owned by current user or root\n", input_name);
 		exit(-1);
 	}
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d2e2882..ea6328a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1405,8 +1405,8 @@ static int __cmd_report(void)
 		exit(-1);
 	}
 
-	if (!force && (input_stat.st_uid != geteuid())) {
-		fprintf(stderr, "file: %s not owned by current user\n", input_name);
+	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
+		fprintf(stderr, "file: %s not owned by current user or root\n", input_name);
 		exit(-1);
 	}
 
-- 
1.6.4.1.341.gf2a44

