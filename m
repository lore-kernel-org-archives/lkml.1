Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbYCHCPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbYCHCPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 21:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbYCHCPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 21:15:11 -0500
Received: from smtp-out.google.com ([216.239.45.13]:58258 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290AbYCHCPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 21:15:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=PP72m28fNa+VtuiAg+C7DE4BlBgL+6mFr5sEIFcbMmFzn+c9vcN5zutP+tIs56sZM
	cfC5QwXpj+DmUMgY43ERQ==
Date: Fri, 7 Mar 2008 18:14:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <clameter@sgi.com>
cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org,
       Lee.Schermerhorn@hp.com, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm 2/2] mempolicy: use default_policy mode instead of
 MPOL_DEFAULT
In-Reply-To: <Pine.LNX.4.64.0803071754250.12037@schroedinger.engr.sgi.com>
Message-ID: <alpine.DEB.1.00.0803071809010.13800@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803071720460.4611@chino.kir.corp.google.com> <alpine.DEB.1.00.0803071722170.4611@chino.kir.corp.google.com> <20080307192845.0492c6f9.pj@sgi.com> <alpine.DEB.1.00.0803071730340.6241@chino.kir.corp.google.com> <20080307193543.6a55ff8d.pj@sgi.com>
 <Pine.LNX.4.64.0803071754250.12037@schroedinger.engr.sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, Christoph Lameter wrote:

> And where is the patch to set the system (or cpuset....) default policy? 
> ;-)
> 

The system default policy is inherently defined in get_vma_policy() and 
alloc_pages_current().

> Note that the system default policy changes during bootup. Could that be 
> done with the default policy? We had some issues a while back with 
> processes spawned at boot inheriting the interleave policy. If they could 
> refer to default_policy instead then a change of default_policy would 
> switch all spawned processes to use MPOL_DEFAULT?
> 

With the patch, get_vma_policy() would return the VMA's policy if it has 
its own get_policy() function that returns a valid policy or differs from 
the default, otherwise it would refer to whatever default_policy is 
statically allocated to represent.

For task mempolicies, alloc_pages_current() has always used default_policy 
if current->mempolicy is NULL.  So you can change default_policy.policy to 
be anything you want (and its v.nodes or v.preferred_node members) and 
that will be the effected policy for any task that doesn't have a valid 
->mempolicy.
