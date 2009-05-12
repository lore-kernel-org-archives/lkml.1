Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbZELQE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbZELQE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756486AbZELQEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:04:39 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:53352 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504AbZELQEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:04:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kIP0aHlOtBNCxqlIblvYMdBoFkhLHwlX5Xu58zWTw9XPaT3c1yQdLa/yp1oTUlhWCG
         yZFjtTmqO01pbvn3d2u0Nrap87EE2Dyg8l+0/FW1WU+6H3SrF+D69CDFedEeXEBtNnd9
         Y2H7Biq5LPF7XpflG8vxi6RT9RizuDjhIF9Rg=
Date: Tue, 12 May 2009 18:04:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: tom.leiming@gmail.com
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/async.c:introduce async_schedule*_atomic
Message-ID: <20090512160434.GD6255@nowhere>
References: <1242141222-8454-1-git-send-email-tom.leiming@gmail.com> <20090512154456.GC6255@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512154456.GC6255@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 05:44:58PM +0200, Frederic Weisbecker wrote:
> On Tue, May 12, 2009 at 11:13:42PM +0800, tom.leiming@gmail.com wrote:
> > From: Ming Lei <tom.leiming@gmail.com>
> > 
> > The async_schedule* may not be called in atomic contexts if out of
> > memory or if there's too much work pending already, because the
> > async function to be called may sleep.
> > 
> > This patch fixes the comment of async_schedule*, and introduces
> > async_schedules*_atomic to allow them called from atomic contexts
> > safely.



Note that async_schedule_atomic is a confusing name.
At a first glance, it could mean that the scheduled job
will be run atomically.

I would suggest async_schedule_inatomic() so that it follows the common
naming pattern in use in the kernel, eg:

- copy_from_user_inatomic()
- futex_atomic_cmpxchg_inatomic()

and so on.



> >   * Returns an async_cookie_t that may be used for checkpointing later.
> > - * Note: This function may be called from atomic or non-atomic contexts.
> > + * Note:This function may be called from non-atomic contexts,and not
> > + * 	called from atomic contexts with safety. Please use
> > + * 	async_schedule_atomic in atomic contexts.


I suggest to add a comment which explains the reason for which it is unsafe
to call it in atomic context: because the scheduled work might be synchronously
executed.

One could believe this is because async_schedule() internally uses
a function which might sleep whereas the actual problem may come
from the scheduled function.

BTW, now that we have an atomic safe version, may be we could
also adapt the kmalloc GFP flags subsequently?


Frederic.

