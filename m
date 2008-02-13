Return-Path: <linux-kernel-owner+w=401wt.eu-S1761963AbYBMUaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761963AbYBMUaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 15:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbYBMUaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 15:30:03 -0500
Received: from relay2.sgi.com ([192.48.171.30]:39755 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753054AbYBMUaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 15:30:01 -0500
Date: Wed, 13 Feb 2008 14:29:56 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
Message-Id: <20080213142956.5ba52101.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802131050240.9186@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
	<1202862136.4974.41.camel@localhost>
	<20080212215242.0342fa25.pj@sgi.com>
	<alpine.DEB.1.00.0802121955040.11889@chino.kir.corp.google.com>
	<20080212221354.a33799f2.pj@sgi.com>
	<alpine.DEB.1.00.0802122018550.11889@chino.kir.corp.google.com>
	<20080213020344.45c9d924.pj@sgi.com>
	<alpine.DEB.1.00.0802130113020.3936@chino.kir.corp.google.com>
	<20080213110426.15179378.pj@sgi.com>
	<alpine.DEB.1.00.0802131050240.9186@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> You're specifically trying to avoid having the application know about its 
> cpuset placement with regard to mems at the time it sets up its mempolicy, 
> right?  Otherwise it could already setup this relative nodemask by 
> selecting node 2, from your example above, in its mems_allowed and it 
> would always be remapped appropriately.

Yes, if an application considers nodes to be interchangeable, I'm
trying to avoid having that application -have- to know its current
cpuset placement, for two reasons:

    For one thing, it's racey.  It's cpuset placement could change,
    unbeknownst to it, between the time it queried it, and the time
    that it issued the mbind or set_mempolicy call.

    For the other thing, it's not always possible.  If the application
    is currently in a cpuset that is smaller than it's preferred
    configuration, it would not be possible to express its preferred
    memory policies using just the smaller number of memory nodes
    allowed by its current cpuset placement.  How do you say "put
    this on my third node" if you don't have a third node and you
    can only speak of the nodes you currently have?


> So, for example, if the task is bound by mems 1-3, and it asks for 
> MPOL_INTERLEAVE over 2-4, then initially the mempolicy is only effected 
> over node 3 and if it's later expanded to mems 1-8, then the mempolicy is 
> effected over nodes 3-5, right?
> 
> And if the mems change to 3-8, the mempolicy is remapped to 5-7 even 
> though 3-5 (which it already was interleaving over) is still accessible?

Yes and yes, for this cpuset relative numbering mode.

> Does MPOL_INTERLEAVE | MPOL_F_STATIC_NODES | MPOL_F_PAULS_NEW_FLAG make 
> any logical sense?  If it does, I think we're going to be writing some 
> very complex remap code in our future.


No -- MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES (which is what I'll
likely call my new flag) are mutually exclusive.

The allowed modes and flags would be:
  Choose exactly one of:
	MPOL_DEFAULT, MPOL_PREFERRED, MPOL_BIND, MPOL_INTERLEAVE
  Plus zero or one of:
	MPOL_F_STATIC_NODES, MPOL_F_RELATIVE_NODES
  where, if you choose neither of tne MPOL_F_*_NODES flags,
  then you get the classic, compatible nodemask handling.

> Well, I didn't cave on anything 

;)   Your simple "ok" was ambiguous enough that we were able to
     read into it whatever we wanted to.

But I've made my case on that issue (involving the separate or
packed policy flag field).  So I probably won't say more, and
I expect to live with whatever you choose, after any further
input from Lee or others.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
