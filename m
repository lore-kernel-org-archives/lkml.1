Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbZKCJJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbZKCJJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 04:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbZKCJJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 04:09:26 -0500
Received: from mail.gmx.net ([213.165.64.20]:41985 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752973AbZKCJJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 04:09:25 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX198w6Bfxwl8o0eeXUwBci01qHiaS5O3DQ2GJ9ntPO
	rvurkSMkQS00O8
Subject: Re: UDP-U stream performance regression on 32-rc1 kernel
From: Mike Galbraith <efault@gmx.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: alex.shi@intel.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1257222791.16282.46.camel@ymzhang>
References: <1257220036.3819.193.camel@alexs-hp.sh.intel.com>
	 <1257222791.16282.46.camel@ymzhang>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Nov 2009 10:09:25 +0100
Message-Id: <1257239365.13856.41.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 12:33 +0800, Zhang, Yanmin wrote:
> On Tue, 2009-11-03 at 11:47 +0800, Alex Shi wrote:
> > We found the UDP-U 1k/4k stream of netperf benchmark have some
> > performance regression from 10% to 20% on our Tulsa and some NHM
> > machines. 
> ﻿
> perf events shows function find_busiest_group consumes about 4.5% cpu time
> with the patch while it only consumes 0.5% cpu time without the patch.
> 
> The communication between netperf client and netserver is very fast.
> When netserver receives a message and there is no new message available,
> it goes to sleep and scheduler calls idle_balance => load_balance_newidle.
> load_balance_newidle spends too much time and a new message arrives quickly
> before load_balance_newidle ends.

I have a similar problem wrt ramp-up and affinity, so will certainly be
doing battle with the thing here.

It's harming mysql+oltp and pgsql+oltp ramp up, and modest load in
general by pulling at the first micro-sleep.  After twiddling
wake_affine() to spread to a shared cache, newidle comes along and
throws a wrench into my plans an eyeblink later.

> As the comments in the patch say hackbench benefits from it, I tested hackbench
> on Nehalem and core2 machines. hackbench does benefit from it, about 6% on
> nehalem machines, but doesn't benefit on core2 machines.

It depends a lot on the load.  I have a testcase which spawns threads at
a ~high rate.  There, turning it off costs ~42% on my little Q6600 box.
It's also a modest utilization win for a kbuild.

In any case though, it certainly wants a couple fangs pulled.

	-Mike

