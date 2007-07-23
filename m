Return-Path: <linux-kernel-owner+w=401wt.eu-S935578AbXGWUe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935578AbXGWUe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765890AbXGWUeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:34:20 -0400
Received: from gw.goop.org ([64.81.55.164]:53417 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763353AbXGWUeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:34:19 -0400
Message-ID: <46A51079.5030006@goop.org>
Date: Mon, 23 Jul 2007 13:32:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: LKML <linux-kernel@vger.kernel.org>, andi@firstfloor.org,
       nix.or.die@googlemail.com, Roland McGrath <roland@redhat.com>
Subject: Re: 2.6.22-git17 boot failure
References: <46A3EC92.3050504@imap.cc> <46A3FBB7.9000608@imap.cc> <46A46BF9.6010906@goop.org> <46A481FD.2030607@imap.cc> <46A4C081.6070305@goop.org> <46A504A3.3070205@imap.cc>
In-Reply-To: <46A504A3.3070205@imap.cc>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> To answer that, I have reproduced the effect with kernel 2.6.23-rc1 with
> netconsole compiled in. I'm attaching both captures, for CONFIG_XEN=y
> (unsuccessful) as well CONFIG_XEN=n (successful).
>
> The first noticeable difference is that the nonzero timestamps starting
> after the line "Detected 3197.059 MHz processor" are much bigger with XEN -
> but perhaps that's expected.
>   

Not at all.  None of the Xen time machinery should be coming into play.

> More to the point, everything from:
>
>   SCSI subsystem initialized
>
> on is completely missing, including all the [S/P]ATA, SCSI, parport, AGP,
> USB, Firewire, RTC and of course ext3 messages. Only the "device-mapper"
> line still appears.

I'm flat out confused.  The only CONFIG_XEN dependencies in the kernel are:

   1. head.S and entry.S, which enable completely no-op pieces of code
      when not running under Xen
   2. The vdso code, which shouldn't play a role here
   3. The whole of arch/i386/xen/, which doesn't get enabled unless you
      run under Xen

There's flat out no way that your kernel would be booting if any of the
Xen code were actually being run, since it would fall over very quickly
without the hypervisor being present.  And anyway, the message "Booting
paravirtualized kernel on bare hardware" tells us we're not using the
Xen code.

How much of this is modules?  Is the initrd probing for scsi/sata? 
Maybe the the vdso change is having an effect.

Ooh, wait.  Do you have an old version of the Xen patches in place,
perhaps?  Does drivers/block/Makefile have:

obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o

(vs := xen-blkfront.o)  Not that it should have any effect on scsi drivers.

Could you do a before and after booting with initcall_debug=1?

Thanks,
    J
