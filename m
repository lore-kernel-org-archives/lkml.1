Return-Path: <linux-kernel-owner+w=401wt.eu-S1760938AbYBMAcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760938AbYBMAcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYBMAcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:32:04 -0500
Received: from relay2.sgi.com ([192.48.171.30]:42815 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753591AbYBMAcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:32:03 -0500
Date: Tue, 12 Feb 2008 18:31:58 -0600
From: Paul Jackson <pj@sgi.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: rientjes@google.com, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mempolicy: convert MPOL constants to enum
Message-Id: <20080212183158.3ff4ccd5.pj@sgi.com>
In-Reply-To: <1202861432.4974.29.camel@localhost>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<1202861432.4974.29.camel@localhost>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee wrote:
> Why not leave it as an int.  Will simplify this and subsequent patch.

I tend to agree with Lee on this one.  If I recall correctly, Christoph
said something similar, regarding the change of the 'policy' field
of struct mempolicy from a short to an enum.

I'm inclined toward the original types for the 'policy' field.

Also, rather than trying to pack the new flag, MPOL_F_STATIC_NODES,
into the existing 'policy' field, I'd suggest instead adding a new
field to 'struct mempolicy' for this flag.  Since 'policy' is only a
short, and since the next field in that struct, is a union that
includes a pointer that is aligned on most arch's to at least a 4 byte
boundary, therefore there is a hole of at least two bytes, following
the short policy field, in which another short or some flag bits can be
placed, with no increase in the size of struct mempolicy.

Specifically, I'd suggest adding the one line for 'mode_f_static_nodes'
as below, and leaving the code involving the encoding of the policy
field alone.

struct mempolicy {
        atomic_t refcnt;
        short policy;   /* See MPOL_* above */
	int mode_f_static_nodes:1;			/* <== Added line <== */
        union {
                struct zonelist  *zonelist;     /* bind */
                short            preferred_node; /* preferred */
                nodemask_t       nodes;         /* interleave */
                /* undefined for default */
        } v;
        nodemask_t cpuset_mems_allowed; /* mempolicy relative to these nodes */
};

Single bit fields (The ":1" above) provide the simplest way to add
boolean flags to structs.  Let the compiler do the work of packing
and unpacking the field.

Then, rather than having to code double-negative explicit masking
operations such as:

	remap = !(mpol_flags(pol->policy) & MPOL_F_STATIC_NODES);
	if (!remap)
		blah blah ...

one can simply code:

	if (pol->mode_f_static_nodes)
		blah blah ...

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
