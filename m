Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbYGIL5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbYGIL5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbYGIL44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:56:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:40321 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbYGIL4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:56:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AcP8HvGT+UDWE7/Um70rTK4roa2J3VQ++KGPkIbLi9rmwoMB1AF6xnLiKE3PtLExFX
         va3mZzYqpzsMjPq1wQe7P3GL9mtgtMvQEqHFLC5K0n+92YTUOJmPMeAo8blWZ5vqI6+F
         0bT7wLwnA1mpPpKTrT3GBfwnCc2h0S3dlq+p8=
Message-ID: <bc64b4640807090456u15d12378qe25375ce4a6cd100@mail.gmail.com>
Date: Wed, 9 Jul 2008 15:56:54 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Ben Dooks" <ben-linux@fluff.org>
Subject: Re: [patch 4/4] MFD: Change mfd platform device usage to wrapper platform_device
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20080709115045.GK8517@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080709104916.200210922@fluff.org>
	 <20080709104933.101610936@fluff.org>
	 <bc64b4640807090415w781507fetfe332271ad158112@mail.gmail.com>
	 <20080709112426.GN8489@trinity.fluff.org>
	 <bc64b4640807090431g5b1960edua2508337973615da@mail.gmail.com>
	 <20080709115045.GK8517@trinity.fluff.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/9 Ben Dooks <ben-linux@fluff.org>:
> On Wed, Jul 09, 2008 at 03:31:04PM +0400, Dmitry wrote:
>> 2008/7/9 Ben Dooks <ben-linux@fluff.org>:
>> > On Wed, Jul 09, 2008 at 03:15:47PM +0400, Dmitry wrote:
>> >> 2008/7/9 Ben Dooks <ben-linux@fluff.org>:
>> >> > This patch changes the mfd core behaviour to wrapper the platform_device
>> >> > it creates in an struct mfd_device which contains the information
>> >> > about the cell that was created.
>> >> >
>> >> > 1) The creation of the resource list and then passing it to the
>> >> >   platform_device_add_resources() causes the allocation of a
>> >> >   large array on the stack as well as copying the source data
>> >> >   twice (it is copied from the mfd_cell to the temporary array
>> >> >   and then copied into the newly allocated array)
>> >> >
>> >> > 2) We can wrapper the platform_device into an mfd_device and use
>> >> >   that to do the platform_device and resource allocation in one
>> >> >   go to reduce the failiure.
>> >> >
>> >> > Note, is there actually any reason to pass the sub devices any
>> >> > information about the cell they are created from? The mfd core
>> >> > already makes the appropriate resource adjustments and anything
>> >> > else like clocks should be exported by the clock drivers?
>> >> >
>> >> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
>> >>
>> >>
>> >> NAK.
>> >> 0) It was discussed yesterday on the list and the decision was to go
>> >> in a different way.
>> >>   I've provided a bit cleaner patch with the same idea, but then we
>> >> decided to go in a bit different way.
>> >> 1) I prefer patch by Mike Rapoport which is more clear and goes in a
>> >> more correct way.
>> >
>> > How "more correct", whilst the patch by Mike makes the platform data
>> > be passed from the cell, there is no longer any way to get from the
>> > platform device to the mfd_cell...
>>
>> Basically we have two choises for the subdevice driver:
>> 1) it doesn't know about cells at all (e.g. generic-bl, IIRC). Then we are safe
>>    to loose that "cell" information
>> 2) If it does use cell information (to get access to hooks), we pass it
>>     via platform_data pointer in the mfd_cell and we are ok with it.
>
> Erm, that is complete non-answer. The driver model and various other
> parts of the kernel are littered with examples of embedding one
> structure within another to gain an C++ like object inheritance.
>
> I've supplied an reasonable example of doing this to create an mfd_cell
> device from an platform_device without creating an large amount of code
> and improving the efficiency and code-lineage in the process. I do not
> see how this isn't "correct" or in any way breaing the current linux
> model of doing things.

It isn't breaking it. OK. I'm leaving the decision to the MFD or ARM
maintainers.
And BTW, nearly the same patch was sent yesterday by me[1]. Is it an independant
work, or did you miss my sign-off?

[1]: http://permalink.gmane.org/gmane.linux.ports.arm.kernel/44142

>
>>
>> > The current driver is being inefficent in the way it creates resources
>> > on the stack and then calls a routine that does an kalloc/memcpy on
>> > the resources.
>>
>> I don't see any inefficiency ATM.
>>
>> >> 2) Please examine the tmio-nand driver (was here on the list and on
>> >> linux-mtd). It uses the mfd_cell
>> >>    to call hooks from the "host" driver (tc6393xb, more to be added soon).
>> >
>> > The one posted in [1] does not call these hooks at-all, can ou please
>> > explain why these hooks are needed in addition to the ones already
>> > available in the platform device driver?
>> >
>> > [1] http://lists.infradead.org/pipermail/linux-mtd/2008-June/022137.html
>>
>> +
>> +static int tmio_hw_init(struct platform_device *dev, struct tmio_nand *tmio)
>> +{
>> +     struct mfd_cell *cell = mfd_get_cell(dev);
>> +     const struct resource *nfcr = NULL;
>> +     unsigned long base;
>> +     int i;
>> +
>> +     for (i = 0; i < cell->num_resources; i++)
>> +             if (!strcmp((cell->resources+i)->name, TMIO_NAND_CONTROL))
>> +                     nfcr = &cell->resources[i];
>> +
>> +     if (nfcr == NULL)
>> +             return -ENOMEM;
>> +
>> +     if (cell->enable) {
>> +             int rc = cell->enable(dev);
>> +             if (rc)
>> +                     return rc;
>> +     }
>>
>> That cell->enable() is necessary to set up the host (in the tc6393xb
>> case to enable buffers)
>> to enable access to the nand.
>
> So, the enable/disable calls might be useful, however is there any
> reason this could not be handled by the clock framework? The suspend/resume
> entries where not used, and I belive should not be in here.

They should be here for exactly the same reason. They are used by the drivers
that will be submitted later. E.g. OHCI driver needs such
suspend/resume handling.

> As noted before, mfd_get_cell() got dropped by [2]
>
> [2] http://lists.arm.linux.org.uk/lurker/message/20080708.153450.bb33046d.en.html

Yes, and as I said before it will need some small modifications.

-- 
With best wishes
Dmitry
