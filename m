Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbZHQVLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbZHQVLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758107AbZHQVL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:11:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55758 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099AbZHQVL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:11:29 -0400
Message-ID: <4A89C76B.2020307@zytor.com>
Date: Mon, 17 Aug 2009 14:11:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@elte.hu, tglx@linutronix.de, venkatesh.pallipadi@intel.com,
       xam@debian.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, pat: allow ISA memory range uncacheable mapping
 requests
References: <1250540630.2709.193.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1250540630.2709.193.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2009 01:23 PM, Suresh Siddha wrote:
> Max Vozeler reported:
>>  Bug 13877 -  bogl-term broken with CONFIG_X86_PAT=y, works with =n  
>>
>>  strace of bogl-term:
>>  814   mmap2(NULL, 65536, PROT_READ|PROT_WRITE, MAP_SHARED, 4, 0)
>> 				 = -1 EAGAIN (Resource temporarily unavailable)
>>  814   write(2, "bogl: mmaping /dev/fb0: Resource temporarily unavailable\n",
>> 	       57) = 57
> 
> PAT code maps the ISA memory range as WB in the PAT attribute, so that
> fixed range MTRR registers define the actual memory type (UC/WC/WT etc).
> 
> But the upper level is_new_memtype_allowed() API checks are failing,
> as the request here is for UC and the return tracked type is WB (Tracked type is
> WB as MTRR type for this legacy range potentially will be different for each
> 4k page).
> 
> Fix is_new_memtype_allowed() by always succeeding the ISA address range
> checks, as the null PAT (WB) and def MTRR fixed range register settings
> satisfy the memory type needs of the applications that map the ISA address
> range.

This patch seems correct in that it matches the current behavior of the
code.  I have, though, to ask what the logic behind treating the ISA
region in this way is.  From a hardware perspective it makes sense --
these addresses have the Legacy MTRRs which are like a
physical-address-based PAT, but it seems somewhat odd that'd we would
expect applications to use different APIs for this region.

I think the patch is definitely OK for x86/urgent, but I'd like some
thoughts about if this really is The Right Thing in the long term?

	-hpa
