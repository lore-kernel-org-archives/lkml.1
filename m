Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbYLSEKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbYLSEKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 23:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYLSEK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 23:10:26 -0500
Received: from mail.fieldses.org ([66.93.2.214]:58219 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbYLSEKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 23:10:25 -0500
Date: Thu, 18 Dec 2008 23:09:52 -0500
To: "Muntz, Daniel" <Dan.Muntz@netapp.com>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, sfr@canb.auug.org.au,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org, steved@redhat.com,
       linux-fsdevel@vger.kernel.org, rwheeler@redhat.com
Subject: Re: Pull request for FS-Cache, including NFS patches
Message-ID: <20081219040952.GB7552@fieldses.org>
References: <7633.1229653644@redhat.com> <7A24DF798E223B4C9864E8F92E8C93EC01AAF3F8@SACMVEXC1-PRD.hq.netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7A24DF798E223B4C9864E8F92E8C93EC01AAF3F8@SACMVEXC1-PRD.hq.netapp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 07:45:57PM -0800, Muntz, Daniel wrote:
> Local disk cache was great for AFS back around 1992.  Typical networks
> were 10 or 100Mbps (slower than disk access at the time),

Would a disk cache on SSD make any sense?  Seems like it'd change the
latency tradeoff.

> and memories
> were small (typical 16MB).  FS-Cache appears to help only with read
> traffic--one reason why the web loves caching--and only for reads that
> would miss the buffer/page cache (memories are now "large").  Solaris
> has had CacheFS since ~1995, HPUX had a port of it since ~1997.  I'd be
> interested in evidence of even a small fraction of Solaris and/or HPUX
> shops using CacheFS.  I am aware of customers who thought it sounded
> like a good idea, but ended up ditching it for various reasons (e.g.,
> CacheFS just adds overhead if you almost always hit your local mem
> cache).

More details on the experiences of RHEL/Fedora users might be
interesting.  My (vague, mostly uniformed) impression is that the group
of people who think they need it is indeed a lot larger than the group
who really do need it--but that the latter group still exists.

--b.

> 
> One argument in favor that I don't see here is that local disk cache is
> persistent (I'm assuming it is in your implementation).
> 
> Addressing 1 and 2 in your list, I'd be curious how often a miss in core
> is a hit on disk.
> Number 3 scares me.  How does this play with the expected semantics of
> NFS?
> Number 5 is hard, if not provably requiring human intervention to do
> syncs when writes are involved (see Disconnected AFS work by
> UM/CITI/Huston, and work at CMU).
> Add persistence as number 6.  This may be the best reason to have it,
> imho.
> 
>   -Dan
> 
> -----Original Message-----
> From: David Howells [mailto:dhowells@redhat.com] 
> Sent: Thursday, December 18, 2008 6:27 PM
> To: Andrew Morton
> Cc: sfr@canb.auug.org.au; linux-kernel@vger.kernel.org;
> nfsv4@linux-nfs.org; steved@redhat.com; dhowells@redhat.com;
> linux-fsdevel@vger.kernel.org; rwheeler@redhat.com
> Subject: Re: Pull request for FS-Cache, including NFS patches
> 
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I don't believe that it has yet been convincingly demonstrated that we
> 
> > want to merge it at all.
> > 
> > It's a huuuuuuuuge lump of new code, so it really needs to provide 
> > decent value.  Can we revisit this?  Yet again?  What do we get from 
> > all this?
> 
> I should tell you to go and reread LKML at this point.
> 
> But...  What can FS-Cache do for you?  Well, in your specific case,
> probably nothing.  If all your computers are local to your normal
> desktop box and are connected by sufficiently fast network and you have
> sufficiently few of them, or you don't use any of NFS, AFS, CIFS,
> Lustre, CRFS, CD-ROMs then it is likely that won't gain you anything.
> 
> Even if you do use some of those "netfs's", it won't get you anything
> yet because I haven't included patches to support anything other than
> NFS and the in-kernel AFS client yet.
> 
> However, if you do use NFS (or my AFS client), and you are accessing
> computers via slow networks, or you have lots of machines spamming your
> NFS server, then it might avail you.
> 
> It's a compromise: a trade-off between the loading and latencies of your
> network vs the loading and latencies of your disk; you sacrifice disk
> space to make up for the deficiencies of your network.  The worst bit is
> that the latencies are additive under some circumstances (when doing a
> page read you may have to check disk and then go to the network).
> 
> 
> So, FS-Cache can do the following for you:
> 
>  (1) Allow you to reduce network loading by diverting repeat reads to
> local
>      storage.
> 
>  (2) Allow you to reduce the latency of slow network links by diverting
> repeat
>      reads to local storage.
> 
>  (3) Allow you to reduce the effect of uncontactable servers by serving
> data
>      out of local storage.
> 
>  (4) Allows you to reduce the latency of slow rotating media (such as
> CDROM
>      and CD-changers).
> 
>  (5) Allow you to implement disconnected operation, partly by (3), but
> also by
>      caching changes for later syncing.
> 
> Now, (1) and (2) are readily demonstrable.  I have posted benchmarks to
> do this.  (3) to (5) are not yet implemented; these have to be mostly
> implemented in the filesystems that use FS-Cache rather than FS-Cache
> itself.  FS-Cache currently has sufficient functionality to do (3) and
> (4), but needs some extra bits to do (5).
> 
> I've tried to implement just the minimal useful functionality for
> persistent caching.  There is more to be added, but it's not immediately
> necessary.
> 
> 
> FS-Cache tries to make its facilities as simple and as general as
> possible so that _any_ filesystem or blockdev can use it.  I have
> patches here to make NFS and AFS use it.  I know someone is working on
> getting Lustre to use it, and other filesystem maintainers have
> expressed interest, subject to the code getting upstream.
> 
> Furthermore, FS-Cache hides the implementation of the cache from the
> netfs.
> Not only that, it hides I/O errors in the cache from the netfs.  Why
> should the netfs have to deal with such things?
> 
> 
> Another way to look at things is to look at other cases of cached
> netfs's.
> OpenAFS for example.  It has a local cache of its own.  Solaris has
> local NFS caching.  Windows has local caching for NFS and CIFS, I think.
> Even web browsers have local caching.
> 
> >  303 files changed, 21049 insertions(+), 3726 deletions(-)
> 
> A big chunk of that, particularly the deletions, is the creds patches.
> Excluding the stuff pulled from the security and NFS trees, the combined
> FS-Cache, CacheFiles and AFS+ and NFS+FS-Cache patches are, in fact:
> 
> 	86 files changed, 15385 insertions(+), 413 deletions(-)
> 
> and over 19% of the insertions is documentation.  Most of the deletions
> (373) are in AFS.
> 
> > Are any distros pushing for this?  Or shipping it?  If so, are they 
> > able to weigh in and help us with this quite difficult decision?
> 
> We (Red Hat) have shipped it in RHEL-5 and some Fedora releases.  Doing
> so is quite an effort, though, precisely because the code is not yet
> upstream.  We have customers using it and are gaining more customers who
> want it.  There even appear to be CentOS users using it (or at least
> complaining when it breaks).
> 
> 
> I don't know what will convince you.  I've given you theoretical reasons
> why caching ought to be useful; I've backed up the ones I've implemented
> with benchmarks; I've given you examples of what our customers are doing
> with it or want to do with it.  Please help me understand what else you
> want.
> 
> Do you perhaps want the netfs maintainers (such as Trond) to say that
> it's necessary?
> 
> David
> _______________________________________________
> NFSv4 mailing list
> NFSv4@linux-nfs.org
> http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4
> _______________________________________________
> NFSv4 mailing list
> NFSv4@linux-nfs.org
> http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4
