Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYLEBMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYLEBMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 20:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbYLEBMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 20:12:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56760
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752022AbYLEBMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 20:12:33 -0500
Date: Thu, 04 Dec 2008 17:12:33 -0800 (PST)
Message-Id: <20081204.171233.201039452.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, eranian@googlemail.com,
       dada1@cosmosbay.com, robert.richter@amd.com, arjan@infradead.org,
       hpa@zytor.com, a.p.zijlstra@chello.nl, rostedt@goodmis.org,
       paulus@samba.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081204225345.654705757@linutronix.de>
References: <20081204225345.654705757@linutronix.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 04 Dec 2008 23:44:39 -0000

>  - No interaction with ptrace: any task (with sufficient permissions) can
>    monitor other tasks, without having to stop that task.

This isn't going to work.

If you look at the things the perfmon libraries do, you do need to
stop the task.

Consider counter virtualization as the most direct example.  Perfmon
allows you to count 6 events even if you can only monitor 2 at a time
with your hardware.  It does this by periodically changing the counter
configuration during the run of the program(s) being inspected.  These
control register changes and counter captures have to be atomic or
else you'll get garbage or less accurate results.

There are entire families of cases where you want to perform a
sequence of operations on the control registers and counters if one of
them overflows.  And these operations must be atomic.  The only way
to ensure this is to stop the task, then let the library in the
monitoring task make the changes, and finally let the library
release that task.

The crux of the matter is, when a counter overflows, what you want to
do in response to that event is non-trivial and it must be performed
without letting the monitored task continue executing.  So you have to
stop the task, and unless you want tons of cpu specific knowledge and
counter virtualization support code in the kernel, we want userspace
telling the kernel how to program the registers.  And since we have
to stop the task, there is no benefit doing this work in the kernel
anyways.

If you don't like the NMI and IPI business on x86 in the perfmon
patches, suggest alternatives.
