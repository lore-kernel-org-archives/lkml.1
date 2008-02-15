Return-Path: <linux-kernel-owner+w=401wt.eu-S1762792AbYBOUYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762792AbYBOUYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758378AbYBOUYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:24:09 -0500
Received: from smtp-out.google.com ([216.239.45.13]:3637 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbYBOUYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:24:07 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=BFTwfg83A0tF5aMzqThGWLgrTV9UQoOrrqPqKaREPSLOeKAsDhpKUIlU2MQ+x3fpR
	K6mNcD8NfXDb+qjzGUIgA==
Date: Fri, 15 Feb 2008 12:23:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <20080215032748.8b07e5eb.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802151216330.19332@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com> <20080214040918.d735e920.pj@sgi.com>
 <alpine.DEB.1.00.0802141336590.6067@chino.kir.corp.google.com> <20080215032748.8b07e5eb.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008, Paul Jackson wrote:

> I don't think so.  It's not possible to detemine if exactly the low
> eight bits of the 'policy' short are a valid mode, -however- that
> "eight" is a spurious detail.  Remove it.
> 

Sure it is, you can determine if the low MPOL_FLAG_SHIFT bits are a valid 
mode by masking off the upper bits and testing if the result is >= 
MPOL_MAX.

> Instead of specifying that the 'policy' short consists of two bytes,
> one for mode and one for flags, rather specify that the policy fields
> consists of some high bits for flags, and the remaining low bits
> (however many remain) for the mode.
> 

Well, it's still an implementation detail that needs to be explicitly 
defined, otherwise we have no way to separate mode from flags when the 
user passes in their int formal as part of either syscall.

And given the recent requirements for a perfectly formed set_mempolicy() 
or mbind() syscall (as a result of the discussion about allowing non-empty 
nodemasks with MPOL_DEFAULT), we need to ensure that invalid flags are not 
being passed.

We should make sure to return -EINVAL to a user specifying an invalid flag 
if, for example, they are using an older kernel that doesn't support what 
they're asking for.

It would be possible to do all of this in both sys_set_mempolicy() and 
sys_mbind() by masking off the set of possible modes and checking the 
result for being >= MPOL_MAX:

	if ((mode & MPOL_MODE_FLAGS) >= MPOL_MAX)
		return -EINVAL;
