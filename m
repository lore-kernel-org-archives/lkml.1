Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbZBKQiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbZBKQiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 11:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbZBKQiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 11:38:14 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:56548 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbZBKQiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:38:12 -0500
Date: Wed, 11 Feb 2009 10:37:53 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Eric Sesterhenn <snakebyte@gmx.de>,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: namespaces?: bug at mm/slub.c:2750
Message-ID: <20090211163753.GA29372@us.ibm.com>
References: <20090206113556.GA3161@alice> <20090206161518.81e7d42c.akpm@linux-foundation.org> <19f34abd0902102355o5bf51096o9aa3737e87104fb9@mail.gmail.com> <20090211000740.f1de7cec.akpm@linux-foundation.org> <19f34abd0902110248n22f8de12lccfa99faafafb942@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0902110248n22f8de12lccfa99faafafb942@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Vegard Nossum (vegard.nossum@gmail.com):
> On Wed, Feb 11, 2009 at 9:07 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >> In case you missed it, KOSAKI Motohiro posted a similar stack-trace
> >> (but not the same BUG) in this thread:
> >> http://lkml.org/lkml/2009/2/10/7
> >>
> >
> > Both traces include the newly-added put_cred_rcu().  Suspicious.
> >
> 
> I have this test case which triggers it regularly after some minutes:
> 
> #include <sys/wait.h>
> #include <sys/types.h>
> 
> #include <errno.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> 
> int main(int argc, char* argv[])
> {
>         unsigned int i;
> 
>         if (fork() == 0) {
>                 while (1)
>                         system("echo -n .");
>         }
> 
>         for (i = 0; i < 2; ++i) {
>                 if (fork() == 0) {
>                         while (1) {
>                                 setreuid(0, 0xcafeba);
>                                 setreuid(0xcafeba, 0);
> 
>                                 setreuid(0, 0xcafebb);
>                                 setreuid(0xcafebb, 0);
>                         }
> 
>                         exit(EXIT_SUCCESS);
>                 }
>         }
> 
>         while (!(wait(NULL) == -1 && errno == ECHILD))
>                 ;
> 
>         return 0;
> }
> 
> It seems to be the combination of exec() and setreuid(), but I
> couldn't get it to work with just exec() instead of system(). It is
> possible that CONFIG_USER_SCHED must be =y for this to work. It can
> probably be simplified too...
> 
> 
> Vegard

I haven't yet been able to reproduce it, but I'm wondering whether
something like the following is needed.

Note that free_user() still seems wrong there, as it won't call
uid_hash_remove(up) for a user which is not inthe init_user_ns at
all, right?


>From 2bc9da9728e0a4242bd8b1362d34e8d425be1b66 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Wed, 11 Feb 2009 11:29:52 -0500
Subject: [PATCH 1/1] user namespaces: only put the userns when we unhash the uid

uids in namespaces other than init don't get a sysfs entry.

For those in the init namespace, while we're waiting to remove
the sysfs entry for the uid the uid is still hashed, and
alloc_uid() may re-grab that uid without getting a new
reference to the user_ns, which we've already put in free_user
before scheduling remove_user_sysfs_dir().

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 kernel/user.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/user.c b/kernel/user.c
index 477b666..bb401a5 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -71,6 +71,7 @@ static void uid_hash_insert(struct user_struct *up, struct hlist_head *hashent)
 
 static void uid_hash_remove(struct user_struct *up)
 {
+	put_user_ns(up->user_ns);
 	hlist_del_init(&up->uidhash_node);
 }
 
@@ -334,7 +335,6 @@ static void free_user(struct user_struct *up, unsigned long flags)
 	atomic_inc(&up->__count);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
 
-	put_user_ns(up->user_ns);
 	INIT_WORK(&up->work, remove_user_sysfs_dir);
 	schedule_work(&up->work);
 }
@@ -357,7 +357,6 @@ static void free_user(struct user_struct *up, unsigned long flags)
 	sched_destroy_user(up);
 	key_put(up->uid_keyring);
 	key_put(up->session_keyring);
-	put_user_ns(up->user_ns);
 	kmem_cache_free(uid_cachep, up);
 }
 
-- 
1.6.1

