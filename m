Return-Path: <linux-kernel-owner+w=401wt.eu-S934175AbXC0S4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175AbXC0S4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934184AbXC0S4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:56:37 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:44107 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934175AbXC0S4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:56:36 -0400
To: linux@horizon.com
CC: akpm@linux-foundation.org, linux@horizon.com, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
In-reply-to: <20070327184227.13923.qmail@science.horizon.com>
	(linux@horizon.com)
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
References: <20070327184227.13923.qmail@science.horizon.com>
Message-Id: <E1HWGpj-0004Yb-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 27 Mar 2007 20:55:51 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yes, this will make msync(MS_ASYNC) more heavyweight again.  But if an
> > application doesn't want to update the timestamps, it should just omit
> > this call, since it does nothing else.
> 
> Er... FWIW, I have an application that makes heavy use of msync(MS_ASYNC)
> and doesn't care about timestamps.  (In fact, sometimes it's configured
> to write to a raw device and there are no timestamps.)
> 
> It's used as a poor man's portable async I/O.  The application logs
> data to disk, and sometimes needs to sync it to disk to ensure it has
> all been written.
> 
> To reduce long pauses when doing msync(MS_SYNC), it does msync(MS_ASYNC)
> as soon as a page is filled up to prompt asynchronous writeback.
> "I'm done writing this page and don't intend to write it again.
> Please start committing it to stable storage, but don't block me."
> 
> Then, occasionally, there's an msync(MS_SYNC) call to be sure the data
> is synced to disk.  This caused annoying hiccups before the MS_ASYNC
> calls were added.
> 
> 
> I agree that msync(MS_ASYNC) has no semantics if time is ignored.
> But it's a useful way to tell the OS that the page is not going
> to be dirtied again.

Just to clarify, here's the header comment for sys_msync():

/*
 * MS_SYNC syncs the entire file - including mappings.
 *
 * MS_ASYNC does not start I/O (it used to, up to 2.5.67).
 * Nor does it marks the relevant pages dirty (it used to up to 2.6.17).
 * Now it doesn't do anything, since dirty pages are properly tracked.
 *
 * The application may now run fsync() to
 * write out the dirty pages and wait on the writeout and check the result.
 * Or the application may run fadvise(FADV_DONTNEED) against the fd to start
 * async writeout immediately.
 * So by _not_ starting I/O in MS_ASYNC we provide complete flexibility to
 * applications.
 */

It's actually wrong about FADV_DONTNEED, which I think doesn't start
writeout either.  So there you have it ;)

Miklos
