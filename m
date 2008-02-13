Return-Path: <linux-kernel-owner+w=401wt.eu-S932808AbYBMTSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbYBMTSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbYBMTSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:18:08 -0500
Received: from smtp-out.google.com ([216.239.33.17]:37831 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758333AbYBMTSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:18:06 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=lTTrkbBPhHIYjSBtsj3O3WdQvCjMAPqQRYUUiKNCk1z0RgxZ989UafAeY7htuKVc3
	yE5h9YULiWLleR9EjtMWA==
Date: Wed, 13 Feb 2008 11:17:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <1202929511.4978.88.camel@localhost>
Message-ID: <alpine.DEB.1.00.0802131113190.9186@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>  <1202862136.4974.41.camel@localhost>
 <20080212215242.0342fa25.pj@sgi.com>  <alpine.DEB.1.00.0802121955040.11889@chino.kir.corp.google.com>  <20080212221354.a33799f2.pj@sgi.com>  <alpine.DEB.1.00.0802122018550.11889@chino.kir.corp.google.com>  <20080213020344.45c9d924.pj@sgi.com> 
 <alpine.DEB.1.00.0802130113020.3936@chino.kir.corp.google.com>  <1202918501.4978.38.camel@localhost>  <alpine.DEB.1.00.0802131035020.9186@chino.kir.corp.google.com> <1202929511.4978.88.camel@localhost>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Lee Schermerhorn wrote:

> > Yeah, it gets tricky.  I'm not too sure about only pulling the mode and 
> > flags apart at mpol_new() time because perhaps, in the future, there will 
> > be flag and mode combinations that are only applicable for set_mempolicy() 
> > and not for mbind(), for example.  I can imagine that someday we may add a 
> > flag that applies only to a task mempolicy and not to a VMA mempolicy.
> 
> True.  Altho' at such a time, I'd probably argue for testing for and
> rejecting invalid mode/flag combinations in the respective
> functions :-).
> 

Yeah, and that would require the modes and flags to be split apart in 
sys_set_mempolicy() and sys_mbind() or at least in do_set_mempolicy() or 
do_mbind().  So if we see the possibility that we want to test for mode 
and flag combinations that perhaps differ between the set_mempolicy() and 
mbind() case, we have to do it in either of those two places.  I think we 
should do it there, as early as possible, like I did in my first patchset.

> OK.  I'm "caving"... :-)  Different views of consistency.  But,
> eventually, I hope we can replace the separate mode[, flags] and
> nodemask in the 'sb_info with a mempolicy and keep the details of modes,
> flags, etc. internal to mempolicy.c.
> 

I agree, I think keeping all of these implementation details inside 
mm/mempolicy.c is the best practice.  We'll still need to expose some of 
the details, such as the parsing of '=static' in the tmpfs mount option to 
add the MPOL_F_STATIC_NODES flag to the policy, but situations like that 
should be rare.

For extendability, I agree that the struct shmem_sb_info member should be 
a pointer to a mempolicy and not an int.

		David
