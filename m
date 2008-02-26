Return-Path: <linux-kernel-owner+w=401wt.eu-S1764675AbYBZVKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764675AbYBZVKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbYBZVKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:10:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbYBZVKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:10:19 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200802261143.28348.phillips@phunq.net>
References: <200802261143.28348.phillips@phunq.net> <200802260226.26984.phillips@phunq.net> <24873.1203991250@redhat.com> <27528.1204036418@redhat.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: dhowells@redhat.com, Trond.Myklebust@netapp.com, chuck.lever@oracle.com,
       casey@schaufler-ca.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/37] Permit filesystem local caching
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 26 Feb 2008 21:09:09 +0000
Message-ID: <2140.1204060149@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips <phillips@phunq.net> wrote:

> > Note further that NFS's write_page() != writing to the cache.  Writing to
> > the cache is typically done by NFS's readpages().
> 
> Yes, of course.  But also by ->write_page no?

Theoretically, perhaps, but currently, no.

> 37 Patches, none of which has "Documentation" in the subject line,

Each piece of documentation is included in the patch to which it applies.
Besides, I, like everyone else, always write full documentation for interfaces
that I add, so you should have expected it to be there, right? :-)

> and you did not provide a diffstat in patch 0 for the patch set as a whole.

StGIT doesn't do that.  Besides, it's redundant information.  I'll add
something to the cover note that points out the documentation.

> One bit that already came out of this, which you have alluded to
> several times yourself but somehow seem to keep glossing over, is that
> you need a ->direct_bio file operations method.

Which I am not allowed.  I have suggested it, and it has been refused.  The
problem, as I understand it, is that this would mean BIOs external to the
filesystem which the filesystem would need additional way of keeping track of.
You have to consider that a filesystem can't rearrange any bits of itself that
have I/O in progress on them.

Furthermore, a BIO may not be appropriate.  Consider ReiserFS's tail packing,
or consider an encrypted filesystem, or, worse, a compressed filesystem.  Also,
what if the filesystem isn't backed by a blockdev?

> So does loopback mount.  It might be worth putting some effort into seeing
> how ->direct_IO can be refactored to make that happen.

Have you looked at the horrible tangle of spaghetti that is the current Linux
direct I/O model?  It would take a lot of effort to refactor it.  I've made a
couple of attempts, but the assumptions it makes make it hard.

A separate, clean, in-kernel direct-IO thing would be an easier way to go - but
it's not actually necessary at the moment.

> You can get it in separately on the basis of helping loopback, and it will
> make your patches nicer.

It will make very little difference to the code.  It would improve cachefiles's
cf-rdwr.c, yes, and it ought to improve performance.

David
