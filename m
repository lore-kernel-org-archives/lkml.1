Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab0BITOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:14:30 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:41779 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751672Ab0BITO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:14:29 -0500
Date: Tue, 9 Feb 2010 22:14:27 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, Michal Simek <monstr@monstr.eu>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH 3/3] of/gpio: Introduce of_put_gpio(), add ref counting
 for OF GPIO chips
Message-ID: <20100209191427.GA18263@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100205204949.GA2575@oksana.dev.rtsoft.ru>
 <20100205205045.GC4178@oksana.dev.rtsoft.ru>
 <fa686aa41002090928o6911d095ydca1e1e670a0fc22@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fa686aa41002090928o6911d095ydca1e1e670a0fc22@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 09, 2010 at 10:28:15AM -0700, Grant Likely wrote:
[...]
> Rather than having a lock at the device tree data pointer level which
> mixes usage with potentially many other drivers; wouldn't it make more
> sense to use a mutex at the of_gc subsystem context?

I don't think so.

of_gc = np->data;
lock(of_gc); (or lock(devtree))
<do something with of_gc>

doesn't provide us what we need, i.e. it doesn't guarantee that
np->data (of_gc) is still alive.

And here:

lock(np->data); (or lock(devtree))
of_gc = np->data;
lock(of_gc);
<do something with of_gc>

The second lock becomes useless (unless you also refcount np->data
usage and can drop the devtree/np->data lock, and grab some other
kind of lock, e.g. mutex, but this is silly).

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
