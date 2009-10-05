Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbZJELNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbZJELNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 07:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758727AbZJELNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 07:13:50 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:3613 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbZJELNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 07:13:50 -0400
X-SourceIP: 213.93.53.227
Subject: Re: futex question
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Anirban Sinha <ani@anirban.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Kaz Kylheku <kaz@zeugmasystems.com>,
       Anirban Sinha <asinha@zeugmasystems.com>
In-Reply-To: <alpine.LFD.2.00.0910051251080.2646@localhost.localdomain>
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local>
	 <20091001092218.GH15345@elte.hu>
	 <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local>
	 <4AC68F13.8050601@us.ibm.com>
	 <alpine.LFD.2.00.0910041031330.2646@localhost.localdomain>
	 <DDFD17CC94A9BD49A82147DDF7D545C501F457C5@exchange.ZeugmaSystems.local>
	 <4AC8CF32.8060108@anirban.org>
	 <alpine.LFD.2.00.0910041853180.2646@localhost.localdomain>
	 <1254738974.26976.24.camel@twins>
	 <alpine.LFD.2.00.0910051251080.2646@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 05 Oct 2009 13:16:12 +0200
Message-Id: <1254741372.26976.35.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 12:56 +0200, Thomas Gleixner wrote:
> 
> Looking more into that I think we should check whether the robust list
> has an entry (lock held) in do_execve() and return -EWOULDBLOCK to
> luser space. Same if pi_waiters is not empty. Holding a lock and
> calling execve() is simply broken.

Fine by me ;-)

something like the below?

The question is of course what Ani was doing that triggered this in the
first place and if he can live with this.. :-)

---
 fs/exec.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index d49be6b..0812ba6 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1295,6 +1295,22 @@ int do_execve(char * filename,
 	bool clear_in_exec;
 	int retval;
 
+	retval = -EWOULDBLOCK;
+#ifdef CONFIG_FUTEX
+	if (unlikely(current->robust_list))
+		goto out_ret;
+#ifdef CONFIG_COMPAT
+	if (unlikely(current->compat_robust_list))
+		goto out_ret;
+#endif
+	spin_lock_irq(&current->pi_lock);
+	if (!list_empty(&current->pi_state_list)) {
+		spin_unlock_irq(&current->pi_lock);
+		goto out_ret;
+	}
+	spin_unlock_irq(&current->pi_lock);
+#endif
+
 	retval = unshare_files(&displaced);
 	if (retval)
 		goto out_ret;


