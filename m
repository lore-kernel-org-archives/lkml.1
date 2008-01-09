Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYAIB72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYAIB72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYAIB7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:59:21 -0500
Received: from gw.goop.org ([64.81.55.164]:53650 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbYAIB7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:59:20 -0500
Message-ID: <478429DE.1090901@goop.org>
Date: Tue, 08 Jan 2008 17:56:46 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
References: <20080109000146.GA29095@elte.hu> <47841194.2010208@goop.org> <20080109002014.GB31289@elte.hu> <20080109002803.GA3732@elte.hu> <20080109003034.GA4658@elte.hu> <47841B09.3020507@goop.org> <20080109005914.GA24228@elte.hu> <47841E3C.9020106@goop.org> <20080109011233.GD25945@bingen.suse.de> <478424DE.3030609@goop.org> <20080109014233.GG25945@bingen.suse.de>
In-Reply-To: <20080109014233.GG25945@bingen.suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Or to put it another way, what's the underlying rationale for making 
>> __PAGE_KERNEL_* not include the GLOBAL flag, but including it in the pgprot 
>> versions?  It means that code like this in ioremap_64.c:
>>     
>
> There is none, but that is not what change_page_attr() cares about.
> It just cares that you pass in the correct bits and you don't currently.
>
> I think you're missing the forrest because of all the trees currently.
>   

Yeah, that may be true, but this particular tree is weird, and I'm 
trying to understand what's going on here.  Specifically, 64-bit 
ioremap()s *don't* set _PAGE_GLOBAL, which appears to be an accident 
resulting from the strange definitions of __PAGE_KERNEL_* vs 
PAGE_KERNEL_*. 

For example, ioremap_64.c:__ioremap() creates a vma for the io mapping, 
and explicitly sets _PAGE_GLOBAL in the vma's version of pgprot - but 
then it calls ioremap_page_range() to actually create the mapping, which 
ends up making a non-global mapping, because its rolling its own version 
of PAGE_KERNEL by using pgprot(__PAGE_KERNEL) - which is not the actual 
definition of PAGE_KERNEL.

I think there's a bug around here, but I think its currently being 
hidden by accident.  I think my changes are correct, and they're 
exposing some other bug.  But I don't really understand how all this 
stuff is supposed to fit together, so I'm looking for an explanation of 
what's supposed to be happening - and ideally - why the current code 
isn't actually buggy.

For example: is ioremap_change_attr() actually *deliberately* creating 
non-global mappings?  Or is it an accident?  And if it really intends to 
create non-global mappings, why?  And why is it buggy for it to create 
global mappings?

    J
