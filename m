Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbXGOWIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbXGOWIP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 18:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbXGOWIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 18:08:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:55836 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbXGOWIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 18:08:02 -0400
Subject: Re: [PATCH] the wrong variable checked after request_irq()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070715220216.GF21668@ftp.linux.org.uk>
References: <E1IAAFp-00053g-Ti@ZenIV.linux.org.uk>
	 <1184535638.25235.15.camel@localhost.localdomain>
	 <20070715220216.GF21668@ftp.linux.org.uk>
Content-Type: text/plain
Date: Mon, 16 Jul 2007 08:07:49 +1000
Message-Id: <1184537269.25235.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-15 at 23:02 +0100, Al Viro wrote:
> On Mon, Jul 16, 2007 at 07:40:38AM +1000, Benjamin Herrenschmidt wrote:
> > On Sun, 2007-07-15 at 20:59 +0100, Al Viro wrote:
> > > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > 
> > Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > 
> > Out of curiosity, how did you pick it up ? You have some automated tool
> > to catch that (or sparse changes) or you just did -lots- of code
> > inspection ?
> 
> While testing sparse changes, actually (comparing pointers to null
> pointer constant spelled without a cast to void *)...  That gave several
> hundred hits, most of them being immediately obvious (picking the lines
> by file and line number and looking through the list had eliminated all
> but about a dozen or two).  Several were not...

Ok. In fact, it would have been nice if gcc had been able to pick it up
for another reason. The old code is:

	if (cascade == NULL)
		return;

	cascade_irq = irq_of_parse_and_map(cascade, 0);
	if (cascade == NO_IRQ) {
		printk(KERN_ERR "mpic: failed to map cascade interrupt");
		return;
	}

And NO_IRQ is 0 on powerpc nowadays. Thus the test can never be true :-)

But it looks like gcc doesn't pick that up.

Ben.


