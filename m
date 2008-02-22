Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbYBVQPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbYBVQPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbYBVQPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:15:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbYBVQPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:15:01 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200802220852.26584.chris.mason@oracle.com>
References: <200802220852.26584.chris.mason@oracle.com> <28196.1203605703@redhat.com> <20080220160557.4715.66608.stgit@warthog.procyon.org.uk> <17916.1203636833@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: dhowells@redhat.com, Daniel Phillips <phillips@phunq.net>,
       Trond.Myklebust@netapp.com, chuck.lever@oracle.com,
       casey@schaufler-ca.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/37] Permit filesystem local caching
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 22 Feb 2008 16:12:24 +0000
Message-ID: <18998.1203696744@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason <chris.mason@oracle.com> wrote:

> > The interesting case is where the disk cache is warm, but the pagecache is
> > cold (ie: just after a reboot after filling the caches).  Here, for the two
> > big files case, BTRFS appears quite a bit better than Ext3, showing a 21%
> > reduction in time for the smaller case and a 13% reduction for the larger
> > case.
> 
> I'm afraid I don't have a good handle on the filesystem operations that
> result from this workload.  Are we reading from the FS to fill the NFS page
> cache?

I'm not sure what you're asking.

When the cache is cold, we determine that we can't read from the cache very
quickly.  We then read data from the server and, in the background, create the
metadata in the cache and store the data to it (by copying netfs pages to
backingfs pages).

When the cache is warm, we read the data from the cache, copying the data from
the backingfs pages to the netfs pages.  We use bmap() to ascertain that there
is data to be read, otherwise we detect a hole and fallback to reading from
the server.

Looking up cache object involves a sequence of lookup() ops and getxattr() ops
on the backingfs.  Should an object not exist, we defer creation of that
object to a background thread and do lookups(), mkdirs() and setxattrs() and a
create() to manufacture the object.

We read data from an object by calling readpages() on the backingfs to bring
the data into the pagecache.  We monitor the PG_lock bits to find out when
each page is read or has completed with an error.

Writing pages to the cache is done completely in the background.
PG_fscache_write is set on a page when it is handed to fscache to storage,
then at some point a background thread wakes up and calls write_one_page() in
the backingfs to write that page to the cache file.  At the moment, this
copies the data into a backingfs page which is then marked PG_dirty, and the
VM writes it out in the usual way.

> > More surprising is that BTRFS performed significantly worse (15% increase
> > in time) in the case where the cache on disk was fully populated and then
> > the machine had been rebooted to clear the pagecaches.
> 
> Which FS operations are included here?  Finding all the files or just an 
> unmount?  Btrfs defrags metadata in the background, and unmount has to wait 
> for that defrag to finish.

BTRFS might not be doing any writing at all here - apart from local atimes
(used by cache culling), that is.

What it does have to do is lots of lookups, reads and getxattrs, all of which
are synchronous.

David
