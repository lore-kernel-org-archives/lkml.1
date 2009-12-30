Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbZL3Rsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbZL3Rsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 12:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbZL3Rsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 12:48:52 -0500
Received: from THUNK.ORG ([69.25.196.29]:45459 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbZL3Rsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 12:48:51 -0500
Date: Wed, 30 Dec 2009 12:48:49 -0500
From: tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       dmitry.torokhov@gmail.com, Jan Kara <jack@suse.cz>, aanisimov@inbox.ru,
       pl4nkton@googlemail.com
Subject: Re: 2.6.33-rc1: kernel BUG at fs/ext4/inode.c:1063 (sparc)
Message-ID: <20091230174849.GN4429@thunk.org>
Mail-Followup-To: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
	dmitry.torokhov@gmail.com, Jan Kara <jack@suse.cz>,
	aanisimov@inbox.ru, pl4nkton@googlemail.com
References: <a4423d670912241449y2da43d5fi3e5a18c114b84178@mail.gmail.com>
 <87hbrfdylc.fsf@openvz.org>
 <a4423d670912251133u795338a4wd32d5cdef8c36c75@mail.gmail.com>
 <87eimir4yk.fsf@openvz.org>
 <a4423d670912271232y5bb928f7wb667ca71f1a93f8a@mail.gmail.com>
 <20091227225216.GB4429@thunk.org>
 <a4423d670912271502n13957e8boc168fdc75444dc09@mail.gmail.com>
 <20091228035159.GC4429@thunk.org>
 <20091230053720.GK4429@thunk.org>
 <87k4w4vbvy.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k4w4vbvy.fsf@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 04:18:09PM +0300, Dmitry Monakhov wrote:
> 
> IMHO we may drop i_allocated_meta_block in ext4_release_file()
> But while looking in to this function i've found another question
> about locking
> static int ext4_release_file(struct inode *inode, struct file *filp)
> {
> 	if (EXT4_I(inode)->i_state & EXT4_STATE_DA_ALLOC_CLOSE) {
> 		ext4_alloc_da_blocks(inode);
> 		EXT4_I(inode)->i_state &= ~EXT4_STATE_DA_ALLOC_CLOSE;
> <<< Seems what i_state modification must being protected by i_mutex,
>  but currently caller don't have to hold it.

(I'm answering this in a separate message since it really is a
separate question).

Yeah, that looks like a problem --- and it exists in more than just
this one place.  Unfortunately using i_mutex to protect updates to
i_state is a bit heavyweight.  What I'm thinking about doing is
converting all of the references the i_state flags to use set_bit,
clear_bit, and test_bit, since this will allow us to safely and
cleanly set/clear/test individual bits.

A quick audit of ext3 seems to show this is potentially a problem with
ext3 as well (specifically, in fs/ext3/xattr.c's use of
EXT3_STATE_XATTR).

						- Ted
