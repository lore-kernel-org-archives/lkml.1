Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbYLaLPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbYLaLPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 06:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbYLaLP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 06:15:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38325 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbYLaLP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 06:15:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1230679056.11508.37.camel@heimdal.trondhjem.org>
References: <1230679056.11508.37.camel@heimdal.trondhjem.org> <7A24DF798E223B4C9864E8F92E8C93EC01AAFE6E@SACMVEXC1-PRD.hq.netapp.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: dhowells@redhat.com, "Muntz, Daniel" <Dan.Muntz@netapp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Bernd Schubert <bernd.schubert@fastmail.fm>, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, steved@redhat.com,
       linux-next@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       rwheeler@redhat.com
Subject: Re: Pull request for FS-Cache, including NFS patches
Date: Wed, 31 Dec 2008 11:15:02 +0000
Message-ID: <29970.1230722102@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> Unless you _are_ root and can check every executable, after presumably
> rebooting into your own trusted kernel, then those requirements won't
> mean squat. If you're that paranoid, then you will presumably also be
> using a cryptfs-encrypted partition for cachefs, which you unmount when
> you're not logged in.

Actually...  Cachefiles could fairly trivially add encryption.  It would have
to be simple encryption but you wouldn't have to store any keys locally.

Currently cachefiles _copies_ data between the backingfs and the netfs pages
because the direct-IO code is only usable to/from userspace.  Rather than
copying, encrypt/decrypt could be called.

A key could be constructed at the point a cache file is looked up.  It could
be constructed from the coherency data.  In the case of NFS that would be
mtime, ctime, isize and change_attr.  The coherency data would be encrypted
with this key and then stored on disk, as would the contents of the file.

It might be possible to chuck the cache key (NFS fh) into the encryption key
too and also encrypt the cache key before it is turned into a filename, though
we'd have to be careful to avoid collisions if each filename is encrypted with
a different key.

We'd probably have to be careful about the coherency data decrypting with a
different key showing up as the wrong but valid thing.

The nice thing about this is that the key need not be retained locally since
it's entirely constructed from data fetched from the netfs.

David
