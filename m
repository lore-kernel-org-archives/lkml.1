Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbZG2HP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbZG2HP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 03:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbZG2HP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 03:15:56 -0400
Received: from smtp-out.google.com ([216.239.45.13]:62578 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZG2HPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 03:15:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=IxPgrfb08p6yPTzdPBlNMSW3lMq1HWjEw3/R0FMb4mXoYA3BXRbi3ecR1Dr8EiTkM
	SvmY7wsRlahxf2S14U06w==
MIME-Version: 1.0
In-Reply-To: <33307c790907281449k5e8d4f6cib2c93848f5ec2661@mail.gmail.com>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com>
	 <33307c790907281449k5e8d4f6cib2c93848f5ec2661@mail.gmail.com>
Date: Wed, 29 Jul 2009 00:15:48 -0700
Message-ID: <33307c790907290015m1e6b5666x9c0014cdaf5ed08@mail.gmail.com>
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
From: Martin Bligh <mbligh@google.com>
To: Chad Talbott <ctalbott@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, wfg@mail.ustc.edu.cn,
       Michael Rubin <mrubin@google.com>, Andrew Morton <akpm@google.com>,
       sandeen@redhat.com, Michael Davidson <md@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 2:49 PM, Martin Bligh<mbligh@google.com> wrote:
>> An interesting recent-ish change is "writeback: speed up writeback of
>> big dirty files."  When I revert the change to __sync_single_inode the
>> problem appears to go away and background writeout proceeds at disk
>> speed.  Interestingly, that code is in the git commit [2], but not in
>> the post to LKML. [3]  This is may not be the fix, but it makes this
>> test behave better.
>
> I'm fairly sure this is not fixing the root cause - but putting it at the head
> rather than the tail of the queue causes the error not to starve wb_kupdate
> for nearly so long - as long as we keep the queue full, the bug is hidden.

OK, it seems this is the root cause - I wasn't clear why all the pages weren't
being written back, and thought there was another bug. What happens is
we go into write_cache_pages, and stuff the disk queue with as much as
we can put into it, and then inevitably hit the congestion limit.

Then we back out to __sync_single_inode, who says "huh, you didn't manage
to write your whole slice", and penalizes the poor blameless inode in question
by putting it back into the penalty box for 30s.

This results in very lumpy I/O writeback at 5s intervals, and very
poor throughput.

Patch below is inline and probably text munged, but is for RFC only.
I'll test it
more thoroughly tomorrow. As for the comment about starving other writes,
I believe requeue_io moves it from s_io to s_more_io which should at least
allow some progress of other files.

--- linux-2.6.30/fs/fs-writeback.c.old  2009-07-29 00:08:29.000000000 -0700
+++ linux-2.6.30/fs/fs-writeback.c      2009-07-29 00:11:28.000000000 -0700
@@ -322,46 +322,11 @@ __sync_single_inode(struct inode *inode,
                        /*
                         * We didn't write back all the pages.  nfs_writepages()
                         * sometimes bales out without doing anything. Redirty
-                        * the inode; Move it from s_io onto s_more_io/s_dirty.
+                        * the inode; Move it from s_io onto s_more_io. It
+                        * may well have just encountered congestion
                         */
-                       /*
-                        * akpm: if the caller was the kupdate function we put
-                        * this inode at the head of s_dirty so it gets first
-                        * consideration.  Otherwise, move it to the tail, for
-                        * the reasons described there.  I'm not really sure
-                        * how much sense this makes.  Presumably I had a good
-                        * reasons for doing it this way, and I'd rather not
-                        * muck with it at present.
-                        */
-                       if (wbc->for_kupdate) {
-                               /*
-                                * For the kupdate function we move the inode
-                                * to s_more_io so it will get more writeout as
-                                * soon as the queue becomes uncongested.
-                                */
-                               inode->i_state |= I_DIRTY_PAGES;
-                               if (wbc->nr_to_write <= 0) {
-                                       /*
-                                        * slice used up: queue for next turn
-                                        */
-                                       requeue_io(inode);
-                               } else {
-                                       /*
-                                        * somehow blocked: retry later
-                                        */
-                                       redirty_tail(inode);
-                               }
-                       } else {
-                               /*
-                                * Otherwise fully redirty the inode so that
-                                * other inodes on this superblock will get some
-                                * writeout.  Otherwise heavy writing to one
-                                * file would indefinitely suspend writeout of
-                                * all the other files.
-                                */
-                               inode->i_state |= I_DIRTY_PAGES;
-                               redirty_tail(inode);
-                       }
+                       inode->i_state |= I_DIRTY_PAGES;
+                       requeue_io(inode);
                } else if (inode->i_state & I_DIRTY) {
                        /*
                         * Someone redirtied the inode while were writing back
