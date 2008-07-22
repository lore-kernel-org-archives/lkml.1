Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbYGVXfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbYGVXfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757762AbYGVX0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:26:11 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:58392 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758686AbYGVX0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:26:10 -0400
Date: Tue, 22 Jul 2008 18:25:28 -0500
From: David Fries <david@fries.net>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, johnpol@2ka.mipt.ru, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: + w1-documentation-w1-masters-ds2490-update.patch added to -mm tree
Message-ID: <20080722232528.GW5621@spacedout.fries.net>
References: <200807220827.m6M8RQEg018613@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807220827.m6M8RQEg018613@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Tue, 22 Jul 2008 18:25:34 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch, is 29 of 30.  Should I resend all 30, or 29 (and to where)?

Randy Dunlap pointed out some errors of the original patch 29, so I
fixed them and resent just that one patch.  This patch doesn't have
any ordering dependencies, but some of the others do.

The first e-mail in the patch set (the below patch replaces 29/30 in
this series).
Message-Id: <12157843053444-git-send-email-johnpol@2ka.mipt.ru>
Subject: [PATCH 1/30] W1: fix deadlocks and remove w1_control_thread
Date:   Fri, 11 Jul 2008 17:51:16 +0400

The e-mail the below patch came from.
Message-ID: <20080715021754.GR5621@spacedout.fries.net>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru> <12157843071043-git-send-email-johnpol@2ka.mipt.ru> <20080714134002.e5dfaaae.randy.dunlap@oracle.com>
Subject: Re: [PATCH 29/30] W1: Documentation/w1/masters/ds2490 update
Date:   Mon, 14 Jul 2008 21:17:54 -0500

On Tue, Jul 22, 2008 at 01:27:26AM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      w1: Documentation/w1/masters/ds2490 update
> has been added to the -mm tree.  Its filename is
>      w1-documentation-w1-masters-ds2490-update.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: w1: Documentation/w1/masters/ds2490 update
> From: David Fries <david@fries.net>
> 
> Provide some additional details about the status of the driver and the
> ds2490 hardware.
> 
> Signed-off-by: David Fries <david@fries.net>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  Documentation/w1/masters/ds2490 |   52 ++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
> diff -puN Documentation/w1/masters/ds2490~w1-documentation-w1-masters-ds2490-update Documentation/w1/masters/ds2490
> --- a/Documentation/w1/masters/ds2490~w1-documentation-w1-masters-ds2490-update
> +++ a/Documentation/w1/masters/ds2490
> @@ -16,3 +16,55 @@ which allows to build USB <-> W1 bridges
>  DS9490(R) is a USB <-> W1 bus master device
>  which has 0x81 family ID integrated chip and DS2490
>  low-level operational chip.
> +
> +Notes and limitations.
> +- The weak pullup current is a minimum of 0.9mA and maximum of 6.0mA.
> +- The 5V strong pullup is supported with a minimum of 5.9mA and a
> +  maximum of 30.4 mA.  (From DS2490.pdf)
> +- While the ds2490 supports a hardware search the code doesn't take
> +  advantage of it (in tested case it only returned first device).
> +- The hardware will detect when devices are attached to the bus on the
> +  next bus (reset?) operation, however only a message is printed as
> +  the core w1 code doesn't make use of the information.  Connecting
> +  one device tends to give multiple new device notifications.
> +- The number of USB bus transactions could be reduced if w1_reset_send
> +  was added to the API.  The name is just a suggestion.  It would take
> +  a write buffer and a read buffer (along with sizes) as arguments.
> +  The ds2490 block I/O command supports reset, write buffer, read
> +  buffer, and strong pullup all in one command, instead of the current
> +  1 reset bus, 2 write the match rom command and slave rom id, 3 block
> +  write and read data.  The write buffer needs to have the match rom
> +  command and slave rom id prepended to the front of the requested
> +  write buffer, both of which are known to the driver. =20
> +- The hardware supports normal, flexible, and overdrive bus
> +  communication speeds, but only the normal is supported.
> +- The registered w1_bus_master functions don't define error
> +  conditions.  If a bus search is in progress and the ds2490 is
> +  removed it can produce a good amount of error output before the bus
> +  search finishes.
> +- The hardware supports detecting some error conditions, such as
> +  short, alarming presence on reset, and no presence on reset, but the
> +  driver doesn't query those values.
> +- The ds2490 specification doesn't cover short bulk in reads in
> +  detail, but my observation is if fewer bytes are requested than are
> +  available, the bulk read will return an error and the hardware will
> +  clear the entire bulk in buffer.  It would be possible to read the
> +  maximum buffer size to not run into this error condition, only extra
> +  bytes in the buffer is a logic error in the driver.  The code should
> +  should match reads and writes as well as data sizes.  Reads and
> +  writes are serialized and the status verifies that the chip is idle
> +  (and data is available) before the read is executed, so it should
> +  not happen.
> +- Running x86_64 2.6.24 UHCI under qemu 0.9.0 under x86_64 2.6.22-rc6
> +  with a OHCI controller, ds2490 running in the guest would operate
> +  normally the first time the module was loaded after qemu attached
> +  the ds2490 hardware, but if the module was unloaded, then reloaded
> +  most of the time one of the bulk out or in, and usually the bulk in
> +  would fail.  qemu sets a 50ms timeout and the bulk in would timeout
> +  even when the status shows data available.  A bulk out write would
> +  show a successful completion, but the ds2490 status register would
> +  show 0 bytes written.  Detaching qemu from the ds2490 hardware and
> +  reattaching would clear the problem.  usbmon output in the guest and
> +  host did not explain the problem.  My guess is a bug in either qemu
> +  or the host OS and more likely the host OS.
> +-- 03-06-2008 David Fries <David@Fries.net>
> _
> 
> Patches currently in -mm which might be from david@fries.net are
> 
> w1-documentation-w1-masters-ds2490-update.patch

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
