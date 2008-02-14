Return-Path: <linux-kernel-owner+w=401wt.eu-S1763661AbYBNTlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763661AbYBNTlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbYBNTlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:41:06 -0500
Received: from smtp-out.google.com ([216.239.33.17]:49856 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbYBNTlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:41:04 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=TuA5gk3gqd0eCkHuF52GXdCdRF/W9QQOQtQjkQpEeL9LbYfpIcVui4DWRm6IuNK2E
	omy/LhJeL5cR9emMcZZyw==
Date: Thu, 14 Feb 2008 11:40:33 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <20080214040918.d735e920.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802141135110.17096@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com> <20080214040918.d735e920.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008, Paul Jackson wrote:

> If we ever call mpol_rebind_policy() with an MPOL_PREFERRED|MPOL_F_STATIC_NODES
> policy when the preferred_node doesn't happen to be in the current cpuset,
> then would the following lines loose the preferred node setting, such that
> it didn't get applied again correctly if that node came back into our allowed
> cpuset ?
> 
>         case MPOL_PREFERRED:
>                 if (!remap && !node_isset(pol->v.preferred_node, *newmask))
>                         pol->v.preferred_node = -1;
> 

That's already been corrected as a result of a discussion between Lee and 
myself (please see the incremental patch that I sent you privately when I 
sent the patchset along).

> Should the mpol_equal() algorithm change, in the case of either
> MPOL_F_RELATIVE_NODES or MPOL_F_STATIC_NODES, to checking
> user_nodemask equality, -instead- of the "switch(mode)"
> mode specific tests?
> 

That's a good question.

We'll need to decide whether mpol_equal() is determining the equality of 
the currently effected mempolicy (whereas policy->user_nodemask is 
irrelevant) or the whole intended mempolicy overall.

I didn't originally modify mpol_equal() because I preferred the former.  
Is there a compelling case for the latter where mpol_equal() is used in 
the tree that would require this change?

> Could we have mpol_to_str() mark policies which are
> MPOL_F_RELATIVE_NODES or MPOL_F_STATIC_NODES?  Perhaps
> by adding a suffix of "|relative" or "|static" or some
> such.
> 

I'd like to keep it in the same format as the tmpfs mount option which is 
'=relative' and '=static'.

		David
