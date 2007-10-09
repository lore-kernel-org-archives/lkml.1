Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbXJIDRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbXJIDRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 23:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbXJIDQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 23:16:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55951
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751039AbXJIDQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 23:16:54 -0400
Date: Mon, 08 Oct 2007 20:16:53 -0700 (PDT)
Message-Id: <20071008.201653.43030513.davem@davemloft.net>
To: greg@kroah.com
Cc: david-b@pacbell.net, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: OHCI root_port_reset() deadly loop...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071009031049.GD14127@kroah.com>
References: <20071007.005156.85395415.davem@davemloft.net>
	<20071008.165420.42793456.davem@davemloft.net>
	<20071009031049.GD14127@kroah.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Mon, 8 Oct 2007 20:10:49 -0700

> Yes it does, I'm seeing reports from some hardware companies of the very
> same thing.  If you serialize and load the ehci driver first, and then
> the ohci driver, that should fix the problem.
> 
> Does that also work for you?  Or are these drivers built into the
> kernel?

As coicidence would have it I finally found a recipe for triggering
the issue, and it ties into what you're talking about here.

It happens only if I make sure OHCI gets loaded first and then EHCI
right afterwards.

It seems that indeed it is important for EHCI to get loaded first,
and in-kernel this is ensured by the link ordering.

However, when both OHCI and EHCI are built as modules (or, similarly
I guess, OHCI is built-in and EHCI is modular) there appears to be
nothing in userspace which makes sure EHCI gets loaded first.

When this triggers, in OHCI's root_port_reset(), the port status
register reads 0x111 in that inner-loop and the value never changes.
It stays like this forever.
