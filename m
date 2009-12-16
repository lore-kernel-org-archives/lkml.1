Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbZLPNQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbZLPNQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 08:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbZLPNQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 08:16:38 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:41241 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbZLPNQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 08:16:37 -0500
Subject: Re: NFS lockdep lock misordering mmap_sem<->i_mutex_key with
 2.6.32-git1
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091216000924.GZ14381@ZenIV.linux.org.uk>
References: <20091207115949.GA7610@basil.fritz.box>
	 <20091207211216.E95E.A69D9226@jp.fujitsu.com>
	 <20091207132009.GI18989@one.firstfloor.org>
	 <20091215222134.GA27892@ZenIV.linux.org.uk>
	 <20091215233841.GE22392@basil.fritz.box>
	 <1260921277.3219.18.camel@localhost>
	 <20091216000924.GZ14381@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 08:16:32 -0500
Message-Id: <1260969392.3219.65.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 2 sum rcpts/h 10 sum msgs/h 2 total rcpts 2054 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 241B20CA82E52CF3635B509731AB172D1E2B7662
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 46 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 00:09 +0000, Al Viro wrote: 
> On Tue, Dec 15, 2009 at 06:54:37PM -0500, Trond Myklebust wrote:
> 
> > > nfs_revalidate_mapping takes i_mutex, but mmap already has mmap_sem
> > > hold and taking i_mutex inside mmap_sem is not allowed by the VFS.
> 
> VM, actually...
> 
> > If you want to work around the problem rather than going for something
> > like Peter's split up of the mmap() callback, then I'd suggest changing
> > to using nfs_revalidate_mapping_nolock() instead. The fact that we are
> > seeing these lock misordering warnings is proof that the call to
> > nfs_revalidate_mapping() is not always a no-op.
> > 
> > By not taking the i_mutex your call to invalidate_inode_pages2() can
> > potentially end up racing with another process that is writing to the
> > file, but that should be a rare occurrence. The effect will be that the
> > two processes can end up fighting to alternatively dirty and then clean
> > the pages...
> 
> Um...  The really interesting question is whether it's a false positive;
> *can* we hit the deadlock here?  getdents() is a red herring; write() and
> truncate() are real candidates.
> 
> What happens if we have one thread do mmap() while another (sharing the
> address space with it) does write() or truncate() on the same file?

If the two threads are sharing a VM then it looks to me as if they can
potentially deadlock.

The scenario would be that the writing thread triggers a page fault
(through __get_user()) when holding the i_mutex, while the other thread
is trying to grab the i_mutex within the mmap() call.

Cheers
  Trond

