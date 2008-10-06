Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbYJFJC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbYJFJC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 05:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYJFJCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 05:02:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbYJFJCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 05:02:49 -0400
Date: Mon, 6 Oct 2008 05:02:46 -0400
From: Alan Cox <alan@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 38/76] tty: usb-serial krefs
Message-ID: <20081006090246.GC29528@shell.devel.redhat.com>
References: <20081005160231.1997.10462.stgit@localhost.localdomain> <20081005161056.1997.12765.stgit@localhost.localdomain> <20081006053658.GA26817@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006053658.GA26817@kroah.com>
User-Agent: Mutt/1.4.2.2i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 10:36:58PM -0700, Greg KH wrote:
> Should we be calling kref_get() and kref_put() in interrupt context?
> Could we just get the reference in open and then put in close when we
> are done with it for each driver?

That depends how you handle hangups and interrupt synchronization. If you
can be sure you will get no more interrupts before you drop the reference
in close/hangup then yes that should be fine. In particular watch out for
the fact that hangup/close/re-open can run pretty much in parallel with
cases like

		close called by user
		interrupted by carrier drop causing hangup

		in parallel another open begins and blocks waiting a close

(Obviously for hotplug some further care is needed on the unplug paths)

Right now USB serial doesn't actually address all those cases anyway I suspect.
I wasn't going to attack that until I had a common tty_port and tty_port code
to do all that work rather than trying to fix each group of drivers.

Alan

