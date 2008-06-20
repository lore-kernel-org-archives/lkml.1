Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbYFTTFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbYFTTFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYFTTE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:04:58 -0400
Received: from gw.goop.org ([64.81.55.164]:57146 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbYFTTE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:04:58 -0400
Message-ID: <485BFF57.5090906@goop.org>
Date: Fri, 20 Jun 2008 12:04:55 -0700
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
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com> <20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com> <485947A8.8060801@goop.org> <4859511E.5050605@sgi.com> <48596315.6020104@goop.org> <48596893.4040908@sgi.com> <485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org> <485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org> <485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com> <485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com> <485BE80E.10209@goop.org> <Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com> <485BF8F5.6010802@goop.org> <Pine.LNX.4.64.0806201148430.16227@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0806201148430.16227@schroedinger.engr.sgi.com>
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
>>> The loader setup for the percpu section changes with zero basing. Maybe that
>>> has bad side effects
>>>       
>> How does it work?  The symbols in the percpu segment are 0-based, but where
>> does the data for the sections which correspond to that segment go?
>>     
>
> Its loaded at __per_cpu_load but the symbols have addresses starting at 0.
>   

Yes, which leads to an odd-looking ELF file where the Phdrs aren't 
sorted by virtual address order.  I'm wondering what would happen if a 
bootloader that actually understood ELF files tried to load it as an 
actual ELF file...

>> So the question is what kernel virtual address is it being loaded to?
>> __per_cpu_load is ffffffff808d1000, so ffffffff808d6000 is what you'd
>> expect...
>>     
>
> Correct.
>   

Well, reading back from that address got zeros, so something is amiss.

>> Hm, but what happens when this gets converted to bzImage?  Hm, looks OK, I
>> think.
>>
>> BTW, I think __per_cpu_load will cause trouble if you make a relocatable
>> kernel, being an absolute symbol.  But I have relocation off at the moment.
>>     
>
> Hmmm.... we could add the relocation offset to __per_cpu_load? 
> __per_cpu_load is used very sparingly. Basically only useful during early 
> boot and when a new per cpu area has to be setup. In that case we want to 
> copy from __per_cpu_load to the newly allocated percpu area.
>   

Yes, it should be fairly easy to manually relocate it by applying the 
(load - link) offset to it.


    J
