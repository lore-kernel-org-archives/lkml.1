Return-Path: <linux-kernel-owner+w=401wt.eu-S1760979AbXISShW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979AbXISShW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbXISShJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:37:09 -0400
Received: from mail.fieldses.org ([66.93.2.214]:58891 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbXISShH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:37:07 -0400
Date: Wed, 19 Sep 2007 14:37:03 -0400
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Consolidate sleeping routines in file locking code
Message-ID: <20070919183703.GE5946@fieldses.org>
References: <46EFD574.5060705@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EFD574.5060705@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 05:41:08PM +0400, Pavel Emelyanov wrote:
> This is the next step in fs/locks.c cleanup before turning
> it into using the struct pid *. 
> 
> This time I found, that there are some places that do a
> similar thing - they try to apply a lock on a file and go 
> to sleep on error till the blocker exits.
> 
> All these places can be easily consolidated, saving 28 
> lines of code and more than 600 bytes from the .text,
> but there is one minor note. 

I'm not opposed to consolidating this code, but would it be possible to
do so in a more straightforward way, without passing in a callback
function?  E.g. a single __posix_lock_file_wait that just took an inode
instead of a filp and called __posix_lock_file() could be called from
both posix_lock_file_wait() and locks_mandatory_locked, right?

> The locks_mandatory_area() code becomes a bit different 
> after this patch - it no longer checks for the inode's 
> permissions change. Nevertheless, this check is useless 
> without my another patch that wakes the waiter up in the
> notify_change(), which is not considered to be useful for
> now.

OK.  Might be better to submit this as a separate patch, though.

--b.
