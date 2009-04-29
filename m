Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbZD2MsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbZD2MsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbZD2Mrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:47:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:52622 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbZD2Mri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:47:38 -0400
Cc: "Jeff Haran" <jharan@Brocade.COM>, <linux-kernel@vger.kernel.org>,
       Dave Jiang <djiang@mvista.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kumar Gala <galak@gate.crashing.org>, linuxppc-dev@ozlabs.org
Message-Id: <66D3881A-A16D-4051-9073-1FF28C4F4742@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090429003704.1c37d6e1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: bug in drivers/edac/mpc85xx_edac.c:mpc85xx_mc_check()
Date: Wed, 29 Apr 2009 07:46:37 -0500
References: <57AC2FA1761300418C7AB8F3EA493C9702E319DB@HQ-EXCH-5.corp.brocade.com> <20090429003704.1c37d6e1.akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 29, 2009, at 2:37 AM, Andrew Morton wrote:

> Let's cc the suitable people.
>
> On Tue, 28 Apr 2009 18:23:42 -0700 "Jeff Haran" <jharan@Brocade.COM>  
> wrote:
>
>> Hi,
>>
>> Recent versions of this function contain the following snippets:
>>
>>    if (err_detect & DDR_EDE_SBE)
>>        edac_mc_handle_ce(mci, pfn, err_addr & PAGE_MASK,
>>                  syndrome, row_index, 0, mci->ctl_name);
>>
>>    if (err_detect & DDR_EDE_MBE)
>>        edac_mc_handle_ue(mci, pfn, err_addr & PAGE_MASK,
>>                  row_index, mci->ctl_name);
>>
>> I am pretty sure the references to PAGE_MASK should be proceeded by a
>> tilda, as in:
>>
>>    if (err_detect & DDR_EDE_SBE)
>>        edac_mc_handle_ce(mci, pfn, err_addr & ~PAGE_MASK,
>>                  syndrome, row_index, 0, mci->ctl_name);
>>
>>    if (err_detect & DDR_EDE_MBE)
>>        edac_mc_handle_ue(mci, pfn, err_addr & ~PAGE_MASK,
>>                  row_index, mci->ctl_name);
>>
>
> Could well be.  PAGE_MASK is very easy to get wrong.  I've _never_
> trusted my own memory of it and I always have to go back to the
> definition when reviewing code :(

This should ~PAGE_MASK to get the offset into the page.

>> Much as I would like to submit a tested patch like the rest of the
>> world, I find myself in the situation where the only Freescale target
>> system I have to test on is running a 3 year old kernel (2.6.14),  
>> which
>> preceeds the introduction of EDAC driver support, at least for
>> Freescale. So the best I can do is borrow from the new EDAC driver  
>> and
>> backport it to the old kernel.
>>
>> But I have learned a few things in this process and can thus share  
>> what
>> I've learned as it may be of help to the EDAC driver developers:
>>
>> 1) Before you read the Freescale 8548 CAPTURE_ADDRESS register, you  
>> want
>> to read CAPTURE_ATTRIBUTES first and make sure the VLD bit (least
>> significant bit in the register) is set or else the data in
>> CAPTURE_ADDRESS may not be yet valid.
>>
>> 2) When you are done scrubbing the memory with the single bit  
>> error, you
>> want to write 0 to CAPTURE_ATTRIBUTES so as to clear VLD and thus  
>> setup
>> the ECC capture logic to capture the next single bit error.

This is a correct description based on how FSL error HW works.

- k

