Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbXJ0Ru5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbXJ0Ru5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 13:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbXJ0Ruj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 13:50:39 -0400
Received: from smtp-out.google.com ([216.239.45.13]:59981 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbXJ0Rui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 13:50:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=xaLB9M7fW6LSWDNaAOWHavbsynsuiSiVLaBM8COggA/1h8urGuF/k2OBo64U5jyiy
	xvk+n9q1ESxx8FonrOCwA==
Date: Sat, 27 Oct 2007 10:50:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Christoph Lameter <clameter@sgi.com>, Lee.Schermerhorn@hp.com,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071026194144.6042316a.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com> <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com> <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
 <20071025185506.8c373aa8.pj@sgi.com> <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com> <1193412644.5032.13.camel@localhost> <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com> <20071026120037.7b95a136.pj@sgi.com>
 <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com> <1193433239.5032.95.camel@localhost> <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com> <1193434278.5032.106.camel@localhost> <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
 <20071026180713.aeedfac2.pj@sgi.com> <Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com> <20071026194144.6042316a.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Paul Jackson wrote:

> > Yes. We should default to Choice B. Add an option MPOL_MF_RELATIVE to 
> > enable that functionality? A new version of numactl can then enable
> > that by default for newer applications.
> 
> I'm confused.  If B is the default, then we don't need a flag to
> enable it, rather we need a flag to go back to the old choice A.
> 

I think there's a mixup in the flag name there, but I actually would 
recommend against any flag to effect Choice A.  It's simply going to be 
too complex to describe and is going to be a headache to code and support.  

The MPOL_PREFERRED behavior when constrained by cpusets was previously, to 
my knowledge, undocumented; you're in the position to make the behavior do 
what you want it to do and then release documentation so we'll finally 
have a complete and unambiguous API for it.  Right now it should be 
considered undefined and thus you are free to implement it as you choose.  
Then all callers of set_mempolicy(MPOL_PREFERRED) will standardize on that 
and not have to worry about the machine's 
mpol_preferred_relative_to_cpuset setting.

Then, any task that is attached to a cpuset and expecting the fourth node 
in their set_mempolicy(MPOL_PREFERRED) call to mean system node 3 if 
it's in the cpuset's mems_allowed will be broken.  If you want that, 
you'll need your task to be attached to a cpuset with at least mems 0-3; 
programmers will pick that up quickly enough if it's clearly documented.
I think Choice B is correct and makes more sense in terms of the semantics 
and at least allows mempolicies and cpusets to play nicely together 
without a bidirectional dependency on one another.

		David
