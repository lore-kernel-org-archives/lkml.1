Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbZENDTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbZENDTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 23:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759948AbZENDTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 23:19:43 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:42360 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbZENDTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 23:19:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uwUJh7RTuHSKEaf3lBk1epXFC7LV9lmdSuLJyEFKq2L0C7VGwqaFyId6Zg+x6TEunl
         rvHFRPVPwIexHwZ/jkS/54ijlt519uPzI6OPBHeGfV6Eyv+Fa1q3g5AVQPwVpo67nRW0
         y8pHRPBbzayyNDqrEHmUvj2r102OugM0DoCcg=
Date: Thu, 14 May 2009 05:19:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: tom.leiming@gmail.com, arjan@infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] kernel:async function call:introduce
	async_run_inatomic(v2)
Message-ID: <20090514031937.GA5476@nowhere>
References: <1242229899-16761-1-git-send-email-tom.leiming@gmail.com> <20090513191144.6aae00d7@gondolin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513191144.6aae00d7@gondolin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 07:11:44PM +0200, Cornelia Huck wrote:
> On Wed, 13 May 2009 23:51:39 +0800,
> tom.leiming@gmail.com wrote:
> 
> > From: Ming Lei <tom.leiming@gmail.com>
> > 
> > The purpose of this function is to offer a simple way to schedule an
> > asynchronous thread from an atomic context, because there are not any
> > functions which can create and start a kernel thread in atomic contexts
> > now. We use async_running_no_sync as running list to make callers that
> > don't want to synchronize on cookies, so can avoid some side effects for
> > async_synchronize_full().
> > 
> > Part of note for async_run_inatomic and some guideline is from Cornelia Huck.
> > 
> > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> > Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> > ---
> >  include/linux/async.h |    2 ++
> >  kernel/async.c        |   23 +++++++++++++++++++++++
> >  2 files changed, 25 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/async.h b/include/linux/async.h
> > index 18ce92b..9ff62af 100644
> > --- a/include/linux/async.h
> > +++ b/include/linux/async.h
> > @@ -16,6 +16,8 @@
> >  typedef u64 async_cookie_t;
> >  typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
> > 
> > +extern int async_run_inatomic(async_func_ptr *ptr, void *data);
> > +
> >  extern async_cookie_t async_schedule(async_func_ptr *ptr, void *data);
> >  extern async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
> >  					    struct list_head *list);
> > diff --git a/kernel/async.c b/kernel/async.c
> > index 8663f5b..cb527b3 100644
> > --- a/kernel/async.c
> > +++ b/kernel/async.c
> > @@ -65,6 +65,7 @@ static async_cookie_t next_cookie = 1;
> > 
> >  static LIST_HEAD(async_pending);
> >  static LIST_HEAD(async_running);
> > +static LIST_HEAD(async_running_no_sync);
> >  static DEFINE_SPINLOCK(async_lock);
> > 
> >  static int async_enabled = 0;
> > @@ -222,6 +223,28 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data,
> >  	return newcookie;
> >  }
> > 
> > + /**
> > + * async_run_inatomic - in atomic contexts schedule a function for
> > + * 			asynchronous execution
> 
> I'm not 100% sure whether kerneldoc likes split lines for the
> description.
> 
> "async_run_inatomic - schedule a function for asynchronous execution from atomic context without checkpointing"
> - but that's really a bit long...
> 
> > + *
> > + * @ptr: function to execute asynchronously
> > + * @data: data pointer to pass to the function
> > + *
> > + * Return zero if success, or else return others if failured
> 
> Returns zero on success, !zero on failure
> 
> > + * Note:
> 
> I'd move the description of the function's purpose before Note:.
> 
> > + * The purpose of this function is to offer a simple way to schedule an
> > + * asynchronous thread from an atomic context, because there are not any
> > + * functions which can create and start a kernel thread in atomic contexts
> > + * now. 
> 
> I don't think the second part of the sentence is needed, this should
> only be mentioned in the patch description. I'd rather add
> 
> "Since it does not return a cookie for checkpointing, it is for callers
> that don't need later synchronization."
> 
> > We use async_running_no_sync as running list to make callers that
> > + * don't want to synchronize on cookies, so can avoid some side effects for
> > + * async_synchronize_full().
> 
> "async_run_inatomic() uses a distinct running list in order to avoid
> slowing down synchronization within the general domain."
> 
> (The cookie will still be checked when __lowest_in_progress() returns
> the cookie for the async_pending list, but I think that is negligible -
> and it would be a general issue for special domains.)
> 
> > + */
> > +int async_run_inatomic(async_func_ptr *ptr, void *data)
> > +{
> > +	return !__async_schedule(ptr, data, &async_running_no_sync, 1);
> > +}
> > +EXPORT_SYMBOL_GPL(async_run_inatomic);
> > +
> >  /**
> >   * async_schedule - schedule a function for asynchronous execution
> >   * @ptr: function to execute asynchronously
> 
> Btw: Do you have any specific use cases for this function in mind?


I have some usecases in mind concerning async_schedule_inatomic()
because it still provides a way to synchronize against pending async
jobs. Especially it could replace some lazy workqueues which receive
rare events.

But I wonder if async_run_inatomic() is really matching any common
pattern inside the kernel.
It seems to me rare to never need waiting for an async job completion.

Frederic.

