Return-Path: <linux-kernel-owner+w=401wt.eu-S933562AbXKOVfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562AbXKOVfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933221AbXKOVfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:35:13 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:37543 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932987AbXKOVfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:35:11 -0500
Date: Thu, 15 Nov 2007 13:35:10 -0800
From: Micah Dowty <micah@vmware.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>
Subject: Re: High priority tasks break SMP balancer?
Message-ID: <20071115213510.GA16079@vmware.com>
References: <20071109223417.GB16250@vmware.com> <4734F397.7080802@gmx.net> <20071110001103.GD16250@vmware.com> <2FAA6826-653E-482F-A037-C539BAEEA1DA@mac.com> <20071115191408.GA4914@vmware.com> <Pine.LNX.4.64.0711151206370.28639@schroedinger.engr.sgi.com> <20071115202425.GC4914@vmware.com> <Pine.LNX.4.64.0711151328090.29711@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711151328090.29711@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 01:28:55PM -0800, Christoph Lameter wrote:
> On Thu, 15 Nov 2007, Micah Dowty wrote:
> 
> > Yes, the Python test harness crashes, not the kernel. It's just
> > because on a kernel which exhibits this SMP balancer bug, within a
> > couple of test iterations I'll hit a case where cpu1 was almost
> > totally idle and the test harness divides by zero when calculating the
> > imbalance.
> 
> I still have some problem understanding what you are complaining about? 
> The patch that you bisected had some issues that were fixed later by 
> Siddha.

On all kernels I've tested from after your patch was committed, I can
reproduce a problem where a single high-priority thread which wakes up
very frequently can artificially inflate the SMP balancer's load
average for one CPU, causing other tasks to be migrated off that
CPU. The result is that this high-priority thread (which may only use
a few percent CPU) gets an entire CPU to itself. Even if there are
several busy-looping threads running, this CPU will be mostly idle.

In the first email I CC'ed you on, I attached a test program that I've
been able to use to reproduce the issue. Feel free to ignore the
Python program- it's just a harness I was using to test for the
problem quickly during my git-bisect run.  to reproduce the
problem. The relevant code is all in priosched.c.

Thanks,
--Micah
