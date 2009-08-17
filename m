Return-Path: <linux-kernel-owner+w=401wt.eu-S1757088AbZHQHqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088AbZHQHqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 03:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZHQHqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 03:46:25 -0400
Received: from www84.your-server.de ([213.133.104.84]:55602 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbZHQHqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 03:46:24 -0400
Subject: Re: [PATCH 2/7] kfifo: move out spinlock
From: Stefani Seibold <stefani@seibold.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
In-Reply-To: <20090817074820.3585206b@lxorguk.ukuu.org.uk>
References: <1250455161.28540.4.camel@wall-e>
	 <1250455590.28540.10.camel@wall-e>
	 <20090816235843.0f7f11de@lxorguk.ukuu.org.uk>
	 <20090816163422.a147a918.akpm@linux-foundation.org>
	 <20090817074820.3585206b@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 09:46:22 +0200
Message-Id: <1250495182.20837.27.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 17.08.2009, 07:48 +0100 schrieb Alan Cox:
> > kfifo has no business assuming that the caller wants to use
> > spin_lock() locking.
> > 
> > If we want to add wrapper helpers around kfifo to reduce code
> > duplication in callers, and if one of those wrapper helpers provides
> > spinlock-based locking then fine.
> 
> Those wrappers happen to be called kfifo_get and kfifo_put
> 
> > But the happens-to-use-spin_lock functions shouldn't be called
> > kfifo_get(), because that steals namespace from the unlocked functions,
> > and makes the naming for the happens-to-use-mutex_lock functions look
> > weird.
> 
> All over the kernel unlocked function versions have a leading _ name.
> It's the kernel convention.

Thats is not true in every case. Have a look at list.h - That was the
pattern i have implemented the new kfifo API.

> 
> The other thing I must say I dislike about these patches is the
> gratuitious 'let's rename all the functions' approach it takes. The kfifo
> API is documented, used and random API of the year type changes mess
> stuff up and cause unneeded churn.

First: Non of my eight linux kernel developer books does mention this
API. The only place is the in-kernel documentation and the man pages of
the "kernel hackers manual".

The main reason to do this was to design a cleaner interface. Because
there are very few users of this API, i thought it is a good time and
chance to do this.

My first draft version does also not renamed this functions, but there
was some concerns about the new functionality without modification the
function names.

Also the remove of the spinlock made is necessary to rename the
functions for preventing miss-use by out-of-kernel-tree drivers.

I think the break is not so hard if you believe. All you have to do is
to replace or kfifo_get() into kfifo_out_locked() and kfifo_put() into
kfifo_in_locked() if you really need the old behavior.

The thing is that we get no progress without changes.

> 
> The implementation itself is a really really nice idea.
> 
> 

Thanks for the flowers ;-)


