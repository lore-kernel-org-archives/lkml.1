Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbYFTShx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbYFTShx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 14:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYFTShp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 14:37:45 -0400
Received: from gw.goop.org ([64.81.55.164]:36039 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbYFTSho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 14:37:44 -0400
Message-ID: <485BF8F5.6010802@goop.org>
Date: Fri, 20 Jun 2008 11:37:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Mike Travis <travis@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com> <20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com> <485947A8.8060801@goop.org> <4859511E.5050605@sgi.com> <48596315.6020104@goop.org> <48596893.4040908@sgi.com> <485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org> <485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org> <485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com> <485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com> <485BE80E.10209@goop.org> <Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 20 Jun 2008, Jeremy Fitzhardinge wrote:
>
>   
>> So it seems the problem is that the pre-initialized gdt_page is being lost and
>> replaced with zero.  Linker script bug?
>>     
>
> Is the pre initialized gdt page in the per cpu area? Does not look like 
> it. 

Yes, it should be.  arch/x86/kernel/setup_64.c:

DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
	[GDT_ENTRY_KERNEL32_CS] = { { { 0x0000ffff, 0x00cf9b00 } } },
	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00af9b00 } } },
	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9300 } } },
	[GDT_ENTRY_DEFAULT_USER32_CS] = { { { 0x0000ffff, 0x00cffb00 } } },
	[GDT_ENTRY_DEFAULT_USER_DS] = { { { 0x0000ffff, 0x00cff300 } } },
	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00affb00 } } },
} };


> The loader setup for the percpu section changes with zero basing. 
> Maybe that has bad side effects

How does it work?  The symbols in the percpu segment are 0-based, but 
where does the data for the sections which correspond to that segment go?

The vmlinux looks like it has the gdt_page data in it.  
per_cpu__gdt_page is 0x5000, and offset 0x5000 in .data.percpu has the 
right stuff:

 5000 00000000 00000000 ffff0000 009bcf00  ................
 5010 ffff0000 009baf00 ffff0000 0093cf00  ................
 5020 ffff0000 00fbcf00 ffff0000 00f3cf00  ................
 5030 ffff0000 00fbaf00 00000000 00000000  ................
 5040 00000000 00000000 00000000 00000000  ................
 5050 00000000 00000000 00000000 00000000  ................
 5060 00000000 00000000 00000000 00000000  ................


So the question is what kernel virtual address is it being loaded to?  
__per_cpu_load is ffffffff808d1000, so ffffffff808d6000 is what you'd 
expect...

Hm, but what happens when this gets converted to bzImage?  Hm, looks OK, 
I think.

BTW, I think __per_cpu_load will cause trouble if you make a relocatable 
kernel, being an absolute symbol.  But I have relocation off at the moment.

    J
