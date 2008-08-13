Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbYHMDL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbYHMDL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 23:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbYHMDLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 23:11:19 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:23479 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbYHMDLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 23:11:19 -0400
Subject: Re: [PATCH 4/6] Replace inode flush semaphore with a completion
From: Daniel Walker <dwalker@mvista.com>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, matthew@wil.cx
In-Reply-To: <1214556284-4160-5-git-send-email-david@fromorbit.com>
References: <1214556284-4160-1-git-send-email-david@fromorbit.com>
	 <1214556284-4160-5-git-send-email-david@fromorbit.com>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 20:11:17 -0700
Message-Id: <1218597077.6166.15.camel@dhcp32.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-27 at 18:44 +1000, Dave Chinner wrote:
> Use the new completion flush code to implement the inode
> flush lock. Removes one of the final users of semaphores
> in the XFS code base.
> 
> Version 2:
> o make flock functions static inlines
> o use new completion interfaces

I was looking over this lock in XFS .. The iflock/ifunlock seem to be
very much like mutexes in most of the calling locations. Where the lock
happens at the start, and the unlock happens when the function calls
bottom out. It seems like a better way to go would be to change from,

xfs_ilock(uqp, XFS_ILOCK_EXCL);
xfs_iflock(uqp);
error = xfs_iflush(uqp, XFS_IFLUSH_SYNC);

Where xfs_iflush eventually does the unlock to,

xfs_ilock(uqp, XFS_ILOCK_EXCL);
xfs_iflock(uqp);
error = xfs_iflush(uqp, XFS_IFLUSH_SYNC);
xfs_ifunlock(uqp);

And remove the unlocking from inside xfs_iflush(). Then use a flag to
indicate that the flush is in progress, and a
completion/wait_for_completion when another thread needs to wait on the
flush to complete if it's an async flush.

That seems vastly more complex than your current patch, but I think it
will be much cleaner ..

Daniel

