Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbYB0BR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbYB0BR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 20:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbYB0BRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 20:17:20 -0500
Received: from smtp-out.google.com ([216.239.45.13]:28239 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbYB0BRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 20:17:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=F7fz4AvjlbpghS1IVnEI09UYXLKEEtsFyZ9YQCCXVFO+gnox9ghRLTcNNDt3tvxhI
	fvNTLUzqjEyzt1UW/PirQ==
Date: Tue, 26 Feb 2008 17:17:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 5/6] mempolicy: add MPOL_F_RELATIVE_NODES flag
In-Reply-To: <alpine.DEB.1.00.0802250016120.12368@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0802261704310.25919@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250014410.12368@chino.kir.corp.google.com>
 <alpine.DEB.1.00.0802250016120.12368@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, David Rientjes wrote:

> Adds another optional mode flag, MPOL_F_RELATIVE_NODES, that specifies
> nodemasks passed via set_mempolicy() or mbind() should be considered
> relative to the current task's mems_allowed.
> 

Here's some examples of the functional changes between the default 
actions of the various mempolicy modes and the new behavior with 
MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES.

To read this, the logical order follows from the left-most column to the 
right-most:

 - "mems" is the task's mems_allowed as constrained by its attached
   cpuset,

 - "nodemask" is the mask passed with the set_mempolicy() or mbind() call 
   for that particular policy,

 - the first "result" is the nodemask that the policy is effected over,

 - "rebind" is the nodemask of a subsequent change to the cpuset's mems,
   and

 - the second "result" is the nodemask that the policy is now effected 
   over.

			MPOL_INTERLEAVE
			---------------
	mems	nodemask	result		rebind		result
	1-3	0-2		1-2[*]		4-6		4-5
	1-3	1-2		1-2		0-2		0-1
	1-3	1-3		1-3		4-7		4-6
	1-3	2-4		2-3		0-2		1-2
	1-3	2-6		2-3		4-7		5-6
	1-3	4-7		EINVAL
	1-3	0-7		1-3		4-7		4-6

			MPOL_PREFERRED
			--------------
	mems	nodemask	result		rebind		result
	1-3	0		EINVAL
	1-3	2		2		4-7		5
	1-3	5		EINVAL

			MPOL_BIND
			---------
	mems	nodemask	result		rebind		result
	1-3	0-2		1-2		0-2		0-1
	1-3	1-2		1-2		2-7		2-3
	1-3	1-3		1-3		0-1		0-1
	1-3	2-4		2-3		3-6		4-5
	1-3	2-6		2-3		5		5
	1-3	4-7		EINVAL
	1-3	0-7		1-3		1-3		1-3

 [*] Notice how the resulting nodemask for all of these examples when
     creating the mempolicy is intersected with mems_allowed.  This is
     the current behavior, with contextualize_policy(), and is identical
     to the initial result of the MPOL_F_STATIC_NODES case.

     Perhaps it would make more sense to remap the nodemask when it is
     created, as well, in the ~MPOL_F_STATIC_NODES case.  For example, in
     this case, the "result" would be 1-3 instead.

     That is a departure from what is currently implemented in HEAD (and,
     thus, can be used as ample justification for the above behavior) but
     makes more sense.  Thoughts?

			MPOL_INTERLEAVE | MPOL_F_STATIC_NODES
			-------------------------------------
	mems	nodemask	result		rebind		result
	1-3	0-2		1-2		4-6		nil
	1-3	1-2		1-2		0-2		1-2
	1-3	1-3		1-3		4-7		nil
	1-3	2-4		2-3		0-2		2
	1-3	2-6		2-3		4-7		4-6
	1-3	4-7		EINVAL
	1-3	0-7		1-3		4-7		4-7

			MPOL_PREFERRED | MPOL_F_STATIC_NODES
			------------------------------------
	mems	nodemask	result		rebind		result
	1-3	0		EINVAL
	1-3	2		2		4-7		-1[**]
	1-3	5		EINVAL

 [**] Upon further rebind with a nodemask of 2, the preferred node would
      again be 2.

			MPOL_BIND | MPOL_F_STATIC_NODES
			-------------------------------
	mems	nodemask	result		rebind		result
	1-3	0-2		1-2		0-2		0-2
	1-3	1-2		1-2		2-7		2
	1-3	1-3		1-3		0-1		1
	1-3	2-4		2-3		3-6		3-4
	1-3	2-6		2-3		5		5
	1-3	4-7		EINVAL
	1-3	0-7		1-3		1-3		1-3

			MPOL_INTERLEAVE | MPOL_F_RELATIVE_NODES
			---------------------------------------
	mems	nodemask	result		rebind		result
	1-3	0-2		1-3		4-6		4-6
	1-3	1-2		2-3		0-2		1-2
	1-3	1-3		1-3		4-7		5-7
	1-3	2-4		1-3		0-2		0-2
	1-3	2-6		1-3		4-7		4-7
	1-3	4-7		1-3		0-1,5		0-1,5
	1-3	0-7		1-3		4-7		4-7

			MPOL_PREFERRED | MPOL_F_RELATIVE_NODES
			--------------------------------------
	mems	nodemask	result		rebind		result[***]
	1-3	0		1		0		1
	1-3	2		3		4-7		3
	1-3	5		3		0-7		3

 [***] All of these results are wrong and will be corrected in the next
       posting of the patchset.  They change the preferred node in some
       cases to be a node that is expressly excluded from being accessed
       by the cpuset mems change.

			MPOL_BIND | MPOL_F_RELATIVE_NODES
			---------------------------------
	mems	nodemask	result		rebind		result
	1-3	0-2		1-3		0-2		0-2
	1-3	1-2		2-3		2-7		3-4
	1-3	1-3		1-3		0-1		0-1
	1-3	2-4		1-3		3-6		3,5-6
	1-3	2-6		1-3		5		5
	1-3	4-7		1-3		0-3,6		0-2,6
	1-3	0-7		1-3		1-3		1-3
