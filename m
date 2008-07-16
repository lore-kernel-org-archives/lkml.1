Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbYGPFbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbYGPFbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 01:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbYGPFa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 01:30:58 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:6647 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbYGPFa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 01:30:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=j2VHbl8hbjmIEmmek9YzzgO2I8jOTcGp4wIifTVCHTC2eMWX/bRAszv17fzeXqPb+4
         9zrzRNyFohRan6Mq3Vs7onpzW+gfeh8IXpW6KMeYkQ+v7pPi00sNu7o8tl1WyMDb6WVf
         qISyqni0HbOQ7ZT+g5yv/0EdpXYzuzGehuaw8=
Message-ID: <dd18b0c30807152230u39ef9c18v78b48d1c7b9ddd17@mail.gmail.com>
Date: Wed, 16 Jul 2008 05:30:55 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080716035830.GA27935@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30807151252w7edcea19t8cec5ec5f958c7c0@mail.gmail.com>
	 <20080715231118.GA26807@bromo.msbb.uc.edu>
	 <dd18b0c30807151726i622dabceve31828460085ee57@mail.gmail.com>
	 <20080716012427.GA27398@bromo.msbb.uc.edu>
	 <dd18b0c30807152005g3c58001br7182f7670d6247db@mail.gmail.com>
	 <20080716035830.GA27935@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 3:58 AM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> Justin,
>     At the moment I am not really certain what the problem is.
> I have heard that Macintel machines (because of EFI) can't boot
> without resorting to MMCONFIG. If that is true, the problem I
> am seeing would appear to start with the fact that the boot
> proceeds with "Not using MMCONFIG". I plan on trying to add
> some printk statements in arch/x86/pci/mmconfig-shared.c to
> puzzle out why this is failing. The code in question is...
>
>
>                if (!early)
>                        printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not"
>                               " reserved in ACPI motherboard resources\n",
>                               cfg->address);
>                /* Don't try to do this check unless configuration
>                   type 1 is available. how about type 2 ?*/
>                if (raw_pci_ops && e820_all_mapped(cfg->address,
>                                                  cfg->address + size - 1,
>                                                  E820_RESERVED)) {
>                        printk(KERN_NOTICE
>                               "PCI: MCFG area at %Lx reserved in E820\n",
>                               cfg->address);
>                        valid = 1;
>                }
>
>                if (!valid)
>                        goto reject;
>        }
>
>        return;
>
> reject:
>        printk(KERN_ERR "PCI: Not using MMCONFIG.\n");
>        pci_mmcfg_arch_free();
>        kfree(pci_mmcfg_config);
>        pci_mmcfg_config = NULL;
>        pci_mmcfg_config_num = 0;
> }
>
> I've verified that test for raw_pci_ops is passing but it appears
> that the e820_all_mapped() test is failing (at least on
> my machine).
>                        Jack
>
> On Wed, Jul 16, 2008 at 03:05:23AM +0000, Justin Mattock wrote:
>> On Wed, Jul 16, 2008 at 1:24 AM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
>> > Justin,
>> >    You also download the x86_64 iso instead from...
>> >
>> > http://mirrors.kernel.org/fedora/development/x86_64/os/images/
>> >
>> > Both should give you the same kernel boot freeze that I am
>> > seeing (assuming that the kernel boots up with the message
>> > "Not using MMCONFIG". At this point I am just trying to find
>> > out if anyone else can reproduce this issue on a MacBook Pro
>> > (second generation). Otherwise I am going to be out of luck
>> > when distros switch to 2.6.26.
>> >                          Jack
>> > ps I am currently guessing that thet actual freeze is
>> > occuring in the code that is executed right after...
>> >
>> > pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
>> > pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
>> >
>> > but before...
>> >
>> > PCI: Transparent bridge - 0000:00:1e.0
>> >
>> > ...which never appears here under 2.6.26.
>> >
>> >
>> >
>> >
>> > On Wed, Jul 16, 2008 at 12:26:05AM +0000, Justin Mattock wrote:
>> >> >
>> >>
>> >> Ah I see, so this is from a fresh .iso image
>> >> I can give you're suggestion a try(need to locate a blank cd)
>> >> keep in mind the .iso might not have x86 support i.g.
>> >> I use nubuntu(why: it's small) one of the problems I was facing was
>> >> the alpha release, which did not support x86(when using that .iso image
>> >> it would start booting and then spit out a bunch of messages vertically,
>> >> but a few month's later they released there .iso with support thus
>> >> giving me the opportunity to use it.
>> >> This might be what you are dealing with.
>> >> regards;
>> >>
>> >> --
>> >> Justin P. Mattock
>> >
>>
>> I have not yet tried the .iso's yet.
>> (busy with other things at the moment),
>> from what you're telling me it seems they must have left out
>> something in the .config. "Shit" this means you can't even load the .iso itself
>> for the initial install. Maybe you should let them know about this(I
>> don't use fedora that much)
>> If need be, try a stable version of the O.S(fedora). so you can load
>> 2.6.26, and then if time permits
>> you, update to that of the development version.(that is until you get
>> an answer from the
>> maintainers of this .iso with the issue).
>> regards;
>>
>> --
>> Justin P. Mattock
>

Hello;
One of my weaknesses right now is pulling code out of my ass
(maybe in a few years from now), but from what you are showing me
This is what is causing the NULL(if that's right to say)

 if (!valid)
                       goto reject;

So the question is, is how to have a valid
"something" to prevent going to NULL
maybe a boot param i.g. acpi_osi=Darwin,
or another option to make a "good" !valid
So you don't:   goto reject;

Or take the whole reject mechanism out
just so you can boot up, and then asses the situation from there.
regards;


-- 
Justin P. Mattock
