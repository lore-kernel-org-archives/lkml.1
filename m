Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbXFOJYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbXFOJYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 05:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbXFOJYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 05:24:44 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:52793 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752004AbXFOJYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 05:24:43 -0400
Subject: Re: [patch 0/3] no MAX_ARG_PAGES -v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ollie Wild <aaw@google.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
       parisc-linux@lists.parisc-linux.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>
In-Reply-To: <65dd6fd50706141358i39bba32aq139766c8a1a3de2b@mail.gmail.com>
References: <20070613100334.635756997@chello.nl>
	 <617E1C2C70743745A92448908E030B2A01AF860A@scsmsx411.amr.corp.intel.com>
	 <65dd6fd50706132323i9c760f4m6e23687914d0c46e@mail.gmail.com>
	 <1181810319.7348.345.camel@twins>
	 <65dd6fd50706141358i39bba32aq139766c8a1a3de2b@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 11:24:38 +0200
Message-Id: <1181899478.7348.349.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-14 at 13:58 -0700, Ollie Wild wrote:

>   A good heuristic, though, might be to limit
> argument size to a percentage (say 25%) of maximum stack size and
> validate this inside copy_strings().

This seems to do:


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/exec.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

Index: linux-2.6-2/fs/exec.c
===================================================================
--- linux-2.6-2.orig/fs/exec.c	2007-06-15 11:05:09.000000000 +0200
+++ linux-2.6-2/fs/exec.c	2007-06-15 11:05:18.000000000 +0200
@@ -199,6 +199,23 @@ static struct page *get_arg_page(struct 
 	if (ret <= 0)
 		return NULL;
 
+	if (write) {
+		struct rlimit *rlim = current->signal->rlim;
+		unsigned long size = bprm->vma->vm_end - bprm->vma->vm_start;
+
+		/*
+		 * Limit to 1/4-th the stack size for the argv+env strings.
+		 * This ensures that:
+		 *  - the remaining binfmt code will not run out of stack space,
+		 *  - the program will have a reasonable amount of stack left
+		 *    to work from.
+		 */
+		if (size > rlim[RLIMIT_STACK].rlim_cur / 4) {
+			put_page(page);
+			return NULL;
+		}
+	}
+
 	return page;
 }
 


