Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbZBRWe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbZBRWe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757807AbZBRWby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:31:54 -0500
Received: from kroah.org ([198.145.64.141]:34696 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757792AbZBRWbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:31:53 -0500
Date: Wed, 18 Feb 2009 14:28:59 -0800
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
       alan@lxorguk.ukuu.org.uk, Nadia Derbey <Nadia.Derbey@bull.net>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Bastian Blank <bastian@waldi.eu.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [patch 02/36] mqueue: fix si_pid value in mqueue do_notify()
Message-ID: <20090218222859.GC10668@kroah.com>
References: <20090218222447.432108614@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mqueue-fix-si_pid-value-in-mqueue-do_notify.patch"
In-Reply-To: <20090218222841.GA10668@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

commit a6684999f7c6bddd75cf9755ad7ff44435f72fff upstream.

If a process registers for asynchronous notification on a POSIX message
queue, it gets a signal and a siginfo_t structure when a message arrives
on the message queue.  The si_pid in the siginfo_t structure is set to the
PID of the process that sent the message to the message queue.

The principle is the following:
. when mq_notify(SIGEV_SIGNAL) is called, the caller registers for
  notification when a msg arrives. The associated pid structure is stroed into
  inode_info->notify_owner. Let's call this process P1.
. when mq_send() is called by say P2, P2 sends a signal to P1 to notify
  him about msg arrival.

The way .si_pid is set today is not correct, since it doesn't take into account
the fact that the process that is sending the message might not be in the
same namespace as the notified one.

This patch proposes to set si_pid to the sender's pid into the notify_owner
namespace.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Bastian Blank <bastian@waldi.eu.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 ipc/mqueue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -498,7 +498,8 @@ static void __do_notify(struct mqueue_in
 			sig_i.si_errno = 0;
 			sig_i.si_code = SI_MESGQ;
 			sig_i.si_value = info->notify.sigev_value;
-			sig_i.si_pid = task_tgid_vnr(current);
+			sig_i.si_pid = task_tgid_nr_ns(current,
+						ns_of_pid(info->notify_owner));
 			sig_i.si_uid = current->uid;
 
 			kill_pid_info(info->notify.sigev_signo,

