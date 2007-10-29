Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbXJ2HAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbXJ2HAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 03:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbXJ2HAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 03:00:44 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49236 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbXJ2HAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 03:00:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=GFSVVp2YVBlcDug+g3s9LNM64Iah67hb6Hf53W0Kmo4NpCHejde3OPcxJGiX7yoEr
	7hLRUlZ6jkLOuFEV3XU+A==
Date: Mon, 29 Oct 2007 00:00:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071028224533.df924291.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710282352270.23978@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <20071026120037.7b95a136.pj@sgi.com> <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com> <1193433239.5032.95.camel@localhost> <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
 <1193434278.5032.106.camel@localhost> <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com> <20071026180713.aeedfac2.pj@sgi.com> <Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com> <20071026194144.6042316a.pj@sgi.com>
 <alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com> <20071027161955.e9d4d2db.pj@sgi.com> <alpine.DEB.0.9999.0710272231170.23796@chino.kir.corp.google.com> <20071028164637.8d1b45b0.pj@sgi.com> <alpine.DEB.0.9999.0710281742090.26837@chino.kir.corp.google.com>
 <20071028212745.57a7db67.pj@sgi.com> <alpine.DEB.0.9999.0710282130320.32474@chino.kir.corp.google.com> <20071028224533.df924291.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007, Paul Jackson wrote:

> > If we can't identify any applications that would be broken by this, what's 
> > the difference in simply implementing Choice B and then, if we hear 
> > complaints, add your hack to revert back to Choice A behavior based on the 
> > get_mempolicy() call you specified is always part of libnuma?
> 
> I'll probably reply to other parts of your message later, but this
> one catches my eye right now.
> 
> "if we hear complaints, add your hack ... back"  -- this doesn't seem
> like a good idea to me.  Maybe inside Google you don't see it, but
> for those of us shipping computer systems using major distributions
> such as SUSE or Red Hat, there can be a year lag between when I send a
> feature patch to Andrew, and when my customers send their first
> feedback to me resulting from using that new feature.
> 

Let's add a Choice C:

	Any nodemask that is passed to set_mempolicy() is saved as the
	intent of the application in struct mempolicy.  All policies
	are effected on a contextualized per-allocation basis.

	Policies such as MPOL_INTERLEAVE always get AND'd with 
	pol->cpuset_mems_allowed.  If that yields numa_no_nodes,
	MPOL_DEFAULT is used instead.

	Policies such as MPOL_PREFERRED are respected if the node is set
	in pol->cpuset_mems_allowed, otherwise MPOL_DEFAULT is used.	

	If an application attempts to setup a memory policy for an
	MPOL_PREFERRED node that it doesn't have access to or an
	MPOL_INTERLEAVE nodemask that is empty when AND'd with
	pol->cpuset_mems_allowed, -EINVAL is returned and no new policy
	is effected.

	If an application gains nodes in pol->cpuset_mems_allowed that
	now include the nodes from MPOL_INTERLEAVE or MPOL_PREFERRED,
	that policy is then effected once again.  Otherwise,
	MPOL_DEFAULT is still used.
