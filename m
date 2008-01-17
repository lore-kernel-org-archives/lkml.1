Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYAQI4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYAQI4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 03:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYAQI43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 03:56:29 -0500
Received: from hs-out-0708.google.com ([64.233.178.251]:31094 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753341AbYAQI42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 03:56:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g4maDqIDbvv6bkpSq+x4wTl0rNk6OhWtMZ5M5zcEbcwqqoE3txq8HAoyMWMKf8xq0I1oKAm/KzSzQINevd7YiXOKy62NaU6jkIjgEuFKVs0P7Y8zqHpWVyCS9UdM4+fYD3rKg/tjlZFknQqCKyXxrsn7hnt3jJLG4Nip7NED/g4=
Message-ID: <a8e1da0801170056l6ab44ac1r77eec6822543445@mail.gmail.com>
Date: Thu, 17 Jan 2008 16:56:26 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jarek Poplawski" <jarkao2@gmail.com>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct class
Cc: "Greg KH" <gregkh@suse.de>, stefanr@s5r6.in-berlin.de, david-b@pacbell.net,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
In-Reply-To: <20080117083810.GA1710@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0801161717r4cdc1e9cn6a8ec1731c8f831b@mail.gmail.com>
	 <20080117083810.GA1710@ff.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 17, 2008 4:38 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> On 17-01-2008 02:17, Dave Young wrote:
> > On Jan 16, 2008 4:34 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> >> On Wed, Jan 16, 2008 at 09:03:03AM +0800, Dave Young wrote:
> >> ...
> >>> The lockdep warining was posted in the below thread, actually, I have
> >>> built and run this patced kernel for several days, there's no more
> >>> warnings.
> >>> http://lkml.org/lkml/2008/1/3/2
> >> Right... But, with something like this:
> >>
> >> ... have_some_fun(... cls)
> >> {
> >>         mutex_lock_nested(&cls->mutex, SINGLE_DEPTH_NESTING);
> >>         have_other_fun(cls);
> >>         mutex_unlock(&cls->mutex);
> >>
> >> }
> >>
> >> ... have_more_fun(...)
> >> {
> >>         ...
> >>
> >>         mutex_init(&cls->mutex);
> >>
> >>         mutex_lock(&cls->mutex);
> >>         have_some_fun(cls);
> >>         mutex_unlock(&cls->mutex);
> >> }
> >>
> >> probably you wouldn't get any lockdep warning too...
> >
> > Sorry for late reply.
> > Actually, I don't know much about lockdep. Could you tell how to use
> > it properly in this scenario?
>
> As you have noticed while working on this patch, if two different
> instances of the same structure containig some lock are created in
> the same place, lockdep will treat this one (the same) lock. It looks
> strange, but actually it's a feature which enables to track
> dependencies between different locks on 'class' level instead of
> instance 'level'. The downside is that lockdep is very often too
> sensitive by default, so you have to 'annotate' when instancess are
> actually on different level (e.g. parents and children here) and
> could be locked at the same time or in some order.
>
> You can use e.g. mutex_lock_nested() or lockdep_set_class*() for this.
> Then lockdep simply trusts you, and starts to think they are different
> locks. If you do it wrong there will be simply no more warnings, but
> undercover lockups still possible (and diagnosing a bit harder then).
> So, since in your patch there are two levels of locking, and you
> started to annotate lockdep about a child taking parent's class lock
> with:
> mutex_lock_nested(&parent_class->mutex, SINGLE_DEPTH_NESTING);
>
> you should do the same everywhere in a situation like this.
> lockdep will treat this simply as lock B vs. A (mutex_lock(&cls))
> dependencies.

Thanks for the explain, let me check the lockings again.

>
> Regards,
> Jarek P.
>
> PS: BTW, it seems after this patch 1/1 the locking was changed a bit,
> so these previous tests could be not enough.
>
