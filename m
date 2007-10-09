Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbXJIEJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbXJIEJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 00:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbXJIEJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 00:09:13 -0400
Received: from smtp105.sbc.mail.re2.yahoo.com ([68.142.229.100]:40405 "HELO
	smtp105.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750717AbXJIEJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 00:09:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=lBeONXk+75+hW0Z4aiNGefFzg6xM/dcJzalwzfs1sSSTZeTg62w+oB52T/70QgCNmOFOPvf1NVA/0G4xM/ODYLAvnPR2c2ioePp6Y/Oa7gRXeQIPTZhvQvpd7N1Dj61JnDXcBhJEafByXko7cNlx4Nh8DdX3Q682WRe0yx2Q5XU=  ;
X-YMail-OSG: bpExaTkVM1kOqb3Kgoq2j7FZst3Pe8RZrsBYjJVmJDkZxZDfcWmPAiGDGv35z3UATe6TXXkAQQ--
Date: Mon, 08 Oct 2007 21:09:17 -0700
From: David Brownell <david-b@pacbell.net>
To: davem@davemloft.net
Subject: Re: OHCI root_port_reset() deadly loop...
Cc: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       greg@kroah.com
References: <20071006.235358.104048815.davem@davemloft.net>
 <20071007073141.A88DD2393E2@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071007.005156.85395415.davem@davemloft.net>
 <20071008.165420.42793456.davem@davemloft.net>
In-Reply-To: <20071008.165420.42793456.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071009040917.DC7FC237446@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> To add some more information here, I think the EHCI idea might
> hold some water.
>
> What I have here are two NEC OHCI USB interfaces and one NEC EHCI
> USB interface on PCI.  Aparently they all go through a shared
> USB hub, mapped like this:
>
> HUB Port 1: OHCI #1, EHCI
> HUB Port 2: OHCI #2, EHCI
> HUB Port 3: OHCI #1, EHCI
> HUB Port 4: OHCI #2, EHCI
> HUB Port 5: OHCI #1, EHCI
>
> The OHCI ports go out to external USB connectors on the back panel of
> the machine, whereas the EHCI is connected up to an internal USB
> storage CDROM device and what appears to be another USB hub.

There's actually no such thing as an "EHCI port" or an "OHCI port".
Instead, there's a set of ports, each of which can be switched so
the USB differential data signals go up to either controller.

When EHCI starts, that switch points to EHCI so that devices can try
enumerating with high speed signaling.  When a device doesn't respond
to that "chirp", the EHCI root hub driver switches the port to the
companion controller.  (Which is OHCI here, UHCI on some PCs, etc.)


> The problem seems to be very strongly tied to timing.  For example
> simply adding "ignore_loglevel" to the kernel boot command line can
> make the problem go away.
>
> This got me thinking about your EHCI comment.
>
> If these controllers are going through the same HUB, things might go
> south if OHCI initialized first, then khubd et al. are asynchronously
> accessing the segments behind OHCI at the same time that the EHCI
> driver is initializing.  Perhaps, this is the kind of sequence of
> events which makes one of the root ports reset in such a way that the
> the reset bit never clears.
>
> Given that this machine has 64 cpus, the likelyhood for such parallel
> accesses is very likely :-)
>
> Does this make any sense?

Yes, that's why I asked about EHCI.  My speculation would be that
OHCI starts the reset, and EHCI claims the port before it completes;
or contrariwise OHCI starts the reset right after EHCI claims it.

And there's some point in that process where a hardware race makes
the trouble you've observed.  I believe there are plenty of other
places where it's perfectly fine if EHCI grabs the port, or this
little race would have shown up many times before.

- Dave


