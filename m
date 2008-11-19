Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbYKSXDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbYKSXDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 18:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYKSXDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 18:03:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55697 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbYKSXDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 18:03:36 -0500
Message-ID: <49249B05.9080305@redhat.com>
Date: Wed, 19 Nov 2008 18:02:29 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, Jim Keniston <jkenisto@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: [PATCH -mm] bugfix: release old_p's insn_slot before error return
References: <200811190741.mAJ7fvK5019964@imap1.linux-foundation.org>
In-Reply-To: <200811190741.mAJ7fvK5019964@imap1.linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

akpm@linux-foundation.org wrote:
> The patch titled
>      bugfix: pass aggr_kprobe to arch_remove_kprobe
> has been added to the -mm tree.  Its filename is
>      kprobes-support-probing-module-__exit-function-fix-2.patch

Oops, sorry, I found one another bug...

Release old_p->ainsn.insn_slot before error return, if the memory
allocation of new aggr_kprobe is failed.

Signed-off-by: Masami Hiramatsu  <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 kernel/kprobes.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: 2.6.28-rc4/kernel/kprobes.c
===================================================================
--- 2.6.28-rc4.orig/kernel/kprobes.c
+++ 2.6.28-rc4/kernel/kprobes.c
@@ -584,8 +584,11 @@ static int __kprobes register_aggr_kprob
 		ap = old_p;
 	} else {
 		ap = kzalloc(sizeof(struct kprobe), GFP_KERNEL);
-		if (!ap)
+		if (!ap) {
+			if (kprobe_gone(old_p))
+				arch_remove_kprobe(old_p);
 			return -ENOMEM;
+		}
 		add_aggr_kprobe(ap, old_p);
 		copy_kprobe(ap, p);
 		ret = add_new_kprobe(ap, p);


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

