Return-Path: <linux-kernel-owner+w=401wt.eu-S1756976AbZELQwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbZELQwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbZELQwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:52:33 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:37636 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbZELQwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:52:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PW3qeW6cRa+lvAqSpwAVjNdXdRkmoUEFVfGPn2hdnVE7ZvB6fYDYQAtF0M/zOvChYs
         wwoyOKDeM/ukQVq3HGy4FsjUWixkVuzc5gt1HRJbTkHsZpBtGxw/wGBONKJ2lyRCgC2Z
         0Kb86Pxwq6Y5u8HWJNOeUYfvOsSpbG6ECTsh4=
Date: Tue, 12 May 2009 18:52:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: tom.leiming@gmail.com, arjan@infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/async.c:introduce async_schedule*_atomic
Message-ID: <20090512165227.GE6255@nowhere>
References: <1242141222-8454-1-git-send-email-tom.leiming@gmail.com> <20090512154456.GC6255@nowhere> <20090512160434.GD6255@nowhere> <20090512183105.09e628f0@gondolin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512183105.09e628f0@gondolin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 06:31:05PM +0200, Cornelia Huck wrote:
> On Tue, 12 May 2009 18:04:35 +0200,
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Tue, May 12, 2009 at 05:44:58PM +0200, Frederic Weisbecker wrote:
> > > On Tue, May 12, 2009 at 11:13:42PM +0800, tom.leiming@gmail.com wrote:
> > > >   * Returns an async_cookie_t that may be used for checkpointing later.
> > > > - * Note: This function may be called from atomic or non-atomic contexts.
> > > > + * Note:This function may be called from non-atomic contexts,and not
> > > > + * 	called from atomic contexts with safety. Please use
> > > > + * 	async_schedule_atomic in atomic contexts.
> > 
> > 
> > I suggest to add a comment which explains the reason for which it is unsafe
> > to call it in atomic context: because the scheduled work might be synchronously
> > executed.
> > 
> > One could believe this is because async_schedule() internally uses
> > a function which might sleep whereas the actual problem may come
> > from the scheduled function.
> 
> I'm wondering whether this is not mixing two different things up:
> - Making async_schedule_* safe from an atomic context.


It was already safe from atomic context, async_schedule() internals
does not make use of sleeping functions.
So indeed the inatomic suffix is not that much appropriate from
an async internal point in view, it makes sense only from the
caller/callee point of view.

But if we start worrying about the GFP flags used by __async_schedule(),
then yes we are mixing up two things.


> - Disallowing calling the function synchronously if asynchronous
>   scheduling failed.
> 
> Perhaps we want async_schedule_nosync() in addition?



This division would make more sense indeed.

- async_schedule_inatomic() would be nosync() and would use
  GFP_ATOMIC. I guess the case where we want to run
  a job synchronously from atomic in case of async failure is too rare
  (non-existent?).
- async_schedule_nosync() would be only nosync() and would use
  GFP_KERNEL

I'm not sure the second case will ever be used though.

Another alternative would be to define a single async_schedule_nosync()
which also takes a gfp flag.


> > 
> > BTW, now that we have an atomic safe version, may be we could
> > also adapt the kmalloc GFP flags subsequently?
> 
> Yes, that would make sense.

