Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbYBMCBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbYBMCBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbYBMCBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:01:24 -0500
Received: from smtp-out.google.com ([216.239.33.17]:47658 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbYBMCBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:01:23 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=XgFj8Bh2hJ+mKV5u6xm7QHeEt+KBBfD01Xsvt6U2lzUHGLoZCuplgLTJH0Mowy/3Q
	VjOy2BqqOrpqz7VwtoHTg==
Date: Tue, 12 Feb 2008 18:00:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Christoph Lameter <clameter@sgi.com>, Lee.Schermerhorn@hp.com,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mempolicy: convert MPOL constants to enum
In-Reply-To: <20080212193229.edbff05a.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802121755400.23110@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <1202861432.4974.29.camel@localhost> <20080212183158.3ff4ccd5.pj@sgi.com> <Pine.LNX.4.64.0802121702431.11628@schroedinger.engr.sgi.com> <20080212193229.edbff05a.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Paul Jackson wrote:

> Christoph wrote:
> > Good. And remove the enum.
> > 
> > It would be better to add some sort of flags field?
> 
> On the other hand, despite my brilliant (hah!) endorsement
> of bit field flags in my reply a few minutes ago, I'd settle
> for (1) removing the enum, and (2) using a flags field and
> more defines for the new stuff.  I will grant that Christoph
> is correct that that form is more common in the kernel, and
> there is something to be said for doing things in the most
> common manner.
> 

The enum has already been removed, as I've said a few times.

The 'flags' field would be wrong because you're ignoring that these flags 
are both passed by the user to the kernel and by the kernel to the user as 
part of the 'int *' parameter in either set_mempolicy() or mbind().

So they must have predefined shift in linux/mempolicy.h to separate that 
'int *' parameter into the policy mode and the optional mode flags.

If you introduced a separate flags member to struct mempolicy, you'd be 
wasting the lower MPOL_FLAG_SHIFT bits for no apparent purpose so your 
flag bits still work:

	#define MPOL_F_STATIC_NODES	(1 << MPOL_FLAG_SHIFT)

There's no way around that without shifting before storing and each time 
you read pol->flags.

So since those bits would have to be unused and can perfectly accomodate 
the mode bits (with the current definition of MPOL_FLAG_SHIFT at 8, we 
can accomodate up to 256 distinct modes), there is no reason why they 
cannot be combined.  That is why I implemented it that way.

		David
