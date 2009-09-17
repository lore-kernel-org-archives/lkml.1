Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbZIQWyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbZIQWyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 18:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZIQWyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 18:54:15 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:53206 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbZIQWyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 18:54:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=d4pCveKKXTjTJISl4J5ZWQglXNepZoB2tErvGCIJHsuG4uSYrlioyT4RrwBqB5OWK3
         Pb9WwJRG8LspvY+TswofkEN4W9Ten5SFyJy/jv8WCr/GYYXM0yPB33rvDvaxPexd4tVd
         CZHWezakfrK2hUFcW/wKK8pVjwccxG8yO0DC8=
MIME-Version: 1.0
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901D41E44@mi8nycmail19.Mi8.com>
References: <1253224997-7422-1-git-send-email-vapier@gentoo.org> 
	<BD79186B4FD85F4B8E60E381CAEE190901D41E44@mi8nycmail19.Mi8.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 17 Sep 2009 18:53:58 -0400
Message-ID: <8bd0f97a0909171553s1b7ee725x728bbca2f49511a9@mail.gmail.com>
Subject: Re: [spi-devel-general] [PATCH 1/2] spi: new SPI bus 
	lock/unlockfunctions
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       Yi Li <yi.li@analog.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 18:45, H Hartley Sweeten wrote:
> On Thursday, September 17, 2009 3:03 PM, Mike Frysinger wrote:
>> From: Yi Li <yi.li@analog.com>
>>
>> For some MMC cards over SPI bus, it needs to lock the SPI bus for its own
>> use.  The SPI transfer must not be interrupted by other SPI devices that
>> share the SPI bus with SPI MMC card.
>>
>> This patch introduces 2 APIs for SPI bus locking operation.
>>
>>  /**
>> + * spi_lock_bus - lock SPI bus for exclusive access
>> + * @spi: device which want to lock the bus
>> + * Context: any
>> + *
>> + * Once the caller owns exclusive access to the SPI bus,
>> + * only messages for this device will be transferred.
>> + * Messages for other devices are queued but not transferred until
>> + * the bus owner unlock the bus.
>> + *
>> + * The caller may call spi_lock_bus() before spi_sync() or spi_async().
>> + * So this call may be used in irq and other contexts which can't sleep,
>> + * as well as from task contexts which can sleep.
>> + *
>> + * It returns zero on success, else a negative error code.
>> + */
>> +int spi_lock_bus(struct spi_device *spi)
>> +{
>> +     if (spi->master->lock_bus)
>> +             return spi->master->lock_bus(spi);
>> +     else
>> +             return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(spi_lock_bus);
>> +
>> +/**
>> + * spi_unlock_bus - unlock SPI bus
>> + * @spi: device which want to unlock the bus
>> + * Context: any
>> + *
>> + * The caller has called spi_lock_bus() to lock the bus. It calls
>> + * spi_unlock_bus() to release the bus so messages for other devices
>> + * can be transferred.
>> + *
>> + * If the caller did not call spi_lock_bus() before, spi_unlock_bus()
>> + * should have no effect.
>> + *
>> + * It returns zero on success, else a negative error code.
>> + */
>> +int spi_unlock_bus(struct spi_device *spi)
>> +{
>> +     if (spi->master->unlock_bus)
>> +             return spi->master->unlock_bus(spi);
>> +     else
>> +             return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(spi_unlock_bus);
>> +
>> +/**
>
> I assume the spi master driver must supply the {lock/unlock}_bus methods
> to properly support the locking.

currently, yes.  a common solution would be nice.  ideas/patches welcome ;).

> But, by returning 0 when the methods
> are not supplied you are basically saying all the current master drivers
> in mainline support bus locking.  I think this is really only "true" if
> spi->master->num_chipselect == 1.

right, but that is no different from what we have today.  there is no
way for a client to guarantee exclusive access, so you cant write code
assuming it in the first place.  the only consumer thus far (mmc_spi)
actually errors out if such conditions exist.

in other words, we arent breaking anything.

> Also, do you have a master driver that does have the {lock/unlock}_bus
> methods?  I would like to see how you handled it.

http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=commitdiff;h=cc54fa8ed63e11a000031bc650d41d57b441803d
-mike
