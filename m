Return-Path: <linux-kernel-owner+w=401wt.eu-S932219AbYBMStc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbYBMStc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbYBMStY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:49:24 -0500
Received: from smtp-out.google.com ([216.239.33.17]:35631 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbYBMStW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:49:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=d7UWnMKuWRaPwm0IiPklRHMKMHgGolhOZFBijqrBxWJLcrSLzk4tuszrPXrTRBPo1
	+MFH9nyPLl/4hR6/jBejw==
Date: Wed, 13 Feb 2008 10:48:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <1202918501.4978.38.camel@localhost>
Message-ID: <alpine.DEB.1.00.0802131035020.9186@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>  <1202862136.4974.41.camel@localhost>
 <20080212215242.0342fa25.pj@sgi.com>  <alpine.DEB.1.00.0802121955040.11889@chino.kir.corp.google.com>  <20080212221354.a33799f2.pj@sgi.com>  <alpine.DEB.1.00.0802122018550.11889@chino.kir.corp.google.com>  <20080213020344.45c9d924.pj@sgi.com> 
 <alpine.DEB.1.00.0802130113020.3936@chino.kir.corp.google.com> <1202918501.4978.38.camel@localhost>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Lee Schermerhorn wrote:

> > >  2) Those 'mpol_mode()' wrappers on all those mempolicy->policy
> > >     evaluations look dangerous to me.  It looks like a code bug
> > >     waiting to happen.  Unless I miss my guess, if you forget one of
> > >     those wrappers (or someone making a future change misses one), no
> > >     one will notice until sometime at runtime, someone makes use of the
> > >     new fangled MPOL_F_STATIC_NODES mode in some new situation, and we
> > >     end up executing code that we didn't expect to execute just then.
> > > 
> > >     I urge you to reconsider, and keep it so that the 'policy' field of struct
> > >     mempolicy naturally evaluates to just the policy.  There should be just one
> > >     pair of places, on entry to, and exit from, the kernel, where the code is
> > >     aware of the need to pack the mode and the policy into a single word.
> > > 
> > 
> > Ok.
> 
> I was hoping David wouldn't cave on this point. ;-)  I do agree with
> David that if we ever end up with nr_modes + nr_mode_flags > 16, the API
> will become too complex for myself, at least, to comprehend.  I don't
> feel too strongly either way, and I'll explain more below, but first:
> 

Hmm, I don't remember "caving" on this point; Paul asked me to reconsider 
and I said that I would.  I think it's also helpful to have more 
discussion on the matter by including other people's opinions.

> I do agree with Paul that there is a danger of missing one of these in
> converting existing code.  In fact, I missed one in my ref counting
> rework patch that I will ultimately rebase atop David's final version
> [I'm already dependent on Mel Gorman's patch series].  To catch this, I
> decided to rename the "policy" member to "mode".  This also aligns the
> struct better with the numa_memory_policy doc [I think of the "policy"
> as the tuple:  mode + optional nodemask].  For future code, I think we
> could add comments to the struct definition warning that one should use
> the wrappers to access the mode or mode flags.
> 

I considered this when I implemented it the way I did, and that was part 
of the reason I was in favor of enum mempolicy_mode so much: functions 
that had a formal of type 'enum mempolicy_mode' were only the mode and 
formals of type 'int' or 'unsigned short' were the combination.  I even 
stated that difference in Documentation/vm/numa_memory_policy.txt in the 
first patchset.

> However, let's step back and look at the usage of the mempolicy struct.
> In earlier mail, David mentioned that it is passed around outside of
> mempolicy.c.  While this is true, the only place that I see where code
> outside of mempolicy.c deals with the policy/mode and nodemask
> separately--as opposed to using an opaque mempolicy struct--is in the
> shmem mount option parsing.  Everywhere else, as far as I can see, just
> uses the struct mempolicy.  Even slab/slub call into slab_node() in
> mempolicy.c to extract the target node for the policy.
> 

Yes, struct shmem_sb_info stores the 'policy' member as well so it would 
need to include a new 'flags' member as well.  And the interface between 
the two, mpol_shared_policy_init() would need another formal for the 
flags.

> So, if David does accept Paul's plea to separate the mode and the mode
> flags in the structure, I would suggest that we do this in mpol_new().
> That is, in {sys|do}_{set_mempolicy|mbind}(), maintain the API format
> with the mode flags ORed into the mode.  mpol_new() can pull them apart
> into different struct mempolicy members.  The rest of mempolicy.c can
> use them directly from the struct without the helpers.  get_mempolicy()
> will need to pack the mode and flags back together--perhaps with an
> inverse helper function.
> 

Yeah, it gets tricky.  I'm not too sure about only pulling the mode and 
flags apart at mpol_new() time because perhaps, in the future, there will 
be flag and mode combinations that are only applicable for set_mempolicy() 
and not for mbind(), for example.  I can imagine that someday we may add a 
flag that applies only to a task mempolicy and not to a VMA mempolicy.

> As for the shmem mount option parsing:  For now, I'd suggest that we
> keep the mode flags OR'd into the "policy" member of the shmem_sb_info
> struct -- i.e., the "API format"--to preserve the mpol_new() interface.

I don't like this because its not consistent.  It increases the confusion 
of what contains a mode and what contains the combination.  I think the 
safest thing to do, if we separate the mode and flags out in struct 
mempolicy is to do it everywhere.  All helper functions will need 
additional formals similar to what I did in the first patchset (that was 
actually unpopular) and struct shmem_sb_info need to be modified to 
include the additional member.

In other words, I'm all in favor of storing the mode and flags however we 
want, but I think it should be done consistenty throughout the tree.  
While mpol_mode() wrappers may not be favorable all over the place (and I 
didn't miss any), it may be easier than the alternative.

		David
