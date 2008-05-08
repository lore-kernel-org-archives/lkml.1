Return-Path: <linux-kernel-owner+w=401wt.eu-S1764419AbYEHToe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764419AbYEHToe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYEHToX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:44:23 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3148 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbYEHToV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:44:21 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: Two questions about scheduling and threading.
Date: Thu, 8 May 2008 12:44:17 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEEKMIAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <C448672F.1E24B%brian@visionpro.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 08 May 2008 12:45:11 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 08 May 2008 12:45:13 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> When I start my system for the first time, I start one thread for each
> processor/core in the machine (is this the correct thing to do)?  These
> threads set a busy flag, go to work and then go to sleep.  I put
> everything
> to sleep as opposed to killing the threads because it saves me on
> average of
> about 400ms each time around.

That's not unreasonable. However, you may wish to create a few extra
threads. Otherwise, if one thread is blocked on I/O, you can't use all the
CPUs.

> My problem is, and, it is very reproducable, that if CPU0 is at 100%, none
> of my threads see the wakeup!  It doesn't matter what the other CPU's are
> doing, if they're all at 0 or 100%, but if CPU0 is 100, I'm
> toast.  Is there
> anyway around this?

Sounds like a bug. What does your wakeup code look like? Do you put your
threads to sleep blocked on a condition variable? Is the c.v. code correctly
using a predicate, that's something easy to screw up. It's like 'select',
there's a dozen classic mistakes and someone often makes one or two of them
and their code still soemtimes works.

> Also, I know that we're supposed to sit back and let the scheduler do all
> the work for us; but, in the 2.6.16.16 kernel, is there a way to assign a
> specific thread and/or process to a designated processor???  I really need
> to be able to do this because even with the preemptive
> scheduling, I'm still
> real-time and it's not quite real-time enough!

Big mistake. If you bind threads to CPUs and the thread that gets a wakeup
is assigned to a CPU that's busy, the job that thread was going to do will
have to wait, while other CPUs sit idle.

DS


