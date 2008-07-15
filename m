Return-Path: <linux-kernel-owner+w=401wt.eu-S1758322AbYGOBoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbYGOBoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 21:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbYGOBoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 21:44:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49499
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753206AbYGOBoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 21:44:19 -0400
Date: Mon, 14 Jul 2008 18:44:18 -0700 (PDT)
Message-Id: <20080714.184418.203308475.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: dwmw2@infradead.org, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, mchan@broadcom.com
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
 in-kernel, use it in more drivers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080714164119.99c33d5b.akpm@linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	<20080714164119.99c33d5b.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 14 Jul 2008 16:41:19 -0700

> On Mon, 14 Jul 2008 16:23:26 -0700
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > Linus, please pull from the for-2.6.27 branch of:
> > 	git://git.infradead.org/users/dwmw2/firmware-2.6.git for-2.6.27
> 
> The firmware flamewars seem to have subsided lately.  Is everyone happy
> with this now?

I'm not happy for network drivers, although I'm happy to see that
David respected out NACKs on tg3/bnx2/etc. and didn't include those
bits.

I still haven't seen an answer to the chip reset issues.  The argument
has been that this stuff is going to save kernel memory when the
driver isn't loading firmware, but that's not really possible.

When a lot of these network drivers reset, due to a transmit timeout
or other exception, we need to load the firmware again.

So this means, that if request_firmware() dies or fails for some
reason in these scenerios, we can't reset the network card.  Something
as simple as a memory or other allocation failure deep inside of
request_firmware() means we lose the networking interface.

To me this seems like a very non-resilient setup.  It makes sense
to just keep the firmware in-core so we can load it without having
to even think about possible failures.

And that to me basically makes this transformation pointless.  It's
in fact a regression.

Furthermore, the issue of suspend and resume was brought up.  What if
request_firmware() fails then?  And can request_firmware() even be
allowed in that context?  What if the disk on which the firmware
resides hasn't been resumed yet?

In response to the suspend/resume queries, a lot of special voodoo was
mentioned that perhaps would allow request_firmware() to get invoked
in the correct context and with the firmware partition's block device
resumed already.

But who the heck is going to write all of that code and fix up all
of these drivers so that they can resume reliably again?

And for what?

None of the people who wrote and maintain these effected networking
drivers want these changes installed.  And they are the ones who will
have to diagnose strange request_firmware() failures that lead to
non-functioning devices during resume or after a transmit timeout.
