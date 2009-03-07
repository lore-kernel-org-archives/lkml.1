Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbZCGBZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbZCGBZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 20:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbZCGBZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 20:25:12 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:38624 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbZCGBZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 20:25:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EbYrd+WkcpQiLwe4d+omiU0qwJ7TkYAKvAc0KbJ83tj8GBmRFABEOexTQNF2X81oPz
         buGzipeeStOQaE+62gQhJJ6QA4m2EVAz45BhlpPoP6gjhU9P87a/X2WTjkv1jmzXqzR7
         rIWtwKBnloiokIcKVRydnRw+8KNcx4NHLk97U=
MIME-Version: 1.0
In-Reply-To: <adaiqmmf87v.fsf@cisco.com>
References: <1236384801-10305-1-git-send-email-timur@freescale.com>
	 <adaiqmmf87v.fsf@cisco.com>
Date: Fri, 6 Mar 2009 19:25:08 -0600
X-Google-Sender-Auth: e5cfbbee1b35fda7
Message-ID: <ed82fe3e0903061725y40dc246ehd3482690ee3898fa@mail.gmail.com>
Subject: Re: [PATCH] add function spin_event_timeout()
From: Timur Tabi <timur@freescale.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 6, 2009 at 7:11 PM, Roland Dreier <rdreier@cisco.com> wrote:
>  > The function spin_event_timeout() takes a condition and timeout value
>  > (in jiffies) as parameters.  It spins until either the condition is true
>  > or the timeout expires.  It returns non-zero if the condition is true,
>  > zero otherwise.
>
> What's the motivation for this?  Where do you plan to use it?

I expect it would be useful for drivers that need to wait until a
specific register has changed its value, but don't want to risk an
infinite loop if the hardware is not functioning.  For example, to
replace the while loop and subsequent check in this code:

long timeout = jiffies + 10;

setbits32(&ssi->scr, CCSR_SSI_SCR_SSIEN | CCSR_SSI_SCR_RE);

/* Wait until the SSI has filled its FIFO. Without this
 * delay, ALSA complains about overruns.  When the FIFO
 * is full, the DMA controller initiates its first
 * transfer.  Until then, however, the DMA's DAR
 * register is zero, which translates to an
 * out-of-bounds pointer.  This makes ALSA think an
 * overrun has occurred.
*/
while (!(in_be32(&ssi->sisr) & CCSR_SSI_SISR_RFF0) &&
        (jiffies < timeout));
if (!(in_be32(&ssi->sisr) & CCSR_SSI_SISR_RFF0))
        return -EIO;

> If we're going to make this core infrastructure, it seems we should
> implement it with all best practices... eg I would think the while loop
> should include cpu_relax().

Ok.  I'll post version 2 on Monday.  Anything else I'm missing?

-- 
Timur Tabi
Linux kernel developer at Freescale
