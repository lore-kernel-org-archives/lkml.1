Return-Path: <linux-kernel-owner+w=401wt.eu-S1946057AbXEAXsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946057AbXEAXsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 19:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946072AbXEAXsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 19:48:22 -0400
Received: from mail.screens.ru ([213.234.233.54]:57693 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946057AbXEAXsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 19:48:21 -0400
Date: Wed, 2 May 2007 03:48:22 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: libata-core.c: unsafe cancel_delayed_work() usage?
Message-ID: <20070501234822.GA277@tv-sign.ru>
References: <200704260110.22224.rjw@sisk.pl> <20070425165410.b73443b4.akpm@linux-foundation.org> <20070426100922.GB12892@in.ibm.com> <20070426101547.GA97@tv-sign.ru> <20070426125838.GC12892@in.ibm.com> <20070427184258.62794053.akpm@linux-foundation.org> <20070501225654.GA190@tv-sign.ru> <4637CEAA.7070102@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4637CEAA.7070102@garzik.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01, Jeff Garzik wrote:
>
> Oleg Nesterov wrote:
> >
> >Alan, the usage of cancel_delayed_work() in drivers/ata/libata-core.c looks
> >suspicious to me, both ->hotplug_task and ->port_task can re-arm 
> >themselves,
> >so cancel_delayed_work + flush_workqueue (or cancel_work_sync) is not 
> >enough.
> >
> >Could you confirm/nack my understanding?
> 
> For all rearming workqueues, one must use cancel-rearming-blahblah.

Well, yes and no. cancel_rearming_delayed_work() requires that dwork
re-arms itself unconditionally, otherwise it just hangs (actually, the
patch to fix this shortcoming is ready). However, ata_pio_task() for
example, re-arms only when ATA_BUSY.

So it is very possible that the code is correct, if the caller of
ata_port_flush_task() ensures that ATA_BUSY is not possible. Otherwise
we should change cancel_rearming_delayed_work() and use it.

Oleg.

