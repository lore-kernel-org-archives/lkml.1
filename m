Return-Path: <linux-kernel-owner+w=401wt.eu-S932993AbXA1XgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993AbXA1XgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 18:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932995AbXA1XgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 18:36:23 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41830 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932991AbXA1XgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 18:36:22 -0500
Date: Sun, 28 Jan 2007 15:30:05 -0800
From: Andrew Morton <akpm@osdl.org>
To: paulmck@linux.vnet.ibm.com
Cc: dipankar@in.ibm.com, Gautham Shenoy <ego@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Message-Id: <20070128153005.f320b834.akpm@osdl.org>
In-Reply-To: <20070128224756.GA7672@linux.vnet.ibm.com>
References: <20070124011519.GG1613@linux.vnet.ibm.com>
	<20070124090111.GC27221@in.ibm.com>
	<20070124161559.GA1762@linux.vnet.ibm.com>
	<20070124210645.GA19650@in.ibm.com>
	<20070126191113.GA14770@in.ibm.com>
	<20070126112837.059502fc.akpm@osdl.org>
	<20070126194622.GA17134@in.ibm.com>
	<20070126121739.be3e072a.akpm@osdl.org>
	<20070126204406.GB17134@in.ibm.com>
	<20070126132949.50544e90.akpm@osdl.org>
	<20070128224756.GA7672@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jan 2007 14:47:56 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> > If we use the process freezer, these bugs all get automatically fixed,
> > and we get to remove the existing locking, and we don't need to think
> > about it any more.
> 
> The idea being to essentially suspend the system to RAM, remove the
> CPU and then unsuspend it?  Seems like quite high overhead -- or am
> I misunderstanding the proposal?

The process freezer basically wakes up all threads in the machine and makes
them go to sleep in a specific place, so they're all in a known state. 
kernel threads are also captured, via their open-coded polling call to
try_to_freeze().

The machine suspend code uses the process freezer, as does kprobes.  The
freezer isn't tied to suspend or to power management.

The freezer does have potential to be expensive if used frequently and if
there are many threads.  But I don't think anyone has looked at optimising
it.  For example, there are certain places in the kernel where threads
commonly sleep (eg, select()).  We know that this is a safe place to sleep
wrt (at least) CPU hotplug, so there's not really a need to wake those
processes up.  Perhaps something could be done with that observation...

But first we'd need to demonstrate that we actually have a problem.
