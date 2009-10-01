Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbZJAXqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbZJAXqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbZJAXqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:46:53 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:10139 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753341AbZJAXqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:46:52 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: futex question
Date: Thu, 1 Oct 2009 16:46:16 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local>
In-Reply-To: <20091001092218.GH15345@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: futex question
Thread-Index: AcpCeM5Y8udjwKupT8qLYDY1nIet2AAdnIXg
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local> <20091001092218.GH15345@elte.hu>
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Darren Hart" <dvhltc@us.ibm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Should we not just clear the pointer (and
>> it's compat version) within do_execve()?


In our private repository, applying the following patch resolved the
issues I mentioned. I no longer see messages like this:

 [futex] ("ifconfig")(pid=2509) exit_robust_list:unable to fetch robust
entry. uaddr=0x000000002abbc4f0

from my instrumented kernel within exit_robust_list(). My
instrumentation looked something like this:

if (fetch_robust_entry(...)) {
printk(...);
return;
}

Just tossing the patch in the community in case someone is interested
...



Signed-off-by: Anirban Sinha <asinha@zeugmasystems.com>
---
 fs/compat.c |    3 +++
 fs/exec.c   |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 6d6f98f..c3d117c 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1510,6 +1510,9 @@ int compat_do_execve(char * filename,
        if (retval)
                goto out_file;

+#ifdef CONFIG_FUTEX
+       current->compat_robust_list = NULL;
+#endif
        bprm->argc = compat_count(argv, MAX_ARG_STRINGS);
        if ((retval = bprm->argc) < 0)
                goto out;
diff --git a/fs/exec.c b/fs/exec.c
index 172ceb6..e9334b8 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1323,6 +1323,9 @@ int do_execve(char * filename,
        retval = bprm_mm_init(bprm);
        if (retval)
                goto out_file;
+#ifdef CONFIG_FUTEX
+       current->robust_list = NULL;
+#endif

        bprm->argc = count(argv, MAX_ARG_STRINGS);
        if ((retval = bprm->argc) < 0)


