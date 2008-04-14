Return-Path: <linux-kernel-owner+w=401wt.eu-S1764032AbYDNRqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764032AbYDNRqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762576AbYDNRpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:45:52 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:21577 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763958AbYDNRpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:45:49 -0400
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Does process need to have a kernel-side stack all the time?
From: Andi Kleen <andi@firstfloor.org>
References: <200804141547.57719.vda.linux@googlemail.com>
Date: Mon, 14 Apr 2008 19:44:15 +0200
In-Reply-To: <200804141547.57719.vda.linux@googlemail.com> (Denys Vlasenko's message of "Mon, 14 Apr 2008 15:47:57 +0200")
Message-ID: <87hce4uya8.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Apr 2008 17:37:30.0101 (UTC) FILETIME=[36A1D250:01C89E56]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko <vda.linux@googlemail.com> writes:

> A lot of effort went into minimizing of stack usage.
> If I understand it correctly, one of the reasons for this
> was to be efficient and not have lots of pages
> used for stacks when we have a lot of threads
> (tens of thousands).

Actually the real reason the 4K stacks were introduced IIRC was that
the VM is not very good at allocation of order > 0 pages and that only
using order 0 and not order 1 in normal operation prevented some stalls.

This rationale also goes back to 2.4 (especially some of the early 2.4
VMs were not very good) and the 2.6 VM is generally better and on
x86-64 I don't see much evidence that these stalls are a big problem
(but then x86-64 also has more lowmem).

Note that your proposal doesn't change this at all.

I personally think 4K stacks are a bad idea because code 
is always getting more complex and having more stack is 
a very useful safety margin.

> A random thought occurred to me: in a system with so many
> threads most of them are not executing anyway, even on
> that gigantic Altix machines. Do they all need to have
> kernel stack, all the time? I mean: the process which
> is running in user space is not using kernel stack at all.
> Process which is not running on a CPU right now
> is not using it either.

Actually processes that sleep do use the stack.
Take a look at Sysrq-t output some time. Pretty much 
all sleepers have some context.

Only processes currently running in user land do not use
the kernel stack, but there are very little of them
(never more than you have CPUs) 

-Andi
