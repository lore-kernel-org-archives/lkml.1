Return-Path: <linux-kernel-owner+w=401wt.eu-S1764895AbXGWVnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764895AbXGWVnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbXGWVnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:43:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51531 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbXGWVm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:42:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Subject: Re: which signal is sent to freeze process?
Date: Mon, 23 Jul 2007 23:50:49 +0200
User-Agent: KMail/1.9.5
Cc: nigel@suspend2.net, linux-kernel@vger.kernel.org
References: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com> <200707210010.05877.rjw@sisk.pl> <A3258B497F1C1441AD36A2E8B45FD62858D6A0@scsmsx412.amr.corp.intel.com>
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD62858D6A0@scsmsx412.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707232350.50208.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 23 July 2007 22:57, Agarwal, Lomesh wrote:
> Why do you need try_to_freeze in below patch? Shouldn't
> !freezing(current) checking is enough?

The try_to_freeze() is needed so that the process doesn't block the freezing
of tasks (it is supposed to call refrigerator() as soon as reasonably possible
when freezing(current) is true).

Alternatively, we might return 0 from do_sys_poll() if do_poll() has
returned 0 and both signal_pending(current) and freezing(current) are
true.  Below is a patch that implements that.  Could you please try it?

Greetings,
Rafael


---
 fs/select.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22-rc6-mm1/fs/select.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/fs/select.c
+++ linux-2.6.22-rc6-mm1/fs/select.c
@@ -722,7 +722,7 @@ int do_sys_poll(struct pollfd __user *uf
 		walk = walk->next;
   	}
 	err = fdcount;
-	if (!fdcount && signal_pending(current))
+	if (!fdcount && (signal_pending(current) && !freezing(current)))
 		err = -EINTR;
 out_fds:
 	walk = head;
