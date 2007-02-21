Return-Path: <linux-kernel-owner+w=401wt.eu-S1161188AbXBULes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161188AbXBULes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161212AbXBULer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:34:47 -0500
Received: from wx-out-0506.google.com ([66.249.82.235]:39344 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161188AbXBULeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:34:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=aGSKVeULAataZFZoeCxtoavASpBLwVvj4zdUpbpNTfW7++wPm0lNTzT+tukxNmbzu9YAFW8EPAIj+bnhMNcHNcOFyhREQ5rTRP5t+cpQW+vWatUimOWaeNGNEoUz8iMzTauVSfKkJm+2gGvnxvr2iVv16i0ArecTJMA7S18sXTE=
Message-ID: <45DC2E52.4030506@gmail.com>
Date: Wed, 21 Feb 2007 20:34:42 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Marcel Holtmann <marcel@holtmann.org>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: current git crashes on bootup with pci_iounmap()
References: <1171380714.3829.6.camel@pim.off.vrfy.org>	 <1171382645.23580.29.camel@violet>	 <1171385524.3855.2.camel@pim.off.vrfy.org> <3ae72650702141257w6b30a8efge5b6109feebb5512@mail.gmail.com>
In-Reply-To: <3ae72650702141257w6b30a8efge5b6109feebb5512@mail.gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On 2/13/07, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> On Tue, 2007-02-13 at 17:04 +0100, Marcel Holtmann wrote:
>> > > kernel BUG at lib/iomap.c:254!
>> > > invalid opcode: 0000 [#1]
>> > > ...
>> > >
>> > > The screen picture is here:
>> > >   http://vrfy.org/pci_iounmap.jpg
>> > >
>> > > It's a Thinkpad T43p.
>> > >
>> > > 2.6.20 was working fine.
>> > >
>> > > Commenting out:
>> > >   IO_COND(addr, /* nothing */, iounmap(addr));
>> > > in:
>> > >   lib/iomap.c:254
>> > > makes at least booting up possible.
>> >
>> > I saw a similar one on my X41. Disabling the AHCI driver made the
>> > machine booting again.
>>
>> Hey Marcel,
>> yeah, that works fine here too.
> 
> Tejun, Jeff, any ideas what's going wrong with the iomap change and
> the AHCI driver?

The following commit should have fixed the problem, at least the oops.
Care to give the current git head a shot?

commit fb4d64e78ceab77cf20f7796f74aa10ebe862032
Author: Frederik Deweerdt <deweerdt@free.fr>
Date:   Fri Feb 16 01:27:15 2007 -0800

    [PATCH] pci_iomap_regions() error handling fix

    It appears that the pcim_iomap_regions() function doesn't get the error
    handling right. It BUGs early at boot with a backtrace along the
lines of:

    ahci_init
    pci_register_driver
    driver_register
    [...]
    ahci_init_one
    pcim_iomap_region
    pcim_iounmap

    The following patch allows me to boot. Only the if(mask..) continue;
    part fixes the problem actually, the gotos where changed so that we
    don't try to unmap something we couldn't map anyway.

    Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Tejun Heo <htejun@gmail.com>
    Cc: Jeff Garzik <jeff@garzik.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

-- 
tejun
