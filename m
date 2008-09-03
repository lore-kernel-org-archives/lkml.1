Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbYICJVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYICJVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 05:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYICJVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 05:21:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40736
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751625AbYICJVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 05:21:45 -0400
Date: Wed, 03 Sep 2008 02:21:38 -0700 (PDT)
Message-Id: <20080903.022138.31681256.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, wli@holomorphy.com,
       sparclinux@vger.kernel.org, manfred@colorfullife.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] prevent sparc64 from invoking irq handlers on offline
 CPUs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080903004211.GD6748@linux.vnet.ibm.com>
References: <20080831173349.GA15393@linux.vnet.ibm.com>
	<20080902.171630.193505044.davem@davemloft.net>
	<20080903004211.GD6748@linux.vnet.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 2 Sep 2008 17:42:11 -0700

> On Tue, Sep 02, 2008 at 05:16:30PM -0700, David Miller wrote:
> > So I'd like to hold off on this patch until this locking issue is
> > resolved.
> 
> OK, it is your architecture.  But in the meantime, sparc64 can take
> interrupts on CPUs whose cpu_online_map bits have been cleared.

Paul, here is how I resolved this in my tree.

First, I applied a patch that killed that 'call_lock' and replaced
the accesses with ipi_call_lock() and ipi_call_unlock().

Then I sed'd up your patch so that it applies properly after that
change.

I still think there will be a problem here on sparc64.  I had the
online map clearing there happening first because the fixup_irqs()
thing doesn't drain interrupts.  It just makes sure that "device"
interrupts no longer point at the cpu.  So all new device interrupts
after fixup_irqs() will not go to the cpu.

Then we do the:

	local_irq_enable();
	mdelay(1);
	local_irq_disable();

thing to process any interrupts which were sent while we were
retargetting the device IRQs.

I also intended this to drain the cross-call interrupts too, that's
why I cleared the cpu_online_map() bit before fixup_irqs() and
the above "enable/disable" sequence runs.

With your change in there now, IPIs won't get drained and the system
might get stuck as a result.

I wonder if it would work if we cleared the cpu_online_map right
before the "enable/disable" sequence, but after fixup_irqs()?

Paul, what do you think?
