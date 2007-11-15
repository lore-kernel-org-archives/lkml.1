Return-Path: <linux-kernel-owner+w=401wt.eu-S1765341AbXKOQvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765341AbXKOQvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757174AbXKOQvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:51:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54350 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756842AbXKOQvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:51:02 -0500
Date: Thu, 15 Nov 2007 08:48:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org,
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
In-Reply-To: <20071115163201.GA24087@suse.de>
Message-ID: <alpine.LFD.0.9999.0711150846280.2786@woody.linux-foundation.org>
References: <20071115060353.071060513@mini.kroah.org> <20071115064037.GH18951@kroah.com> <alpine.LFD.0.9999.0711150810130.2786@woody.linux-foundation.org> <20071115163201.GA24087@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Nov 2007, Greg KH wrote:

> On Thu, Nov 15, 2007 at 08:11:30AM -0800, Linus Torvalds wrote:
> > > 
> > > patch 7fb7ac241162dc51ec0f7644d4a97b2855213c32 in mainline.
> > 
> > This one is getting reverted in mainline in about five minutes (unless I 
> > find an email from Stephen to address the reported regression - I haven't 
> > gone through all my emails yet), so I don't think it should make it into 
> > stable.
> 
> Thanks for letting me know which patch is causing the problem, I just
> got another report of the skge driver not working with all of these
> patches applied.

I suspect that's the same report.

> It looks like I'll just drop this one from the patch list, unless
> Stephen has a better idea.

This is my commit message for the revert - note the suggested possible 
fix (but also why I didn't apply it, and why things got reverted).

		Linus
---
commit 279e1dab949d33737557babfe9f74e0b74fbe39a
Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
Date:   Thu Nov 15 08:44:36 2007 -0800

    Revert "skge: fix ram buffer size calculation"
    
    This reverts commit 7fb7ac241162dc51ec0f7644d4a97b2855213c32.
    
    Heikki Orsila reports that it causes a regression:
    
      "Doing
    
    	nc host port < /dev/zero
    
       on a sending machine (not skge) to an skge machine that is receiving:
    
    	nc -l -p port >/dev/null
    
       with ~60 MiB/s speed, causes the interface go malfunct. A slow
       transfer doesn't cause a problem."
    
    See
    
    	http://bugzilla.kernel.org/show_bug.cgi?id=9321
    
    for some more information.
    
    There is a workaround (also reported by Heikki):
    
      "After some fiddling, I noticed that not changing the register write
       order on patch:
    
       +       skge_write32(hw, RB_ADDR(q, RB_END), end);
               skge_write32(hw, RB_ADDR(q, RB_WP), start);
               skge_write32(hw, RB_ADDR(q, RB_RP), start);
       -       skge_write32(hw, RB_ADDR(q, RB_END), end);
    
       fixes the visible effect..  Possibly not the root cause of the
       problem, but changing the order back fixes networking here."
    
    but that has yet to be ack'ed or tested more widely, so the whole
    problem-causing commit gets reverted until this is resolved properly.
    
    Bisected-and-requested-by: Heikki Orsila <shdl@zakalwe.fi>
    Cc: Stephen Hemminger <shemminger@linux-foundation.org>
    Cc: Jeff Garzik <jeff@garzik.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

 drivers/net/skge.c |   51 +++++++++++++++++++++++++++------------------------
 1 files changed, 27 insertions(+), 24 deletions(-)
