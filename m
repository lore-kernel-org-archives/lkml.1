Return-Path: <linux-kernel-owner+w=401wt.eu-S965225AbXCLNWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965225AbXCLNWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965412AbXCLNWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:22:51 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3811 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965376AbXCLNWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:22:50 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Matt Mackall" <mpm@selenic.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, <ck@vds.kolivas.org>
Subject: RE: RSDL-mm 0.28
Date: Mon, 12 Mar 2007 06:22:39 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKAEBACDAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <8cd998d50703101828l71fbec7bi9a819ad7b7fd9828@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 12 Mar 2007 05:23:06 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 12 Mar 2007 05:23:08 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > There's a substantial performance hit for not yield, so we probably
> > want to investigate alternate semantics for it. It seems reasonable
> > for apps to say "let me not hog the CPU" without completely expiring
> > them. Imagine you're in the front of the line (aka queue) and you
> > spend a moment fumbling for your wallet. The polite thing to do is to
> > let the next guy in front. But with the current sched_yield, you go
> > all the way to the back of the line.

> Well... are you advocating we change sched_yield semantics to a
> gentler form? This is a cinch to implement but I know how Ingo feels
> about this. It will only encourage more lax coding using sched_yield
> instead of proper blocking (see huge arguments with the ldap people on
> this one who insist it's impossible not to use yield).

The basic point of sched_yield is to allow every other process at the same
static priority level a chance to use the CPU before you get it back. It is
generally an error to use sched_yield to be nice. It's nice to get your work
done when the scheduler gives you the CPU, that's why it gave it to you.

It is proper to use sched_yield as an optimization when it more efficient to
allow another process/thread to run than you, for example, when you
encounter a task you cannot do efficiently at that time because another
thread holds a lock.

It's also useful prior to doing something that can most efficiently be done
without interruption. So a thread that returns from 'sched_yield' should
ideally be given a full timeslice if possible. This may not be sensible if
the 'sched_yield' didn't actuall yield, but then again, if nothing else
wants to run, why not give the only task that does a full slice?

In no case is much of anything guaranteed, of course. (What can you do if
there's no other process to yield to?)

Note that processes that call sched_yield should be rewarded for doing so
just as process that block on I/O are, assuming they do in fact wind up
giving up the CPU when they would otherwise have had it.

DS


