Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbYGBRhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbYGBRhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 13:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYGBRha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 13:37:30 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:52267 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbYGBRh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 13:37:29 -0400
Subject: Re: nfs client readdir caching issue?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andy Chittenden <andyc@bluearc.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <0F10A59FDFFDFD4E9BEBD7365DE6725501EC3707@uk-email.terastack.bluearc.com>
References: <0F10A59FDFFDFD4E9BEBD7365DE6725501EC3707@uk-email.terastack.bluearc.com>
Content-Type: text/plain
Date: Wed, 02 Jul 2008 13:37:25 -0400
Message-Id: <1215020245.9783.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: FC14DCE729CBF94DF8150C7532080083D8D9D351
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 194 total 9086676 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-02 at 12:03 +0100, Andy Chittenden wrote:
> Very rarely, we're seeing various problems on a linux kernel client
> (seen on various versions) with ls on directories from an NFS server
> that haven't changed:
> 
> * looping ls (strace -v shows getdents returning the same names over
> again).
> * duplicate directory entries.
> * missing directory entries.
> 
> I've hunted google but can only see problems where NFS servers have
> returned duplicate cookies. I've packet captured the readdirplus on one
> of the directories and see no duplicate cookies. The problems remain
> until the directory is touched, the NFS server is unmounted or some
> other event happens (the data is flushed from the cache?).
> 
> I think we then got lucky and got two packet captures from different
> clients running the same linux kernel. On these clients, the ls output
> was ok - no loops, no duplicates, no missing entries. Both captures
> showed two readdirplus requests returning the same entries in the same
> order but the amount of data in the responses was different. One capture
> showed the server returned 1724 bytes, 10 entries, last cookie of 12,
> followed by the next readdirplus returning a length of 948 bytes, 5
> entries, a first cookie value of 13. In the other capture, the responses
> returned 2204 bytes, 13 entries, a last cookie of 17 and 468 bytes, 2
> entries, a first cookie of 19.
> 
> In the past we've found that ls has returned duplicate entries on this
> directory (but didn't have a capture at the time) and those duplicate
> entries are the ones that are returned as the last 3 entries in the
> first response of the second capture and the first 3 entries in the
> second response of the first capture.
> 
> So what I think has happened in this particular case, is that at some
> point in the past, the directory was read OK with packets similar to the
> first capture. Next, the client decided to get rid of the first page of
> cached readdir responses from memory for some reason (running low on
> memory?) but kept the second page. Subsequently, the readdir cache needs
> repopulating so the client sends a readdirplus specifying cookie of 0
> and this time it gets a response which is similar to the first packet of
> the second capture and thus we now have in cache duplicate names and
> cookie values.
> 
> So is this possible? Is there some easy way to provoke it? Does this
> mean the client's readdir cache is broken?

If so, then invalidate_inode_pages2_range() would have to be broken: we
always clear the readdir cache immediately after reading in the page
with index 0 (i.e. the first readdir page).

It shouldn't be possible for another thread to race with that cache
invalidation either since the entire readdir() call is protected by the
parent directory's inode->i_mutex.

Cheers
  Trond

