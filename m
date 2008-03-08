Return-Path: <linux-kernel-owner+w=401wt.eu-S1758405AbYCHTNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405AbYCHTNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 14:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbYCHTNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 14:13:07 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:4017 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbYCHTNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 14:13:06 -0500
Subject: Re: [patch -mm 2/2] mempolicy: use default_policy mode instead of
	MPOL_DEFAULT
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.00.0803071730340.6241@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803071720460.4611@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0803071722170.4611@chino.kir.corp.google.com>
	 <20080307192845.0492c6f9.pj@sgi.com>
	 <alpine.DEB.1.00.0803071730340.6241@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Sat, 08 Mar 2008 14:13:00 -0500
Message-Id: <1205003580.4918.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-07 at 17:33 -0800, David Rientjes wrote:
> On Fri, 7 Mar 2008, Paul Jackson wrote:
> 
> > > So instead of checking for comparisons against a mempolicy's mode to
> > > MPOL_DEFAULT or falling back stricly to MPOL_DEFAULT throughout the code,
> > > we should use the mode that is defined in this struct.
> > 
> > Is this just a stylistic choice?  That is, is the same machine
> > code produced either way?
> > 
> > If that's the case, could you briefly explain why you prefer
> > one style (default_policy.policy) over the other (MPOL_DEFAULT)?
> > 
> 
> Very fast response!
> 
> Yes, the same code is generated since default_policy.policy is statically 
> declared as MPOL_DEFAULT.
> 
> I chose this because checks in mpol_new() to return NULL if the mode is 
> MPOL_DEFAULT is purely based on the fact that, as the default system 
> policy, policy task or VMA pointers are set to &default_policy.

Do I understand that you're saying that when mode is specified as
MPOL_DEFAULT, the current task policy [in the case of set_mempolicy()]
or the indicated vma policy [in the case of mbind()] is set to
&default_policy?  If that's not what you're saying, please disregard the
rest of this message.

If that is what you're saying:   This is not the case.  When mode is
specified as MPOL_DEFAULT,  mpol_new() returns NULL and
do_set_mempolicy() or do_mbind() [via it's helper functions] replaces
the existing task or vma policy with the NULL, freeing [releasing a
reference on] the existing policy, if any.  This results in the target
policy--task or vma--"falling back" to the surrounding policy scope.
This seems to have been the behavior as far back as I have looked.

In fact, the only place that MPOL_DEFAULT occurs in the policy [mode]
member of struct mempolicy is in the system default_policy.  [As
Christoph noted, this is not the case during system initialization.]  In
this context, it means "local allocation".  This requires us to have the
MPOL_DEFAULT case in the switches throughout mempolicy.c.

I have a patch queued up, waiting for things to settle down in
mempolicy.c, to replace the policy/mode in default_policy with
MPOL_PREFERRED with preferred_node = -1.  Then, we can remove all of the
MPOL_DEFAULT cases out of the switches in the allocation paths and
"clean up" the documentation, including man pages.  MPOL_DEFAULT becomes
simply an API mechanism to request fall back to the surrounding policy
scope which, to my mind, is what "default policy" means.

I don't have a problem with this patch in the context of the current
implementation, altho' it does seem a bit pointless to me, unless you
have something further that you're trying to to accomplish.

I'll move the aforementioned patch to the head of my queue and send it
out early this coming week for review atop whatever mempolicy patches
Andrew has added to the tree at that time.

Later,
Lee


