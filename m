Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbYLOK0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbYLOK0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 05:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYLOKZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 05:25:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57361 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbYLOKZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 05:25:54 -0500
Date: Mon, 15 Dec 2008 11:24:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: kenchen@google.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: broken do_each_pid_{thread,task}
Message-ID: <20081215102415.GA11106@redhat.com>
References: <494581D7.6000203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494581D7.6000203@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14, Jiri Slaby wrote:
>
> I'm getting
> `if (type == PIDTYPE_PID)' is unreachable
> warning from kernel/exit.c. The preprocessed code looks like:
> do {
>          struct hlist_node *pos___;
>          if (pgrp != ((void *)0))
>                  for (LIST ITERATION) {
>                          {
>                           if (!((p->state & 4) != 0))
>                            continue;
>                           retval = 1;
>                           break;
>                          }
>                          if (PIDTYPE_PGID == PIDTYPE_PID)
>                                  break;
>                  }
> } while (0);
> and it's obviously wrong.

Why do you think it is wrong? This break stops the "hlist_for_each"
loop, not the enclosing "do while".

Actually, I don't understand why the compiler complains, and I never
saw a warning myself.

But the check is ugly indeed, that is why the patch was named "uglify ...".

> After investigating this code usage all around, it's broken on many places
> this or similar way.
>
> For do_each_pid_thread(), even this code snippet from fs/ioprio.c is broken
> due to double do {} while expansion:
> do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
>   ret = set_task_ioprio(p, ioprio);
>   if (ret)
>     break;
> } while_each_pid_thread(pgrp, PIDTYPE_PGID, p);

Yes, this is obviously not what was intended. But afaics, this is
the only place which should be fixed?

> Any idea how to get rid of this issue?

We had the similar bug for IOPRIO_WHO_USER case, iirc. Probably
we can fix it the same way:

--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -118,8 +118,9 @@ asmlinkage long sys_ioprio_set(int which
 			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
 				ret = set_task_ioprio(p, ioprio);
 				if (ret)
-					break;
+					goto end_pgrp;
 			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
+end_pgrp:
 			break;
 		case IOPRIO_WHO_USER:
 			if (!who)

Oleg.

