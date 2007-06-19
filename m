Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbXFSVtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbXFSVtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 17:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbXFSVtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 17:49:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44376 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752744AbXFSVs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 17:48:59 -0400
Date: Tue, 19 Jun 2007 14:48:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: And now for something _totally_ different: Linux v2.6.22-rc5
In-Reply-To: <200706192337.49505.m.kozlowski@tuxland.pl>
Message-ID: <alpine.LFD.0.98.0706191443460.3593@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org>
 <200706192337.49505.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Jun 2007, Mariusz Kozlowski wrote:
> 
> 	MAINTAINERS says riscom8 is orphaned so not sure
> if anybody cares. Spotted this when playing with modprobe
> walking /lib/modules/`uname -r`/kernel in a loop ;)

Oh wow.

I wonder why it does that. The code literally does:

        save_flags(flags);
        cli();
        tty_unregister_driver(riscom_driver);
        put_tty_driver(riscom_driver);
        restore_flags(flags);

and I don't see the point.

(And that's what then causes the warning: tty_unregister_driver will 
eventually get a mutex, but the caller had disabled hardware interrupts..

I see absolutely *zero* reason for that whole save_flags/cli/restore_flags 
dance at all, so I think the right thing to do is to just remove it.

I'm Cc'ing Alan, in case he cares. 

Mariusz, if you actually *use* the dang thing, and really care, you can 
send me a tested patch. I can pretty much guarantee that removing those 
irq games won't make things any worse, but no way am I going to just 
remove it on my own without any users or any testing.

		Linus
