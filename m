Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbZJ2PmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbZJ2PmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbZJ2PmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:42:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:40023 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbZJ2PmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:42:20 -0400
Message-ID: <4AE9B812.2080307@kernel.org>
Date: Thu, 29 Oct 2009 16:43:14 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Andreas Gruenbacher <agruen@suse.de>,
       Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH -next] ia64/sn: fix percpu warnings
References: <20091014163445.f0441473.sfr@canb.auug.org.au>	 <20091014151003.0ef42973.randy.dunlap@oracle.com>	 <4AD67C05.2030201@kernel.org> <12c511ca0910261124p64f2ad5emc88d00b9957482b3@mail.gmail.com> <57C9024A16AD2D4C97DC78E552063EA3E345953E@orsmsx505.amr.corp.intel.com> <4AE85D28.90809@kernel.org> <57C9024A16AD2D4C97DC78E552063EA3E34C0108@orsmsx505.amr.corp.intel.com> <4AE87344.6030708@kernel.org> <57C9024A16AD2D4C97DC78E552063EA3E34C018B@orsmsx505.amr.corp.intel.com> <57C9024A16AD2D4C97DC78E552063EA3E34C0629@orsmsx505.amr.corp.intel.com> <4AE9AA0E.5070104@kernel.org>
In-Reply-To: <4AE9AA0E.5070104@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yiee... lexer/parser problem in genksyms.  cc'ing Andreas, Sam and Jan
for help and quoting whole body.

Hello,

Tejun Heo wrote:
> Hello,
> 
> Luck, Tony wrote:
>> Ok.  x86 doesn't see this because the defconfig has
>>   CONFIG_MODVERSIONS is not set
>>
>> If I turn MODVERSION off, then the problem disappears for me.
>>
>> If I turn MODVERSIONS on for x86 (and fudge a driver to make use of
>> softirq_work_list), then x86 gets the CRC warning too.
> 
> Right, I can reproduce it here too.
> 
>> So this isn't a tool chain problem. Neither x86 nor ia64
>> can handle exported per-cpu array objects when CONFIG_MODVERSIONS
>> is set.
>>
>> Looking at the __crc symbols in the vmlinux for x86 with
>> CONFIG_MODVERSIONS=y I see:
>>
>> 000000006dcaeb88 A __crc_per_cpu__kernel_stack
>> 00000000b3994c7a A __crc_per_cpu__kstat
>> 00000000d917c158 A __crc_per_cpu__node_number
>>                  w __crc_per_cpu__softirq_work_list
>> 0000000036a1f502 A __crc_per_cpu__softnet_data
>> 0000000057adf756 A __crc_per_cpu__this_cpu_off
>>
>> which explains why "modpost" is unable to find a CRC.
>>
>> Maybe the comments in <linux/module.h> are supposed to be a
>> clue? :
>>
>> #ifdef CONFIG_MODVERSIONS
>> /* Mark the CRC weak since genksyms apparently decides not to
>>  * generate a checksums for some symbols */
>> #define __CRC_SYMBOL(sym, sec)                                  \
>>         extern void *__crc_##sym __attribute__((weak));         \
>>         static const unsigned long __kcrctab_##sym              \
>>         __used                                                  \
>>         __attribute__((section("__kcrctab" sec), unused))       \
>>         = (unsigned long) &__crc_##sym;
>>
>> But not enough of a clue for me :-(
> 
> I have no idea either.  I'll dig a bit and try to find out what's
> going on.

So, the problem is that genksyms can't understand the following.

  __typeof__(int [10]) my_ar;
  EXPORT_SYMBOL(my_ar);

Would it be difficult to teach it how to parse it?

Thanks.

-- 
tejun
