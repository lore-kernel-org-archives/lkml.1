Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbXGIDfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbXGIDfw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 23:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758756AbXGIDfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 23:35:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40790 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758723AbXGIDfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 23:35:41 -0400
Message-ID: <4691ACEA.8000607@torque.net>
Date: Sun, 08 Jul 2007 23:35:06 -0400
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: DervishD <lkml@dervishd.net>, Linux-kernel <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: cdparanoia not setting count and/or reply_len properly
References: <20070708103928.GA20349@DervishD> <4690DA1B.3010901@s5r6.in-berlin.de>
In-Reply-To: <4690DA1B.3010901@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> DervishD wrote at lkml:
>>     Hi all :)
>>
>>     I know, this has been treated on the list before (year 2005) but
>> without any real solution I'm aware of.
>>
>>     I'm running kernel 2.6.20.14, and I have an ATAPI DVD writer that I
>> use with an IDE-to-USB adapter, so it appears as an SCSI drive to the
>> kernel.
>>
>>     Anytime I rip anything with it, the log fills with the same message:
>> some numbers about a certain number of bytes and the old friend message
>> that I've put in the subject.
>>
>>     I assume that the warning makes sense, but the fact is that my log
>> is full with the same message, the ripping is correct (so cdparanoia is
>> working OK WRT ripping) and if weren't for the printk_ratelimit, the
>> system will freeze.
>>
>>     I don't know if cdparanoia should be fixed, but certainly the
>> warning could be issued only if CONFIG_SCSI_VERBOSE is set. This way you
>> will have the message if something goes wrong and you want more info,
>> but in cases where the warning is harmless your log will be clean...
>>
>>     Anyway, this message is not for make suggestions, but for asking for
>> information: why is this warning happening? naugthy cdparanoia? naughty
>> kernel? I'm a bit confused and I want to use my external DVD drive for
>> ripping from time to time, to "exercise" it...
>>
>>     Thanks a lot in advance :)
>>
>>     Raúl Núñez de Arenas Coronado
>>
> 
> This question is better asked at lsml.  (Therefore I'm quoting in full.)

In Fedora 7 I see this:

# cdparanoia --version
cdparanoia III release 9.8 (March 23, 2001)
(C) 2001 Monty <monty@xiph.org> and Xiphophorus

Report bugs to paranoia@xiph.org
http://www.xiph.org/paranoia/


So, given that date, lk 2.4.2 was out but it was probably
a bit early to start using the sg version 3 interface
which first appeared in lk 2.4.1 . So that "lets annoy
the user" message was added by someone who got burnt by
the old sg version 2 interface and decided people needed
to be warned. The warning comes from this code is sg.c :

        /*
         * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
         * but is is possible that the app intended SG_DXFER_TO_DEV, because the
re
         * is a non-zero input_size, so emit a warning.
         */
        if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV)
                if (printk_ratelimit())
                        printk(KERN_WARNING
                               "sg_write: data in/out %d/%d bytes for SCSI comma
nd 0x%x--"
                               "guessing data in;\n" KERN_WARNING "   "
                               "program %s not setting count and/or reply_len pr
operly\n",
                               old_hdr.reply_len - (int)SZ_SG_HEADER,
                               input_size, (unsigned int) cmnd[0],
                               current->comm);

That code wasn't written be me and I would gladly remove it.
For anyone who has read the sg driver documentation,
SG_DXFER_TO_FROM_DEV implies a _read_ from the device. The
reason SG_DXFER_TO_FROM_DEV exists is for backward
compatibility to the sg version 1 interface. It was a hack to
get around the fact that the SCSI subsystem didn't report short
reads (what folks should use 'resid' for) back in those days.


It is probably about time that cdparanoia was updated ...

Doug Gilbert




