Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbYF0Cwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbYF0Cwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 22:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYF0Cwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 22:52:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:48861 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbYF0Cwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 22:52:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Mndt1GYuSMYqIJnXywvkaGe8qYJHG0uueFIM7BajSA0cdmg84061OOeoSiCyw1Kyya
         +FWxZQN/imsBE1O65f9yFqmZPyZtIloKQPNsm8wK7gDThe1RVOqKeQF51x9jwPvKQk8F
         B4DP/3r8fFVa1BBjlORF34n/Ko3qYilqv16no=
Message-ID: <86802c440806261952u31de7262u37e1b4d628c9ffcf@mail.gmail.com>
Date: Thu, 26 Jun 2008 19:52:34 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 1/2] x86 boot: add E820_RESVD_KERN
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <1214534894.10865.6.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <1214461978.10809.6.camel@caritas-dev.intel.com>
	 <86802c440806260025v3fc1970aq682b568cccba4b4e@mail.gmail.com>
	 <1214466513.11346.30.camel@caritas-dev.intel.com>
	 <86802c440806260247p19f5b850r8757c51280912ae9@mail.gmail.com>
	 <86802c440806261922n3f13b454o5e543e28d9a34e8e@mail.gmail.com>
	 <1214534894.10865.6.camel@caritas-dev.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m5R2r8fq012047

On Thu, Jun 26, 2008 at 7:48 PM, Huang, Ying <ying.huang@intel.com> wrote:> On Thu, 2008-06-26 at 19:22 -0700, Yinghai Lu wrote:>> On Thu, Jun 26, 2008 at 2:47 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:>> > On Thu, Jun 26, 2008 at 12:48 AM, Huang, Ying <ying.huang@intel.com> wrote:>> >> On Thu, 2008-06-26 at 00:25 -0700, Yinghai Lu wrote:>> >> [...]>> >>> >                if (pfn >= limit_pfn)>> >>> > @@ -977,7 +978,7 @@ u64 __init early_reserve_e820(u64 startt>> >>> >                return 0;>> >>> >>> >>> >        addr = round_down(start + size - sizet, align);>> >>> > -       e820_update_range(addr, sizet, E820_RAM, E820_RESERVED);>> >>> > +       e820_update_range(addr, sizet, E820_RAM, E820_RESVD_KERN);>> >>>>> >>> this line is not needed.>> >>>> >> Why? Memory reserved by early_rserved_e820 should not be saved during>> >> hibernation? shoudl not be saved by kdump?>> >>>> Can you tell me why this line is not needed?
that function only have one user. the mpc reserve_new, so we want itto be E820_RESERVED, and kexec  tools could have that range reserved,the next kernel will not overwrite the updated mptable.
>> [...]>> some like the attach patch...>>>> you still can merge parse_setup_data parse_e820_ext>> also entries in parse_e820_ext is not initialized..., __copy_e820_map>> will do nothing.>> ï»¿OK. Because some E820 entries are available after parse_setup_data(),> it is better to call reserve_setup_data() after calling> parse_setup_data() if update_e820_range() is used instead of> reserve_early().
can you double check parse_e820_ext()?it seems entries is not initialized properly,
void __init parse_e820_ext(struct setup_data *sdata, unsigned long pa_data){        u32 map_len;        int entries;        struct e820entry *extmap;
        entries = sdata->len / sizeof(struct e820entry);        map_len = sdata->len + sizeof(struct setup_data);        if (map_len > PAGE_SIZE)                sdata = early_ioremap(pa_data, map_len);        extmap = (struct e820entry *)(sdata->data);        __copy_e820_map(extmap, entries);===========> what is value for entries?        sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);        if (map_len > PAGE_SIZE)                early_iounmap(sdata, map_len);        printk(KERN_INFO "extended physical RAM map:\n");        e820_print_map("extended");}

YHÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
