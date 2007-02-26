Return-Path: <linux-kernel-owner+w=401wt.eu-S1751257AbXBZGhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbXBZGhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 01:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbXBZGhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 01:37:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:17450 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbXBZGhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 01:37:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,218,1170662400"; 
   d="scan'208"; a="201239555:sNHT19315226"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: RFC/patch: down_timeout_interruptible()
Date: Sun, 25 Feb 2007 22:37:40 -0800
Message-ID: <C72DEB015BA7724783363DE1AF6B0F98016FF09B@orsmsx417.amr.corp.intel.com>
In-Reply-To: <1172385954.3265.14.camel@laptopd505.fenrus.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: RFC/patch: down_timeout_interruptible()
Thread-Index: AcdYqJsPvkbWuDbCSYWLHik/yeDJ7AAx9x9w
From: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 26 Feb 2007 06:37:41.0427 (UTC) FILETIME=[9D56D030:01C75970]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Arjan van de Ven [mailto:arjan@infradead.org]
>
>> I gave it a quick try (must admit, not too tested) and it seems that
>> the setting of TIF_SIGPENDING without really having a signal queued
>> is not having easily visible ugly consequences.
>
>what happens if you get a signal around the time the timeout fires?

Depends of what around means.

+	result = down_interruptible(sem);
+	del_timer(&dit_timer);
+	if (result < 0 && data.result < 0)
+		result = data.result;

This piece of code will catch the 'timeout arrived right before a 
signal' case. 'data.result' is set by the timeout handler, so it 
doesn't interfere.

Now, if the timeout arrives right after a signal was delivered
but before the thread returns from down_interruptible, then it
will also look like a timeout (as that code in the if statement
will kick in) -- to some extent, it is 'right' theoretically, as
it didn't get the sem before the time expired. TIF_SIGPENDING is 
still set, so the signal is not lost (unless I miss something else
about the signal delivery engine).

The last case, if the timeout arrives after the signal and after
down_interruptible returns, nothing in theory. There is a window
where the timer could still execute before it is deleted and it
would look like a timeout [which theoretically could be right too].
Maybe the result < 0 && data.result < 0 check should be done 
before del_timer(). 

Suggestions? 

-- Inaky
