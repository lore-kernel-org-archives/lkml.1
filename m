Return-Path: <linux-kernel-owner+w=401wt.eu-S1760911AbZATXRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911AbZATXRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 18:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbZATXR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 18:17:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62866 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbZATXR0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 18:17:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] usb/mcs7830: Don't use buffers from stack for USB transfers
Date: Wed, 21 Jan 2009 00:17:18 +0100
User-Agent: KMail/1.9.9
Cc: ceggers@gmx.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <34115.192.168.0.40.1232483361.squirrel@server> <200901202345.47792.arnd@arndb.de> <20090120.144719.120709836.davem@davemloft.net>
In-Reply-To: <20090120.144719.120709836.davem@davemloft.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901210017.19038.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18pHslTRKYhHQzyIimcZXof7fXtowiETzTB3FR
 yxVW3v2WglHhWYjcmXVrAbD1rChuQmJfQwEv477wRkJPcrHcHf
 uSyazLw3GcIvQ1Kfruf+Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 January 2009, David Miller wrote:
> You cannot DMA from/to the kernel stack, because it might not be in
> the aliased linear mapping of physical memory.  It could even be
> vmalloc()'d memory on some platforms.

Ok, I see. It seems a bit of a waste to do a kmalloc for something
that is guaranteed to be just a few bytes, but allocating the
buffer per-device would mean another mutex, which has about the
same overhead, so I'm basically ok with the patch.

> +       buffer = kmalloc(size, GFP_NOIO);

GFP_NOIO seems out of place in a network driver: there is nothing
wrong with waiting for I/O here, so plain GFP_KERNEL should be fine.

> +       if (buffer == NULL)
> +               return -ENOMEM;

I'd prefer to write 

	if (!buffer)

here, as I do elsewhere in the driver.

Otherwise,

Acked-by: Arnd Bergmann <arnd@arndb.de>
