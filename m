Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0BAVUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 16:20:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53569 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab0BAVUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 16:20:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH] irda: remove BKL from irnet open function
Date: Mon, 1 Feb 2010 22:20:30 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc5; KDE/4.3.2; x86_64; ; )
Cc: John Kacur <jkacur@gmail.com>, Samuel Ortiz <samuel@sortiz.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <1265048321-8097-1-git-send-email-cascardo@holoscopio.com> <520f0cf11002011232u415146a9md3afe65af4d810a6@mail.gmail.com> <20100201203616.GJ1414@holoscopio.com>
In-Reply-To: <20100201203616.GJ1414@holoscopio.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201002012220.30887.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/0ct06F2OUWJwaWhwhN6Ub7ucRnd+VJnroV8z
 oXFDw6jaFc1mg9hLiUkkrHiXSeO4Yj8RmWfUK+nnfbvSrPojJh
 YM8YPLfJeJmFoOC+O9yXw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 February 2010, Thadeu Lima de Souza Cascardo wrote:
> On Mon, Feb 01, 2010 at 09:32:30PM +0100, John Kacur wrote:
> > On Mon, Feb 1, 2010 at 7:18 PM, Thadeu Lima de Souza Cascardo
> > <cascardo@holoscopio.com> wrote:
> And is it possible that ioctl will be called before open returns? If it
> is, then, yes, this is not safe. But I don't really believe the case. Or
> is it?

ioctl may be called on an open file descriptor while open is called
by another thread to open a second file descriptor for the same device.

> Or is it only possible to happen with different struct file*? In that
> case, open is only allocating and initializing the irnet_socket *ap.
> Then, ioctl uses it. There is some race between the different ioctls,
> but no race between open/ioctl for different opened devices. That is, a
> process may open /dev/irnet while another process is issuing ioctls to
> its own opened /dev/irnet.

right.
 
> Besides, dev_irnet_ioctl uses the file private_data to get to the
> irnet_socket, which is the last thing the open call does. I assume doing
> an attribution to a pointer is atomic in all architectures supported by
> Linux currently, isn't it?

The pointer assignment is atomic, but it may not be synchronized to data
pointed to it. On Alpha (probably no others so far), this would result
in irnet_socket seen as uninitialized after the pointer to is can be
seen as valid if there was no locking. No architecture would read an
invalid pointer though.

I guess that what John was trying to point out actually is the fact that
you shouldn't really do the BKL removal in one function only but rather
do it for the whole driver at once. The irnet driver uses the BKL in
open, ioctl and llseek, so if you want to clean up that driver, please
introduce proper locking in the driver and do all of the three.

	Arnd
