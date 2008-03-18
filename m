Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbYCRLVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbYCRLVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYCRLVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:21:25 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:42213 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbYCRLVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 07:21:24 -0400
Date: Tue, 18 Mar 2008 12:20:33 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MMC: Card detection through pin CD/DAT3 issue
Message-ID: <20080318122033.020b45b5@mjolnir.drzeus.cx>
In-Reply-To: <83116F0A4FF67A4F97BA0B6E408C48E301DAB4AA@zuerich.BC-Int.NET>
References: <83116F0A4FF67A4F97BA0B6E408C48E301DAB4AA@zuerich.BC-Int.NET>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008 11:59:25 +0100
"Wappler Marcel" <Marcel.Wappler@bridgeco.net> wrote:

> Hi Pierre, hi MMC developers,
> 
> I am at porting the generic PCI controller driver mmc/host/sdhci.c to a special non PCI direct memory mapped host. The hardware
> vendor decided to implement the card detection not through the mechanical card present switch but through detecting the card
> internal pull up at pin 1 (CD/DAT3).
> 

The SDHCI spec doesn't specify how to detect the card, so this is a valid behaviour. That said, it's a very stupid way to detect cards as it is very unreliable. There's a reason extremely few use this technique.

> With this detection scheme I have some dificulties togehter with the internal working of the current MMC stack:
> 
> The controller cannot detect a newly inserted card if the card power is switched of. This is due to the fact that the SD card
> applies the internal card detection pull up after it powered up. If there is no power -> no powering up -> no pull up. (besides the
> fact that a pull up needs power to for doing its work :-) )
> 

Then you have broken hardware. The specs clearly state that the controller must be able to detect cards without powering up the cards. Also, the cards must implement the pull-up in a way that behaves like a resistor. So there should be no requirement for full power there either.

> My questions are:
> 
> 1. knows anyone a host controller which uses the same card detection mechanism?
> 

Yes, some wbsd controllers at least.

> 2. How could the driver manage the problem that the MMC stack switches off the card power if removed and therefor no state change on
> line CD/DAT3 occurs at re-insertion of that card?
> 

Provided your hardware is in fact so broken that it cannot be properly handled, you could add a quirk that forces the sdhci driver to keep power on constantly.

> 3. In a short look through some MMC card specs I did not find any description of some card detection mechanism. So I suppose the
> mechanical switch is the only possible solution to detect a newly inserted card. Am I right or is there nevertheless a chance to
> detect a inserted MMC together with this host?
> 

I have a faint memory of a pull-up being added to the MMC 4 spec (the ones with lots of pads). Still, it's a crappy detection mechanism as it doesn't play well with data transfers, and the pull-up can usually be disabled in the cards.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
