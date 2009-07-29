Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbZG2OLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbZG2OLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 10:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZG2OLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 10:11:16 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3449 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbZG2OLQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 10:11:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=d6tfNQQcWvcQ1gpJGCW1oxzUKUO74EzWuxLDVBRAymcBcHgbNjCovI/rAcKLN5r/1
	l995T82Oc5+xydLEe/NRw==
MIME-Version: 1.0
In-Reply-To: <20090729114322.GA9335@localhost>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com>
	 <33307c790907281449k5e8d4f6cib2c93848f5ec2661@mail.gmail.com>
	 <33307c790907290015m1e6b5666x9c0014cdaf5ed08@mail.gmail.com>
	 <20090729114322.GA9335@localhost>
Date: Wed, 29 Jul 2009 07:11:10 -0700
Message-ID: <33307c790907290711s320607b0i79c939104d4c2d61@mail.gmail.com>
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
From: Martin Bligh <mbligh@google.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chad Talbott <ctalbott@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Michael Rubin <mrubin@google.com>,
       Andrew Morton <akpm@google.com>, sandeen@redhat.com,
       Michael Davidson <md@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- mm.orig/fs/fs-writeback.c
> +++ mm/fs/fs-writeback.c
> @@ -325,7 +325,8 @@ __sync_single_inode(struct inode *inode,
>                                 * soon as the queue becomes uncongested.
>                                 */
>                                inode->i_state |= I_DIRTY_PAGES;
> -                               if (wbc->nr_to_write <= 0) {
> +                               if (wbc->nr_to_write <= 0 ||
> +                                   wbc->encountered_congestion) {
>                                        /*
>                                         * slice used up: queue for next turn
>                                         */
>

That's not sufficient - it only the problem in the wb_kupdate path. If you want
to be more conservative, how about we do this?

--- linux-2.6.30/fs/fs-writeback.c.old  2009-07-29 00:08:29.000000000 -0700
+++ linux-2.6.30/fs/fs-writeback.c      2009-07-29 07:08:48.000000000 -0700
@@ -323,43 +323,14 @@ __sync_single_inode(struct inode *inode,
                         * We didn't write back all the pages.  nfs_writepages(
)
                         * sometimes bales out without doing anything. Redirty
                         * the inode; Move it from s_io onto s_more_io/s_dirty.
+                        * It may well have just encountered congestion
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
-                                * other inodes on this superblock will get som
e
-                                * writeout.  Otherwise heavy writing to one
-                                * file would indefinitely suspend writeout of
-                                * all the other files.
-                                */
-                               inode->i_state |= I_DIRTY_PAGES;
+                       inode->i_state |= I_DIRTY_PAGES;
+                       if (wbc->nr_to_write <= 0 ||     /* sliced used up */
+                            wbc->encountered_congestion)
+                               requeue_io(inode);
+                       else {
+                               /* somehow blocked: retry later */
                                redirty_tail(inode);
                        }
                } else if (inode->i_state & I_DIRTY) {
