Return-Path: <linux-kernel-owner+w=401wt.eu-S1762094AbYBZK10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762094AbYBZK10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 05:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbYBZK1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 05:27:16 -0500
Received: from phunq.net ([64.81.85.152]:53743 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754406AbYBZK1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 05:27:14 -0500
From: Daniel Phillips <phillips@phunq.net>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 00/37] Permit filesystem local caching
Date: Tue, 26 Feb 2008 02:26:26 -0800
User-Agent: KMail/1.9.5
Cc: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
References: <200802251643.16631.phillips@phunq.net> <22888.1203981562@redhat.com> <24873.1203991250@redhat.com>
In-Reply-To: <24873.1203991250@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802260226.26984.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need to respond to this in pieces... first the bit that is bugging
me:

> >   * two new page flags
> 
> I need to keep track of two bits of per-cached-page information:
> 
>  (1) This page is known by the cache, and that the cache must be informed if
>      the page is going to go away.

I still do not understand the life cycle of this bit.  What does the
cache do when it learns the page has gone away?  How is it informed?
Who owns the page cache in which such a page lives, the nfs client?
Filesystem that hosts the page?  A third page cache owned by the
cache itself?  (See my basic confusion about how many page cache
levels you have, below.)

Suppose one were to take a mundane approach to the persistent cache
problem instead of layering filesystems.  What you would do then is
change NFS's ->write_page and variants to fiddle the persistent
cache as well as the network, instead of just the network as now.
This fiddling could even consist of ->write calls to another
filesystem, though working directly with the bio interface would
yield the fastest, and therefore to my mind, best result.

In any case, you find out how to write the page to backing store by
asking the filesystem, which in the naive approach would be nfs
augmented with caching library calls.  The filesystem keeps its own
metadata around to know how to map the page to disk.  So again
naively, this metadata could tell the nfs client that the page is
not mapped to disk at all.  So I do not see what your per-page bit
is for, obviously because I do not fully understand your caching
scheme.  Which I could eventually find out by reading all the
patches but asking you is so much more fun :-)

By the way, how many levels of page caching for the same data are
there, is it:

  1) nfs client
  2) cache layer's own page cache
  3) filesystem hosting the cache

or just:

  1) nfs client page cache
  2) filesystem hosting the cache

I think it is the second, but that is already double caching, which
has got to hurt.

Regards,

Daniel
