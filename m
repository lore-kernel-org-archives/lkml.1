Return-Path: <linux-kernel-owner+w=401wt.eu-S1761950AbYBNKJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761950AbYBNKJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 05:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYBNKJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 05:09:22 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48702 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750951AbYBNKJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 05:09:21 -0500
Date: Thu, 14 Feb 2008 04:09:18 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
Message-Id: <20080214040918.d735e920.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few more review comments on details of this patch set ...

=========

In mempolicy.h, the lines:

    /*
     * The lower MPOL_FLAG_SHIFT bits of the policy mode represent the MPOL_*
     * constants defined in enum mempolicy_mode.  The upper bits represent
     * optional set_mempolicy() MPOL_F_* mode flags.
     */
    #define MPOL_FLAG_SHIFT (8)
    #define MPOL_MODE_MASK  ((1 << MPOL_FLAG_SHIFT) - 1)

    /* Flags for set_mempolicy */
    #define MPOL_F_STATIC_NODES     (1 << MPOL_FLAG_SHIFT)
    #define MPOL_MODE_FLAGS (MPOL_F_STATIC_NODES)   /* legal set_mempolicy() MPOL_* mode flags */

could be simplified, to:

    /*
     * Optional flags that modify nodemask numbering.
     */
    #define MPOL_F_RELATIVE_NODES (1<<14)	/* remapped relative to cpuset */
    #define MPOL_F_STATIC_NODES (1<<15)		/* unremapped physical masks */
    #define MPOL_MODE_FLAGS (MPOL_F_RELATIVE_NODES|MPOL_F_STATIC_NODES)
    						/* combined MPOL_F_* mask flags */

(really, that MPOL_FLAG_SHIFT is just unnecessary distracting detail.)

=========

If we ever call mpol_rebind_policy() with an MPOL_PREFERRED|MPOL_F_STATIC_NODES
policy when the preferred_node doesn't happen to be in the current cpuset,
then would the following lines loose the preferred node setting, such that
it didn't get applied again correctly if that node came back into our allowed
cpuset ?

        case MPOL_PREFERRED:
                if (!remap && !node_isset(pol->v.preferred_node, *newmask))
                        pol->v.preferred_node = -1;

=========

Instead of the double negative and the use of a new
word 'remap' meaning the opposite of STATIC, as in"

	int remap;
	...
	remap = !(mpol_flags(pol->policy) & MPOL_F_STATIC_NODES);
	...
		if (!remap)

How about something more direct, as in:

	int static_nodes;
	...
	static_nodes = mpol_flags(pol->policy) & MPOL_F_STATIC_NODES;
	...
		if (static_nodes)
		
Each additional logic inversion and additional name that isn't
trivially based on an existing name just makes this code more
difficult to read.

Of course, if we used bit fields for these additional flags,
instead of #defines and masks, the above would get even simpler,
eliminating the extra define's, and replacing the above three lines
with just the one line:

		if (pol->f_static_nodes)
		
But I already failed with that suggestion ... grumble, grumble ...

=========

Should the mpol_equal() algorithm change, in the case of either
MPOL_F_RELATIVE_NODES or MPOL_F_STATIC_NODES, to checking
user_nodemask equality, -instead- of the "switch(mode)"
mode specific tests?

=========

Could we have mpol_to_str() mark policies which are
MPOL_F_RELATIVE_NODES or MPOL_F_STATIC_NODES?  Perhaps
by adding a suffix of "|relative" or "|static" or some
such.


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
