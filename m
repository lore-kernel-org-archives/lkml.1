Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbYDLTEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbYDLTEv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 15:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbYDLTEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 15:04:41 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47132 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbYDLTEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 15:04:40 -0400
Date: Sat, 12 Apr 2008 13:04:24 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Oeser <ioe-lkml@rameria.de>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080412190423.GM11962@parisc-linux.org>
References: <20080411210022.GJ11962@parisc-linux.org> <1208003081.7427.7.camel@twins> <20080412172606.GL11962@parisc-linux.org> <1208023549.6230.37.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208023549.6230.37.camel@lappy>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 08:05:49PM +0200, Peter Zijlstra wrote:
> On Sat, 2008-04-12 at 11:26 -0600, Matthew Wilcox wrote:
> >  We can continue the
> > discussion about eliminating one or the other API, but my opinion is that
> > eliminating either is a mistake.  The choice of API indicates how the
> > author thinks about the code, which is crucial for those reading the code.
> 
> Which is exactly the point, semaphores are rarely the right tool for the
> job (I'm currently only aware of XFS that actually uses them as actual
> semaphores, and the driver model that uses it to get around lockdep -
> still need to come up with a good solution for that).

I guess you haven't grepped the tree recently then.  We have 11 places
which call sema_init with a number other than 0 or 1 as the second
argument:

./fs/xfs/linux-2.6/sema.h:#define initnsema(sp, val, name)      sema_init(sp, val)
./drivers/net/mlx4/cmd.c:       sema_init(&priv->cmd.event_sem, priv->cmd.max_cmds);
./drivers/char/viotape.c:       sema_init(&reqSem, VIOTAPE_MAXREQ);
./drivers/infiniband/hw/mthca/mthca_cmd.c:      sema_init(&dev->cmd.event_sem, dev->cmd.max_cmds);
./drivers/acpi/osl.c:   sema_init(sem, initial_units);
./drivers/scsi/megaraid/megaraid_sas.c: sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);
./drivers/scsi/megaraid/megaraid_mm.c:  sema_init(&adapter->kioc_semaphore, lld_adp->max_kioc);
./drivers/video/omap/hwa742.c:  sema_init(&hwa742.req_sema, i - IRQ_REQ_POOL_SIZE);
./drivers/video/omap/blizzard.c:        sema_init(&blizzard.req_sema, i - IRQ_REQ_POOL_SIZE);
./drivers/usb/misc/usblcd.c:    sema_init(&dev->limit_sem, USB_LCD_CONCURRENT_WRITES);
./drivers/usb/usb-skeleton.c:   sema_init(&dev->limit_sem, WRITES_IN_FLIGHT);

It's nice to know that nobody is using __DECLARE_SEMAPHORE_GENERIC or
__SEMAPHORE_INITIALIZER at this time.  I'll delete those from my semaphore
tree soon.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
