Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbZJESLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbZJESLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 14:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbZJESLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 14:11:39 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:31963 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754443AbZJESLi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 14:11:38 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: futex question
Date: Mon, 5 Oct 2009 11:11:00 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501FD8752@exchange.ZeugmaSystems.local>
In-Reply-To: <1254738974.26976.24.camel@twins>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: futex question
Thread-Index: AcpFp1x/JKbp9PR2RPmNlfbRmdE46wAPs7AQ
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local> <20091001092218.GH15345@elte.hu> <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local> <4AC68F13.8050601@us.ibm.com> <alpine.LFD.2.00.0910041031330.2646@localhost.localdomain> <DDFD17CC94A9BD49A82147DDF7D545C501F457C5@exchange.ZeugmaSystems.local> <4AC8CF32.8060108@anirban.org> <alpine.LFD.2.00.0910041853180.2646@localhost.localdomain> <1254738974.26976.24.camel@twins>
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Thomas Gleixner" <tglx@linutronix.de>
Cc: "Anirban Sinha" <ani@anirban.org>, "Ingo Molnar" <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>, "Darren Hart" <dvhltc@us.ibm.com>,
       "Kaz Kylheku" <KKylheku@zeugmasystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
>The problem with the patch send my Ani is that it clears the robust
>lists before the point of no return, so on a failing execve() we'd have
>messed up the state.

Ah! yes. I should have added the lines after load_binary() succeeds:

 fs/compat.c |    3 +++
 fs/exec.c   |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 6d6f98f..7d1baf5 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1539,6 +1539,9 @@ int compat_do_execve(char * filename,
        if (retval < 0)
                goto out;

+#ifdef CONFIG_FUTEX
+       current->compat_robust_list = NULL;
+#endif
        /* execve succeeded */
        current->fs->in_exec = 0;
        current->in_execve = 0;
diff --git a/fs/exec.c b/fs/exec.c
index 172ceb6..d7b4ca3 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1354,6 +1354,9 @@ int do_execve(char * filename,
        if (retval < 0)
                goto out;

+#ifdef CONFIG_FUTEX
+       current->robust_list = NULL;
+#endif
        /* execve succeeded */
        current->fs->in_exec = 0;
        current->in_execve = 0;



btw, by the same token, shouldn't we call sched_exec() after the exec()
actually succeeds and the process has a new mm (thus having a smallest
effective memory and cache footprint)? I know that I could be missing
something subtle.

Ani

