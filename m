Return-Path: <linux-kernel-owner+w=401wt.eu-S1764674AbYBMIEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764674AbYBMIEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757737AbYBMIDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:03:51 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35671 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755623AbYBMIDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:03:50 -0500
Date: Wed, 13 Feb 2008 02:03:44 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
Message-Id: <20080213020344.45c9d924.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802122018550.11889@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
	<1202862136.4974.41.camel@localhost>
	<20080212215242.0342fa25.pj@sgi.com>
	<alpine.DEB.1.00.0802121955040.11889@chino.kir.corp.google.com>
	<20080212221354.a33799f2.pj@sgi.com>
	<alpine.DEB.1.00.0802122018550.11889@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok ... I read this patchset a little closer, and see a couple
of items worth noting.

The infamous unpublished (except to a few) patch I drafted on Christmas
(Dec 25, 2007) basically added two new modes for how mempolicy
nodemasks were to be resolved:
 1) a static, no remap, mode, such as in this present patchset, and
 2) a cpuset relative mode that correctly handled the case of cpusets
    growing larger (increased numbers of nodes.)

I'd like to persuade you to add case (2) as well.  But I suspect,
given that case (2) was never as compelling to you as it was to me
in our December discussions, that I'll have little luck doing that.

If you choose not to add case (2) to your patchset, then I'll wait
until the dust settles on your patchset, and follow up with a second
patch, adding case (2) and presenting the justification for it then.

Notes and questions on your current patchset:

 1) It looks like you -add- a second nodemask to struct mempolicy:
	    nodemask_t cpuset_mems_allowed; /* mempolicy relative to these nodes */
	    nodemask_t user_nodemask;       /* nodemask passed by user */

    I believe you can overlay these two nodemasks using a union, and avoid making
    struct mempolicy bigger.

 2) Those 'mpol_mode()' wrappers on all those mempolicy->policy
    evaluations look dangerous to me.  It looks like a code bug
    waiting to happen.  Unless I miss my guess, if you forget one of
    those wrappers (or someone making a future change misses one), no
    one will notice until sometime at runtime, someone makes use of the
    new fangled MPOL_F_STATIC_NODES mode in some new situation, and we
    end up executing code that we didn't expect to execute just then.

    I urge you to reconsider, and keep it so that the 'policy' field of struct
    mempolicy naturally evaluates to just the policy.  There should be just one
    pair of places, on entry to, and exit from, the kernel, where the code is
    aware of the need to pack the mode and the policy into a single word.

 3) Does your patchset allow the user to specify a nodemask that includes nodes
    outside of the current cpuset with a MPOL_F_STATIC_NODES mode?  At first
    glance, I didn't see that it did, but I should have looked closer.  This
    strikes me as an essential aspect of this mode.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
