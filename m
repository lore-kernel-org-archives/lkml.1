Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbYK1QJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbYK1QJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 11:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYK1QJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 11:09:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53075 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbYK1QJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 11:09:44 -0500
Date: Fri, 28 Nov 2008 17:08:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Tejun Heo <htejun@gmail.com>, Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <mszeredi@suse.cz>, Brad Boyer <flar@allandria.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Roland McGrath <roland@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] poll: allow f_op->poll to sleep, take#6
Message-ID: <20081128160802.GA11809@redhat.com>
References: <20081125173032.GA21539@redhat.com> <492CD1AB.3000802@kernel.org> <492CD358.2020603@gmail.com> <alpine.DEB.1.10.0811252148540.32523@alien.or.mcafeemobile.com> <492CEF04.6070100@gmail.com> <alpine.DEB.1.10.0811252313420.32523@alien.or.mcafeemobile.com> <492E65F9.30208@gmail.com> <492E6A6E.9020000@gmail.com> <alpine.DEB.1.10.0811272033440.3147@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811272033440.3147@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27, Davide Libenzi wrote:
>
> On Thu, 27 Nov 2008, Tejun Heo wrote:
>
> > f_op->poll is the only vfs operation which is not allowed to sleep.  It's
> > because poll and select implementation used task state to synchronize
> > against wake ups, which doesn't have to be the case anymore as wait/wake
> > interface can now use custom wake up functions.  The non-sleep restriction
> > can be a bit tricky because ->poll is not called from an atomic context
> > and the result of accidentally sleeping in ->poll only shows up as
> > temporary busy looping when the timing is right or rather wrong.
> >
> > This patch converts poll/select to use custom wake up function and use
> > separate triggered variable to synchronize against wake up events.  The
> > only added overhead is an extra function call during wake up and
> > negligible.
> >
> > This patch removes the one non-sleep exception from vfs locking rules and
> > is beneficial to userland filesystem implementations like FUSE, 9p or
> > peculiar fs like spufs as it's very difficult for those to implement
> > non-sleeping poll method.
>
> Looks OK to me, although it'd be better if some more folks eye it, in
> order to avoid painful mistakes.

Just in case, I think the patch is correct too.

(v4l1-compat.c:poll_one() looks buggy, it doesn't check if poll_get_entry()
 fails, but this has nothing to do with this patch).

Oleg.

