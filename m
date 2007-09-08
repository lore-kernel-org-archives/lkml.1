Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbXIGUbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbXIGUbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 16:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbXIGUbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 16:31:08 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:29090 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753664AbXIGUbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 16:31:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GweKYr9NArbgdm5g6EjH4rjhfcxS+KYemNTxvQwRqmxCA/QtFyfAkRVrttT24TcmmK+6hIB/CtuX+iM+DhaenyOipwh5i25KrR+iVbuYkCvWAVBbJGUW0cMnn3OmlkqgeQg2YL+ZstEnrO54Q9846kC8p5pespOPceaUV5mVwtk=  ;
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: patch: improve generic_file_buffered_write() (2nd try 1/2)
Date: Sat, 8 Sep 2007 16:28:27 +1000
User-Agent: KMail/1.9.5
Cc: Bernd Schubert <bs@q-leap.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       brian@clusterfs.com
References: <200709051546.06224.bs@q-leap.de> <200709081415.54211.nickpiggin@yahoo.com.au> <87odgeckjf.fsf@informatik.uni-tuebingen.de>
In-Reply-To: <87odgeckjf.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709081628.27310.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 September 2007 06:01, Goswin von Brederlow wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> > On Thursday 06 September 2007 03:41, Bernd Schubert wrote:
> > Minor nit: when resubmitting a patch, you should include everything
> > (ie. the full changelog of problem statement and fix description) in a
> > single mail. It's just a bit easier...
>
> Will do next time.
>
> > So I believe the problem is that for a multi-segment iovec, we currently
> > prepare_write/commit_write once for each segment, right? We do this
>
> It is more complex.
>
> Currently a __grab_cache_page, a_ops->prepare_write,
> filemap_copy_from_user[_iovec] and a_ops->commit_write is done
> whenever we hit
>
>   a) a page boundary

This is required by the prepare_write/commit_write API. The write_begin
/ write_end API is also a page-based one, but in future, we are looking
at having a more general API but we haven't completely decided on the
form yet. "perform_write" is one proposal you can look for.


>   b) a segment boundary

This is done, as I said, because of the deadlock issue. While the issue is
more completely fixed in -mm, a special case for kernel memory (eg. nfsd)
is in the latest mainline kernels.


> Those two cases don't have to, and from the stats basically never,
> coincide. For NFSd this means we do this TWICE per segment and TWICE
> per page.

The page boundary doesn't matter so much (well it does for other reasons,
but we've never been good at them...). The segment boundary means that
we aren't able to do block sized writes very well and end up doing a lot of
read-modify-write operations that could be avoided.


> > because there is a nasty deadlock in the VM (copy_from_user being
> > called with a page locked), and copying multiple segs dramatically
> > increases the chances that one of these copies will cause a page fault
> > and thus potentially deadlock.
>
> What actually locks the page? Is it __grab_cache_page or
> a_ops->prepare_write?

prepare_write must be given a locked page.


> Note that the patch does not change the number of copy_from_user calls
> being made nor does it change their arguments. If we need 2 (or more)
> segments to fill a page we still do 2 seperate calls to
> filemap_copy_from_user_iovec, both only spanning (part of) one
> segment.
>
> What the patch changes is the number of copy_from_user calls between
> __grab_cache_page and a_ops->commit_write.

So you're doing all copy_from_user calls within a prepare_write? Then
you're increasing the chances of deadlock. If not, then you're breaking
the API contract.


> Copying a full PAGE_SIZE bytes from multiple segments in one go would
> be a further improvement if that is possible.
>
> > The fix you have I don't think can work because a filesystem must be
> > notified of the modification _before_ it has happened. (If I understand
> > correctly, you are skipping the prepare_write potentially until after
> > some data is copied?).
>
> Yes. We changed the order of copy_from_user calls and
> a_ops->prepare_write by mistake. We will rectify that and do the
> prepare_write for the full page (when possible) before copying the
> data into the page.

OK, that is what used to be done, but the API is broken due to this
deadlock. write_begin/write_end fixes it properly.


> > Anyway, there are fixes for this deadlock in Andrew's -mm tree, but
> > also a workaround for the NFSD problem in git commit 29dbb3fc. Did
> > you try a later kernel to see if it is fixed there?
>
> Later than 2.6.23-rc5?

No it would be included earlier. The "segment_eq" check should be
allowing kernel writes (nfsd) to write multiple segments. If you have a
patch which changes this significantly, then it would indicate the
existing logic has a problem (or you've got a userspace application doing
the writev, which should be fixed by the write_begin patches in -mm).
