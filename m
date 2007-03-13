Return-Path: <linux-kernel-owner+w=401wt.eu-S933245AbXCMU03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbXCMU03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933251AbXCMU03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:26:29 -0400
Received: from www.osadl.org ([213.239.205.134]:47313 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933245AbXCMU02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:26:28 -0400
Subject: Re: x86_64 system lockup from userspace using setitimer()
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Johannes Bauer <JohannesBauer@gmx.de>, linux-kernel@vger.kernel.org,
       schwab@suse.de
In-Reply-To: <45F7033B.2030204@redhat.com>
References: <45F6F3A6.9060405@gmx.de>  <45F7033B.2030204@redhat.com>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 21:33:05 +0100
Message-Id: <1173817985.13341.120.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 16:02 -0400, Chuck Ebbert wrote:
> >     struct itimerval tim = {
> >         .it_interval = {
> >             .tv_sec = 140735669863712,
> >             .tv_usec = 4199521
> >         },
> Could this be fixed by:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8bfd9a7a229b5f3d3eda5d7d45c2eebec5b4ba16
> 
> [PATCH] hrtimers: prevent possible itimer DoS

No. The possible DoS is only when high res timers are enabled, which is
not the case in 2.6.20.

Looking at the values 

140735669863712 = 0x7FFF 939C 0520

We convert second to nanoseconds:

140735669863712 * 1e9 =  0x1DCD 4BC3 6B82 914B 4000

The seconds value is limited to LONG_MAX, but on a 64 bit machine, the
140735669863712 is inside LONG_MAX and we have an multiplication
overflow.

I'm not sure, how this results in a DoS, but I will look into this
tomorrow morning, when I'm more awake.

	tglx


