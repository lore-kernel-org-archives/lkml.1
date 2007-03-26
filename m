Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbXCZMhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbXCZMhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 08:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbXCZMhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 08:37:34 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54896 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbXCZMhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 08:37:32 -0400
Date: Mon, 26 Mar 2007 15:37:30 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: David Howells <dhowells@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error
 bug
In-Reply-To: <11045.1174911764@redhat.com>
Message-ID: <Pine.LNX.4.64.0703261525370.14158@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703261447190.13229@sbz-30.cs.Helsinki.FI> 
 <Pine.LNX.4.64.0703261427490.12793@sbz-30.cs.Helsinki.FI>
 <20070326024143.a226c9b2.akpm@linux-foundation.org> <1174904637.32691.86.camel@roc-desktop>
 <6017.1174908318@redhat.com> <6791.1174909459@redhat.com>  <11045.1174911764@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> > revoke_mapping() is mostly same as munmap(2) except that it preserves the 
> > vma but makes it VM_REVOKED. This means that if the process tries to 
> > access the region it will SIGBUS and if it tries to remap the range it 
> > will get EINVAL.

On Mon, 26 Mar 2007, David Howells wrote:
> Yeah, that's not enforceable in NOMMU-mode situations.  I presume it differs
> from munmap() also in that it can effectively be forced by one process upon
> another.

Yes.

On Mon, 26 Mar 2007, David Howells wrote:
> In MMU-mode, how does this work with private mappings that have some private
> copies of the pages that make up the mapping?  Are those still available to a
> process that is using them?  Are they revoked when swapped out?  Or are they
> forcibly evicted?

We don't touch private mappings at all as they're a snapshot to the inode 
_before_ it was revoked. So private mappings don't really matter all: you 
don't see any new data after it has been revoked nor do you flush anything 
to the disk.

Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> >   - If there are shared mappings, always return -ENOENT for revoke(2).
 
On Mon, 26 Mar 2007, David Howells wrote:
> That sounds feasible.  How about -ETXTBSY instead?

Well, assuming we would use revoke for things like SAK, this doesn't 
really work out too well because all a malicious process has to is create 
a shared mapping and they've effectively blocked the whole thing.

Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> >   - If there are shared mappings, immediately raise SIGBUS for those 
> >     processes that are accessing it.

On Mon, 26 Mar 2007, David Howells wrote:
> Hmmm... maybe.  That sounds a bit antisocial though, but is also 
> workable.

It's antisocial for sure but the only way to guarantee revoke() succeeds 
on a NOMMU setup. Oh well, lets disable it for now and see if anyone even 
wants revoke() for NOMMU.

Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> Does the SIGBUS raised have its own si_code, btw?  Perhaps BUS_REVOKED?

That's a good idea. I'll add one.

			Pekka
