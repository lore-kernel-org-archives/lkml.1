Return-Path: <linux-kernel-owner+w=401wt.eu-S934435AbXKPVD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934435AbXKPVD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbXKPVDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:03:21 -0500
Received: from zakalwe.fi ([80.83.5.154]:46191 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757575AbXKPVDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:03:20 -0500
Date: Fri, 16 Nov 2007 23:03:19 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 08/16] skge: fix ram buffer size calculation
Message-ID: <20071116210318.GA7681@zakalwe.fi>
References: <20071115060353.071060513@mini.kroah.org> <20071115064037.GH18951@kroah.com> <alpine.LFD.0.9999.0711150810130.2786@woody.linux-foundation.org> <20071115163201.GA24087@suse.de> <alpine.LFD.0.9999.0711150846280.2786@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711150846280.2786@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 08:48:58AM -0800, Linus Torvalds wrote:
> This is my commit message for the revert - note the suggested possible 
> fix (but also why I didn't apply it, and why things got reverted).
> 
> 		Linus
> ---
> commit 279e1dab949d33737557babfe9f74e0b74fbe39a
> Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
> Date:   Thu Nov 15 08:44:36 2007 -0800
> 
>     Revert "skge: fix ram buffer size calculation"
>     
>     This reverts commit 7fb7ac241162dc51ec0f7644d4a97b2855213c32.
>     
>     Heikki Orsila reports that it causes a regression:
>     
>       "Doing
>     
>     	nc host port < /dev/zero
>     
>        on a sending machine (not skge) to an skge machine that is receiving:
>     
>     	nc -l -p port >/dev/null
>     
>        with ~60 MiB/s speed, causes the interface go malfunct. A slow
>        transfer doesn't cause a problem."
>     
>     See
>     
>     	http://bugzilla.kernel.org/show_bug.cgi?id=9321
>     
>     for some more information.
>     
>     There is a workaround (also reported by Heikki):
>     
>       "After some fiddling, I noticed that not changing the register write
>        order on patch:
>     
>        +       skge_write32(hw, RB_ADDR(q, RB_END), end);
>                skge_write32(hw, RB_ADDR(q, RB_WP), start);
>                skge_write32(hw, RB_ADDR(q, RB_RP), start);
>        -       skge_write32(hw, RB_ADDR(q, RB_END), end);
>     
>        fixes the visible effect..  Possibly not the root cause of the
>        problem, but changing the order back fixes networking here."
>     
>     but that has yet to be ack'ed or tested more widely, so the whole
>     problem-causing commit gets reverted until this is resolved properly.
>     
>     Bisected-and-requested-by: Heikki Orsila <shdl@zakalwe.fi>
>     Cc: Stephen Hemminger <shemminger@linux-foundation.org>
>     Cc: Jeff Garzik <jeff@garzik.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
>  drivers/net/skge.c |   51 +++++++++++++++++++++++++++------------------------
>  1 files changed, 27 insertions(+), 24 deletions(-)

Thanks. I pulled

commit 8c0863403f109a43d7000b4646da4818220d501f

and now the skge driver works here.

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
