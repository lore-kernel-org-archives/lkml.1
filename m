Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbYHSCkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbYHSCkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 22:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYHSCkC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 22:40:02 -0400
Received: from gate.crashing.org ([63.228.1.57]:53124 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbYHSCkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 22:40:00 -0400
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Scott Wood <scottwood@freescale.com>, Eran Liberty <liberty@extricom.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <alpine.DEB.1.10.0808182208110.13401@gandalf.stny.rr.com>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com>
	 <48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal>
	 <48A9AFA7.8080508@freescale.com>
	 <alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com>
	 <1219110814.8062.2.camel@pasglop>
	 <alpine.DEB.1.10.0808182208110.13401@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 12:39:09 +1000
Message-Id: <1219113549.8062.13.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hmm, this was originally copied from x86, where we did a cmpxchg, but that 
> is probably not needed since all of this is done in kstop_machine. Also, 
> only the "get" is needed. If we don't fault there, we wont fault on the 
> put (unless we have permissions wrong, and that would be a bug).

Would it ? How do we make sure the kernel text is mapped writeable ?

> So are you recommending something like
> 
>         int cmd;
> 
> 	if (__get_user(cmd, ip))
> 		goto fault;
> 
> 	if (cmd != old)
> 		goto not_same;
> 
> 	WARN_ON_ONCE(__put_user(cmd, ip));
> 
> If we did this, we could probably put this into the generic code:

That would work I suppose, I'll give it a try.

> 	if (copy_from_user(cmd, ip, ARCH_CALL_SIZE))
> 		goto fault;
> 
> 	if (memcmp(cmd, old, ARCH_CALL_SIZE) != 0)
> 		goto not_same;
> 
> 	WARN_ON_ONCE(copy_to_user(cmd, ip, ARCH_CALL_SIZE));

You need the __ variants or the access_ok() checks will bite
you bad.

Ben.


