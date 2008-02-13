Return-Path: <linux-kernel-owner+w=401wt.eu-S1763444AbYBMAxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763444AbYBMAxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbYBMAxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:53:32 -0500
Received: from smtp-out.google.com ([216.239.33.17]:44739 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbYBMAxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:53:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=GvHxy4sTMMOZlN2g71gHTwfihUKX5wP9EdBOqQf1WdnSma2vKtidud/UDOMl9j/Y8
	nK7ialEAbqUqmAOczYOmQ==
Date: Tue, 12 Feb 2008 16:53:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, akpm@linux-foundation.org,
       clameter@sgi.com, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mempolicy: convert MPOL constants to enum
In-Reply-To: <20080212183158.3ff4ccd5.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802121644140.3291@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <1202861432.4974.29.camel@localhost> <20080212183158.3ff4ccd5.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Paul Jackson wrote:

> I tend to agree with Lee on this one.  If I recall correctly, Christoph
> said something similar, regarding the change of the 'policy' field
> of struct mempolicy from a short to an enum.
> 

I've already made the change in my patchset as a result of Christoph's 
comment.

> I'm inclined toward the original types for the 'policy' field.
> 
> Also, rather than trying to pack the new flag, MPOL_F_STATIC_NODES,
> into the existing 'policy' field, I'd suggest instead adding a new
> field to 'struct mempolicy' for this flag.  Since 'policy' is only a
> short, and since the next field in that struct, is a union that
> includes a pointer that is aligned on most arch's to at least a 4 byte
> boundary, therefore there is a hole of at least two bytes, following
> the short policy field, in which another short or some flag bits can be
> placed, with no increase in the size of struct mempolicy.
> 

I disagree, that space can be reserved for future use that will perhaps be 
much needed at that time.

The type 'short' is obviously overkill to hold the value of the policy 
mode since we only have four currently defined modes.  We'll never exceed 
the capacity of type 'unsigned char' if mempolicies are going to remain 
useful.

If the flag bits are going to be stored in the same member as the mode, it 
is necessary to make the change, as I have, to be unsigned to avoid 
sign-extension when this is promoted to 'int' that is required as part of 
the API.

> Specifically, I'd suggest adding the one line for 'mode_f_static_nodes'
> as below, and leaving the code involving the encoding of the policy
> field alone.
> 
> struct mempolicy {
>         atomic_t refcnt;
>         short policy;   /* See MPOL_* above */
> 	int mode_f_static_nodes:1;			/* <== Added line <== */
>         union {
>                 struct zonelist  *zonelist;     /* bind */
>                 short            preferred_node; /* preferred */
>                 nodemask_t       nodes;         /* interleave */
>                 /* undefined for default */
>         } v;
>         nodemask_t cpuset_mems_allowed; /* mempolicy relative to these nodes */
> };
> 
> Single bit fields (The ":1" above) provide the simplest way to add
> boolean flags to structs.  Let the compiler do the work of packing
> and unpacking the field.
> 
> Then, rather than having to code double-negative explicit masking
> operations such as:
> 
> 	remap = !(mpol_flags(pol->policy) & MPOL_F_STATIC_NODES);
> 	if (!remap)
> 		blah blah ...
> 
> one can simply code:
> 
> 	if (pol->mode_f_static_nodes)
> 		blah blah ...
> 

The problem with your approach is that we need to pass the optional mode 
flags back to the user through get_mempolicy() and the user needs to pass 
them to us via set_mempolicy() or mbind().  So we'll still need the 
#define in linux/mempolicy.h:

	#define MPOL_F_STATIC_NODES	(1 << MPOL_FLAG_SHIFT)

We could deal with this as follows:

	if (mode & MPOL_F_STATIC_NODES)
		pol->mode_f_static_nodes = 1;

but that doesn't make much sense.

Once Christoph's comment is taken into consideration and we start passing 
around 'int policy' instead of 'enum mempolicy_mode mode' again, I don't 
think anybody will struggle with doing:

	if (mode & MPOL_F_STATIC_NODES)

to check for the prescence of a flag.

		David
