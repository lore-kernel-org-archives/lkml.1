Return-Path: <linux-kernel-owner+w=401wt.eu-S935683AbZDBJn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935683AbZDBJn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761024AbZDBJnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:43:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56719 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbZDBJnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:43:04 -0400
Subject: Re: Help: tasklet blocked for >8msec - USB mouse related
From: Peter Zijlstra <peterz@infradead.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@tglx.de>
In-Reply-To: <49D24A32.9070103@imap.cc>
References: <49CCFEBA.6060009@imap.cc>  <49D24A32.9070103@imap.cc>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 02 Apr 2009 11:43:59 +0200
Message-Id: <1238665439.8530.5740.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 18:52 +0200, Tilman Schmidt wrote:
> /me wrote:
> > A user of the Gigaset base driver (drivers/isdn/gigaset/bas-gigaset.c)
> > reports his connection being dropped exactly every 30 seconds.
> > Analysis of his dmesg indicates that when the error occurs, both the
> > tasklets read_iso_tasklet and write_iso_tasklet handling the B channel
> > data stream (125 USB isochronous packets per second in each direction)
> > are at the same time not executed for an entire inter-packet interval,
> > ie. 8 msecs.
> 
> The user did a bit of ellimination work, and it turned out that if
> he disconnected his Logitech Laser Mouse from its USB port and
> connected it to the PS2 port instead, the regular blockages ceased.
> 
> So we have a workaround, but no explanation.
> 
> This is on Debian Lenny with a 2.6.26 kernel. The user claims newer
> kernels don't boot on his machine. Btw, he also reports that the
> ISDN connection breaks each time he hotplugs any USB device, but
> so far has failed to produce a syslog excerpt for that. (sigh)
> The Motherboard is a Gigabyte GA-EP45T-EXTREME, advertised as
> "Designed for overclocking enthusiasts with overwhelming
> overclocking experience", which lets me fear the worst ...

Looks like the USB driver holds off interrupts for a long-long time. But
afaik that's not the only troublesome spot in mainline.

One way to test this would be using the threaded interrupt patches
Thomas posted, along with the USB driver conversion.

Another possible source might be SMIs -- and there's nothing much you
can do about those except bitch to Gigabyte.

But really, relying on <10ms execution latency on mainline is almost
asking for it -- in general we do better, but there are a few sore
spots.
