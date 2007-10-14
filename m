Return-Path: <linux-kernel-owner+w=401wt.eu-S1763448AbXJNW0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763448AbXJNW0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 18:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758210AbXJNW0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 18:26:32 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:58423 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752361AbXJNW0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 18:26:31 -0400
Subject: Re: linux-2.6.23-mm1 crashed
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Milter <davemilter@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Boaz Harrosh <bharrosh@panasas.com>
In-Reply-To: <20071014122144.f8e56ed9.akpm@linux-foundation.org>
References: <2a382c6e0710141145j51286bd0o8a2eb307f7455cd@mail.gmail.com>
	 <20071014122144.f8e56ed9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 14 Oct 2007 18:26:29 -0400
Message-Id: <1192400789.3351.59.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-10-14 at 12:21 -0700, Andrew Morton wrote:
> On Sun, 14 Oct 2007 22:45:47 +0400 "Dave Milter" <davemilter@gmail.com> wrote:
> 
> > I build linux-2.6.23-mm1 and try to boot it using qemu,
> > and it crashed with trace like this:
> > do_page_fault
> > error_code
> > lock_acquire
> > _spin_lock_irqsave
> > gdth_timeout
> > run_timer_softirq
> > __do_softirq
> > do_softirq
> > 
> > I have screenshot, but have no idea, is it legal to include it, if I
> > sent copy to lkml.
> > config of kernel in attachment,
> > I apply all three patches from hot-fixes.
> > 
> 
> The screenshot is here:  http://userweb.kernel.org/~akpm/crash.png
> 
> It would appear that gdth_timeout() is passing a bad pointer into
> spin_lock_irqsave().

There's a bug in the gdth rework in that the instance can be deleted
from the list before the actual timer is stopped.  This can be worked
around I think by the following patch; although we really should be
stopping the timer from firing when the list goes empty.

James

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index e8010a7..7fa22be 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3793,6 +3793,9 @@ static void gdth_timeout(ulong data)
     gdth_ha_str *ha;
     ulong flags;
 
+    if (list_empty(&gdth_instances))
+	return;
+
     ha = list_first_entry(&gdth_instances, gdth_ha_str, list);
     spin_lock_irqsave(&ha->smp_lock, flags);
 



