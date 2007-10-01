Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbXJAWTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbXJAWTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbXJAWTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:19:11 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3234 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbXJAWTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:19:09 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
Subject: RE: Network slowdown due to CFS
Date: Mon, 1 Oct 2007 15:17:52 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEPDHCAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
In-Reply-To: <20071001125350.055ef9bb@laptopd505.fenrus.org>
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 01 Oct 2007 15:18:13 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 01 Oct 2007 15:18:14 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Arjan van de Ven wrote:

> > It can occasionally be an optimization. You may have a case where you
> > can do something very efficiently if a lock is not held, but you
> > cannot afford to wait for the lock to be released. So you check the
> > lock, if it's held, you yield and then check again. If that fails,
> > you do it the less optimal way (for example, dispatching it to a
> > thread that *can* afford to wait).

> at this point it's "use a futex" instead; once you're doing system
> calls you might as well use the right one for what you're trying to
> achieve.

There are two answers to this. One is that you sometimes are writing POSIX
code and Linux-specific optimizations don't change the fact that you still
need a portable implementation.

The other answer is that futexes don't change anything in this case. In
fact, in the last time I hit this, the lock was a futex on Linux.
Nevertheless, that doesn't change the basic issue. The lock is locked, you
cannot afford to wait for it, but not getting the lock is expensive. The
solution is to yield and check the lock again. If it's still held, you
dispatch to another thread, but many times, yielding can avoid that.

A futex doesn't change the fact that sometimes you can't afford to block on
a lock but nevertheless would save significant effort if you were able to
acquire it. Odds are the thread that holds it is about to release it anyway.

That is, you need something in-between "non-blocking trylock, fail easily"
and "blocking lock, do not fail", but you'd rather make forward progress
without the lock than actually block/sleep.

DS


