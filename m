Return-Path: <linux-kernel-owner+w=401wt.eu-S1761245AbYBKT7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761245AbYBKT7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:59:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760833AbYBKT6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:58:37 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:53504 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760824AbYBKT6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:58:36 -0500
Date: Mon, 11 Feb 2008 08:10:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] mempolicy: update NUMA memory policy documentation
Message-Id: <20080211081053.446a4152.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.1.00.0802101507560.11145@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507560.11145@chino.kir.corp.google.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 07:30:35 -0800 (PST) David Rientjes wrote:

> Updates Documentation/vm/numa_memory_policy.txt and
> Documentation/filesystems/tmpfs.txt to describe optional mempolicy mode
> flags.
> 
> Cc: Paul Jackson <pj@sgi.com>
> Cc: Christoph Lameter <clameter@sgi.com>
> Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> Cc: Andi Kleen <ak@suse.de>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  Documentation/filesystems/tmpfs.txt     |   11 ++++++++
>  Documentation/vm/numa_memory_policy.txt |   41 +++++++++++++++++++++++++++----
>  2 files changed, 47 insertions(+), 5 deletions(-)
> 

> diff --git a/Documentation/vm/numa_memory_policy.txt b/Documentation/vm/numa_memory_policy.txt
> --- a/Documentation/vm/numa_memory_policy.txt
> +++ b/Documentation/vm/numa_memory_policy.txt
> @@ -135,9 +135,11 @@ most general to most specific:
>  
>  Components of Memory Policies
>  
> -    A Linux memory policy is a tuple consisting of a "mode" and an optional set
> -    of nodes.  The mode determine the behavior of the policy, while the
> -    optional set of nodes can be viewed as the arguments to the behavior.
> +    A Linux memory policy consists of a "mode", optional mode flags, and an
> +    optional set of nodes.  The mode determine the behavior of the policy,

                                        determines

> +    the optional mode flags determine the behavior of the mode, and the
> +    optional set of nodes can be viewed as the arguments to the policy
> +    behavior.
>  
>     Internally, memory policies are implemented by a reference counted
>     structure, struct mempolicy.  Details of this structure will be discussed
> @@ -145,7 +147,12 @@ Components of Memory Policies
>  
>  	Note:  in some functions AND in the struct mempolicy itself, the mode
>  	is called "policy".  However, to avoid confusion with the policy tuple,
> -	this document will continue to use the term "mode".
> +	this document will continue to use the term "mode".  Since the mode and
> +	optional mode flags are stored in the same struct mempolicy member
> +	(specifically, pol->policy), you must use mpol_mode(pol->policy) to
> +	access only the mode and mpol_flags(pol->policy) to access only the
> +	flags.  Any function with a formal of type enum mempolicy_mode only
> +	refers to the mode.
>  
>     Linux memory policy supports the following 4 behavioral modes:
>  
> @@ -231,6 +238,28 @@ Components of Memory Policies
>  	    the temporary interleaved system default policy works in this
>  	    mode.
>  
> +   Linux memory policy supports the following optional mode flag:
> +
> +	MPOL_F_STATIC_NODES:  This flag specifies that the nodemask passed by
> +	the user should not be remapped if the task or VMA's set of accessible
> +	nodes changes after the memory policy has been defined.
> +
> +	    Without this flag, anytime a mempolicy is rebound because of a
> +	    change in the set of accessible nodes, the node (Preferred) or
> +	    nodemask (Bind, Interleave) is remapped to the new set of
> +	    accessible nodes.  This may result in nodes being used that were
> +	    previously undesired.  With this flag, the policy is either
> +	    effected over the user's specified nodemask or the Default
> +	    behavior is used.
> +
> +	    For example, consider a task that is attached to a cpuset with
> +	    mems 1-3 that sets an Interleave policy over the same set.  If
> +	    the cpuset's mems change to 3-5, the Interleave will now occur
> +	    over nodes 3, 4, and 5.  With this flag, however, since only
> +	    node 3 is accessible from the user's nodemask, the "interleave"
> +	    only occurs over that node.  If no nodes from the user's
> +	    nodemask are now accessible, the Default behavior is used.
> +
>  MEMORY POLICY APIs
>  
>  Linux supports 3 system calls for controlling memory policy.  These APIS
> @@ -251,7 +280,9 @@ Set [Task] Memory Policy:
>  	Set's the calling task's "task/process memory policy" to mode
>  	specified by the 'mode' argument and the set of nodes defined
>  	by 'nmask'.  'nmask' points to a bit mask of node ids containing
> -	at least 'maxnode' ids.
> +	at least 'maxnode' ids.  Optional mode flags may be passed by
> +	intersecting the 'mode' argument with the flag (for example:

        or combining ?  I'm used to intersection being more of an
	and-op instead of an or-op, but maybe I'm missing something.

> +	MPOL_INTERLEAVE | MPOL_F_STATIC_NODES).
>  
>  	See the set_mempolicy(2) man page for more details

---
~Randy
