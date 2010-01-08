Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113Ab0AHUVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0AHUVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 15:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879Ab0AHUU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 15:20:59 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45461 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab0AHUU7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 15:20:59 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86: update nr_irqs according cpu num
References: <1262951595-1729-1-git-send-email-yinghai@kernel.org>
	<1262951595-1729-5-git-send-email-yinghai@kernel.org>
	<m1bph4o1il.fsf@fess.ebiederm.org>
	<86802c441001081149k1be26027m62752604dca53aa@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 08 Jan 2010 12:20:52 -0800
In-Reply-To: <86802c441001081149k1be26027m62752604dca53aa@mail.gmail.com> (Yinghai Lu's message of "Fri\, 8 Jan 2010 11\:49\:36 -0800")
Message-ID: <m1tyuwgxgb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On Fri, Jan 8, 2010 at 11:11 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Yinghai Lu <yinghai@kernel.org> writes:
>>
>>> that is max number on run time.
>>
>> Ouch!  Unless I misread this code this will leave nr_irqs at
>> NR_IRQS_LEGACY. aka 16.
>
> nr_irqs is set to NR_IRQS before.

Yep my mistake.

>> Let's do something stupid and simple.
>> nr_irqs = nr_cpus_ids * 256;  /* Semi-arbitrary number */
>>
>> Ideally we would set "nr_irqs = 0x7fffffff;" but we have just enough
>> places using nr_irqs that I think those loops would get painful if we
>> were to do that.
>
> or you need have NR_IRQS = NR_CPUS * 256 at first,
>
> and then make nr_irqs = nr_cpu_ids * 224 ?

The important part is that NR_IRQS become an arbitrary number larger
than we can strictly support.

Based on my quick look the bad offenders (aka static sized arrays of
NR_IRQS) all look at NR_IRQS not nr_irqs.  So I don't see a point
in having nr_irqs < NR_IRQS.

So let's just kill arch_probe_nr_irqs() on x86.

Then we can worry about things like fixing xen and the interrupt
remapping code to not having NR_IRQS sized arrays.

Eric
