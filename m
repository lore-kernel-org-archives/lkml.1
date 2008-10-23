Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbYJWHRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbYJWHRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 03:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYJWHQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 03:16:59 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46677 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955AbYJWHQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 03:16:58 -0400
Date: Thu, 23 Oct 2008 09:16:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitri Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Add block device speciffic splice write method
Message-ID: <20081023071559.GV22217@kernel.dk>
References: <1224424858-3927-1-git-send-email-dmonakhov@openvz.org> <20081020174931.GH19428@kernel.dk> <20081020181156.GI19428@kernel.dk> <20081022223928.a6ce476f.akpm@linux-foundation.org> <20081023062921.GQ22217@kernel.dk> <20081022234157.33d46459.akpm@linux-foundation.org> <20081023065113.GU22217@kernel.dk> <20081023000315.6aa579f2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023000315.6aa579f2.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23 2008, Andrew Morton wrote:
> On Thu, 23 Oct 2008 08:51:13 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Oct 22 2008, Andrew Morton wrote:
> > > On Thu, 23 Oct 2008 08:29:23 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > > > But really it'd be better if the throttling happened down in
> > > > > pipe_to_file(), on a per-page basis.  As it stands we can dirty an
> > > > > arbitrary number of pagecache pages without throttling.  I think?
> > > > 
> > > > That's pretty exactly why it isn't done in the actor, to avoid doing it
> > > > per-page. As it's going to be PIPE_BUFFERS (16) pages max, I think this
> > > > is better.
> > > > 
> > > > Back in the splice early days, the balance_dirty_pages() actually showed
> > > > up in profiles when it was done on a per-page basis. So I'm reluctant to
> > > > change it :-)
> > > 
> > > That's why (the misnamed) balance_dirty_pages_ratelimited() exists?
> > 
> > I think that is what was used, but the details are a little hazy at this
> > point. So I can't say for sure.
> 
> All that function does is to bump a per-cpu variable and
> once-per-thousand or so it does the balance.  If it was causing
> problems in the splice application we want to know, because write()
> uses it!

Once per 8 or 32. If we haven't exceeded the dirty limit, calling it in
the actor or at the end should not make a difference for splice, since
we should be going into balance_dirty_pages() at most once.

Perhaps it was different some years ago, or perhaps the micro benchmarks
were screwed. Or perhaps my memory is shot, can't say for sure :)

> >  In this case it's moot anyway, since we can kill it.
> 
> Nope, we can only remove it if the fd is O_SYNC||is_sync().

Right, I forgot this is still the buffered path.

-- 
Jens Axboe

