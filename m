Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbYI1S6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbYI1S6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 14:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbYI1S6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 14:58:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:42857 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbYI1S6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 14:58:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=b1v5IuuX3FsttsNJ2YRwzMImoyjb3J/LYSHCW61DnOgp3rs2Dpvab02z1bl1NMGGi9
         1g7K2lbyW7C4DKPGWMiw5cGtqi/TtamAnp8th9R+hKYamc3eJh3eszisn2YVdKlQmFGe
         OxaIES6C+rh+qe2RNURnCjUglXwGirLXJ/4g0=
Date: Sun, 28 Sep 2008 21:58:15 +0300
From: Pekka Paalanen <pq@iki.fi>
To: "=?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: trace_pipe tentative fix
Message-ID: <20080928215815.3a9aa355@daedalus.pq.iki.fi>
In-Reply-To: <20080928201259.09bbac54@daedalus.pq.iki.fi>
References: <48DD0347.5070008@gmail.com>
	<20080927002121.0038cdfe@daedalus.pq.iki.fi>
	<c62985530809270517g179f1d21nca05cf50b289b2f5@mail.gmail.com>
	<20080928201259.09bbac54@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Sep 2008 20:12:59 +0300
Pekka Paalanen <pq@iki.fi> wrote:

> If I understand you suggestion, it looks like the right thing to do.
> Here is a tentative fix, which has not even been compile-tested.
> 
> Is it so that the problem is triggered by consuming a trace entry
> which does not produce any output? If that entry is all there is
> in the ring at a time of a read call, then the last call to
> trace_seq_to_user() returns -EBUSY, because there is nothing to
> copy to user. What I failed to understand when I wrote that
> piece of code, is that returning 0 means EOF. The only cases
> when we do want to return an EOF are near the
> 	while (trace_empty(iter)) {
> loop.
> 
> Frederic, could you test the fix, and if it works, send it to Ingo?

Whoops, sret was left in a bad state. Here's a new one.

---

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 6ada059..16b8a22 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2605,7 +2605,6 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
        sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
        if (sret != -EBUSY)
                return sret;
-       sret = 0;
 
        trace_seq_reset(&iter->seq);
 
@@ -2616,6 +2615,8 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
                        goto out;
        }
 
+waitagain:
+       sret = 0;
        while (trace_empty(iter)) {
 
                if ((filp->f_flags & O_NONBLOCK)) {
@@ -2749,8 +2750,13 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
        sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
        if (iter->seq.readpos >= iter->seq.len)
                trace_seq_reset(&iter->seq);
+
+       /*
+        * If there was nothing to send to user, inspite of consuming trace
+        * entries, go back to wait for more entries.
+        */
        if (sret == -EBUSY)
-               sret = 0;
+               goto waitagain;
 
 out:
        mutex_unlock(&trace_types_lock);
