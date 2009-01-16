Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbZAPMgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbZAPMgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759225AbZAPMfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 07:35:51 -0500
Received: from h155.mvista.com ([63.81.120.155]:47819 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758351AbZAPMft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 07:35:49 -0500
Message-ID: <49707F20.4030600@ru.mvista.com>
Date: Fri, 16 Jan 2009 15:35:44 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Dmitry Gryazin <gdu@mns.spb.ru>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Kirill Smelkov <kirr@mns.spb.ru>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, navy-patches@mns.spb.ru
Subject: Re: [PATCH] ide: motherboard-info based blacklist for ide-dma
References: <1230651239-29388-1-git-send-email-kirr@mns.spb.ru> <49611CF4.9030103@ru.mvista.com> <4961478B.9060005@ru.mvista.com> <200901151448.52900.gdu@mns.spb.ru>
In-Reply-To: <200901151448.52900.gdu@mns.spb.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Dmitry Gryazin wrote:

>>>> True.  However it should be possible to handle it correctly by adding
>>>> the
>>>> DMA quirk to the respective host drivers (seems to be via82cxxx.c in
>>>> case of
>>>> IEI PCISA-C3/EDEN).
>>>>         
>>>   Yeah, this seems a viable approach...
>>>       
>>>> Kirill, could you please look into adding such quirk to via82cxxx
>>>> instead?
>>>>
>>>> [ It seems the best place to add it would be via_init_one() as we
>>>> could just
>>>>         
>>>   No, not really -- the issue is not at all as simple as this patch
>>> tried to present it. Looking at its "Quick Startup Reference"
>>> (http://f.ipc2u.ru/files/add/doc/496/M_PCISA-C800EV_ENG.pdf), the EPIC
>>> board has *two* normal IDE connectors in addition to the CF slot
>>> (connected to the secondary port -- and it seems possible that a hard
>>> drive can be connected to the same port as CF), so the right place
>>> seems to rather be in [mu]dma_filter() methods -- and the decision
>>> should be strictly based on the drive type indicating CF, i.e. by
>>> calling ata_id_is_cfa().
>>>       
>
> As you suggest, we could use the following criterions:
>
>     Board vendor="FIC"		&&
>     Board name="PT-2200"	&&
>     VIA-family IDE controller	&&
>     drive type=CF
>   

   Yes, but in almost exactly opposite order (well one check shoud be added)

    VT82C686 (or whatever) and
    secondary channel and
    CFA device and
    DMI ID is FIC PT2200

> It should work good enough.
>
> To test it I also tried to install external IDE CF adaptor to the secondary 
> IDE controller (both master and slave).

   You mean that this adaptor is directly connected to IDE slot with the 
cable... hm, haven't seen those.

> And it's also identified as CF drive 
> type. And we turn off DMA for it. But since external CF adaptor could be 
> wired right, turning DMA off would be incorrect in some cases.
>
> Yes, _that_ particular external IDE/CF adaptor that we bought, has the same  
> problem, so turning DMA off on it should be correct. We even decided to 
> verify ourselves that wrong soldering is the cause of problems, and wired 
> manually necessary pins, and, voila, DMA works. So the question is:
>
>     Is it right to implement the above-mentioned criterion, which would work 
>     correctly in 99 cases of 100, but will pessimistically turn DMA off in
>     rare cases (e.g. rightly wired external IDE/CF adaptor attached to
>     PCISA/C3), or is the whole problem unsolvable?
>   

   Good question. However, with the on-board CF adapter already present 
on the seconary channel it seems improbable that the user will need to 
connect another (external) CF adapter. Even if he'd need it, he'd still 
be able to use the primary port.

> We could not come up with the right criterion which selects exactly on-board 
> CF slot, so if there is no satisfactory 100% reliable solution maybe it 
> doesn't make sense to continue...
>   

   I think it still does make sense.

MBR, Sergei


