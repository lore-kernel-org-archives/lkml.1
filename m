Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbYEKLRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbYEKLRI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 07:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbYEKLQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 07:16:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35430 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYEKLQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 07:16:56 -0400
Date: Sun, 11 May 2008 07:16:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: Morten Welinder <mwelinder@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Deleting large files
Message-ID: <20080511111652.GA2323@infradead.org>
References: <118833cc0805071249w36145eb6g7ed5c18d9fdf6fce@mail.gmail.com> <20080508081906.GY3700@mea-ext.zmailer.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508081906.GY3700@mea-ext.zmailer.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 11:19:06AM +0300, Matti Aarnio wrote:
> This very question has troubled SQUID developers.  Whatever the system, unlink()
> that really does free diskspace does so with unbound timelimit and in services
> where one millisecond is long wait time, the solution has been to run separate
> subprocess that actually does the unlinks.
> 
> Squid is not threaded software, and it was created long ago when threads were
> rare and implementations were different in subtle details --> no threads at all.

I'd call long times for the final unlink a bug in the filesystem.
There's not all that much to do when deleting a file.   What you need to
do is basically return the allocated space to the free space allocator
and mark the inode as unused and return it to the inode allocator.  The
first one may take quite a while with a indirect block scheme, but with
an extent based filesystem it shouldn't be a problem.  The latter
shouldn't take too long either, and with a journaling filesystem it's
even easier because you can intent-log the inode deletion first and then
perform it later e.g. as part of a batched write-back of the inode
cluster.
