Return-Path: <linux-kernel-owner+w=401wt.eu-S935260AbXGTWCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935260AbXGTWCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbXGTWC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:02:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40101 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765AbXGTWC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:02:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Subject: Re: which signal is sent to freeze process?
Date: Sat, 21 Jul 2007 00:10:05 +0200
User-Agent: KMail/1.9.5
Cc: nigel@suspend2.net, linux-kernel@vger.kernel.org
References: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com> <200707201324.06290.rjw@sisk.pl> <A3258B497F1C1441AD36A2E8B45FD62858CCA1@scsmsx412.amr.corp.intel.com>
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD62858CCA1@scsmsx412.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707210010.05877.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 20 July 2007 20:07, Agarwal, Lomesh wrote:
> Can you suggest a way I can debug the issue why I am getting EINTR error
> for system calls in resuming? What else can cause the system call
> failure with EINTR?

Well, I think I know what the problem is.  do_poll checks
signal_pending(current) and breaks when it's set, but that may be caused
by the freezer.

You may try the patch below (untested) and see if that helps.

Greetings,
Rafael


---
 fs/select.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc6-mm1/fs/select.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/fs/select.c
+++ linux-2.6.22-rc6-mm1/fs/select.c
@@ -23,6 +23,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/rcupdate.h>
+#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 
@@ -593,6 +594,8 @@ static int do_poll(unsigned int nfds,  s
 		struct poll_list *walk;
 		long __timeout;
 
+		try_to_freeze();
+
 		set_current_state(TASK_INTERRUPTIBLE);
 		for (walk = list; walk != NULL; walk = walk->next) {
 			struct pollfd * pfd, * pfd_end;
@@ -618,7 +621,8 @@ static int do_poll(unsigned int nfds,  s
 		 * a poll_table to them on the next loop iteration.
 		 */
 		pt = NULL;
-		if (count || !*timeout || signal_pending(current))
+		if (count || !*timeout ||
+		    (signal_pending(current) && !freezing(current)))
 			break;
 		count = wait->error;
 		if (count)
