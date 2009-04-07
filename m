Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbZDGGzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbZDGGzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbZDGGyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:54:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908AbZDGGys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:54:48 -0400
Date: Mon, 6 Apr 2009 23:50:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>, jack@suse.cz,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/3] block_write_full_page: Use synchronous writes for
 WBC_SYNC_ALL writebacks
Message-Id: <20090406235052.1ea47513.akpm@linux-foundation.org>
In-Reply-To: <20090406232141.ebdb426a.akpm@linux-foundation.org>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu>
	<1238185471-31152-2-git-send-email-tytso@mit.edu>
	<20090406232141.ebdb426a.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009 23:21:41 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> I mean, let's graph it:
> 
> WRITE_SYNC -> WRITE_SYNC_PLUG -> BIO_RW_SYNCIO -> bio_sync() -> REQ_RW_SYNC -> rw_is_sync() -> does something mysterious in get_request()
>                                                                             -> rq_is_sync() -> does something mysterious in IO schedulers
>                               -> BIO_RW_NOIDLE -> bio_noidle() -> REQ_NOIDLE -> rq_noidle() -> does something mysterious in cfq-iosched only
>            -> BIO_RW_UNPLUG   -> bio_unplug() -> REQ_UNPLUG -> OK, the cognoscenti know what this is supposed to do, but it is unused!

whoop, I found a use of bio_unplug() in __make_request().

So it appears that the intent of your patch is to cause an unplug after
submission of each WB_SYNC_ALL block?

But what about all the other stuff which WRITE_SYNC might or might not
do?  What does WRITE_SYNC _actually_ do, and what are the actual
effects of this change??

And what effect will this large stream of unplugs have upon merging?
