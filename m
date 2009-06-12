Return-Path: <linux-kernel-owner+w=401wt.eu-S932886AbZFLIEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbZFLIEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932677AbZFLIDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:03:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52191 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbZFLID2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:03:28 -0400
Date: Fri, 12 Jun 2009 09:56:50 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] posix-cpu-timers: avoid do_sys_times() races with
 __exit_signal()
Message-ID: <20090612095650.61863c41@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <1244790598.6691.956.camel@laptop>
References: <20090612084910.1b63b0af@dhcp-lab-109.englab.brq.redhat.com>
	<1244790598.6691.956.camel@laptop>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 09:09:58 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2009-06-12 at 08:49 +0200, Stanislaw Gruszka wrote:
> > Protect thread_group_cputime() call by siglock, to avoid possible (but
> > to be honest - very improbable) double times accounting of exiting task.
> > This is revert of commit 2b5fe6de58276d0b5a7c884d5dbfc300ca47db78
> > "thread_group_cputime: move a couple of callsites outside of ->siglock",
> > but implementation of thread_group_cputime() was different then.
> 
> Would be nice to have a description of exactly how you'd end up
> accounting twice (and thus how this patch fixes it).

In thread_group_cputime() we loop on all threads within the group to sum 
they cputimes. After finish loop, we add killed tasks times from tsk->signal.
If thread (one or more) exit in gap between loop and adding killed tasks
times, __exit_signal() function add already accounted times to tsk->signal.
So some exiting threads times could be accounted twice.

Stanislaw
