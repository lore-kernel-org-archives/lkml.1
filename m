Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbZHMSmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbZHMSmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 14:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136AbZHMSmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 14:42:17 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:53859 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbZHMSmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 14:42:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAM/7g0qrR7MV/2dsb2JhbAC7XIgrkRMFhBk
X-IronPort-AV: E=Sophos;i="4.43,375,1246838400"; 
   d="scan'208";a="366859266"
Date: Thu, 13 Aug 2009 11:42:18 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] Combine two one-character CR-LF writes into one
	two-character write for O_ONLCR
Message-ID: <20090813184218.GA12832@cuplxvomd02.corp.sa.net>
References: <20090813175430.GA8769@cuplxvomd02.corp.sa.net> <20090813181521.GB28172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813181521.GB28172@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-1; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 11:15:21AM -0700, Greg KH wrote:
> On Thu, Aug 13, 2009 at 10:54:30AM -0700, David VomLehn wrote:
> > When handling output of a newline character in O_ONLCR mode, the n_tty.c
> > do_output_char() function uses the struct tty_operations function write_room()
> > to determine whether it is possible to write two characters. It uses
> > tty_put_char() for each character which, for the USB generic serial driver,
> > translates into a write() for each character. For the USB generic serial
> > driver the value returned by write_room() only applies to the next write().
> > A second write() done in quick succession will fail because the write URB
> > buffer is still busy from the first write(). In this case, it results in the
> > printing of a carriage return without the following line feed.
> 
> How about fixing the usb-serial generic driver to properly handle stuff
> like this instead?  It should be using a fifo and not the stupid method
> it currently is.

Good question. Right now, there are a number of USB serial devices that don't
use the generic USB serial framework, but they generally seem to use the
write_urb_busy flag the same way the generic code does. This makes it easier
to mix and match generic and non-generic code. Going to a FIFO approach and
doing away with the write_urb_busy flag seemed like a lot of change for very
little benefit. In addition, I would argue that doing one two-character write()
of two one-character writes() is a more logical way to output two characters,
anyway.

I have another motivation for maintaining the write_urb_busy flag as part of
the standard USB generic serial environment: I'm finishing up an RFC patchset
that provides for a polled USB console. This way you won't need any of the
buffering some of the USB serial drivers use, for which overruns can still
occur and, which may very well not have written the output by the time they
return. In other words USB consoles will have the same synchronous output
behavior as dumb UART consoles.  I have it working with EHCI and am looking
at OHCI.

> Anyway, what device are you using that uses the usb-serial generic
> driver that you are seeing this problem with?

I'm using a cp210x work-alike.

> greg k-h

David VL
