Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZGOQxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZGOQxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 12:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbZGOQxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 12:53:17 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47189 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbZGOQxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 12:53:16 -0400
Date: Wed, 15 Jul 2009 22:23:08 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tty related hangs with 2.6.31-rc3
Message-ID: <20090715165308.GA5228@skywalker>
References: <20090715132956.GA10004@skywalker> <20090715161142.55083da7@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715161142.55083da7@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 04:11:42PM +0100, Alan Cox wrote:
> On Wed, 15 Jul 2009 18:59:56 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > Hi,
> > 
> > I am finding tty related hangs with 2.6.31-rc3. This didn't happen 
> > before. This happen when i close the emacs session. The /proc/<pid>/stack
> > content is below      
> 
> Thanks - nice clear trace. Looks like a bug in the n_tty locking changes
> from a few releases back that the pty changes are triggering.
> 
> Basically process_echoes calls tty_put_char which if it thinks a device
> queue was full and now has a bit of space will call tty_wakeup which can
> call process_echoes and thus deadlock. With a physical serial device we
> will even sometimes call tty_wakeup() from the serial transmit path
> which is an irq path (which makes this doubly wrong as it then takes
> mutexes)
> 
> Emacs presumably uses fasync which is the trigger for this. You need the
> right timing combined with the new pty behaviour combined with FASYNC to
> trigger it.
> 
> 
> > [<c0362c5b>] process_echoes+0x2b/0x2e0
> [which tries to take the lock we already hold (end A)]
> > [<c03638cb>] n_tty_write_wakeup+0xb/0x40
> [which processes our ldisc wakeup (end A)]
> > [<c0360a88>] tty_wakeup+0x58/0x70
> [which wakes up our tty (end A)]
> > [<c0368347>] pty_write+0x67/0x70
> [our write method is for tty/pty pairs end A output, queued to end B]
> > [<c035f1cb>] tty_put_char+0x2b/0x40
> [calls tty_put_char to write the echoed byte to end A output]
> > [<c036291f>] do_output_char+0xef/0x200
> [the fake typed character is echoed back towards end B]
> > [<c0362d4e>] process_echoes+0x11e/0x2e0
> [tries to process echo characters on end A]
> > [<c0364292>] n_tty_receive_char+0x102/0x710
> [ receives a byte that we've faked typing to end A input]
> > [<c0364ac0>] n_tty_receive_buf+0x220/0x410
> [ioctl method calls the ld->ops->receive_buf for n_tty (unsafely but that
> bug is old]
> > [<c036059c>] tiocsti+0x8c/0xa0
> > [<c0361aca>] tty_ioctl+0x25a/0x310
> > [<c01e52c8>] vfs_ioctl+0x28/0x80
> > [<c01e54f4>] do_vfs_ioctl+0x64/0x1c0
> > [<c01e56a3>] sys_ioctl+0x53/0x70
> > [<c0102e3c>] sysenter_do_call+0x12/0x28
> > [<ffffffff>] 0xffffffff
> 
> Do you have the lock validator enabled and if so did it have anything
> useful to report ?
> 
> Please try the following. I suspect this is the real fix:
>

With limited testing i am not seeing the hang any more. I will keep running
with the patch and report back if i hit the hang again.

-aneesh
