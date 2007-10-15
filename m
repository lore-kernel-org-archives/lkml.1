Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbXJOX6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbXJOX6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbXJOX6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:58:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49399
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbXJOX6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:58:24 -0400
Date: Mon, 15 Oct 2007 16:58:28 -0700 (PDT)
Message-Id: <20071015.165828.59656315.davem@davemloft.net>
To: david-b@pacbell.net
Cc: stern@rowland.harvard.edu, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [Linux-usb-users] OHCI root_port_reset() deadly loop...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071015233910.5A17123BC99@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20071009.213507.78708496.davem@davemloft.net>
	<20071015.150124.78710191.davem@davemloft.net>
	<20071015233910.5A17123BC99@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>
Date: Mon, 15 Oct 2007 16:39:10 -0700

> > Bad news, even with the rwsem after a lot more testing I can still
> > trigger the hang in ohci_hub_control() :-(
> >
> > I think we need to go back to considering the total serialization
> > approach to this problem.
> 
> We shouldn't need that.  What happens if you add an msleep(5)
> before ehci-hcd::ehci_run() drops ehci_cf_port_reset_rwsem?

What happens is the heisenbug will go away for another week.

> The theory there being that the switch triggered by setting CF
> doesn't take effect instantaneously, contrary to the effective
> assumption of that code.  A delay of 5 msec seems like it should
> be more than enough, but that's kind of a guess ... it's good to
> keep that low, since unfortunately that's in the critical path
> for OLPC "resume from idle".

I want to help with this, but if I even breath on the kernel the bug
goes away.  The race just gets harder to trigger, and if we just keep
adding things it'll make the problem go away but for the absolutely
wrong reasons.

The only way we will provably fix this is to make sure EHCI initialize
fully, first, regardless of kernel config or what userland does.

Also, David, you haven't done anything with the feedback I gave to the
most recent revision of the OHCI hub reset anti-wedge patch.  You
removed the debug logging when the outer-loop timeout expires, and I
asked that you put that back so that if it happens there is some
chance to know that this is what happened.  If it's not supposed to
happen, there is no harm in putting the debugging log message there
so that if the impossible does happen we find out about it.

I really don't think it's appropriate for that bug fix to sit yet
another week.
