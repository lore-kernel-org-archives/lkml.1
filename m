Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbZGaViK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbZGaViK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbZGaViJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:38:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:38831 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbZGaViI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:38:08 -0400
Message-ID: <4A736380.8030101@windriver.com>
Date: Fri, 31 Jul 2009 16:34:56 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 07/10] ehci-dbgp,ehci: Allow early or late use of the
 dbgp device
References: <Pine.LNX.4.44L0.0907311448460.2643-100000@iolanthe.rowland.org> <4A7355EA.60107@windriver.com>
In-Reply-To: <4A7355EA.60107@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jul 2009 21:34:58.0442 (UTC) FILETIME=[C0B1DEA0:01CA1226]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> What happens across a system suspend?
>
>   

I assume you mean as a test case:

echo -n mem > /sys/power/state

The dbgp device goes away entirely, when used with
earlyprintk=dbgp,keep.  But there is a way to fix it reasonably
easily.  Perhaps you might ack this resume patch, if you agree?

Jason.

---
From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] ehci-dbgp,ehci: Allow dbpg to work with suspend/resume

In order for the dbgp driver to survive suspend/resume, on every ehci
resume operation the debug controller must get re-initialized.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: dbrownell@users.sourceforge.net
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>

---
 drivers/usb/host/ehci-hub.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -204,6 +204,13 @@ static int ehci_bus_resume (struct usb_h
 		return -ESHUTDOWN;
 	}
 
+	if (unlikely(ehci->debug)) {
+		if (ehci->debug && !dbgp_reset_prep())
+			ehci->debug = NULL;
+		else
+			dbgp_external_startup();
+	}
+
 	/* Ideally and we've got a real resume here, and no port's power
 	 * was lost.  (For PCI, that means Vaux was maintained.)  But we
 	 * could instead be restoring a swsusp snapshot -- so that BIOS was
