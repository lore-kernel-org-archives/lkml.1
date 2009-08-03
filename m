Return-Path: <linux-kernel-owner+w=401wt.eu-S932165AbZHCOmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbZHCOmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 10:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbZHCOml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 10:42:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:63381 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbZHCOmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 10:42:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefani Seibold <stefani@seibold.net>
Subject: Re: [RFC 0/2] new kfifo API
Date: Mon, 3 Aug 2009 16:42:14 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.98; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, open-iscsi@googlegroups.com,
       Mike Christie <michaelc@cs.wisc.edu>
References: <1249306755.8358.8.camel@wall-e>
In-Reply-To: <1249306755.8358.8.camel@wall-e>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908031642.15136.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/x5pgbwhYonmrRZcsoR3jJd6Vn8WrQ4ikq8PH
 R+n42CVfSUW2xUvJbLVumGY7ugtVakVtVQMQ6f8x0ppQ/Fp1Dt
 CCC7BmeofzlFd42Kwumww==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Stefani Seibold wrote:
> This is a proposal of a new generic kernel FIFO implementation.
> 
> The current kernel fifo API is not very widely used, because it has to many
> constrains. Only 13 files in the current 2.6.30 used it. FIFO's are
> like list are a very basic thing and a kfifo API which handles the most use
> case would save a lot of time and memory resources.
> 
> I think there are the following reasons why kfifo is not in use.
> 
> - There is a need of a spinlock despite you need it or not
> - A fifo can only allocated dynamically
> - There is no support for data records inside a fifo
> - The FIFO size can only a power of two
> - The API is to tall, some important functions are missing

My guess is that more importantly

- few people so far needed the functionality.

All of the existing users are in relatively obscure device drivers,
a total of 16 committers have touched code using it since 2.6.12
and almost all the changes were in iSCSI (cc:ing maintainer).

> So i decided to extend the kfifo in a more generic way without blowing up
> the API to much. This was my design goals:
> 
> - Generic usage: For kernel internal use or device driver
> - Provide an API for the most use case
> - Preserve memory resource
> - Linux style habit: DECLARE_KFIFO, DEFINE_KFIFO and INIT_KFIFO Macros
> - Slim API: The whole API provides 13 functions.
> - Ability to handle variable length records. Three type of records are
>   supported:
>   - Records between 0-255 bytes, with a record size field of 1 bytes
>   - Records between 0-65535 bytes, with a record size field of 2 bytes
>   - Byte stream, which no record size field
>   Inside a fifo this record types it is not a good idea to mix them together.
> - Direct copy_to_user from the fifo and copy_from_user into the fifo.
> - Single structure: The fifo structure contains the management variables and
>   the buffer. No extra indirection is needed to access the fifo buffer.
> - Lockless access: if only one reader and one writer is active on the fifo,
>   which is the common use case, there is no additional locking necessary.
> - Performance
> - Easy to use

This sounds all nice, and your code looks clean and usable, but really,
what's your point?

If you have a new driver that will use all the new features, please
just tell us, that would make your point much clearer. Also, if
you can quantify an advantage (xxxx bytes code size reduce, yy%
performance improvement on Y benchmark) that would be really
helpful.

> One thing is that the new API is not compatible with the old one. I had
> a look at the current user of the old kfifo API and it is easy to adapt it to
> the new API. These are the files which use currently the kfifo API:
> 
> /usr/src/linux/./drivers/char/nozomi.c
> /usr/src/linux/./drivers/char/sonypi.c
> /usr/src/linux/./drivers/infiniband/hw/cxgb3/cxio_resource.c
> /usr/src/linux/./drivers/media/video/meye.c
> /usr/src/linux/./drivers/net/wireless/libertas/main.c
> /usr/src/linux/./drivers/platform/x86/fujitsu-laptop.c
> /usr/src/linux/./drivers/platform/x86/sony-laptop.c
> /usr/src/linux/./drivers/scsi/libiscsi.c
> /usr/src/linux/./drivers/scsi/libiscsi_tcp.c
> /usr/src/linux/./drivers/scsi/libsrp.c
> /usr/src/linux/./drivers/usb/host/fhci.h
> /usr/src/linux/./net/dccp/probe.c
> 
> I will do this job if there is a tendency for substitute the old API. So i ask
> for comments....

I don't think we should risk introducing regressions if the only possible
benefit is to make an interface easy to use that almost nobody uses.
We have also recently gained the include/linux/ring_buffer.h API which
appears to be a superset of the kfifo API.

	Arnd <><
