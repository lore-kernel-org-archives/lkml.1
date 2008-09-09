Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbYIIPbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbYIIPbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbYIIPaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:30:55 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:39597 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbYIIPay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:30:54 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [bisected][resend] pnp: Huge number of "io resource overlap" messages
Date: Tue, 9 Sep 2008 09:30:26 -0600
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Rene Herman <rene.herman@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <200809091250.08620.elendil@planet.nl>
In-Reply-To: <200809091250.08620.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809090930.27583.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 04:50:06 am Frans Pop wrote:
> The only thing I used to get for pnp 00:08 on my Toshiba Satellite A40
> up to 2.6.26 was this single line:
> pnp 00:08: can't add resource for IO 0xa8-0xa9

2.6.26 supported up to 40 I/O resources for PNP devices.  If a
device had more than 40, we complained once and silently ignored
all the rest.

> During bisecting I have found that fairly early in the 2.6.27 cycle this
> was "fixed" and that message disappeared. The commit that changed this was:
> commit aee3ad815dd291a7193ab01da0f1a30c84d00061
> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Date:   Fri Jun 27 16:56:57 2008 -0600
>     PNP: replace pnp_resource_table with dynamically allocated resources
> 
> Was it expected that that change could lead to a message disappearing?
> I don't really read that from the commit description.

Yep.  This commit removed the fixed limit (40), so we shouldn't see
messages like that any more.  The commit log mentioned these:

        pnpacpi: exceeded the max number of IO resources
        00:01: too many I/O port resources

but I should have mentioned "can't add resource for IO ...", too.

> So far for the intro, now the issue (regression?) that prompted this mail.
> 
> Now with 2.6.27-rc4/5 I'm suddenly getting a total of 78 (!) warnings
> about "io resource overlaps" for pnp 00:08 in my dmesg, even though
> AFAIK those have never caused any trouble.

78 messages is certainly intolerable.  If the PNP quirk ignored
PNP resources that had already been disabled, I think we'd generate
"only" 27 messages.

> Bisection identified this commit as the cause:
> commit 999ed65ad12e374d7445fbc13f5a1d146ae4b0da
> Author: Rene Herman <rene.herman@gmail.com>
> Date:   Fri Jul 25 19:44:47 2008 -0700
>     pnp: have quirk_system_pci_resources() include io resources
> 
> The PCI devices mentioned in the messages (1f.5 and 1f.6) are the ICH4
> AC'97 audio controller and AC'97 (software) modem. At least sound works
> fine _without_ this change; I don't really use the softmodem.
> I'm not completely sure what pnp 00:08 is. Seems to have the "system"
> driver.

pnp 00:08 is a "motherboard" device the describes a lot of the
legacy hardware (DMA controllers, timers, keyboard, etc) on the
system board.  The "system" driver reserves those resources to
prevent us from placing anything else on top of them.

What's curious about this to me is that those BARs just look wrong:

  0000:00:1f.5 BAR 0 (0x0-0xff)
  0000:00:1f.5 BAR 1 (0x0-0x3f)
  0000:00:1f.6 BAR 0 (0x0-0xff)
  0000:00:1f.6 BAR 1 (0x0-0x7f)

Those seem like they'd be right on top of all those motherboard devices
(and each other).

I have some similar devices, with I/O BARs of the same sizes as
yours, but they have reasonable values and /proc/iomem and
/proc/ioports show sensible things:

  00:1e.2 Multimedia audio controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Audio Controller (rev 03)
        Region 0: I/O ports at 3100 [size=256]
        Region 1: I/O ports at 3200 [size=64]
        Region 2: Memory at c8c01000 (32-bit, non-prefetchable) [size=512]
        Region 3: Memory at c8c02000 (32-bit, non-prefetchable) [size=256]

  00:1e.3 Modem: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Modem Controller (rev 03) (prog-if 00 [Generic])
        Region 0: I/O ports at 3400 [size=256]
        Region 1: I/O ports at 3500 [size=128]

  $ cat /proc/ioports 
  ...
  3100-31ff : 0000:00:1e.2
    3100-31ff : Intel ICH6
  3200-323f : 0000:00:1e.2
    3200-323f : Intel ICH6
  3400-34ff : 0000:00:1e.3
  3500-357f : 0000:00:1e.3

  $ cat /proc/iomem
  ...
  c8c01000-c8c011ff : 0000:00:1e.2
    c8c01000-c8c011ff : Intel ICH6
  c8c02000-c8c020ff : 0000:00:1e.2
    c8c02000-c8c020ff : Intel ICH6

What do "lspci -vv" and /proc/ioports and /proc/iomem show for you?

Bjorn
