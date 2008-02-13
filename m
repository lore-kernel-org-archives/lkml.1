Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbYBMPPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbYBMPPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbYBMPPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:15:25 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:33008 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbYBMPPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:15:24 -0500
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <alpine.DEB.1.00.0802122100190.24022@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
	 <1202862136.4974.41.camel@localhost>
	 <alpine.DEB.1.00.0802122004190.11889@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802122100190.24022@chino.kir.corp.google.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 13 Feb 2008 08:15:28 -0700
Message-Id: <1202915728.4978.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 21:06 -0800, David Rientjes wrote:
> On Tue, 12 Feb 2008, David Rientjes wrote:
> 
> > Since we're allowed to remap the node to a different node than the user 
> > specified with either syscall, the current behavior is that "one node is 
> > as good as another."  In other words, we're trying to accomodate the mode 
> > first by setting pol->v.preferred_node to some accessible node and only 
> > setting that to the user-supplied node if it is available.
> > 
> > If the node isn't available and the user specifically asked that it is not 
> > remapped (with MPOL_F_STATIC_NODES), then I felt local allocation was best 
> > compared to remapping to a node that may be unrelated to the VMA or task.  
> > This preserves a sense of the current behavior that "one node is as good 
> > as another," but the user specifically asked for no remap.
> > 
> 
> Upon further inspection, perhaps it's better to fallback to local 
> allocation when the preferred node is not available on rebind and then, if 
> it becomes available later, prefer it again.
> 
> In mpol_rebind_policy():
> 
> 	case MPOL_PREFERRED:
> 		if (!remap) {
> 			int nid = first_node(pol->user_nodemask);
> 
> 			if (node_isset(nid, *newmask))
> 				pol->v.preferred_node = nid;
> 			else {
> 				/*
> 				 * Fallback to local allocation since that
> 				 * is the behavior in mpol_new().  The
> 				 * node may eventually become available.
> 				 */
> 				pol->v.preferred_node = -1;
> 			}
> 		} else
> 			pol->v.preferred_node = node_remap(pol->v.preferred_node,
> 							*mpolmask, *newmask);
> 		break;
> 
> What do you think, Lee?

I agree.  I was still puzzled by your patch in this area as it appeared
to me that you weren't remapping back to your original preferred node,
which seemed to be the whole point of "static".  I was going to ask
about this today, but you caught it first!

Lee

> 
> 		David

