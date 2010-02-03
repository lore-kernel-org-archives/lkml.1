Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab0BCRKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:10:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:45109 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab0BCRKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:10:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kh21QvV72wgsOtmlQu+PWwijEGiPLeYXfmHcGnxa/SfJy7Dh/UgE9uPWy2i6uohP/t
         SW/vgDLOBvPJITWf2del1KMy6hPr0cJPUCP87sQYKrZORVc1wu4ULa8SsqeHPvW2WP2d
         6zg5TF7S1uIBLyZEQ40IGI4QUk66ZnvTcSYOQ=
Message-ID: <4B69AE5B.9060708@gmail.com>
Date: Wed, 03 Feb 2010 09:11:55 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, Ingo Molnar <mingo@elte.hu>,
       Dan Carpenter <error27@gmail.com>, bernhard.kaindl@gmx.net,
       Thomas Gleixner <tglx@linutronix.de>,
       linux1394-devel@lists.sourceforge.net, Rafael Wysocki <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ebiderman@xmission.com, hpa@zytor.com
Subject: Re: ohci1394_dma=early crash since 2.6.32 (was Re: [Bug	 #14487]
 PANIC: early exception 08 rip 246:10	 error	ffffffff810251b5 cr2 0)
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com> <20100201125441.GB2576@bicker> <4B671606.3080405@gmail.com> <4B673233.8000300@s5r6.in-berlin.de> <4B6740B5.5070601@gmail.com> <4B675534.5070107@s5r6.in-berlin.de> <4B676917.2080506@gmail.com> <4B67BC12.4080709@s5r6.in-berlin.de> <4B67C4D2.5050205@gmail.com> <4B67CC55.40301@s5r6.in-berlin.de> <4B67CCEC.2030103@s5r6.in-berlin.de> <4B68D4CA.2010803@gmail.com> <4B694D5C020000780002D6DA@vpn.id2.novell.com>
In-Reply-To: <4B694D5C020000780002D6DA@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/10 01:18, Jan Beulich wrote:
>>>> "Justin P. Mattock"<justinmattock@gmail.com>  03.02.10 02:43>>>
>> The only thing I can think of at this point
>> is maybe the CFLAGS I used to build this system.
>> (as for the x86_32 working and x86_64 failing not sure);
>>
>> I'm curious to see if anybody else is hitting this?
>
> I think it is pretty clear how a page fault can happen here (but you're
> observing a double fault, which I cannot explain [nor can I explain
> why the fault apparently didn't get an error code pushed, which is
> why address and error code displayed are mixed up]): I would
> suspect that FIX_OHCI1394_BASE is now in a different (virtual) 2Mb
> range than what is covered by level{1,2}_fixmap_pgt, but this was
> a latent issue even before that patch (just waiting for sufficiently
> many fixmap entries getting inserted before
> __end_of_permanent_fixed_addresses).
>
> The thing is that head_64.S uses hard-coded numbers, but doesn't
> really make sure (at build time) that the fixmap page tables established
> indeed cover all the entries of importance (and honestly I even can't
> easily tell which of the candidates - FIX_DBGP_BASE,
> FIX_EARLYCON_MEM_BASE, and FIX_OHCI1394_BASE afaict - really
> matter). If either of the first does, the only reasonable solution imo
> is to move FIX_OHCI1394_BASE out of the boot time only range into
> the permanent range (unless the other two can be moved into the
> boot time only range). And obviously the hard coded numbers
> should be eliminated from head_64.S.
>
> Jan
>
>

Thanks for your info on this. I can try today moving things
around just to see. Looking more into this(keep in mind I
have no idea how these page,fix_to_virt calls etc.. work)
I was thinking with what stefan had mentioned ___alloc_bootmem_node
(still need to look into what that function does)maybe keeping fixmap.h 
as is and looking somewhere else might be where the fix might be(but 
could be wrong).

In any case I'll have another go at this today.

Justin P. Mattock

