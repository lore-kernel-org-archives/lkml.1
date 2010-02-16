Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434Ab0BPW4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 17:56:43 -0500
Received: from gate.crashing.org ([63.228.1.57]:41883 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932736Ab0BPW4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 17:56:42 -0500
Subject: Re: [PATCH 18/28] powerpc,kgdb: Introduce low level trap catching
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>
In-Reply-To: <4B7AF321.8060008@windriver.com>
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
	 <1266014143-29444-19-git-send-email-jason.wessel@windriver.com>
	 <1266190167.16346.70.camel@pasglop>  <4B7AF321.8060008@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Feb 2010 09:56:17 +1100
Message-ID: <1266360977.16346.245.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-16 at 13:33 -0600, Jason Wessel wrote:

> I took a peek at xmon, and it suffers from the same problem where you
> can place a breakpoint in any part of rcu_lock, notify_die, or
> atomic_notifier_call_chain and meet with recursive faults.  I also
> checked that xmon appears to correctly return so as to continue if the
> exception was not intended for xmon.
> 
> The reason I had not just moved the code block previously is that I was
> not looking to break anything such as xmon, which is the the only other
> user of this function.
> 
> I'll add your ack, if you agree with the new version of the patch.

Almost, just stick a blank line here:

+               /* Debugger is first in line to stop recursive faults in
+                * rcu_lock, notify_die, or atomic_notifier_call_chain */
+               if (debugger_bpt(regs))
+                       return;
----> 
                /* trap exception */
                if (notify_die(DIE_BPT, "breakpoint", regs, 5, 5, SIGTRAP)
                                == NOTIFY_STOP)
                        return;

Please :-)

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cheers,
Ben.


