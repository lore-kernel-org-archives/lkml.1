Return-Path: <linux-kernel-owner+w=401wt.eu-S934216AbYB2V7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216AbYB2V7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932479AbYB2V7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:59:04 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932400AbYB2V7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:59:01 -0500
Date: Fri, 29 Feb 2008 13:57:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Kerrisk <michael.kerrisk@googlemail.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, aaw <aaw@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, carlos@codesourcery.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com, Geoff Clare <gwc@opengroup.org>
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
In-Reply-To: <alpine.LFD.1.00.0802291200580.17889@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802291350550.17889@woody.linux-foundation.org>
References: <1204119455.6242.403.camel@lappy>  <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>  <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>  <1204305244.6243.111.camel@lappy>  <alpine.LFD.1.00.0802290934130.17889@woody.linux-foundation.org>
  <1204307756.6243.121.camel@lappy> <47C84C6C.2000201@gmail.com>  <alpine.LFD.1.00.0802291032370.17889@woody.linux-foundation.org> <c49095e30802291149t7ad01f6bl59b9083bfb41c920@mail.gmail.com>
 <alpine.LFD.1.00.0802291200580.17889@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Linus Torvalds wrote:
> 
> I do agree that we should at least make the "MAX(stacksize/4, 128k)" 
> change for backwards compatibility.

How about something like this?

The alternative is to just remove that size check entirely, and depend on 
get_user_pages() doing the stack limit check (among all the *other* checks 
it does when it does the acct_stack_growth() thing).

I'd almost prefer that simpler approach, but I don't have any really 
strong preferences. Anybody?

		Linus

---
 fs/exec.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index a44b142..e91f9cb 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -173,8 +173,15 @@ static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		return NULL;
 
 	if (write) {
-		struct rlimit *rlim = current->signal->rlim;
 		unsigned long size = bprm->vma->vm_end - bprm->vma->vm_start;
+		struct rlimit *rlim;
+
+		/*
+		 * We've historically supported up to 32 pages of argument
+		 * strings even with small stacks
+		 */
+		if (size <= 32*PAGE_SIZE)
+			return page;
 
 		/*
 		 * Limit to 1/4-th the stack size for the argv+env strings.
@@ -183,6 +190,7 @@ static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		 *  - the program will have a reasonable amount of stack left
 		 *    to work from.
 		 */
+		rlim = current->signal->rlim;
 		if (size > rlim[RLIMIT_STACK].rlim_cur / 4) {
 			put_page(page);
 			return NULL;
