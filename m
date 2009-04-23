Return-Path: <linux-kernel-owner+w=401wt.eu-S1759968AbZDWPRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968AbZDWPRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757999AbZDWPRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:17:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41056 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759592AbZDWPRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:17:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: e1000: "eeprom checksum is not valid" after kexec
Date: Thu, 23 Apr 2009 17:15:44 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: e1000-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>
References: <49F06EEB.9060500@gmail.com>
In-Reply-To: <49F06EEB.9060500@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904231715.44918.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 April 2009, Jiri Slaby wrote:
> Hi,

Hi,

> 4a865905f685eaefaedf6ade362323dc52aa703b
> (PCI PM: Make pci_set_power_state() handle devices with no PM support)
> breaks e1000 after being kexec'ed. These reverts fix the problem:
>     Revert "PCI PM: Make pci_set_power_state() handle devices with no PM
> support"
>     Revert "PCI PM: Introduce __pci_[start|complete]_power_transition()
> (rev. 2)"
> 
> I reverted the second one

I don't think it can be reverted.

> just for an easy revert of the former one, which is actually the culprit.

Can you just try to revert the changes in pci_raw_set_power_state() and check
if that has any effect (it shouldn't)?

> The symptoms:
> e1000 0000:02:01.0: enabling device (0000 -> 0003)
> e1000 0000:02:01.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
> e1000 0000:02:01.0: setting latency timer to 64
> e1000: 0000:02:01.0: e1000_probe: The EEPROM Checksum Is Not Valid
> Switched to high resolution mode on CPU 0
> /*********************/
> Current EEPROM Checksum : 0xffff
> Calculated              : 0xbaf9
> Offset    Values
> ========  ======
> 00000000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 00000010: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 00000020: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 00000030: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 00000040: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 00000050: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 00000060: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 00000070: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> Include this output when contacting your support provider.
> This is not a software error! Something bad happened to your hardware or
> EEPROM image. Ignoring this problem could result in further problems,
> possibly loss of data, corruption or system hangs!
> The MAC Address will be reset to 00:00:00:00:00:00, which is invalid
> and requires you to set the proper MAC address manually before continuing
> to enable this network device.
> Please inspect the EEPROM dump and report the issue to your hardware vendor
> or Intel Customer Support.
> /*********************/
> e1000: 0000:02:01.0: e1000_probe: Invalid MAC Address
> e1000: 0000:02:01.0: e1000_probe: (PCI-X:33MHz:64-bit) 00:00:00:00:00:00

So this is after kexec?

What happens if you remove just the

	/* Check if we're already there */
	if (dev->current_state == state)
		return 0;

part from pci_set_power_state()?

Rafael
