Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbXJZGEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbXJZGEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 02:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXJZGEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:04:14 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47450 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751801AbXJZGEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:04:13 -0400
Date: Thu, 25 Oct 2007 23:04:09 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, ak@suse.de, clameter@sgi.com,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] cpusets: add memory_spread_user option
Message-Id: <20071025230409.81f20ed3.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710251913350.30400@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251912300.30400@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251913130.30400@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251913350.30400@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm ... another doubt crosses my mind, something perhaps along the
lines of Christoph's earlier concerns of more interactions between
cpusets and mempolicy.

I'm figuring that when someone looks at the cpuset flag:

	memory_spread_user

they will expect that turning it on will cause user space memory to be
spread over the nodes of the cpuset.  Sure makes sense that it would
mean that.

But, for the most part, it doesn't.  Only tasks that have
previously called set_mempolicy(MPOL_INTERLEAVE), and only
after the 'mems' of the cpuset are subsequently changed,
will have their user memory forced to be spread across the
cpuset as a result of this flag setting.

That's weird.  We really should not surprise users like that.

This is a dangerous situation -- the obvious meaning of a flag
is not what it means.

Any chance, David, that you could have this flag mean:

  	Spread user memory allocations over the cpuset,
	period, anytime it is set, regardless of what
	mempolicy calls the task has made and regardless
	of whether or not or when the cpusets 'mems' were
	last changed.

In your previous reply, you wrote:
> This option gives the most power to applications.

Most power, or excessive confusion?  Straight forward consistency and
simple predictability are far more important in almost all cases.  The
usual exception is when you have a serious use case requiring
something that can only be done in a more obscure fashion.

There is always a price paid for supporting such complexities in an API
however, the price being increased confusion, frustration, errors and
bugs on the part of most users of the API.

... Now most likely you will claim you have such a use case, and when
I ask for it, I will be frustrated at the lack of compelling detail of
what is going on in user space - what sorts of users, apps and systems
involved.  Ok, no biggie.  If this goes down that path, then perhaps
at least I need to reconsider the name:

	memory_spread_user

This is -not- like the other memory spread flags.  It only spreads user
memory across the cpuset if previously, in order, (1) the task did
set_mempolicy(MPOL_INTERLEAVE), then (2) someone modified the cpusets
'mems'.  Perhaps the following ugly name better warns users of such
odd behaviour:

	memory_spread_mpol_interleave

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
