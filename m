Return-Path: <linux-kernel-owner+w=401wt.eu-S1762391AbZAWGVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762391AbZAWGVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760900AbZAWGQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:16:35 -0500
Received: from kroah.org ([198.145.64.141]:36240 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760903AbZAWGQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:16:34 -0500
Date: Thu, 22 Jan 2009 22:13:44 -0800
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
       alan@lxorguk.ukuu.org.uk,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: [patch 15/40] kill sig -1 must only apply to callers namespace
Message-ID: <20090123061344.GO2922@kroah.com>
References: <20090123001330.046404396@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kill-sig-1-must-only-apply-to-caller-s-namespace.patch"
In-Reply-To: <20090123001908.GA7397@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

commit d25141a818383b3c3b09f065698c544a7a0ec6e7 upstream.

Currently "kill <sig> -1" kills processes in all namespaces and breaks the
isolation of namespaces.  Earlier attempt to fix this was discussed at:

	http://lkml.org/lkml/2008/7/23/148

As suggested by Oleg Nesterov in that thread, use "task_pid_vnr() > 1"
check since task_pid_vnr() returns 0 if process is outside the caller's
namespace.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Tested-by: Daniel Hokka Zakrisson <daniel@hozac.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/signal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1141,7 +1141,8 @@ static int kill_something_info(int sig, 
 		struct task_struct * p;
 
 		for_each_process(p) {
-			if (p->pid > 1 && !same_thread_group(p, current)) {
+			if (task_pid_vnr(p) > 1 &&
+					!same_thread_group(p, current)) {
 				int err = group_send_sig_info(sig, info, p);
 				++count;
 				if (err != -EPERM)

