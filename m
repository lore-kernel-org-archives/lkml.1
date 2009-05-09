Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbZEIXel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbZEIXel (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 19:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbZEIXec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 19:34:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:39961 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbZEIXec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 19:34:32 -0400
Subject: Device core removal ordering brokenness
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 10 May 2009 09:29:21 +1000
Message-Id: <1241911761.19955.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan !

I was looking at git history regarding the various BUS_NOTIFY_*
notifiers (since David needs some stuff for his DMA debug code that
isn't provided by the current set) when I noticed that commit of yours:

ec0676ee28528dc8dda13a93ee4b1f215a0c2f9d

Unless I'm mistaken, which is very possible, this moves the
BUS_NOTIFY_DEL_DEVICE callback to -before- the driver remove() callback
is invoked. This sounds very illogical and potentially dangerous to me.

In fact, the original ordering and the only one that, to me, makes sense
in term of semantics is:

ADD / ->probe() / BOUND ... UNBIND / ->remove() / DEL

And not the current (since your patch):

ADD / ->probe() / BOUND ... DEL / UNBIND / ->remove()

IE. The DEL callback might tear down data structures used by the driver,
such as DMA mapping stuff etc...  (In fact, that's pretty much the whole
point of this callback). ADD/DEL should be invoked while no driver is
active on the device.

Now if I look at the reason for your change, I discover what look to me
like added brokenness in the core, but again, I may be missing something
obvious. IE. The addition and removal path don't look symetric to me,
and you moved the DEL callback because in the first place, the core
tears down various things (such as PM or sysfs related data structures)
before the driver is unbound from the device.

Whatever you guys think is the right approach for those sysfs and PM
structures, I do believe that moving around the DEL callback was a
mistake and I can see that becoming an issue on various platforms (if
not already).

Cheers,
Ben.




