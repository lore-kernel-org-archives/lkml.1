Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbZFHHso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbZFHHso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 03:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbZFHHsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 03:48:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:30420 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbZFHHsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 03:48:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,323,1241420400"; 
   d="scan'208";a="522560607"
From: "Tang, Feng" <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Date: Mon, 8 Jun 2009 15:47:33 +0800
Subject: RE: [PATCH] tick: add check for the existence of broadcast clock
 event device
Thread-Topic: [PATCH] tick: add check for the existence of broadcast clock
 event device
Thread-Index: AcnoBtE8p9Xi10FaQwa3RreYZ1uYXgABS6JQ
Message-ID: <EADF0A36011179459010BDF5142A457501C9CD39CC@pdsmsx502.ccr.corp.intel.com>
References: <20090605112711.67e7d5cb@feng-desktop>
 <alpine.LFD.2.00.0906061121330.3419@localhost.localdomain>
 <20090606204736.00700bd0@feng-desktop>
 <alpine.LFD.2.00.0906061450220.3419@localhost.localdomain>
 <alpine.LFD.2.00.0906061815460.3419@localhost.localdomain>
 <20090608095730.0c945e78@feng-desktop>
 <alpine.LFD.2.00.0906080739020.3419@localhost.localdomain>
 <20090608141250.6a5735fa@feng-desktop>
 <alpine.LFD.2.00.0906080828021.3419@localhost.localdomain>
 <20090608144740.62f2ed95@feng-desktop>
 <alpine.LFD.2.00.0906080857260.3419@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0906080857260.3419@localhost.localdomain>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n587nI54003936



>-----Original Message-----
>From: Thomas Gleixner [mailto:tglx@linutronix.de]
>Sent: 2009Äê6ÔÂ8ÈÕ 15:00
>To: Tang, Feng
>Cc: mingo@elte.hu; linux-kernel@vger.kernel.org; Li, Shaohua; Pan, Jacob jun
>Subject: Re: [PATCH] tick: add check for the existence of broadcast clock event
>device
>
>On Mon, 8 Jun 2009, Feng Tang wrote:
>> On Mon, 8 Jun 2009 14:33:14 +0800 Thomas Gleixner <tglx@linutronix.de> wrote:
>> > On Mon, 8 Jun 2009, Feng Tang wrote:
>> > > Our apbt driver is pretty similar with HPET's, including its cpu
>> > > hotplug notifier. But our platform only has 2 available apbt to
>> > > use, otherwise we will configure it just like HPET, using one timer
>> > > as bc and others for per-cpu ones, then it won't hit this case
>> > >
>> > > There are 2 situations, one is for the normal boot, apbt0 will be
>> > > inited first and registered to OS as cpu0's timer, then tsc/lapic
>> > > is calculated based on it, and apbt1 is registered later in a
>> > > fs_initcall() (just like hpet.c does) after basic kernel core is
>> > > up. so the sequence is: apbt0 --> lapic0 --> lapic1 --> apbt1
>> >
>> > Hmm, I do not like that at all. That explicitely relies on CPU0 doing
>> > some work which will kick CPU1. That's fragile as hell.
>>
>> I understand the concern. apbt0 is inited in a very early boot phase when
>> the cpu1 is not up yet, and os don't even know wether there is a cpu1, that's
>> why we registered apbt1 in fs_initcall(). If we explicitly setup apbt1 when
>> OS brings up cpu1, it is a little brutal and not generic as only our platform
>> has apbt, and I guess cpu hotplug maintainer won't like it :p
>
>Why is that a problem ? You already have a special case for apbt0 in
>the early setup code. So where is the problem when you have an apbt1
>init call on CPU1 _before_ the local APIC is initialized on CPU1.

Yes, your proposal makes good sense. But our apbt0 initialization is an x86 legacy one like HPET and is put into the same position where hpet_enable() exists, it keeps the impact to x86 arch dependent code be minimal, if we put the apbt1 init code into x86's cpu initialization code, I think it will cause much more complains, that's why we chose to follow hpet's method to use delayed init.

The reason we proposed to add pointer check is there are already such checks in the broadcast code, adding these won't do harm to existing code. 

Thanks,
Feng
>
>That's definitely saner than relying on magic IPI wakeups.
>
>Thanks,
>
>	tglx
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
