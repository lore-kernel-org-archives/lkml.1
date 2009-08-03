Return-Path: <linux-kernel-owner+w=401wt.eu-S932300AbZHCPOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbZHCPOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932157AbZHCPOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:14:32 -0400
Received: from www84.your-server.de ([213.133.104.84]:54392 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099AbZHCPOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:14:32 -0400
Subject: Re: [RFC 0/2] new kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, open-iscsi@googlegroups.com,
       Mike Christie <michaelc@cs.wisc.edu>
In-Reply-To: <200908031642.15136.arnd@arndb.de>
References: <1249306755.8358.8.camel@wall-e>
	 <200908031642.15136.arnd@arndb.de>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 17:14:18 +0200
Message-Id: <1249312458.23559.25.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 03.08.2009, 16:42 +0200 schrieb Arnd Bergmann:
> On Monday 03 August 2009, Stefani Seibold wrote:
> > This is a proposal of a new generic kernel FIFO implementation.
> > 
> > The current kernel fifo API is not very widely used, because it has to many
> > constrains. Only 13 files in the current 2.6.30 used it. FIFO's are
> > like list are a very basic thing and a kfifo API which handles the most use
> > case would save a lot of time and memory resources.
> > 
> > I think there are the following reasons why kfifo is not in use.
> > 
> > - There is a need of a spinlock despite you need it or not
> > - A fifo can only allocated dynamically
> > - There is no support for data records inside a fifo
> > - The FIFO size can only a power of two
> > - The API is to tall, some important functions are missing
> 
> My guess is that more importantly
> 
> - few people so far needed the functionality.
> 

This is not true, that is only your view. Don't speak for other people.
A lot of device driver developer has its own implement of a fifo. I have
written a lot of device drivers for embedded system and i always missed
a clean designed and implemented fifo API subsystem.
 
> All of the existing users are in relatively obscure device drivers,
> a total of 16 committers have touched code using it since 2.6.12
> and almost all the changes were in iSCSI (cc:ing maintainer).
> 
> > So i decided to extend the kfifo in a more generic way without blowing up
> > the API to much. This was my design goals:
> > 
> > - Generic usage: For kernel internal use or device driver
> > - Provide an API for the most use case
> > - Preserve memory resource
> > - Linux style habit: DECLARE_KFIFO, DEFINE_KFIFO and INIT_KFIFO Macros
> > - Slim API: The whole API provides 13 functions.
> > - Ability to handle variable length records. Three type of records are
> >   supported:
> >   - Records between 0-255 bytes, with a record size field of 1 bytes
> >   - Records between 0-65535 bytes, with a record size field of 2 bytes
> >   - Byte stream, which no record size field
> >   Inside a fifo this record types it is not a good idea to mix them together.
> > - Direct copy_to_user from the fifo and copy_from_user into the fifo.
> > - Single structure: The fifo structure contains the management variables and
> >   the buffer. No extra indirection is needed to access the fifo buffer.
> > - Lockless access: if only one reader and one writer is active on the fifo,
> >   which is the common use case, there is no additional locking necessary.
> > - Performance
> > - Easy to use
> 
> This sounds all nice, and your code looks clean and usable, but really,
> what's your point?
> 
> If you have a new driver that will use all the new features, please
> just tell us, that would make your point much clearer. Also, if
> you can quantify an advantage (xxxx bytes code size reduce, yy%
> performance improvement on Y benchmark) that would be really
> helpful.
> 

Yes, i have some drivers where i use a former version of the kfifo API.
But the real advantage is not benchmarking.

First if we have a useable kfifo API i think other developer will use
it. And this will save memory.

Second: The feature to store variable length records in the fifo is IMHO
very nice. It save memory and give you a very flexible method to store
datagrams. Especially many usb devices which works with variable data
packages length. So the new API gives a very easy way to queue this kind
of datagrams.

Third: The old API did not have a kfifo_to_user oder a kfifo_from_user
functionality, so everybody wo need to store userspace data must write
it own version of this.

Fourth: We don't discus about a havy API change, it is more subtle. And
it doesn't blow up the kernel, okay, a little little bit. But i am sure
that this well be gained back, if/when developer use this new API.    

> > One thing is that the new API is not compatible with the old one. I had
> > a look at the current user of the old kfifo API and it is easy to adapt it to
> > the new API. These are the files which use currently the kfifo API:
> > 
> > /usr/src/linux/./drivers/char/nozomi.c
> > /usr/src/linux/./drivers/char/sonypi.c
> > /usr/src/linux/./drivers/infiniband/hw/cxgb3/cxio_resource.c
> > /usr/src/linux/./drivers/media/video/meye.c
> > /usr/src/linux/./drivers/net/wireless/libertas/main.c
> > /usr/src/linux/./drivers/platform/x86/fujitsu-laptop.c
> > /usr/src/linux/./drivers/platform/x86/sony-laptop.c
> > /usr/src/linux/./drivers/scsi/libiscsi.c
> > /usr/src/linux/./drivers/scsi/libiscsi_tcp.c
> > /usr/src/linux/./drivers/scsi/libsrp.c
> > /usr/src/linux/./drivers/usb/host/fhci.h
> > /usr/src/linux/./net/dccp/probe.c
> > 
> > I will do this job if there is a tendency for substitute the old API. So i ask
> > for comments....
> 
> I don't think we should risk introducing regressions if the only possible
> benefit is to make an interface easy to use that almost nobody uses.

I think this is a typical killer argument. Above you wrote the kfifo API
is used only by some obscure device driver. Now you say it is to risky
to change the API. The code is straightforward. If you don't use the new
functionality, especially the variable records, there is only a minor
difference between the old and the new API.
 
> We have also recently gained the include/linux/ring_buffer.h API which
> appears to be a superset of the kfifo API.
> 

The ring_buffer API is in my opinion not the right thing for device
drivers. I think the design goal for this was deep in kernel use.

> 	Arnd <><


