Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbYLDKQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbYLDKQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbYLDKQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:16:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51315 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbYLDKQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:16:39 -0500
Date: Thu, 4 Dec 2008 11:16:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jianjun Kong <jianjun@zeuux.org>
Cc: mingo@redhat.com, Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86: fix warning of uninitialized variable
Message-ID: <20081204101633.GD18708@elte.hu>
References: <20081204010013.GA17445@ubuntu> <20081204101023.GA18708@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081204101023.GA18708@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jianjun Kong <jianjun@zeuux.org> wrote:
> 
> > fix warning of uninitialized 'base' in arch/x86/kernel/scx200_32.c
> > 
> > arch/x86/kernel/scx200_32.c: In function ‘scx200_probe’:
> > arch/x86/kernel/scx200_32.c:82: warning: ‘base’ may be used
> > uninitialized in this function
> > 
> > Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
> > ---
> >  arch/x86/kernel/scx200_32.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> this patch is wrong, and your analysis-free commit log is wrong as 
> well!
> 
> i fixed this a few weeks ago, and GCC pinpointed a _real_ bug - which 
> you hacked around instead of fixing. See the real fix below.

Also, see an example below of the case where GCC is wrong about a 
warning, and how it is annotated.

	Ingo

------------->
>From af4d2994e0e8e6e529b0e87f4e436dad062a9c05 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 25 Nov 2008 13:14:19 +0100
Subject: [PATCH] fix warning in fs/ocfs2/stack_user.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

this warning:

  fs/ocfs2/stack_user.c: In function ‘user_cluster_connect’:
  fs/ocfs2/stack_user.c:807: warning: ‘control’ may be used uninitialized in this function

triggers because GCC does not recognize the (correct) error flow
between:

 - ocfs2_live_connection_new() and 'control'

Annotate it.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/ocfs2/stack_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index faec2d8..55e2cdc 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -804,7 +804,7 @@ static int fs_protocol_compare(struct ocfs2_protocol_version *existing,
 static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 {
 	dlm_lockspace_t *fsdlm;
-	struct ocfs2_live_connection *control;
+	struct ocfs2_live_connection *uninitialized_var(control);
 	int rc = 0;
 
 	BUG_ON(conn == NULL);
