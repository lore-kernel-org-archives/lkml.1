Return-Path: <linux-kernel-owner+w=401wt.eu-S1765937AbXLMULN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765937AbXLMULN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765718AbXLMUKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:10:33 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:4472 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765752AbXLMUKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:10:30 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <mrmacman_g4@mac.com>, "Jesper Juhl" <jesper.juhl@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
Subject: RE: yield API
Date: Thu, 13 Dec 2007 12:10:21 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEFEINAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
In-Reply-To: <54633429-AF8F-4A9F-9141-B70B74A8359E@mac.com>
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 13 Dec 2007 12:11:30 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 13 Dec 2007 12:11:32 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Kyle Moffett wrote:

> That is a *terrible* disgusting way to use yield.  Better options:
>    (1) inotify/dnotify

Sure, tie yourself to a Linux-specific mechanism that may or may not work
over things like NFS. That's much worse.

>    (2) create a "foo.lock" file and put the mutex in that

Right, tie yourself to process-shared mutexes which historically weren't
available on Linux. That's much better than an option that's been stable for
a decade.

>    (3) just start with the check-file-and-sleep loop.

How is that better? There is literally no improvement, since the first check
will (almost) always fail.

> > Now is this the best way to handle this situation? No.  Does it
> > work better than just doing the wait loop from the start? Yes.
>
> It works better than doing the wait-loop from the start?  What
> evidence do you provide to support this assertion?

The evidence is that more than half the time, this avoids the sleep. That
means it has zero cost, since the yield is no heavier than a sleep would be,
and has a possible benefit, since the first sleep may be too long.

> Specifically, in
> the first case you tell the kernel "I'm waiting for something but I
> don't know what it is or how long it will take"; while in the second
> case you tell the kernel "I'm waiting for something that will take
> exactly X milliseconds, even though I don't know what it is.  If you
> really want something similar to the old behavior then just replace
> the "sched_yield()" call with a proper sleep for the estimated time
> it will take the program to create the file.

The problem is that if the estimate is too short, pre-emption will result in
a huge performance drop. If the estimate is too long, there will be some
wasted CPU. What was the claimed benefit of doing this again?

> > Is this a good way to use sched_yield()? Maybe, maybe not.  But it
> > *is* an actual use of the API in a real app.

> We weren't looking for "actual uses", especially not in binary-only
> apps.  What we are looking for is optimal uses of sched_yield(); ones
> where that is the best alternative.  This... certainly isn't.

Your standards for "optimal" are totally unrealistic. In his case, it was
optimal. Using platform-specific optimizations would have meant more
development and test time for minimal benefit. Sleeping first would have had
some performance cost and no benefit. In his case, sched_yield was optimal.
Really.

DS


