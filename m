Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbXJITXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbXJITXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 15:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbXJITXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 15:23:05 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:22238 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751381AbXJITXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 15:23:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=d2B9HIVI8U2CBuxoLAyX8KRZYrsDJNRj9rHqc0RDjQCsZBBhl78PENPxiqVL4zM1T/EdF5VOBTaWnKGEOM0zSYnypKIP5dbFS3e8byudRq6vBacDsLkSoIfb2BJcqIMiUXkYHCw42VooQz6VCAjuQ9pqd/XJxltOBDadOVc2td8=  ;
X-YMail-OSG: _WHwTOkVM1k8SlCFYy5P2sictFwPbbCgJpvnYUW5Nw.vmJloEbVVmpT6vVWw1tKL.seKgKJkew--
Date: Tue, 09 Oct 2007 12:22:50 -0700
From: David Brownell <david-b@pacbell.net>
To: stern@rowland.harvard.edu, linux-usb-devel@lists.sourceforge.net,
       greg@kroah.com, davem@davemloft.net
Subject: Re: [linux-usb-devel] OHCI root_port_reset() deadly loop...
Cc: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20071009033412.E37E323700C@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071008.204236.92016616.davem@davemloft.net>
 <20071009043909.GA4940@kroah.com>
 <20071008.214727.48799757.davem@davemloft.net>
 <20071009060640.GB15744@kroah.com>
In-Reply-To: <20071009060640.GB15744@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071009192250.BD703236A37@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH <greg@kroah.com>
>
> Here's some information from Intel about where they have seen this
> happen for UHCI controllers, so it's not just an OHCI issue :(
>
>	...
>
> 1) We see that the ports with low speed devices are still in EHCI mode
> (port owner bit not written to in EHCI driver). In our analyzer captures
> we see the reads from the Port Status & Control register and it is
> indicating that there are low speed devices on the ports. Can you tell
> us why the driver would not be doing the write to the port owner bit
> when it sees that low speed devices are attached to that port? Is there
> something specific that it looks for and decides not to do the write?

It's hard to say without more info about what's going on.  It
might be on a non-enumeraton code path -- where nothing expects
to set the OWNER bit -- or the CONNECT bit might not be set.
See host/ehci-hub.c for details about exactly what the EHCI parts
are doing, and core/hub.c for how it's driven.

(It can be tricky to make sense of all that, easier if debugging
messages are turned on.   But that changes timings.  Better yet
would be being non-intrusive tracing of the actual code paths
that the CPU follows.)


> 2) In other cases we see that the ports with the low speed devices are
> back in UHCI mode but the ports are disabled. In this case we see from
> the analyzer traces that the UHCI driver has completed setting up the
> port. It has actually enabled that port in UHCI mode. We then see the
> EHCI driver comes in and it resets everything. The driver then gives
> control back to the UCHI controller (by setting the port owner bit)
> but...since the UHCI driver has already setup this port once it seems
> that it does not go back and set it up again. In this case we do not
> think that the UHCI driver has completed running when the EHCI driver
> comes in and does the reset. Can you tell us if the UHCI driver was
> interrupted in the middle but after the ports with the low speed devices
> had been enabled would the UHCI driver ever go back and reinitialize the
> ports with the low speed devices?

If the UHCI driver got disconnect and reconnect notifications,
I expect it would do so.  At least OHCI seems *not* to have gotten
such notifications.  I'm speculating that the "just a switch"
behavior for the CF (and OWNER) bits may not allow notifications
like that to happen when the companion controllers are resetting.

- Dave

