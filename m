Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbYIJGar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbYIJGar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 02:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbYIJGaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 02:30:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41230 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYIJGai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 02:30:38 -0400
Date: Tue, 9 Sep 2008 23:29:51 -0700
From: Greg KH <greg@kroah.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroups: fix probable race with put_css_set[_taskexit]
	and find_css_set
Message-ID: <20080910062951.GA6779@kroah.com>
References: <48AA684B.7000704@cn.fujitsu.com> <6599ad830809091728m426a7219h1977001f86cb5f31@mail.gmail.com> <48C72E7C.8080302@cn.fujitsu.com> <20080910050112.GA2897@kroah.com> <6599ad830809092231h90712a6mc95b81229d64d6bc@mail.gmail.com> <20080910061717.GA6301@kroah.com> <48C76875.50007@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C76875.50007@cn.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 02:25:57PM +0800, Li Zefan wrote:
> Greg KH wrote:
> > On Tue, Sep 09, 2008 at 10:31:24PM -0700, Paul Menage wrote:
> >> On Tue, Sep 9, 2008 at 10:01 PM, Greg KH <greg@kroah.com> wrote:
> >>> What are you trying to solve here with this change?  I agree, it does
> >>> seem a bit "chaotic" :)
> >> There's a place in cgroups that uses kref_put() to release an object;
> >> the release function *then* takes a write-lock and removes the object
> >> from a lookup table; it could race with another thread that searches
> >> the lookup table (while holding a read-lock) and does kref_get() on
> >> the same object.
> > 
> > Ick, yeah that's not good.
> > 
> > What about the way everyone else solves this, grab the lock before you
> > call kref_put()?
> > 
> 
> do_exit()
>   cgroup_exit()
>     put_css_set_taskexit()
>       kref_put()
> 
> If we grab the lock before kref_put(), we add overhead to do_exit(), which
> is what we are trying to avoid here.

But you can't put such logic in the release() function as you are
finding out, that's not going to work either.

Maybe you need to just "open-code" an atomic counter here and not use
kref as it sounds like you are needing to do something very "special"
here.

thanks,

greg k-h
