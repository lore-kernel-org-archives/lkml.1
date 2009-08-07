Return-Path: <linux-kernel-owner+w=401wt.eu-S932826AbZHGPLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826AbZHGPLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932683AbZHGPLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:11:08 -0400
Received: from vena.lwn.net ([206.168.112.25]:33510 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932627AbZHGPLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:11:07 -0400
Date: Fri, 7 Aug 2009 09:08:18 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mark Gross <mgross@linux.intel.com>
Subject: Re: [PATCH 1/2] pm_qos: remove BKL
Message-ID: <20090807090818.064d3647@bike.lwn.net>
In-Reply-To: <20090807055412.GB9182@nowhere>
References: <20090806135841.46682114@bike.lwn.net>
	<20090806135953.7706e57d@bike.lwn.net>
	<20090807055412.GB9182@nowhere>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Aug 2009 07:54:13 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> May be the last doubt could be the blocking_notifier_call_chain() call from
> update_target(). Not sure if these notifier handlers can expect to be called
> concurrently?

I will confess that I hadn't audited the notifiers.  One could easily
argue that concurrent calls to update_target() are entirely possible
with the current code (only one of the callers had BKL protection),
but, then, I'm supposed to be trying to make things better.

The notifier call chain is already protected against concurrent
modification, but, since an rwsem is used, concurrent calls to the
notifiers themselves are possible.  A quick grep shows that, in 2.6.31-rc5,
there is exactly one notifier registered.  It's in
drivers/cpuidle/cpuidle.c; here's the whole thing:

static void smp_callback(void *v)
{
	/* we already woke the CPU up, nothing more to do */
}

After deep meditation on possible race condition scenarios, I am force to
conclude that this particular notifier already has all of the protection it
needs, and that any extra locking is likely to be superfluous.

Thanks for looking at the patch,

jon
