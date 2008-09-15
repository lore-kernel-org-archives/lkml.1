Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbYIOWan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbYIOWan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 18:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbYIOWae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 18:30:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:26578 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbYIOWad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 18:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=hzI2dKvHwVeL18aB/rm2u0e6UlS9SNTL8E+ycMgikNvtDcqO7fGhzRhdmMjH0wsjr3
         iYeju5LAv9sZzwB9YClz0vV+ZloS95lbTnPaPKs8oet/vqbqhA/bs5NJ38rvMx9BKJeB
         nSUAoJM/Yr4QW3R3hg/YewKNBw2iNcXWAPQsw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 2/5] ide: ->ide_dma_clear_irq() -> ->clear_irq()
Date: Mon, 15 Sep 2008 15:29:50 -0700
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200808192031.40288.bzolnier@gmail.com> <48AB478B.5040209@ru.mvista.com> <48CEDD89.5060107@ru.mvista.com>
In-Reply-To: <48CEDD89.5060107@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809151529.50424.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 September 2008 15:11:21 Sergei Shtylyov wrote:
> Hello, I wrote:
> 
> >> * Rename ->ide_dma_clear_irq method to ->clear_irq
> >>   and move it from ide_hwif_t to struct ide_port_ops.
> >>
> >> * Move ->waiting_for_dma check inside ->clear_irq method.
> >>
> >> * Move ->dma_base check inside ->clear_irq method.
> >>
> >> piix.c:
> >> * Add ich_port_ops and remove init_hwif_ich() wrapper.
> >>
> >> There should be no functional changes caused by this patch.
> >>   
> >
> >   Good. I think it's worth implementing this method in at least 
> > cmd64x.c which actually reads the IDE interrupt latch bits 
> > (independent from the DMA interrupt status) in the dma_test_irq() 
> > methods but never clears them, so the latches may reflect a 
> > non-current state of the IDE interrupt...
> 
>    I forgot that it does clear them in its dma_end() methods (which I 
> myself have reworked :-).
>    It seems however that at least for SFF-8038 compatibles, it makes 
> sense to leave it that way since INTRQ might be asserted while BMIDE 
> interrupt bit is not, so the interrupt latch would need clearing even on 
> DMA timeout...
> 
> >   It may also be worth considering turning this method into 
> > test-and-clear, so that we can get the actual IDE interrupt state on 
> > the chips that implement this...
> 
>    Probably might add the test_irq() method to be called on 
> !hwif->waiting_for_dma. Cleraing the status at once seems impractical...

Or we can test for ->waiting_for_dma inside ->test_irq.
 
> >> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >
> > Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
>    Not feeling sure about this patch -- ->waiting_for_dma probably 
> should've been left where it was...

Well, it doesn't change behavior and I think having ->clear_irq method
independent from the transfer mode is a preffered approach.

Thanks,
Bart
