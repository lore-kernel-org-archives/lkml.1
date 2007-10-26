Return-Path: <linux-kernel-owner+w=401wt.eu-S1762084AbXJZJ4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762084AbXJZJ4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760232AbXJZJ4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:56:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55697 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753878AbXJZJ4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:56:36 -0400
Date: Fri, 26 Oct 2007 02:56:34 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, ak@suse.de, clameter@sgi.com,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] cpusets: add memory_spread_user option
Message-Id: <20071026025634.0f32e1e2.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710260204590.8261@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251912300.30400@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251913130.30400@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251913350.30400@chino.kir.corp.google.com>
	<20071025230409.81f20ed3.pj@sgi.com>
	<alpine.DEB.0.9999.0710260204590.8261@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> It all comes down to the decision of whether we want to permit 
> set_mempolicy() calls for tasks and respect the nodemask passed in a 
> memory_spread_user cpuset.

Well said.  My current inclination is to say:
 1) If you want the current behaviour, where set_mempolicy(MPOL_INTERLEAVE)
    calls mean what they say, and cpusets tries as best it can (imperfectly)
    to honor those memory policy calls, even in the face of changing cpusets,
    then leave memory_spread_user turned off (the default, right?)
 2) If you want MPOL_INTERLEAVE tasks to interleave user memory across all
    nodes in the cpuset, whatever that might be, then enable memory_spread_user.

This is admittedly less flexible than your patch provided, but I am
attracted to the simpler API - easier to explain.

This does beg yet another question: shouldn't memory_spread_user force
interleaving of user memory -regardless- of mempolicy.

And yet another question: what about the MPOL_BIND mempolicy?  It too,
to a lesser extent, has the same problems with cpusets that shrink and
then expand.  Several tasks in a cpuset with multiple nodes could carefully
bind to a separate node each, but then end up collapsed all onto the same
node if the cpuset was shrunk to one node and then expanded again.

I should sleep on this, and hopefully respond again, within this day.

On a different point, we could, if it was worth the extra bit of code,
improve the current code's handling of mempolicy rebinding when the
cpuset adds memory nodes.  If we kept both the original cpusets
mems_allowed, and the original MPOL_INTERLEAVE nodemask requested by
the user in a call to set_mempolicy, then we could rebind (nodes_remap)
the currently active policy v.nodes using that pair of saved masks to
guide the rebinding.  This way, if say a cpuset shrunk, then regrew back
to its original size (original number of nodes) we would end up
replicating the original MPOL_INTERLEAVE request, cpuset relative.
This would provide a more accurate cpuset relative translation of such
memory policies with-out- changing the set_mempolicy API.  Hmmm ... this
might meet your needs entirely, so that we did not need -any- added
flags to the API.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
