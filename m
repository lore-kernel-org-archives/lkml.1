Return-Path: <linux-kernel-owner+w=401wt.eu-S1030477AbXECIzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030477AbXECIzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030505AbXECIzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:55:12 -0400
Received: from eth8932.sa.adsl.internode.on.net ([150.101.246.227]:49309 "EHLO
	aix.gdt.id.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030477AbXECIzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:55:11 -0400
Subject: Re: Detecting process death for anycast named process monitoring
From: Glen Turner <gdt@gdt.id.au>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070503080142.GB12018@flint.arm.linux.org.uk>
References: <4638FCEA.4010806@gdt.id.au>
	 <20070503080142.GB12018@flint.arm.linux.org.uk>
Content-Type: text/plain
Organization: Glen Turner <http://www.aarnet.edu.au/~gdt/>
Date: Thu, 03 May 2007 18:25:06 +0930
Message-Id: <1178182506.4032.1.camel@thrace>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Russell,

Thanks for your answer.

> If you did have a process which polls for the service, what happens if
> that process dies?

The failure mode is good. The monitoring process dies, the
interface stays up, ospfd keeps advertising the route, named
keeps running. We pick up the lack of a monitoring process
in Nagios, manually down lo:1 so the traffic goes elsewhere
and investigate the fault. No customer impact unless
named dies for some independent reason before the NOC staff
down lo:1.

> ... Given that
> you're always going to have another process (which might be killed)
> your thought about having a parent process monitor the death of the
> child seems to be the simplest.

The failure mode for a parent monitoring process is not good.
The monitoring process dies, the interface stays up, ospfd
keeps advertising the route, the child named dies.  Since
we still have incoming DNS requests but no running DNS server,
customers will need to timeout and try the next DNS server
in their /etc/resolv.conf.  So customer impact is severely
reduced performance web performance until the NOC staff log
in and down lo:1.

As you can see, the basic requirement is for the lo:1 interface
to track the state of the named process at all times.

> What if the dbus system dies?  What if your monitoring process dies?

As long as these don't kill named whilst failing, we have enough
time to sort it out manually. Nagios (or whatever system health
monitor you shoose to configure) will hassle the Network Operations
Center in short order.

> Surely a simple solution is going to be the best solution?

That's why I'm posting here. I'd settle for some simple answer,
even if it is particular to Linux.

> You could also have that process interact with a watchog, so failures
> with that process cause a reboot.

No need. Dropping lo:1 makes the DNS traffic go to a healthier
server. Then the box can be left as-is so the sysadmins can take
it apart to find the basic cause of the fault.

Thanks for your thoughts. Some monitoring mechanism that didn't
kill named if it goes wrong would be fantastic.

Glen

