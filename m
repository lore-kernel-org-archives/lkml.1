Return-Path: <linux-kernel-owner+w=401wt.eu-S1760598AbXIUOgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598AbXIUOgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758605AbXIUOg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:36:27 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:52418 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867AbXIUOgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:36:25 -0400
Date: Fri, 21 Sep 2007 15:36:05 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>, Gerd Hoffmann <kraxel@suse.de>,
       linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Yinghai.Lu@Sun.COM, bryan.wu@analog.com, dilinger@queued.net,
       kraxel@redhat.com, lethal@linux-sh.org, rgetz@blackfin.uclinux.org,
       vapier.adi@gmail.com
Subject: Re: [PATCH] kernel/printk.c: Concerns about the console handover
In-Reply-To: <20070921134331.GC20277@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64N.0709211454570.2724@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0709201749240.30788@blysk.ds.pg.gda.pl>
 <20070921010349.2caee558.akpm@linux-foundation.org>
 <Pine.LNX.4.64N.0709211428300.2724@blysk.ds.pg.gda.pl>
 <20070921134331.GC20277@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Russell King wrote:

> I suspect the correct fix for this is to take the fix in the ARM tree
> for serial_core's console initialisation, and ensure that zs.c handles
> the power management of the port (enabling/disabling transmitter)
> in the power management callback.

 Hmm, it sounds a bit hackish to me.  The serial part is from the 1970s -- 
nobody thought of power management back then.  And even though the 
DECstation is about 20 years younger, it does not provide any means for 
power management either -- it is a workstation/server class system after 
all.

> You can find the fix in the mbox archive:
> 
>  http://ftp.arm.linux.org.uk/pub/linux/arm/kernel/git-cut/arm:devel.mbox

 Hmm, nothing of relevance there.

 I see no problem with implementing the ->pm() call as something like:

void zs_pm(struct uart_port uport, unsigned int state, unsigned int oldstate)
{
	struct zs_port *zport = to_zport(uport);

	if (state < 3)
		zport->regs[5] |= TxENAB;
	else
		zport->regs[5] &= ~TxENAB;
	write_zsreg(zport, R5, zport->regs[5]);
}

itself, but it looks more like a workaround than a fix to me.  I'll have 
to think about it and also double-check it is safe.  The SCC is about as 
complicated as you can get with a serial port.

 Thanks for the hint though.

  Maciej
