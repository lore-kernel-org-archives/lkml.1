Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbXIGUf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbXIGUf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 16:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbXIGUfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 16:35:51 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:35554 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbXIGUfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 16:35:50 -0400
X-Greylist: delayed 2074 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Sep 2007 16:35:50 EDT
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Bernd Schubert <bs@q-leap.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       brian@clusterfs.com,
       Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: patch: improve generic_file_buffered_write() (2nd try 1/2)
References: <200709051546.06224.bs@q-leap.de>
	<20070905083529.a1c8a0a9.randy.dunlap@oracle.com>
	<200709051941.56145.bs@q-leap.de>
	<200709081415.54211.nickpiggin@yahoo.com.au>
Date: Fri, 07 Sep 2007 22:01:08 +0200
In-Reply-To: <200709081415.54211.nickpiggin@yahoo.com.au> (Nick Piggin's
	message of "Sat, 8 Sep 2007 14:15:53 +1000")
Message-ID: <87odgeckjf.fsf@informatik.uni-tuebingen.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> On Thursday 06 September 2007 03:41, Bernd Schubert wrote:
> Minor nit: when resubmitting a patch, you should include everything
> (ie. the full changelog of problem statement and fix description) in a
> single mail. It's just a bit easier...

Will do next time.

> So I believe the problem is that for a multi-segment iovec, we currently
> prepare_write/commit_write once for each segment, right? We do this

It is more complex.

Currently a __grab_cache_page, a_ops->prepare_write,
filemap_copy_from_user[_iovec] and a_ops->commit_write is done
whenever we hit

  a) a page boundary
  b) a segment boundary

Those two cases don't have to, and from the stats basically never,
coincide. For NFSd this means we do this TWICE per segment and TWICE
per page.

> because there is a nasty deadlock in the VM (copy_from_user being
> called with a page locked), and copying multiple segs dramatically
> increases the chances that one of these copies will cause a page fault
> and thus potentially deadlock.

What actually locks the page? Is it __grab_cache_page or
a_ops->prepare_write?

Note that the patch does not change the number of copy_from_user calls
being made nor does it change their arguments. If we need 2 (or more)
segments to fill a page we still do 2 seperate calls to
filemap_copy_from_user_iovec, both only spanning (part of) one
segment.

What the patch changes is the number of copy_from_user calls between
__grab_cache_page and a_ops->commit_write.

Copying a full PAGE_SIZE bytes from multiple segments in one go would
be a further improvement if that is possible.

> The fix you have I don't think can work because a filesystem must be
> notified of the modification _before_ it has happened. (If I understand
> correctly, you are skipping the prepare_write potentially until after
> some data is copied?).

Yes. We changed the order of copy_from_user calls and
a_ops->prepare_write by mistake. We will rectify that and do the
prepare_write for the full page (when possible) before copying the
data into the page.

> Anyway, there are fixes for this deadlock in Andrew's -mm tree, but
> also a workaround for the NFSD problem in git commit 29dbb3fc. Did
> you try a later kernel to see if it is fixed there?

Later than 2.6.23-rc5?

> Thanks,
> Nick

MfG
        Goswin
