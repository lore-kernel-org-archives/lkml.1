Return-Path: <linux-kernel-owner+w=401wt.eu-S1763012AbZEFWML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763012AbZEFWML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761458AbZEFVzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:55:00 -0400
Received: from kroah.org ([198.145.64.141]:57291 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761265AbZEFVyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:55 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:01 2009
Message-Id: <20090506214800.970188489@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 41/58] check_unsafe_exec() doesnt care about signal handlers sharing
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=check_unsafe_exec-doesn-t-care-about-signal-handlers-sharing.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit f1191b50ec11c8e2ca766d6d99eb5bb9d2c084a3 upstream.

... since we'll unshare sighand anyway

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exec.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1053,23 +1053,20 @@ int check_unsafe_exec(struct linux_binpr
 {
 	struct task_struct *p = current, *t;
 	unsigned long flags;
-	unsigned n_fs, n_sighand;
+	unsigned n_fs;
 	int res = 0;
 
 	bprm->unsafe = tracehook_unsafe_exec(p);
 
 	n_fs = 1;
-	n_sighand = 1;
 	write_lock(&p->fs->lock);
 	lock_task_sighand(p, &flags);
 	for (t = next_thread(p); t != p; t = next_thread(t)) {
 		if (t->fs == p->fs)
 			n_fs++;
-		n_sighand++;
 	}
 
-	if (p->fs->users > n_fs ||
-	    atomic_read(&p->sighand->count) > n_sighand) {
+	if (p->fs->users > n_fs) {
 		bprm->unsafe |= LSM_UNSAFE_SHARE;
 	} else {
 		if (p->fs->in_exec)


