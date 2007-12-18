Return-Path: <linux-kernel-owner+w=401wt.eu-S934698AbXLRHIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934698AbXLRHIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 02:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbXLRHIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 02:08:09 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:48086 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758561AbXLRHIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 02:08:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WXyl0UnET+MRZrreXFFfA+U1EhOyBvJbmtcgaiqLiuP+uLKkkAkl8slbBszb3RsK3DJpncmqMdKrYREhJvopcZJhQQ2kbWAABWnlLeyf+X7yzzHFVG5RlrvVWugUikn5dnBD4klKKv28KQHGlTbV13DgvJc3loxVFJeZDTpFDOk=  ;
X-YMail-OSG: RTLBS10VM1mMejW6uV4Ebt7o4xlxQg12Lk7YCbNWRogrcH_hiEihYeMG6eWXsS0gxCX_jw5J9g--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/28] AFS: Add a function to excise a rejected write from the pagecache [try #2]
Date: Tue, 18 Dec 2007 18:07:53 +1100
User-Agent: KMail/1.9.5
Cc: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
References: <200712141521.24227.nickpiggin@yahoo.com.au> <20071205194020.24617.28880.stgit@warthog.procyon.org.uk> <731.1197932071@redhat.com>
In-Reply-To: <731.1197932071@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712181807.53907.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 December 2007 09:54, David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > This reintroduces the fault vs truncate race window, which must be fixed.
>
> Hmmm...  perhaps.

What do you mean by perhaps?


> I remember that cropped up in NFS, but I'm doing things 
> a bit differently to NFS.  Remind me again how that worked please.

How what worked? NFS is using invalidate inode pages quite frequently
so it ran into the race more often.


> > Also, it is adding a fair bit of complexity in an area where we should
> > instead be reducing it. I think your filesystem should not be doing
> > writeback caching of dirty data in the cases where it is so problematic
> > (or at least, disallow mmap and read on the dirty data until it has been
> > written back or failed).
>
> Eh?  It's a stateless network filesystem.  There's a gap between writing to
> a file (perhaps though an mmap) and the pagecache pages being written back
> in which someone may change the security on a file and block the writeback.
> There's nothing I can do to prevent it, so I have to instead deal with the
> consequences should they arise.  See the description of patch 25 for
> examples.
>
> So you say I shouldn't do any writeback caching at all?

No, you could do writeback caching but disallow read of dirty data. But
yeah, a coherent mmap isn't possible then, I guess.


> > But otherwise I guess if you really want to discard the dirty data after
> > a failed writeback attempt, what's wrong with just
> > invalidate_inode_pages2?
>
> Erm...  Because it deadlocks?

Why don't you call it after calling end_page_writeback?
