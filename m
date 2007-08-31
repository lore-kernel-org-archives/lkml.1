Return-Path: <linux-kernel-owner+w=401wt.eu-S966477AbXHaVeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966477AbXHaVeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 17:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965637AbXHaVeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 17:34:08 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4714 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965609AbXHaVeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 17:34:07 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: Nonblocking call may block in a mutex? Nonblocking call after poll may fail?
Date: Fri, 31 Aug 2007 14:33:22 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKIEJPGIAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <379fb4870708310513o46a721c6l3080179ccbb8f519@mail.gmail.com>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 31 Aug 2007 14:33:55 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 31 Aug 2007 14:33:55 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> If this output-buffer has "4-bytes space remaining for process A",
> then a non-blocking write of process A could still encounter a locked
> mutex, if process B is busy writing to the output-buffer.

Of course.

> Should process A now block/sleep until that mutex is free and it can
> access the output-buffer (and it's 4 bytes space)?

That depends on how long the other process might hold the mutex. If it's
just the time it takes to copy the buffer and do fast things, then it should
wait. If it might be a long time, then it's probably better not to block, as
the process requested.

> What about a non-blocking (write-) poll of process A: if the poll call
> succeeds (the output buffer has space remaining for process A), and
> process A now performs a non-blocking write: what happens if A
> encounters a blocked mutex, since process B is busy writing to the
> output-buffer.
> a) Should A block until the mutex is available?

Probably, unless the mutex is one that could be held for a very long time.
It really depends upon what semantics make sense with your driver. Is the
wait so short it should be considered not blocking or is it potentially long
enough that it should be avoided?

A non-blocking call does not mean it must never ever lose the CPU at all
under any circumstances. It just means no waits for "too long".

> b) Should A return -EAGAIN, even though the poll call succeeded?

If the wait would be for too long, then yes.

> c) Should it be impossible for this to happen! i.e. -> should process
> A already "have" the mutex in question, when the poll call succeeds
> (thus preventing B from writing to the output buffer)

No. Functions like 'poll' and 'select' are just status-reporting functions.
They should not change the semantics of other operations unless that's
unavoidable.

> For c) What if process A "has" the mutex, but never does the
> non-blocking write. Then no process can write, since the mutex is held
> by process A...

Right. That's why return values from 'poll' and 'select' don't guarantee
future behavior.

DS


