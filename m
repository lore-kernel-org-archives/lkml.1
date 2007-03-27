Return-Path: <linux-kernel-owner+w=401wt.eu-S934171AbXC0Sma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934171AbXC0Sma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934168AbXC0Sma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:42:30 -0400
Received: from science.horizon.com ([192.35.100.1]:15139 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934171AbXC0Sm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:42:29 -0400
Date: 27 Mar 2007 14:42:27 -0400
Message-ID: <20070327184227.13923.qmail@science.horizon.com>
From: linux@horizon.com
To: miklos@szeredi.hu
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
Cc: akpm@linux-foundation.org, linux@horizon.com, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, this will make msync(MS_ASYNC) more heavyweight again.  But if an
> application doesn't want to update the timestamps, it should just omit
> this call, since it does nothing else.

Er... FWIW, I have an application that makes heavy use of msync(MS_ASYNC)
and doesn't care about timestamps.  (In fact, sometimes it's configured
to write to a raw device and there are no timestamps.)

It's used as a poor man's portable async I/O.  The application logs
data to disk, and sometimes needs to sync it to disk to ensure it has
all been written.

To reduce long pauses when doing msync(MS_SYNC), it does msync(MS_ASYNC)
as soon as a page is filled up to prompt asynchronous writeback.
"I'm done writing this page and don't intend to write it again.
Please start committing it to stable storage, but don't block me."

Then, occasionally, there's an msync(MS_SYNC) call to be sure the data
is synced to disk.  This caused annoying hiccups before the MS_ASYNC
calls were added.


I agree that msync(MS_ASYNC) has no semantics if time is ignored.
But it's a useful way to tell the OS that the page is not going
to be dirtied again.
