Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbXEXWfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbXEXWfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXEXWfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:35:25 -0400
Received: from pat.uio.no ([129.240.10.15]:54455 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbXEXWfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:35:24 -0400
Subject: Re: [PATCH 2/4] AFS: Add a function to excise a rejected write
	from the pagecache
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <27608.1180042522@redhat.com>
References: <20070524133821.3ee9c9f3.akpm@linux-foundation.org>
	 <20070523191518.24135.81257.stgit@warthog.cambridge.redhat.com>
	 <20070523191524.24135.2609.stgit@warthog.cambridge.redhat.com>
	 <27608.1180042522@redhat.com>
Content-Type: text/plain
Date: Thu, 24 May 2007 18:35:15 -0400
Message-Id: <1180046115.8872.27.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.139)
X-UiO-Scanned: E3FA4C0D602B7EBFE994EFE6E248D33543E232FC
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 527 total 1943480 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 22:35 +0100, David Howells wrote:
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Could you please flesh this out a bit, from a higher level?
> 
> See the description for patch 3/4.
> 
> > As in: what does it mean for a server to "reject" a write? What's actually
> > going on here?
> 
> Simply, it means that the server refused to perform the write.  The example I'm
> thinking of is that it refused to do so because the ACL governing that file
> changed between the permission() check and the attempt to write the data back.
> 
> All it takes is a write-back cache and a tiny little delay between the copy to
> page cache and the write back to the server and there's a window in which
> another client can leap in and make it impossible for the client to write the
> data.
> 
> There are other possibilities, for instance:
> 
>  (1) The key governing the writeback expires.
> 
>  (2) The user's account is deleted or disabled.
> 
> The file being deleted is handled elsewhere.  In such a case, everyone's
> writes are just discarded.
> 
> > Why does the server do this?
> 
> Because it's told to by some other client.  Think chmod, or in AFS's case:
> 
> 	fs setacl -dir . -acl system:administrators rlidka
> 
> This removes write access by not including a 'w' amongst 'rlidka'.
> 
> (Note in AFS, the ACLs attached to a directory control the files in that
> directory).
> 
> > I assume that the application will see a short write or an EIO or something?
> 
> EACCES or similar most likely.  In AFS's case you should get an abort with some
> appropriate error code.  This is then mapped to EACCES, EKEYREVOKED,
> EKEYEXPIRED, etc.
> 
> > How does this interact with MAP_SHARED?
> 
> MAP_SHARED/PROT_WRITE is just another way of doing writes to the pagecache.  It
> isn't really special.  The way I've done it is to use page_mkwrite() to track
> the key with which a write through a mapping is written back.
> 
> > Do we expect that any other networked filesystem would want to do this? 
> > (and if not, why not?) Or do they already attempt to do it in some other
> > fashion?
> 
> _Any_ network filesystem that (a) has access controls, and (b) does writeback
> caching (be the interval ever so brief) is liable to this issue.  It could
> possible for a netfs to avoid with this by getting a guarantee that the write
> will be accepted upfront (CIFS might do this), or by blocking attempts to
> change the access controls through some sort of locking (again CIFS might do
> this).
> 
> However, looking at NFS, it appears that NFS may be liable to this problem.  It
> does appear to use writeback caching, though it flushes its writes back fairly
> promptly making it quite difficult to test.  I talked to Steve Dickson about
> this, and I get the impression that NFS will just sit their and keep retrying
> the writeback.

No. If the write fails, then NFS will mark the mapping as invalid and
attempt to call invalidate_inode_pages2() at the earliest possible
moment.

I'm adding in a patch to defer marking the page as uptodate until the
write is successful in cases where NFS is writing a pristine page.

As for pages that are already marked as uptodate, well you already have
a race: you have deferred the page write, and so other processes may
already have read the rejected data before you tried to write it out.

Trond

