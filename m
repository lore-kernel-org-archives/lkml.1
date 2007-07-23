Return-Path: <linux-kernel-owner+w=401wt.eu-S1764096AbXGWWSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764096AbXGWWSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbXGWWS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:18:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:17292 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbXGWWS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:18:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,572,1175497200"; 
   d="scan'208";a="109091583"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: which signal is sent to freeze process?
Date: Mon, 23 Jul 2007 15:18:26 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD62858D7B7@scsmsx412.amr.corp.intel.com>
In-Reply-To: <200707232350.50208.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: which signal is sent to freeze process?
thread-index: AcfNcm3oet6ds8dZQiiqGissL2C8xwABLMLQ
References: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com> <200707210010.05877.rjw@sisk.pl> <A3258B497F1C1441AD36A2E8B45FD62858D6A0@scsmsx412.amr.corp.intel.com> <200707232350.50208.rjw@sisk.pl>
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: <nigel@suspend2.net>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 Jul 2007 22:18:27.0883 (UTC) FILETIME=[64C5B7B0:01C7CD77]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The net effect would be same. Why would you choose one over other
(do_sys_poll vs. do_poll)?
Can you point me to code where socket read returns in case of
signal_pending? I need to try couple of things.

-----Original Message-----
From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
Sent: Monday, July 23, 2007 2:51 PM
To: Agarwal, Lomesh
Cc: nigel@suspend2.net; linux-kernel@vger.kernel.org
Subject: Re: which signal is sent to freeze process?

On Monday, 23 July 2007 22:57, Agarwal, Lomesh wrote:
> Why do you need try_to_freeze in below patch? Shouldn't
> !freezing(current) checking is enough?

The try_to_freeze() is needed so that the process doesn't block the
freezing
of tasks (it is supposed to call refrigerator() as soon as reasonably
possible
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
