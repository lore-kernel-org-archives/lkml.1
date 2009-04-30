Return-Path: <linux-kernel-owner+w=401wt.eu-S1763782AbZD3Pd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763782AbZD3Pd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763220AbZD3Pdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:33:35 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:27090 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763271AbZD3Pde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:33:34 -0400
MIME-Version: 1.0
In-Reply-To: <fa686aa40904300811u41e94972offfd75520636bb02@mail.gmail.com>
References: <f73f7ab80904171732n41832d0hc62978e57bbcc32e@mail.gmail.com>
	 <625fc13d0904200529l152b8d75g33c3f940de1b2920@mail.gmail.com>
	 <f73f7ab80904201710m57472291yf7ff86760977b8e8@mail.gmail.com>
	 <1240388476.17445.10.camel@pasglop>
	 <f73f7ab80904300804j1f847b70ha0fe3cda07249110@mail.gmail.com>
	 <fa686aa40904300811u41e94972offfd75520636bb02@mail.gmail.com>
Date: Thu, 30 Apr 2009 11:33:31 -0400
Message-ID: <f73f7ab80904300833w69025c2fjdefbe9f2eef323f1@mail.gmail.com>
Subject: Re: Porting the ibm_newemac driver to use phylib (and other PHY/MAC 
	questions)
From: Kyle Moffett <kyle@moffetthome.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       netdev <netdev@vger.kernel.org>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 11:11 AM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> Just a heads up Kyle; there are changes queued in the netdev tree
> which add OF helpers for MDIO bus drivers and MAC drivers.  See here:
>
> http://git.kernel.org/?p=linux/kernel/git/davem/net-next-2.6.git;a=commit;h=8bc487d150b939e69830c39322df4ee486efe381
>
> and here is an example of a driver change:
>
> http://git.kernel.org/?p=linux/kernel/git/davem/net-next-2.6.git;a=commit;h=1dd2d06c0459a2f1bffc56765e3cc57427818867

Hmm, very interesting!  Thanks!  Although I'm not sure that those OF
helpers are entirely usable for the emac driver at the moment, as the
device trees for the existing boards simply don't have PHYs present in
them.  Most of the ibm_newemac board device-trees just have one of:
"phy-address = <4>", "phy-mask = <0xffff0000>", or nothing at all (for
autodetection).  I will probably need to leave in support for the old
PHY mask parsing to preserve backwards compatibility.

My main concern at the moment is cleaning up the driver's general PHY
handling.  I got started on this whole mess when I was trying to write
some hackish PHY drivers for a weird custom board I've got here.  I
couldn't figure out why the hell all my PHY register changes in the
phy_ops->init function kept getting cleared, until I noticed 2 things:
 The emac_reset_phy() function gets called occasionally and does not
call the ->init() function again afterwards.  The
genmii_setup_forced() function (in the EMAC driver) unconditionally
ORs the BCMR_RESET flag into the MII_BCMR register.  Both of those
meant that any early setup I did for my PHY was getting completely
cleared on a regular basis, with no decent way for me to patch it back
up again.

Cheers,
Kyle Moffett
