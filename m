Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbYIPJRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbYIPJRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 05:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYIPJRC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 05:17:02 -0400
Received: from h155.mvista.com ([63.81.120.155]:14044 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751203AbYIPJRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 05:17:00 -0400
Message-ID: <48CF7986.2020302@ru.mvista.com>
Date: Tue, 16 Sep 2008 13:16:54 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jeremy@sgi.com
Subject: Re: [PATCH 2/5] ide: ->ide_dma_clear_irq() -> ->clear_irq()
References: <200808192031.40288.bzolnier@gmail.com> <48AB478B.5040209@ru.mvista.com> <48CEDD89.5060107@ru.mvista.com> <200809151529.50424.bzolnier@gmail.com>
In-Reply-To: <200809151529.50424.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>>> * Rename ->ide_dma_clear_irq method to ->clear_irq
>>>>   and move it from ide_hwif_t to struct ide_port_ops.
>>>>
>>>> * Move ->waiting_for_dma check inside ->clear_irq method.
>>>>
>>>> * Move ->dma_base check inside ->clear_irq method.
>>>>
>>>> piix.c:
>>>> * Add ich_port_ops and remove init_hwif_ich() wrapper.
>>>>
>>>> There should be no functional changes caused by this patch.
>>>>   
>>>>         
>>>   Good. I think it's worth implementing this method in at least 
>>> cmd64x.c which actually reads the IDE interrupt latch bits 
>>> (independent from the DMA interrupt status) in the dma_test_irq() 
>>> methods but never clears them, so the latches may reflect a 
>>> non-current state of the IDE interrupt...
>>>       
>>    I forgot that it does clear them in its dma_end() methods (which I 
>> myself have reworked :-).
>>    It seems however that at least for SFF-8038 compatibles, it makes 
>> sense to leave it that way since INTRQ might be asserted while BMIDE 
>> interrupt bit is not, so the interrupt latch would need clearing even on 
>> DMA timeout...
>>     
>>>   It may also be worth considering turning this method into 
>>> test-and-clear, so that we can get the actual IDE interrupt state on 
>>> the chips that implement this...
>>>       
>>    Probably might add the test_irq() method to be called on 
>> !hwif->waiting_for_dma. Cleraing the status at once seems impractical...
>>     
>
> Or we can test for ->waiting_for_dma inside ->test_irq.
>   

   That also will do...

>>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>>>         
>>> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
>>>       
>>    Not feeling sure about this patch -- ->waiting_for_dma probably 
>> should've been left where it was...
>>     
>
> Well, it doesn't change behavior and I think having ->clear_irq method
> independent from the transfer mode is a preffered approach.
>   

   But its implementations will have to depend on it anyway. And 
clearing the IDE interrupt in general already depends on the transfer 
mode -- the BMIDE interrupt which is a (delayed) reflection of INTRQ is 
cleared implicitly by the dma_end() method -- except in at least sgiioc4 
driver.
   BTW, sgiioc4 seems another candidate for clear_irq() implementation 
-- currently clearing is done implicitly by the read_status() method (I 
don't quite understand why it clears DMA error interrupt there). 
However, since there's no documentation, I'm not sure how the IDE 
interrupt is latched by IOC4.

> Thanks,
> Bart
>   

MBR, Sergei


