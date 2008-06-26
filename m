Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbYFZRsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbYFZRsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 13:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYFZRsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 13:48:03 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:56560 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093AbYFZRsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 13:48:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ajHmOv0izzC7tK+/LHQS2gfMfUbKtyOjDy68lCCKw6JAWzsUqSPnc5BZPV9IMApHhz
         1uyU7fMbpyEbZUvVstzIVwitUXR2w96rcD0w5V2tYJcjUwmnuDxvvv+kHvpeSDBqH9gV
         5WWYdTFTcjUPUn1FltGoVCdxgXEj1KWBEMRpU=
Message-ID: <4863D02F.4070205@gmail.com>
Date: Thu, 26 Jun 2008 22:51:51 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] ftrace: prevent ftrace modifications while being
 kprobe'd
References: <485D45AB.3000405@gmail.com> <20080623201525.GA10386@elte.hu> <863e9df20806232029x6621ff13qd584591214e93d7f@mail.gmail.com> <20080626123329.GQ29619@elte.hu>
In-Reply-To: <20080626123329.GQ29619@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> best would be a delta patch against tip/master to fix up whatever is 
> still missing.

Here is the merge fixup for tip/master (and tip/tracing/ftrace).

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 85e8413..0f271c4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -502,8 +502,12 @@ static void ftrace_replace_code(int enable)
 				continue;
 
 			/* ignore updates to this record's mcount site */
-			if (get_kprobe((void *)rec->ip))
+			if (get_kprobe((void *)rec->ip)) {
+				freeze_record(rec);
 				continue;
+			} else {
+				unfreeze_record(rec);
+			}
 
 			failed = __ftrace_replace_code(rec, old, new, enable);
 			if (failed && (rec->flags & FTRACE_FL_CONVERTED)) {
@@ -740,7 +744,10 @@ static int __ftrace_update_code(void *ignore)
 				ftrace_del_hash(p);
 				INIT_HLIST_NODE(&p->node);
 				hlist_add_head(&p->node, &temp_list);
+				freeze_record(p);
 				continue;
+			} else {
+				unfreeze_record(p);
 			}
 
 			/* convert record (i.e, patch mcount-call with NOP) */
