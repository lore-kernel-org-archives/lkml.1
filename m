Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbYBMFHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbYBMFHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 00:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbYBMFHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 00:07:05 -0500
Received: from smtp-out.google.com ([216.239.33.17]:53371 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYBMFHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 00:07:03 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=n1iEXOkPPwYec/g3inReOpxioYCis0Up3Fp5eckHDmKwDh30R5hfRM4JGamaS0lId
	MXrO8qL9Pchku2ULSAaeA==
Date: Tue, 12 Feb 2008 21:06:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <alpine.DEB.1.00.0802122004190.11889@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0802122100190.24022@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com> <1202862136.4974.41.camel@localhost>
 <alpine.DEB.1.00.0802122004190.11889@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, David Rientjes wrote:

> Since we're allowed to remap the node to a different node than the user 
> specified with either syscall, the current behavior is that "one node is 
> as good as another."  In other words, we're trying to accomodate the mode 
> first by setting pol->v.preferred_node to some accessible node and only 
> setting that to the user-supplied node if it is available.
> 
> If the node isn't available and the user specifically asked that it is not 
> remapped (with MPOL_F_STATIC_NODES), then I felt local allocation was best 
> compared to remapping to a node that may be unrelated to the VMA or task.  
> This preserves a sense of the current behavior that "one node is as good 
> as another," but the user specifically asked for no remap.
> 

Upon further inspection, perhaps it's better to fallback to local 
allocation when the preferred node is not available on rebind and then, if 
it becomes available later, prefer it again.

In mpol_rebind_policy():

	case MPOL_PREFERRED:
		if (!remap) {
			int nid = first_node(pol->user_nodemask);

			if (node_isset(nid, *newmask))
				pol->v.preferred_node = nid;
			else {
				/*
				 * Fallback to local allocation since that
				 * is the behavior in mpol_new().  The
				 * node may eventually become available.
				 */
				pol->v.preferred_node = -1;
			}
		} else
			pol->v.preferred_node = node_remap(pol->v.preferred_node,
							*mpolmask, *newmask);
		break;

What do you think, Lee?

		David
