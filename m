Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab0BOTuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 14:50:20 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:35723 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab0BOTuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 14:50:16 -0500
MIME-Version: 1.0
In-Reply-To: <20100209191427.GA18263@oksana.dev.rtsoft.ru>
References: <20100205204949.GA2575@oksana.dev.rtsoft.ru> <20100205205045.GC4178@oksana.dev.rtsoft.ru> 
	<fa686aa41002090928o6911d095ydca1e1e670a0fc22@mail.gmail.com> 
	<20100209191427.GA18263@oksana.dev.rtsoft.ru>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 15 Feb 2010 12:49:56 -0700
X-Google-Sender-Auth: 27327af48699f128
Message-ID: <fa686aa41002151149u158bc2fbn5af16f6bd714d36c@mail.gmail.com>
Subject: Re: [PATCH 3/3] of/gpio: Introduce of_put_gpio(), add ref counting 
	for OF GPIO chips
To: avorontsov@ru.mvista.com
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, Michal Simek <monstr@monstr.eu>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 9, 2010 at 12:14 PM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> On Tue, Feb 09, 2010 at 10:28:15AM -0700, Grant Likely wrote:
> [...]
>> Rather than having a lock at the device tree data pointer level which
>> mixes usage with potentially many other drivers; wouldn't it make more
>> sense to use a mutex at the of_gc subsystem context?
>
> I don't think so.
>
> of_gc = np->data;
> lock(of_gc); (or lock(devtree))
> <do something with of_gc>
>
> doesn't provide us what we need, i.e. it doesn't guarantee that
> np->data (of_gc) is still alive.
>
> And here:
>
> lock(np->data); (or lock(devtree))
> of_gc = np->data;
> lock(of_gc);
> <do something with of_gc>
>
> The second lock becomes useless (unless you also refcount np->data
> usage and can drop the devtree/np->data lock, and grab some other
> kind of lock, e.g. mutex, but this is silly).

Okay, I'm convinced now.  The model is wrong.  struct of_gc does need
to be a member of struct gpio_chip and conditionally compiled against
CONFIG_OF_GPIO.  This locking requirement is just too plain ugly, and
dereferencing the np->data pointer in this way is dangerous (what if
something that is not struct of_gc is stored there).

Put of_gc into struct gpio_chip, and I'll completely support that approach.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
