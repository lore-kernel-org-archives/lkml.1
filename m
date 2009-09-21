Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbZIUODm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbZIUODm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbZIUODl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:03:41 -0400
Received: from mail-yw0-f185.google.com ([209.85.211.185]:42459 "EHLO
	mail-yw0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbZIUODl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:03:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VdFFCDFUAdOiag9fcwGxxLt1R5j5/DuvvYGIRlewxqbGOGVWyixQ7NJ96bDWHhhE0s
         l+LIdeh+cgFCO4m33r+nGTj6QTeeBknYcLIFN11JbU0DkVxVylC2G3dfSKCUs0XGal0h
         o6ZzLoc0nLBcD4xUgcTeqfHVb2eYm8uefIssA=
MIME-Version: 1.0
In-Reply-To: <1253514780.3925.36.camel@adam-desktop>
References: <1253224997-7422-1-git-send-email-vapier@gentoo.org> 
	<20090918142911.2d0c4408.akpm@linux-foundation.org> <1253514780.3925.36.camel@adam-desktop>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 21 Sep 2009 09:36:25 -0400
Message-ID: <8bd0f97a0909210636h655ba305sfef099b0f20a8176@mail.gmail.com>
Subject: Re: [PATCH 1/2] spi: new SPI bus lock/unlock functions
To: Li Yi <yi.li@analog.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       cooloney@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 02:33, Li Yi wrote:
> On Fri, 2009-09-18 at 14:29 -0700, Andrew Morton wrote:
>> On Thu, 17 Sep 2009 18:03:16 -0400
>> Mike Frysinger <vapier@gentoo.org> wrote:
>>
>> > From: Yi Li <yi.li@analog.com>
>> >
>> > For some MMC cards over SPI bus, it needs to lock the SPI bus for its own
>> > use.  The SPI transfer must not be interrupted by other SPI devices that
>> > share the SPI bus with SPI MMC card.
>> >
>> > This patch introduces 2 APIs for SPI bus locking operation.
>> >
>> > Signed-off-by: Yi Li <yi.li@analog.com>
>> > Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> > ---
>> > Andrew: we've posted these in the past with no response.  could you pick
>> >         them up please ?
>> >
>> >  drivers/spi/spi.c       |   48 +++++++++++++++++++++++++++++++++++++++++++++++
>> >  include/linux/spi/spi.h |    7 ++++++
>> >  2 files changed, 55 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
>> > index 70845cc..b82b8ad 100644
>> > --- a/drivers/spi/spi.c
>> > +++ b/drivers/spi/spi.c
>> > @@ -653,6 +653,54 @@ static void spi_complete(void *arg)
>> >  }
>> >
>> >  /**
>> > + * spi_lock_bus - lock SPI bus for exclusive access
>> > + * @spi: device which want to lock the bus
>> > + * Context: any
>> > + *
>> > + * Once the caller owns exclusive access to the SPI bus,
>> > + * only messages for this device will be transferred.
>> > + * Messages for other devices are queued but not transferred until
>> > + * the bus owner unlock the bus.
>> > + *
>> > + * The caller may call spi_lock_bus() before spi_sync() or spi_async().
>> > + * So this call may be used in irq and other contexts which can't sleep,
>> > + * as well as from task contexts which can sleep.
>>
>> Hence spi_lock_bus() basically has to use a spinning lock?
>>
>> So code which has called spi_lock_bus() cannot sleep until it calls
>> spi_unlock_bus()?
>>
>> That's worth mentioning in the description.
>>
> Code called spi_lock_bus() _can_ sleep. This is mentioned in the
> comments.

should add might_sleep() to the common spi_lock_bus() function then.
-mike
