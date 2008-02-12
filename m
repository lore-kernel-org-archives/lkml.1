Return-Path: <linux-kernel-owner+w=401wt.eu-S1762850AbYBLTSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762850AbYBLTSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYBLTSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:18:18 -0500
Received: from smtp-out.google.com ([216.239.45.13]:21040 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbYBLTSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:18:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=dOP1VTUper7sQHeFMqIKRcYjHjcTkvReKrxdlwC0vJ92nkEVFfjQ3QZIJTo0WF9Oy
	MvB7DA6Y9eecIgINPqsvg==
Date: Tue, 12 Feb 2008 11:14:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/4] mempolicy: support optional mode flags
In-Reply-To: <1202830267.4974.14.camel@localhost>
Message-ID: <alpine.DEB.1.00.0802121109570.9649@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>  <1202747811.5014.37.camel@localhost>  <alpine.DEB.1.00.0802111127080.1671@chino.kir.corp.google.com>
 <1202830267.4974.14.camel@localhost>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Lee Schermerhorn wrote:

> Hmmm, so 'static' means "don't contexutalize"--i.e., don't mask off
> disallowed or memoryless nodes?  That means we'll need to skip them in
> the interleave node calculation in the allocation path.  Perhaps your
> patch already addresses this, but I haven't had time to look.  
> 

All MPOL_F_STATIC_NODES does (by mbind(), set_mempolicy(), or adding 
'=static' to the mempolicy mode on tmpfs mount) is suppress the node remap 
in mpol_rebind_policy().

In mpol_new(), the intent of the user is stored in a new nodemask_t member 
of struct mempolicy and in the static case the passed nodemask is 
intersected with that member.  The policy is then effected over the 
intersection.

If that nodemask includes no accessible nodes, then the mempolicy is not 
effected but rather lies dormant until access to those nodes is attained.  
If and when that happens, the mempolicy will then be effected again 
without any additional set_mempolicy() or mbind() from the user.

		David
