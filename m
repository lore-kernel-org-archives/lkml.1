Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861Ab0ADTQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab0ADTQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 14:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908Ab0ADTQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 14:16:30 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:51923 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab0ADTQ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 14:16:28 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDEV list <netdev@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH 2/2] x86: get more exact nr_irqs
References: <4B347AEE.6030705@kernel.org> <20091228094707.GH24690@elte.hu>
	<4B398ECD.1080506@kernel.org>
	<4807377b1001031906s6b1ee576jc021da2642bb4147@mail.gmail.com>
	<4B415E73.1050801@kernel.org> <4B41918D.3000605@kernel.org>
	<m1fx6lizc3.fsf@fess.ebiederm.org>
	<86802c441001041103s5abd6d3ai4e6ccbfc68323f3c@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 04 Jan 2010 11:16:21 -0800
In-Reply-To: <86802c441001041103s5abd6d3ai4e6ccbfc68323f3c@mail.gmail.com> (Yinghai Lu's message of "Mon\, 4 Jan 2010 11\:03\:02 -0800")
Message-ID: <m1bph9he9m.fsf@fess.ebiederm.org>
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

> On Mon, Jan 4, 2010 at 8:55 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Yinghai Lu <yinghai@kernel.org> writes:
>>
>>> first check with NR_VECTORS - FIRST_EXTERNAL_VECTOR - 0x20
>>> aka minus exceptions and system vectors.
>>>
>>> NR_CPUS = 512, and nr_cpu_ids = 128
>>> will have NR_IRQS = 256 + 512 * 64 = 33024
>>>
>>> assume we have 20 intel ixgbe 6 port cards (with sriov and ixgbevf)
>>>       20 * 6 * 64 * 3 = 23040
>>>
>>> first will get:
>>>       128 * (256 - 64) = 24576
>>> then with nr_irqs_gsi will get
>>>       (120 + 8 * 128 + 120 * 256) = 31864
>>>
>>> so 24576 will be used for nr_irqs.
>>>
>>> 24576 * 8 = 196608 bytes will be used for irq_desc_ptrs[]
>>>
>>> before this patch:
>>>     have nr_irqs = 120 + 8 * 128 + 120 * 64 = 8824
>>>       and irq_desc_ptrs[] is 70592
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> I am lost.    arch_probe_nr_irqs appears to be total nonsense.
>>
>> We have three concepts.
>> - The number of irq sources we can talk about.  ( nr_irqs)
>> - The number of irqs we can possibly service.   ((NR_VECTORS - 0x30) *nr_cpu_ids)
>> - The number of irqs we actually connected up to cards in the
>>  system that we need to do something with.
>>
>> Why do we need to allocate arrays at all?
>>
>
> irq_desc is allocated dynamically.
>
> but irq_desc_ptrs is pointer array, it need to be allocated after
> nr_irqs is probed.

If we care about memory use efficiency let's replace irq_desc_ptrs
with a rbtree or a radix_tree.  Something that moves the memory use
penalty onto those machines that have a lot of irqs.

Eric
