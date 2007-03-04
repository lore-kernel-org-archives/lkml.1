Return-Path: <linux-kernel-owner+w=401wt.eu-S932598AbXCDBjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598AbXCDBjg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 20:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932610AbXCDBjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 20:39:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51371 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932598AbXCDBjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 20:39:35 -0500
Date: Sat, 3 Mar 2007 17:39:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lee Revell" <rlrevell@joe-job.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-Id: <20070303173933.9f46459c.akpm@linux-foundation.org>
In-Reply-To: <75b66ecd0703031716k5b9fd96br9ecd93f1fc3a6032@mail.gmail.com>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	<75b66ecd0703031716k5b9fd96br9ecd93f1fc3a6032@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Mar 2007 20:16:09 -0500 "Lee Revell" <rlrevell@joe-job.com> wrote:

> On 3/3/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > The tool uses an LD_PRELOAD hack to intercept glibc's read(), pread(),
> > write(), pwrite(), close() and dup2() functions.  pagecache control is done
> > via posix_fadvise() and sync_file_range().
> >
> 
> How could this have any effect on the updatedb problem?  updatedb does
> not read() anything, it just open()s and stat()s every file on the
> disk.
> 

err, good point.  _one_ of those dang things which goes off when you've
stayed up too late does a lot of pagecache IO, not sure which one.  Maybe
rpmq?  But I'd expect that to be doing direct-io.

But yes, updatedb's pagecache usage will be mainly metadata, and this tool
doesn't address metadata pagecache, although it could do so.

<does an updatedb on a modest system>

It instantiated 5MB of pagecache and 20MB of slab, took about one minute.

<runs all the other things in /etc/cron.daily>

rpm uses rather a lot of pagecache.

So yes, it looks like updatedb is a slab problem.
