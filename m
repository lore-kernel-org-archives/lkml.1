Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbZHPXf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbZHPXf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 19:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbZHPXf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 19:35:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789AbZHPXf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 19:35:28 -0400
Date: Sun, 16 Aug 2009 16:34:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stefani Seibold <stefani@seibold.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/7] kfifo: move out spinlock
Message-Id: <20090816163422.a147a918.akpm@linux-foundation.org>
In-Reply-To: <20090816235843.0f7f11de@lxorguk.ukuu.org.uk>
References: <1250455161.28540.4.camel@wall-e>
	<1250455590.28540.10.camel@wall-e>
	<20090816235843.0f7f11de@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Aug 2009 23:58:43 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Sun, 16 Aug 2009 22:46:30 +0200
> Stefani Seibold <stefani@seibold.net> wrote:
> 
> > Move the pointer to the spinlock out of struct kfifo. Most
> > users in tree do not actually use a spinlock, so the few
> > exceptions now have to call kfifo_{get,put}_locked, which takes
> > an extra argument to a spinlock.
> 
> NAK this one for the moment
> 
> We are about to set fifo loose through all the USB and some other
> char/serial drivers all of which will use the spinlock facility.

That sounds like a good reason for applying this patch first.

kfifo has no business assuming that the caller wants to use
spin_lock() locking.

If we want to add wrapper helpers around kfifo to reduce code
duplication in callers, and if one of those wrapper helpers provides
spinlock-based locking then fine.

But the happens-to-use-spin_lock functions shouldn't be called
kfifo_get(), because that steals namespace from the unlocked functions,
and makes the naming for the happens-to-use-mutex_lock functions look
weird.

