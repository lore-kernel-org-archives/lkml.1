Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbZIKLii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbZIKLii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 07:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbZIKLih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 07:38:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44319 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbZIKLih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 07:38:37 -0400
Subject: Re: [2.6.31-rc9] hotplug SATA vs lockdep: false positive?
From: Peter Zijlstra <peterz@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
In-Reply-To: <d82e647a0909101859t48f4a494l75040b47a7474760@mail.gmail.com>
References: <6278d2220909091420g688bd11fybc33be4e472757b1@mail.gmail.com>
	 <1252597402.7205.75.camel@laptop>
	 <d82e647a0909101859t48f4a494l75040b47a7474760@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 13:38:38 +0200
Message-Id: <1252669118.7126.22.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 09:59 +0800, Ming Lei wrote:
> 
> IMHO, it seems flushing other workqueues in one workqueue, so it
> may be a false positive. Since the three workqueue instances share one
> lock class, maybe lockdep_set_class*() or other similar annotations
> is needed in acpi_os_initialize1() to avoid the warning.

Hrm.. this code hurts brain..

I count 3 workqueues, kacpi_notify_wq, kacpid_wq and kacpi_hotplug_wq.

And we have:

void acpi_os_wait_events_complete(void *context)
{
        flush_workqueue(kacpid_wq);
        flush_workqueue(kacpi_notify_wq);
}

So we're calling this from the hotplug queue, and flush the other two
acpi wqs?

1) are we sure all this flushing is indeed needed, can't driver .remove
methods use cancel_work() instead?

2) ugh..

Yeah, your problem is that you've overloaded this __acpi_os_execute()
thing and enqueue work to all 3 workqueues using the very same
INIT_WORK() instance.

Untangle that mess a bit and use multiple INIT_WORK() stmts.

Why do you need 3 queues to run 2 functions?

