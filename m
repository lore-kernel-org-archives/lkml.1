Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbZCYELF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbZCYELF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 00:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbZCYEIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 00:08:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64291 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755840AbZCYEIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 00:08:54 -0400
Message-ID: <49C9ADAD.7070303@cn.fujitsu.com>
Date: Wed, 25 Mar 2009 12:06:05 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Steven Rostedt ;" <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] ftrace: Using FTRACE_WARN_ON() to check "freed record" in
 ftrace_release()
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* From Steven Rostedt <rostedt@goodmis.org>
> > Hmm, could you explain this more. I'm thinking that this scenario should
> > not happen, and if it does, it should probably be a bug.
> >
> > Because when we call ftrace_free_rec we change the rec->ip to point to the
> > next record in the chain. Something is very wrong if rec->ip >= s &&
> > rec->ip < e and the record is already free.
> Hello, Steven
>
> Thanks for your comment.
> I got your meaning, and I agree that if rec->ip >= s && rec->ip < e,
> this record is not freed.
> But IMHO, "if rec->ip >= s && rec->ip < e" is used to select records in the
> module,
> and function of ignore "freed record" is only its side-effect.
> So, add a special judgement to avoid "freed record" is not a bad idea.
> And I also agree your suggestion of add a WARN_ON, because this should not
> happened.

Hi Zhaolei,

Great! Feel free to send another patch ;-)

Note, use FTRACE_WARN_ON() macro. This way it shuts down ftrace if it is hit and
helps to avoid further damage later.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7b8722b..1752a63 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -358,9 +358,14 @@ void ftrace_release(void *start, unsigned long size)
 
 	mutex_lock(&ftrace_lock);
 	do_for_each_ftrace_rec(pg, rec) {
-		if ((rec->ip >= s) && (rec->ip < e) &&
-		    !(rec->flags & FTRACE_FL_FREE))
+		if ((rec->ip >= s) && (rec->ip < e)) {
+			/*
+			 * rec->ip is changed in ftrace_free_rec()
+			 * It should not between s and e if record was freed.
+			 */
+			FTRACE_WARN_ON(rec->flags & FTRACE_FL_FREE);
 			ftrace_free_rec(rec);
+		}
 	} while_for_each_ftrace_rec();
 	mutex_unlock(&ftrace_lock);
 }
-- 
1.5.5.3


