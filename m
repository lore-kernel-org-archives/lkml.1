Return-Path: <linux-kernel-owner+w=401wt.eu-S932184AbXDMTzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbXDMTzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 15:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964793AbXDMTzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 15:55:45 -0400
Received: from smtp.osdl.org ([65.172.181.24]:48331 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184AbXDMTzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 15:55:43 -0400
Date: Fri, 13 Apr 2007 12:55:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] make iunique use a do/while loop rather than its
 obscure goto loop
Message-Id: <20070413125512.af11f013.akpm@linux-foundation.org>
In-Reply-To: <461FD536.80903@redhat.com>
References: <200704112158.l3BLwunk023090@dantu.rdu.redhat.com>
	<20070413114214.cb9328f5.akpm@linux-foundation.org>
	<461FD536.80903@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 15:08:38 -0400
Jeff Layton <jlayton@redhat.com> wrote:

> > 
> > ino_t iunique(struct super_block *sb, ino_t max_reserved)
> > {
> > 	static ino_t counter;
> > 	struct inode *inode;
> > 	struct hlist_head * head;
> > 	ino_t res;
> > 
> > 	spin_lock(&inode_lock);
> > 	do {
> > 		if (counter <= max_reserved)
> > 			counter = max_reserved + 1;
> > 		res = counter++;
> > 		head = inode_hashtable + hash(sb, res);
> > 		inode = find_inode_fast(sb, head, res);
> > 	} while (inode != NULL);
> > 	spin_unlock(&inode_lock);
> > 
> > 	return res;
> > }
> > 
> > The counter-vs-max_reserved test can be moved outside the loop, can't it?
> > 
> 
> No. If the counter wraps while we're looping, then we'll need to skip 
> past the "reserved" inode numbers. So we need to check this on every 
> loop iteration.

oh.

(wonders why alpha and s390 use unsigned int for ino_t while everyone
else uses unsigned long)

> We could potentially put that in an "unlikely" if you 
> think that would be better.

Doubt if it'd make much difference.

> > Shouldn't counter be per-sb?
> 
> I doubt it really matters too much, but it could potentially be more 
> efficient to do that, especially after a wraparound on the counter. It 
> might be reasonable to make new_inode use a per-sb counter as well. Do 
> you think it's worth respinning?

Well, that'd be a separate patch.  Sometime, if you're keen.

If that function is ever a performance problem, it'll be an awful
performance problem and we'd need to so something smarter than
a linear search - an idr tree, for example.
