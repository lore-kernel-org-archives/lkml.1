Return-Path: <linux-kernel-owner+w=401wt.eu-S1762761AbZEFWGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762761AbZEFWGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761482AbZEFVyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:47 -0400
Received: from kroah.org ([198.145.64.141]:57187 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761396AbZEFVyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:44 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:59 2009
Message-Id: <20090506214759.276395562@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:57 -0700
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
       alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>
Subject: [patch 29/58] ptrace: ptrace_attach: fix the usage of ->cred_exec_mutex
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=ptrace-ptrace_attach-fix-the-usage-of-cred_exec_mutex.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit cad81bc2529ab8c62b6fdc83a1c0c7f4a87209eb upstream.

ptrace_attach() needs task->cred_exec_mutex, not current->cred_exec_mutex.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/ptrace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -186,7 +186,7 @@ int ptrace_attach(struct task_struct *ta
 	/* Protect exec's credential calculations against our interference;
 	 * SUID, SGID and LSM creds get determined differently under ptrace.
 	 */
-	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
+	retval = mutex_lock_interruptible(&task->cred_exec_mutex);
 	if (retval  < 0)
 		goto out;
 
@@ -230,7 +230,7 @@ repeat:
 bad:
 	write_unlock_irqrestore(&tasklist_lock, flags);
 	task_unlock(task);
-	mutex_unlock(&current->cred_exec_mutex);
+	mutex_unlock(&task->cred_exec_mutex);
 out:
 	return retval;
 }


