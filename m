Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbYE2GjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbYE2GjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 02:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbYE2GjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 02:39:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbYE2GjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 02:39:05 -0400
Date: Wed, 28 May 2008 23:38:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: block: make blktrace use per-cpu buffers for message notes
Message-Id: <20080528233801.e9e55eeb.akpm@linux-foundation.org>
In-Reply-To: <20080529062214.GG25504@kernel.dk>
References: <200805281559.m4SFx7b9022392@hera.kernel.org>
	<20080528231351.a35001bc.akpm@linux-foundation.org>
	<20080529062214.GG25504@kernel.dk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 08:22:15 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, May 28 2008, Andrew Morton wrote:
> > On Wed, 28 May 2008 15:59:07 GMT Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> > 
> > > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=64565911cdb57c2f512a9715b985b5617402cc67
> > > Commit:     64565911cdb57c2f512a9715b985b5617402cc67
> > > Parent:     4722dc52a891ab6cb2d637ddb87233e0ce277827
> > > Author:     Jens Axboe <jens.axboe@oracle.com>
> > > AuthorDate: Wed May 28 14:45:33 2008 +0200
> > > Committer:  Jens Axboe <jens.axboe@oracle.com>
> > > CommitDate: Wed May 28 14:49:27 2008 +0200
> > 
> > please try to avoid merging unreviewed changes.
> 
> Just because you didn't review it doesn't mean it's unreviewed :-)
> 
> It's not unreviewed, it was posted on lkml and a few version were
> bounced back and forth.

OK.  The Subject: swizzling confounded me.

> > >  		if (unlikely(bt))					\
> > >  			__trace_note_message(bt, fmt, ##__VA_ARGS__);	\
> > >  	} while (0)
> > > -#define BLK_TN_MAX_MSG		1024
> > > +#define BLK_TN_MAX_MSG		128
> > 
> > It seems a bit strange to do this right when we've taken this _off_ the
> > stack.  But I suppose nothing will break.
> 
> It was never on the stack, it was a global static char array. We are
> still allocating memory for this, per-cpu. So I think it still makes
> sense to shrink the size. It's really meant for small trace messages,
> 128 bytes is plenty. It's an in-kernel property, the userland app
> doesn't care. So we could easily grow this in the future, should the
> need arise.

yup.

It's a bit sad to stage the data in a local per-cpu buffer and then
copy it into relay's per-cpu buffer.  I guess this is because the
length of the output isn't known beforehand.  Could be fixed by doing
what kvasprintf() does, but that might well be slower.
