Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZCJVTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZCJVTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZCJVTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:19:15 -0400
Received: from gw.goop.org ([64.81.55.164]:35387 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbZCJVTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:19:15 -0400
Message-ID: <49B6D94F.9070902@goop.org>
Date: Tue, 10 Mar 2009 14:19:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] paravirt/xen: add pvop for page_is_ram
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <1235786365-17744-10-git-send-email-jeremy@goop.org> <49B5BD63.1090909@zytor.com>
In-Reply-To: <49B5BD63.1090909@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>   
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> A guest domain may have external pages mapped into its address space,
>> in order to share memory with other domains.  These shared pages are
>> more akin to io mappings than real RAM, and should not pass the
>> page_is_ram test.  Add a paravirt op for this so that a hypervisor
>> backend can validate whether a page should be considered ram or not.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>>     
>
> Why are these pages mapped as RAM in the memory map?  That is the right
> way to handle that, not by adding yet another bloody hook...
>   
Granted pages can turn up anywhere dynamically, since they're pages 
borrowed from other domains for the purposes of IO.  They're not static 
regions of non-RAM like the other cases page_is_ram() tests for,

They can't be mapped via normal pte operations (because they have 
additional state associated with them, like the grant handle), so 
/dev/mem can't just create an aliased mapping by copying the pte.

page_is_ram is used to:

   1. prevent /dev/mem from mapping non-RAM pages
   2. prevent ioremap from mapping any RAM pages
   3. testing for RAMness in PAT

3) isn't yet relevant to Xen; ioremap can't map granted pages either, so 
2) isn't terribly relevent, so the main motivation for this patch is 
1).  This allows us to reject usermode attempts to map granted pages, 
rather than oopsing (as a failed set_pte will raise a page fault).

So, more cosmetic than essential, but I don't see a better way to 
implement this functionality if its to be there at all.

    J
