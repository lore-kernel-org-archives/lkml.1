Return-Path: <linux-kernel-owner+w=401wt.eu-S1752343AbYIJGST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbYIJGST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 02:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYIJGSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 02:18:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:60162 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbYIJGSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 02:18:06 -0400
Date: Tue, 9 Sep 2008 23:17:17 -0700
From: Greg KH <greg@kroah.com>
To: Paul Menage <menage@google.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroups: fix probable race with put_css_set[_taskexit]
	and find_css_set
Message-ID: <20080910061717.GA6301@kroah.com>
References: <48AA684B.7000704@cn.fujitsu.com> <6599ad830809091728m426a7219h1977001f86cb5f31@mail.gmail.com> <48C72E7C.8080302@cn.fujitsu.com> <20080910050112.GA2897@kroah.com> <6599ad830809092231h90712a6mc95b81229d64d6bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830809092231h90712a6mc95b81229d64d6bc@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 10:31:24PM -0700, Paul Menage wrote:
> On Tue, Sep 9, 2008 at 10:01 PM, Greg KH <greg@kroah.com> wrote:
> >
> > What are you trying to solve here with this change?  I agree, it does
> > seem a bit "chaotic" :)
> 
> There's a place in cgroups that uses kref_put() to release an object;
> the release function *then* takes a write-lock and removes the object
> from a lookup table; it could race with another thread that searches
> the lookup table (while holding a read-lock) and does kref_get() on
> the same object.

Ick, yeah that's not good.

What about the way everyone else solves this, grab the lock before you
call kref_put()?

> The current fix is for the release function to recheck inside the lock
> that the object's refcount is still zero, and only actually
> unlink/free it if so. And actually I've just realised that this isn't
> actually even safe, since the thread that just acquired the object
> could kref_put() it almost immediately, which would leave two threads
> both trying to unlink/free the object.

Yeah, don't do that :)

thanks,

greg k-h
