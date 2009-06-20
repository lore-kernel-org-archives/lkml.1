Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbZFTXm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbZFTXm7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 19:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbZFTXmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 19:42:52 -0400
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:34315
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751604AbZFTXmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 19:42:51 -0400
Date: Sat, 20 Jun 2009 19:42:50 -0400
From: Sean MacLennan <smaclennan@pikatech.com>
To: Frans Pop <elendil@planet.nl>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: Badness on the Warp
Message-ID: <20090620194250.5a3e826f@lappy.seanm.ca>
In-Reply-To: <200906202256.46073.elendil@planet.nl>
References: <20090620154824.72b5cd50@lappy.seanm.ca>
	<200906202256.46073.elendil@planet.nl>
Organization: PIKA
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.12.12; i686-pc-linux-gnu)
X-Message-Flag: Warning: This message may contain actual content.
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAHlBMVEXOy8P+/f8hHBFoOhetjm76/P5qPzJLJxltXUSaX0wbgtjEAAACY0lEQVQ4jWWUQWvcMBCF91BCjiuIIWcX6nsE9uZWgknjWwW7sD2rjL1XGzzpNS2ufI5xVv+2byTHSehcbO8nzWjeG+1GqcPhZfTlEl8/hUdVbgDUvfNT+SEqH8Ho/UdQCjDJg0dMceVUhVcBKhn8Go7qTjd4CYCcBL7OQ9GmGXfNuICauaNmIKrbNGWivAngQPhMOScibODGOZ2PYUfdMlCnyTJWpFlu9SkW14Ps6cdZHoJ4F4ENPzxOD3i2cZMA9VCHdV/KCmdC3i7WMAKyNuNfZVUwzoA2pmqjDkZd1ikjfpblTDj32PhSwEH9GHTBrQDvpaXT9Aqc1cz9HwHedg20qkLxK2cLNIh1q8p+Ae53TsMJ36shAewdDPHz+B/YDqOffEhTvXMQYIbp0SppIdQKIIG31XwK4Pk2OrYAuGQX0JHUowDUPY1O77xkeob6CLsxYQfZvMhxNJhYsNY56bjjktA6Pgl6WIiLiOC6g1hQltMMIJBY/FrEhcRisIWcrG3csa8DEOt6pGs5HwIw2zrkCW6TCN0sQP2tuwjSmouWb10EiXrJcUwhqAzfx2aWaYe5F48k9qbBYplKFybRmGPvbuJIyUTKTAagkquabrJWcnV0OqONqFWSfH/qi52cDOvHs10bVOobgEb73NPoh1WSJDky72whkmDcVmCkCMuJU9Yn/y6VMWaGriTTiesmUxZTIS4yOIR5qPzZSbMr2LefcaB4P/V7kNxlvcY9xJnEQ70Cc2w7aCFXtBCnVqC2uCEiU2hz6TxuuUsz0TDy/C1Vcgwayh8AwFvxg9k/LTcWUfA/se5dIXIv87sAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found the source of the badness. The backtrace is correct:

uic_init_one
___alloc_bootmem
___alloc_bootmem_nopanic
alloc_arch_preferred_bootmem

In alloc_arch_preferred_bootmem we have:

	if (WARN_ON_ONCE(slab_is_available()))
		return kzalloc(size, GFP_NOWAIT);

Since the slab is available (it had better be or the call will return
NULL), we get the badness message, then a successful return from
kzalloc.

I believe the author wants something like:

	if (slab_is_available())
		return kzalloc(size, GFP_NOWAIT);
	else
		WARN_ON_ONCE(1);

Cheers,
   Sean
