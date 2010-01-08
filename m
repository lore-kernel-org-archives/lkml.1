Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288Ab0AHUGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab0AHUGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 15:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214Ab0AHUGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 15:06:22 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:56215 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab0AHUGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 15:06:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YEjrFyuDCBO88RsZc83baOK9jQxrxY2q/o6ofAih7urKugLM1JxZevkOq2KI5NGxVz
         Fuql34Ko+emA66LIPm1Mvftf89ZbXLlFNLOsa3/VCmFPDiIi3Dv3k/esXBdKTWRHFXjZ
         P1FU8nZcU57mVHSVgyd5pxGLSujBSAN5SUS2Y=
MIME-Version: 1.0
In-Reply-To: <4B4785C3.4030505@zytor.com>
References: <1262951595-1729-1-git-send-email-yinghai@kernel.org>
	 <1262951595-1729-5-git-send-email-yinghai@kernel.org>
	 <m1bph4o1il.fsf@fess.ebiederm.org> <4B4785C3.4030505@zytor.com>
Date: Fri, 8 Jan 2010 12:06:21 -0800
X-Google-Sender-Auth: 8bc4c8113043699a
Message-ID: <86802c441001081206r1df18abdhbb9a882868cc6b39@mail.gmail.com>
Subject: Re: [PATCH 5/5] x86: update nr_irqs according cpu num
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 8, 2010 at 11:21 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/08/2010 11:11 AM, Eric W. Biederman wrote:
>> Yinghai Lu <yinghai@kernel.org> writes:
>>
>>> that is max number on run time.
>>
>> Ouch!  Unless I misread this code this will leave nr_irqs at
>> NR_IRQS_LEGACY. aka 16.
>>
>> Let's do something stupid and simple.
>> nr_irqs = nr_cpus_ids * 256;  /* Semi-arbitrary number */
>
> This would be 1048576 on the biggest machines we currently support.
> Now, the number of IRQ *vectors* is limited to
> (224-system vectors)*(cpu count), so one could argue that if there is
> anything that is not semi-arbitrary it would be that number, but that
> doesn't account for vector sharing.

(256 - 32 - 16 - system_vectors) * cpu_count + 16

the 16 is legacy from IRQ0 to 15 has domain with all cpus set.

later could move arch_probe_nr_irqs out of early_irq_init,
call it after init_IRQ(), so could use first_system_vector exactly
instead of 0x10

>
> Do we have any place which requires nr_irqs to be *stable*, or can we
> simply treat it as a high water mark for IRQ numbers used?
>
>> Ideally we would set "nr_irqs = 0x7fffffff;" but we have just enough
>> places using nr_irqs that I think those loops would get painful if we
>> were to do that.
yes, those loops
>
> Ideally we should presumably get rid of nr_irqs completely?

some interface in /proc/interrupts need it to make sure sth in sequence.

YH
