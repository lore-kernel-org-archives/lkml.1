Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbYHHIDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbYHHIDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 04:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYHHIDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 04:03:30 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34719 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbYHHID3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 04:03:29 -0400
Date: Fri, 8 Aug 2008 11:01:55 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Simon Horman <horms@verge.net.au>, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, Stephen Tweedie <sct@redhat.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jan Beulich <jbeulich@novell.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Allow compile with CONFIG_DEBUG_INFO=y, X86_PAE not set on gcc
	3.4.5
Message-ID: <20080808080155.GA1992@cs181140183.pp.htv.fi>
References: <20080808050429.GA8473@verge.net.au> <489BE9C3.2010006@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <489BE9C3.2010006@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 11:37:55PM -0700, Jeremy Fitzhardinge wrote:
> Simon Horman wrote:
>> Hi,
>>
>> It appears that "x86: preallocate and prepopulate separately"
>> (d8d5900ef8afc562088f8470feeaf17c4747790f) introduced a minor regression.
>> The build fails on gcc 3.4.5 if CONFIG_DEBUG_INFO=y (that is gcc is
>> called with -g) and X86_PAE not set.
>> 
>> There was previously some discussion of this without resolution.
>> http://lkml.org/lkml/2008/7/18/250
>>
>> 	arch/x86/mm/pgtable.c: In function `pgd_prepopulate_pmd':
>> 	arch/x86/mm/pgtable.c:222: internal compiler error: in remove_insn, at emit-rtl.c:3746
>> 	Please submit a full bug report,
>> 	with preprocessed source if appropriate.
>> 	See <URL:http://gcc.gnu.org/bugs.html> for instructions.
>>
>> 	# i686-unknown-linux-gnu-gcc --version
>> 	i686-unknown-linux-gnu-gcc (GCC) 3.4.5
>>
>> My investigations seem to show that gcc 3.4.5 can't cope with the following
>> construct:
>>
>> 	for (i = 0; i < 0; i++)
>> 		...
>>
>> or more specifically:
>>
>> 	for (i = 0; i < PREALLOCTED_PMDS; i++)
>> 		...
>>
>> when PREALLOCTED_PMDS is 0. That is, when X86_PAE is not set.
>>
>> This patch resolves this problem by moving the relevant code inside
>> #define X86_PAE and providing dummy functions outside !X86_PAE.
>>
>> Signed-off-by: Simon Horman <horms@verge.net.au>
>>   
>
> We resolved the other report by saying that gcc 3.4.4 is broken. It  
> seems 3.4.5 is as well.  Could you just update the compiler?  I'd rather  
> not have to clutter the code with more ifdefs if we can possibly avoid 
> it.
>...

CONFIG_DEBUG_INFO=y is why I never hit it before.

It does not seem to be just one dodgy Redhat compiler (as I assumed in 
the Bugzilla entry) but the whole 3.4 series of gcc which makes our 
resolution of saying that this specific compiler is broken invalid.

Considering that we officially support all compilers >= 3.2 this is just 
one more case where we have to add to the kernel a workaround for a 
broken compiler.

After all, we already have 2 or 3 workarounds for new 2.6.27-rc 
breakages with gcc 3.2 included or at least submitted.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

