Return-Path: <linux-kernel-owner+w=401wt.eu-S933391AbYEUTMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391AbYEUTMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbYEUTMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:12:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:52889 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbYEUTMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:12:15 -0400
In-Reply-To: <Pine.LNX.4.64.0805201650280.5283@axis700.grange>
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>  <20080516193613.28030.13950.stgit@trillian.secretlab.ca>  <Pine.LNX.4.64.0805191446530.27140@axis700.grange>  <fa686aa40805190857u317d3304ie75d11870e109fc5@mail.gmail.com>  <Pine.LNX.4.64.0805191811510.29559@axis700.grange> <fa686aa40805192213y485c4ba2u750748f8201e0377@mail.gmail.com> <Pine.LNX.4.64.0805201650280.5283@axis700.grange>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <716a0f1b6c9a544b480c06a329072483@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net, linuxppc-dev@ozlabs.org,
       fabrizio.garetto@gmail.com, Grant Likely <grant.likely@secretlab.ca>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
Date: Wed, 21 May 2008 21:11:42 +0200
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, elegance apart:-) You can use the SPI-bridge construct to also
> describe simple SPI-chipselect configurations. But is it really a good
> idea? Wouldn't it be better to handle these two cases separately?

It would be best to handle all these things that are specific to
a certain SPI controller (like how CSs work) in the binding for
that SPI controller, and not try to shoehorn all of this into some
artificial generic framework.

If you can have identical addresses on the SPI bus going to different
devices based on which CS is asserted, you'll have to make the CS part
of the "reg".  Example:

spi-controller {
	#address-cells = 2;
	#size-cells = 0;
	some-device@0,f000 { reg = < 0 f000 >; } // CS 0, SPI address f000
	some-device@1,f000 { reg = < 1 f000 >; } // CS 1, SPI address f000
	some-device@1,ff00 { reg = < 1 ff00 >; } // CS 1, SPI address ff00
}

SPI-to-SPI bridges can (and should!) be handled the same way as
anything-to-anything-else bridges are handled as well: either there
is a nice simple one-to-one matching (and you can use "ranges") or
you need a driver for that bridge that knows how to make it work (or
both, "ranges" isn't always enough, the bridge might require some
specific handling for some special situations -- error handling,
suspend, whatever).


Segher

