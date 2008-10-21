Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbYJUBFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbYJUBFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 21:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbYJUBFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 21:05:04 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4622 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYJUBFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 21:05:03 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "David@Lang. Hm" <david@lang.hm>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: RE: sched_yield() options
Date: Mon, 20 Oct 2008 18:04:23 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEMLAIAD.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <alpine.DEB.1.10.0810201603510.21749@asgard.lang.hm>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 20 Oct 2008 18:06:26 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 20 Oct 2008 18:06:28 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> in the case I'm looking at there are two (or more) threads running with
> one message queue in the center.
>
> 'input threads' are grabbing the lock to add messages to the queue
>
> 'output threads' are grabbing the lock to remove messages from the queue
>
> the programmer is doing a pthread_yield() after each message is processed
> in an attempt to help fairness (he initially added it in when he started
> seeing starvation on single-core systems)

Yuck. That forces the worst possible scenario, which is nearly strict
alternation.

There is no reason he should ever be seeing starvation. Each thread should
either:

1) Use out its timeslice. In which case, a thread can at most be starved for
the number of threads multiplied by the size of the timeslice. If this is
too long, then you have too many threads or your timeslice is too big. You
can't fix it with ugly hacks.

2) Get blocked because it needs another thread to help it make forward
progress. In this case, there should be no starvation, since each thread
can't continue until other threads continue.

> what should he be doing instead?

Simply set a limit on the maximum number of messages that can go in the
queue when output threads are CPU limited. Output threads can't starve input
threads because they have to block if the queue is empty (assuming you never
let the queue get too ridiculously full). Input threads can't starve output
threads if there's a reasonable limit on the queue size.

> the link above talks about other cases more, but really doesn't say what
> the right thing to do is for this case.
>
> David Lang

Implement a sensible queue.

DS


