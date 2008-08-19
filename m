Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYHSCrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYHSCrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 22:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYHSCrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 22:47:11 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:51088 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582AbYHSCrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 22:47:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtIFAN3PqUhMRKxB/2dsb2JhbACBYrN2gVg
Date: Mon, 18 Aug 2008 22:47:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       Eran Liberty <liberty@extricom.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
Message-ID: <20080819024707.GA22659@Krystal>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com> <48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal> <48A9AFA7.8080508@freescale.com> <alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com> <1219110814.8062.2.camel@pasglop> <alpine.DEB.1.10.0808182208110.13401@gandalf.stny.rr.com> <1219113549.8062.13.camel@pasglop> <alpine.DEB.1.10.0808182240330.13401@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808182240330.13401@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:46:30 up 75 days,  7:26,  6 users,  load average: 0.40, 0.44,
	0.41
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Tue, 19 Aug 2008, Benjamin Herrenschmidt wrote:
> 
> > 
> > > Hmm, this was originally copied from x86, where we did a cmpxchg, but that 
> > > is probably not needed since all of this is done in kstop_machine. Also, 
> > > only the "get" is needed. If we don't fault there, we wont fault on the 
> > > put (unless we have permissions wrong, and that would be a bug).
> > 
> > Would it ? How do we make sure the kernel text is mapped writeable ?
> 
> We map it writeable if FTRACE is enabled.
> 

Argh. See text_poke(). It's there exactly for this purpose on x86.

Mathieu

> > 
> > > So are you recommending something like
> > > 
> > >         int cmd;
> > > 
> > > 	if (__get_user(cmd, ip))
> > > 		goto fault;
> > > 
> > > 	if (cmd != old)
> > > 		goto not_same;
> > > 
> > > 	WARN_ON_ONCE(__put_user(cmd, ip));
> > > 
> > > If we did this, we could probably put this into the generic code:
> > 
> > That would work I suppose, I'll give it a try.
> > 
> > > 	if (copy_from_user(cmd, ip, ARCH_CALL_SIZE))
> > > 		goto fault;
> > > 
> > > 	if (memcmp(cmd, old, ARCH_CALL_SIZE) != 0)
> > > 		goto not_same;
> > > 
> > > 	WARN_ON_ONCE(copy_to_user(cmd, ip, ARCH_CALL_SIZE));
> > 
> > You need the __ variants or the access_ok() checks will bite
> > you bad.
> 
> Ah, good point ;-)
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
