Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbYKRXoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbYKRXoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 18:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYKRXoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 18:44:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:18372 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbYKRXoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 18:44:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=NvZoO4gf1wwW//Bz+OFghELN05p8VDfdm6zQlZPSdD/hwDz7y1A6mj77BUX2giCJWW
         jciFXAiCnhtvJOzMvvSDl1K7PIe9TLNZ2MSrc6LE6BWdLXTc/Lv0oNaY5nS5lDaoxAFG
         Yj43Ap2A/q1xdhvvSoU9qPHtUx+1eWSM7wag4=
From: Eric Lacombe <goretux@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [x86] do_arch_prctl - bug?
Date: Wed, 19 Nov 2008 00:44:11 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.5; KDE/4.1.3; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <200811181835.07360.goretux@gmail.com>
In-Reply-To: <200811181835.07360.goretux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811190044.11566.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I look at the Intel docs (vol. 3A) again, and see that in 64 bits mode the 
hidden field gs.base are physically mapped to the MSR, so it seems that in 
order to load gs.base we don't need to load gs (like in 32 bits mode), but 
rather we only need to load the MSR.

So I don't understand the purpose of load_gs_index in that context :

if (doit) {
	load_gs_index(0);
	ret = checking_wrmsrl(MSR_KERNEL_GS_BASE, addr);
}

Why don't we only load the MSR ?
What is the purpose of calling load_gs_index with 0 as parameter ?

Thanks in advance for your response,

	Eric

> ENTRY(native_load_gs_index)
>         CFI_STARTPROC
>         pushf
>         CFI_ADJUST_CFA_OFFSET 8
>         DISABLE_INTERRUPTS(CLBR_ANY | ~(CLBR_RDI))
>         SWAPGS
> gs_change:
>         movl %edi,%gs
> 2:      mfence          /* workaround */
>         SWAPGS
>         popf
>         CFI_ADJUST_CFA_OFFSET -8
>         ret
>         CFI_ENDPROC
> ENDPROC(native_load_gs_index)

