Return-Path: <linux-kernel-owner+w=401wt.eu-S1752237AbZISTMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbZISTMQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 15:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbZISTMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 15:12:16 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:42211 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbZISTMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 15:12:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AH34dS7G0NsnMfgwyUn8BHceSUfINPl54VIMuJOAZx1tk2dOrDHgNWH5QUj/Oru6cq
         WqoH7XfDWYGUkr1m/yzMeoQCKESBINNscu+L1TC+WjZdCstfy5M79+MsuHQBIOmdRTQv
         rsYD1R2JRERPDwZSEhj6hdeMWteglsBg8y+9w=
MIME-Version: 1.0
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901D41FB1@mi8nycmail19.Mi8.com>
References: <1253224997-7422-1-git-send-email-vapier@gentoo.org> 
	<BD79186B4FD85F4B8E60E381CAEE190901D41E44@mi8nycmail19.Mi8.com> 
	<8bd0f97a0909171553s1b7ee725x728bbca2f49511a9@mail.gmail.com> 
	<BD79186B4FD85F4B8E60E381CAEE190901D41FB1@mi8nycmail19.Mi8.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 19 Sep 2009 15:11:59 -0400
Message-ID: <8bd0f97a0909191211q4170febfj316d1c0cae31ef5d@mail.gmail.com>
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

On Fri, Sep 18, 2009 at 19:00, H Hartley Sweeten wrote:
> On Thursday, September 17, 2009 3:54 PM, Mike Frysinger wrote:
>>> I assume the spi master driver must supply the {lock/unlock}_bus methods
>>> to properly support the locking.
>>
>> currently, yes.  a common solution would be nice.  ideas/patches welcome ;).
>>
>>> But, by returning 0 when the methods
>>> are not supplied you are basically saying all the current master drivers
>>> in mainline support bus locking.  I think this is really only "true" if
>>> spi->master->num_chipselect == 1.
>>
>> right, but that is no different from what we have today.  there is no
>> way for a client to guarantee exclusive access, so you cant write code
>> assuming it in the first place.  the only consumer thus far (mmc_spi)
>> actually errors out if such conditions exist.
>>
>> in other words, we arent breaking anything.
>
> Actually you are breaking the mmc_spi driver.

no we arent.  the current code does some sloppy checking for possible
concurrent access and then aborts.  the new code drops that sloppy
checking in place of the bus master doing it right.  any setup that is
working today will continue to work fine.  and setup *that is already
broken* will continue to be broken.

> By returning 0 when the methods are not supplied you are saying that the
> master driver supports and locked the bus.  At a minimum, I think spi_lock_bus()
> should return an error code if locking is not supported.
>
> Also, as Andrew Morton pointed out, calling spi_unlock_bus() without having
> a valid lock by calling spi_lock_bus() is a bug.
>
> In addition your patch to mmc_spi should check the return code from
> spi_lock_bus().  If the driver "requires" that the bus be locked it should
> trigger an error path if it cannot be locked.
>
>>> Also, do you have a master driver that does have the {lock/unlock}_bus
>>> methods?  I would like to see how you handled it.
>>
>> http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=commitdiff;h=cc54fa8ed63e11a000031bc650d41d57b441803d
>
> Oiy... The lock/unlock functions are simple enough but the change needed
> to bfin_spi_pump_messages() is a bit complicated.
>
> What happens to next_msg if it is for other devices on the bus?

Yi can take a stab at addressing these issues since he is the guy who
has been putting together in the first place.
-mike
