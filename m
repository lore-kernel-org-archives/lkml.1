Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbZCDXTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbZCDXTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 18:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbZCDXTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 18:19:38 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:11505 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZCDXTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 18:19:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WmcHNgg8An0RiuNJ2KVCD2W7mgKpk+Q/RSyZ0+sg3SmETIRZ+zcwf5Ucgr6VTR7+PL
         HGjM8zv1LFBnFhnyuI4Jo4Aj7UvRlrRFCfbdwH/iFrn2gZSHtcNNtRH2Z2pyoilLLgsF
         B+0auc4tDqciQVxmbqpiERNvDKZFKRKHFKGNM=
Message-ID: <49AF0C81.7060908@gmail.com>
Date: Thu, 05 Mar 2009 00:19:29 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Tejun Heo <htejun@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: __virt_addr_valid vs virtual percpu areas
References: <49AF075D.9070607@goop.org>
In-Reply-To: <49AF075D.9070607@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4.3.2009 23:57, Jeremy Fitzhardinge wrote:
> On i386, __virt_addr_valid() has the test:
>
> if (system_state != SYSTEM_BOOTING && is_vmalloc_addr((void *) x))
> return false;
>
>
> Why is the vmalloc area a valid virtual address while the system is
> booting?

It's not (in the meaning of virt_* functions), but while booting we 
don't have variables used in VMALLOC_START and VMALLOC_END ready for use 
on i386.

Maybe we can introduce more clever method/state which would say: hey, 
vmalloc framework is up and running. And use instead (system_state != 
SYSTEM_BOOTING) hack.

> This is biting me because I need to translate percpu addresses
> to pfns, but I only bother doing the full pagetable walk if
> virt_addr_valid() is false (otherwise I just use __pa()).

Do you need to bother also with vmalloc space?

> Removing this test doesn't seem to harm anything at first glance. Is
> this OK to do in general (and can we quietly set fire to system_state
> while we're about it)?

I wouldn't do that, since vmalloc addr is not virt addr, again in the 
meaning of virt_* functions. And the function wouldn't do the right 
thing, at least in the RUNNING state anymore.
