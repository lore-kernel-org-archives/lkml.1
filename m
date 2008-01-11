Return-Path: <linux-kernel-owner+w=401wt.eu-S1757116AbYAKAhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116AbYAKAhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 19:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbYAKAgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 19:36:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33661 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438AbYAKAgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 19:36:48 -0500
Date: Thu, 10 Jan 2008 16:36:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, supriyak@in.ibm.com
Subject: Re: [PATCH] Fix private_list handling
Message-Id: <20080110163635.33e7640e.akpm@linux-foundation.org>
In-Reply-To: <20080110155513.GB12697@duck.suse.cz>
References: <20080110154959.GA12697@duck.suse.cz>
	<20080110155513.GB12697@duck.suse.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 16:55:13 +0100
Jan Kara <jack@suse.cz> wrote:

>   Hi,
> 
>   sorry for the previous empty email...
> 
>   Supriya noted in his testing that sometimes buffers removed by
> __remove_assoc_queue() don't have b_assoc_mapping set (and thus IO error
> won't be properly propagated). Actually, looking more into the code I found
> there are some more races. The patch below should fix them. It survived
> beating with LTP and fsstress on ext2 filesystem on my testing machine so
> it should be reasonably bugfree... Andrew, would you put the patch into
> -mm? Thanks.
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> ---
> 
> There are two possible races in handling of private_list in buffer cache.
> 1) When fsync_buffers_list() processes a private_list, it clears
> b_assoc_mapping and moves buffer to its private list. Now drop_buffers() comes,
> sees a buffer is on list so it calls __remove_assoc_queue() which complains
> about b_assoc_mapping being cleared (as it cannot propagate possible IO error).
> This race has been actually observed in the wild.

private_lock should prevent this race.

Which call to drop_buffers() is the culprit?  The first one in
try_to_free_buffers(), I assume?  The "can this still happen?" one?

If so, it can happen.  How?  Perhaps this is a bug.

> 2) When fsync_buffers_list() processes a private_list,
> mark_buffer_dirty_inode() can be called on bh which is already on the private
> list of fsync_buffers_list(). As buffer is on some list (note that the check is
> performed without private_lock), it is not readded to the mapping's
> private_list and after fsync_buffers_list() finishes, we have a dirty buffer
> which should be on private_list but it isn't. This race has not been reported,
> probably because most (but not all) callers of mark_buffer_dirty_inode() hold
> i_mutex and thus are serialized with fsync().

Maybe fsync_buffers_list should put the buffer back onto private_list if it
got dirtied again.

