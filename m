Return-Path: <linux-kernel-owner+w=401wt.eu-S935044AbXGWU5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935044AbXGWU5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbXGWU5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:57:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:49463 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbXGWU5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:57:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,572,1175497200"; 
   d="scan'208";a="253751857"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: which signal is sent to freeze process?
Date: Mon, 23 Jul 2007 13:57:35 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD62858D6A0@scsmsx412.amr.corp.intel.com>
In-Reply-To: <200707210010.05877.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: which signal is sent to freeze process?
thread-index: AcfLGaV4xPJHIQ/4TG2WxKjYROv37QCUlVtw
References: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com> <200707201324.06290.rjw@sisk.pl> <A3258B497F1C1441AD36A2E8B45FD62858CCA1@scsmsx412.amr.corp.intel.com> <200707210010.05877.rjw@sisk.pl>
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: <nigel@suspend2.net>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 Jul 2007 20:57:36.0747 (UTC) FILETIME=[19451BB0:01C7CD6C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Why do you need try_to_freeze in below patch? Shouldn't
!freezing(current) checking is enough?

-----Original Message-----
From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
Sent: Friday, July 20, 2007 3:10 PM
To: Agarwal, Lomesh
Cc: nigel@suspend2.net; linux-kernel@vger.kernel.org
Subject: Re: which signal is sent to freeze process?

On Friday, 20 July 2007 20:07, Agarwal, Lomesh wrote:
> Can you suggest a way I can debug the issue why I am getting EINTR
error
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
