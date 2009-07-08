Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbZGHTzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbZGHTzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 15:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbZGHTzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 15:55:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53390 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755355AbZGHTzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 15:55:00 -0400
Date: Wed, 8 Jul 2009 15:54:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Michael S. Zick" <lkml@morethan.org>
cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Null Pointer BUG in uhci_hcd
In-Reply-To: <200907071624.37176.lkml@morethan.org>
Message-ID: <Pine.LNX.4.44L0.0907081546430.22105-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Michael S. Zick wrote:

> Here is an example of the message paths taken - I have another 27Mbytes of the same
> if this snippet isn't enough.

> Jun 30 10:38:00 cb01 kernel: hub 2-0:1.0: over-current change on port 1
> Jun 30 10:38:02 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
> Jun 30 10:38:02 cb01 kernel: hub 2-0:1.0: over-current change on port 2
> Jun 30 10:38:02 cb01 kernel: hub 2-0:1.0: over-current change on port 1
> Jun 30 10:38:04 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
> Jun 30 10:38:04 cb01 kernel: hub 2-0:1.0: over-current change on port 2

This is typical of the errors on bus 2.  ehci-hcd receives
status-change interrupts because of the over-current-change flag.  The
hub driver tries to debounce port 1 (presumably because a device is
connected there) but gives up after two seconds.  Then the cycle
repeats.

> Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: over-current change on port 1
> Jun 30 10:38:34 cb01 kernel: ehci_hcd 0000:00:10.4: port 1 resume error -19
> Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: hub_port_status failed (err = -32)
> Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: connect-debounce failed, port 1 disabled
> Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: over-current change on port 2
> Jun 30 10:38:34 cb01 kernel: ehci_hcd 0000:00:10.4: port 2 resume error -19
> Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: hub_port_status failed (err = -32)
> Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: connect-debounce failed, port 2 disabled

This is typical of the problems on bus 1.  Again we see
over-current-change flags, and this time there's the "resume error
-19".  The only reason that code can appear is if a read returns
0xffffffff, i.e., ~(u32)0.  See handshake() in ehci-hcd.c, and see the
call to handshake in ehci-hub.c shortly before the line containing
"resume error".

It's like I said, your hardware really isn't working properly.

Alan Stern

