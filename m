Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbXCZMXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbXCZMXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 08:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbXCZMXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 08:23:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbXCZMXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 08:23:24 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0703261447190.13229@sbz-30.cs.Helsinki.FI> 
References: <Pine.LNX.4.64.0703261447190.13229@sbz-30.cs.Helsinki.FI>  <Pine.LNX.4.64.0703261427490.12793@sbz-30.cs.Helsinki.FI> <20070326024143.a226c9b2.akpm@linux-foundation.org> <1174904637.32691.86.camel@roc-desktop> <6017.1174908318@redhat.com> <6791.1174909459@redhat.com> 
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, dhowells@redhat.com
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error bug 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 26 Mar 2007 13:22:44 +0100
Message-ID: <11045.1174911764@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> > I don't know, what does it do?  Remember, once a NOMMU process thinks it
> > has the right to access a mapping, there's no way of stopping it doing so
> > short of killing the process.
> 
> revoke_mapping() is mostly same as munmap(2) except that it preserves the 
> vma but makes it VM_REVOKED. This means that if the process tries to 
> access the region it will SIGBUS and if it tries to remap the range it 
> will get EINVAL.

Yeah, that's not enforceable in NOMMU-mode situations.  I presume it differs
from munmap() also in that it can effectively be forced by one process upon
another.

In MMU-mode, how does this work with private mappings that have some private
copies of the pages that make up the mapping?  Are those still available to a
process that is using them?  Are they revoked when swapped out?  Or are they
forcibly evicted?

> What we're trying to do here is, we want to make sure no other tasks can 
> access the inode once it has been revoked.

Okay.

> So there's no way to raise SIGBUS if the range is being accessed. The 
> alternatives are:
> 
>   - No support for revoke(2) on NOMMU.

That's a bit over the top, I think.  It sounds like revoke() is perfectly fine
- as long as there aren't any mappings on the target inode (or at least shared
mappings - dunno about private mappings).

>   - If there are shared mappings, always return -ENOENT for revoke(2).

That sounds feasible.  How about -ETXTBSY instead?

>   - If there are shared mappings, immediately raise SIGBUS for those 
>     processes that are accessing it.

Hmmm... maybe.  That sounds a bit antisocial though, but is also workable.
Does the SIGBUS raised have its own si_code, btw?  Perhaps BUS_REVOKED?

> Making the shared mappings private is not an option because there's no way 
> for the process to know that it's mapping is being pulled under it which 
> will result in bugs. Hmm.

Agreed.

David
