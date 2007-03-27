Return-Path: <linux-kernel-owner+w=401wt.eu-S1750934AbXC0Tef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934AbXC0Tef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 15:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbXC0Tef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 15:34:35 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39476 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbXC0Tee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 15:34:34 -0400
Date: Tue, 27 Mar 2007 12:34:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux@horizon.com
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
Message-Id: <20070327123422.d0bbc064.akpm@linux-foundation.org>
In-Reply-To: <20070327192452.26486.qmail@science.horizon.com>
References: <E1HWGpj-0004Yb-00@dorka.pomaz.szeredi.hu>
	<20070327192452.26486.qmail@science.horizon.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Mar 2007 15:24:52 -0400
linux@horizon.com wrote:

> > * MS_ASYNC does not start I/O (it used to, up to 2.5.67).
> 
> Yes, I noticed.  See
> http://www.ussg.iu.edu/hypermail/linux/kernel/0602.1/0450.html
> for a bug report on the subject February 2006.

Suggest you use msync(MS_ASYNC), then
sync_file_range(SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE).

The new (post 2.6.17) MAP_SHARED dirty-page semantics mean that the msync()
isn't actually needed.

> That's why this application is still running on 2.4.
> 
> As I mentioned at the time, the SUS says:
> (http://opengroup.org/onlinepubs/007908799/xsh/msync.html)
> "When MS_ASYNC is specified, msync() returns immediately once all the
> write operations are initiated or queued for servicing."
> 
> You can argue that putting it on the dirty list constitutes "queued for
> servicing", but the intent seems pretty clear to me: MS_ASYNC is supposed
> to start the I/O.  Although strict standards-ese parsing says that
> either branch of an or is acceptable, it is a common English language
> convention that the first alternative is preferred and the second
> is a fallback.
> 
> It makes sense in this case: start the write or, if that's not possible
> (the disk is already busy), queue it for service as soon as the disk
> is available.
> 
> They perhaps didn't mandate it this strictly, but that's clearly the
> intent.

We can fix your application, and we'll break someone else's.

I don't think it's solveable, really - the range of applications is so
broad, and the "standard" is so vague as to be useless.  This is why we've
been extending these things with linux-specific goodies which permit
applications to actually tell the kernel what they want to be done in a
more finely-grained fashion.
