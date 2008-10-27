Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbYJ0X3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbYJ0X3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 19:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbYJ0X2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 19:28:48 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:48298 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752967AbYJ0X2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 19:28:46 -0400
Date: Mon, 27 Oct 2008 19:28:43 -0400
From: Theodore Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: general protection fault:  from release_blocks_on_commit
Message-ID: <20081027232843.GA9797@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Eric Paris <eparis@redhat.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <1224612181.19719.20.camel@paris-laptop> <20081027181928.GB23111@mit.edu> <49064027.9010509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49064027.9010509@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 05:26:47PM -0500, Eric Sandeen wrote:
> Ted, you probably need some slab debugging on to hit it.

I had slab debugging enabled, but haven't been able to replicate it
yet.  I'll do some more work to try to replicate it.

> I think the problem is that jbd2_journal_commit_transaction may call
> __jbd2_journal_drop_transaction(journal, commit_transaction) if the
> checkpoint lists are NULL, and this frees the commit_transaction.

I think you're right.  I would probably change the patch around so
that after calling __jbd2_jurnal_drop_transaction(), we set
commit_transaction to NULL, and then adding an "if
(commit_transaction)" to the lines in questions; that way we keep the
commit callback outside of the j_list_lock() spinlock.

> Also, I'm not certain that it matters, but the loop in 
> release_blocks_on_commit() is kfreeing list entries w/o taking
> them off the list; I suppose maybe this is safe if the whole thing
> is getting discarded when we're done, but just to keep things sane,
> would this make sense

There are plenty of other loops in the kernel where we go through the
linked list and free all of the items on the list that don't bother to
call list_del().  That was one of the things I checked when I created
the patch.

> (also, I think we need to double-check use of
> s_md_lock; it's taken when adding things to the list, but not when
> freeing/removing ... if it's needed, isn't it needed on both ends...):

No, because the linked list is hanging off the transaction structure.
While the transaction is active, multiple CPU's can be adding elements
to the linked list.  But once the transaction has been committed, we
don't have to worry about any one else trying to modify the linked list.

      	      	    	      	       	      - Ted
