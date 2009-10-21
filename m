Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbZJUQik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbZJUQik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 12:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbZJUQij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 12:38:39 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5533 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbZJUQij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 12:38:39 -0400
Message-ID: <4ADF38D5.9060100@caviumnetworks.com>
Date: Wed, 21 Oct 2009 09:37:41 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Wu Zhangjin <wuzhangjin@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH -v4 9/9] tracing: add function graph tracer support for
 MIPS
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>	 <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>	 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>	 <96110ea5dd4d3d54eb97d0bb708a5bd81c7a50b5.1256135456.git.wuzhangjin@gmail.com>	 <5dda13e8e3a9c9dba4bb7179183941bda502604f.1256135456.git.wuzhangjin@gmail.com>	 <af3ec1b5cd06b6f6a461c9fa7d09a51fabccb08d.1256135456.git.wuzhangjin@gmail.com>	 <a6f2959a69b6a77dd32cc36a5c8202f97d524f1e.1256135456.git.wuzhangjin@gmail.com>	 <53bdfdd95ec4fa00d4cc505bb5972cf21243a14d.1256135456.git.wuzhangjin@gmail.com> <1256141540.18347.3118.camel@gandalf.stny.rr.com>
In-Reply-To: <1256141540.18347.3118.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Oct 2009 16:37:41.0455 (UTC) FILETIME=[CEE525F0:01CA526C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2009-10-21 at 22:35 +0800, Wu Zhangjin wrote:
>> The implementation of function graph tracer for MIPS is a little
>> different from X86.
>>
>> in MIPS, gcc(with -pg) only transfer the caller's return address(at) and
>> the _mcount's return address(ra) to us.
>>
>> move at, ra
>> jal _mcount
>>
>> in the function is a leaf, it will no save the return address(ra):
>>
>> ffffffff80101298 <au1k_wait>:
>> ffffffff80101298:       67bdfff0        daddiu  sp,sp,-16
>> ffffffff8010129c:       ffbe0008        sd      s8,8(sp)
>> ffffffff801012a0:       03a0f02d        move    s8,sp
>> ffffffff801012a4:       03e0082d        move    at,ra
>> ffffffff801012a8:       0c042930        jal     ffffffff8010a4c0 <_mcount>
>> ffffffff801012ac:       00020021        nop
>>
>> so, we can hijack it directly in _mcount, but if the function is non-leaf, the
>> return address is saved in the stack.
>>
>> ffffffff80133030 <copy_process>:
>> ffffffff80133030:       67bdff50        daddiu  sp,sp,-176
>> ffffffff80133034:       ffbe00a0        sd      s8,160(sp)
>> ffffffff80133038:       03a0f02d        move    s8,sp
>> ffffffff8013303c:       ffbf00a8        sd      ra,168(sp)
>> ffffffff80133040:       ffb70098        sd      s7,152(sp)
>> ffffffff80133044:       ffb60090        sd      s6,144(sp)
>> ffffffff80133048:       ffb50088        sd      s5,136(sp)
>> ffffffff8013304c:       ffb40080        sd      s4,128(sp)
>> ffffffff80133050:       ffb30078        sd      s3,120(sp)
>> ffffffff80133054:       ffb20070        sd      s2,112(sp)
>> ffffffff80133058:       ffb10068        sd      s1,104(sp)
>> ffffffff8013305c:       ffb00060        sd      s0,96(sp)
>> ffffffff80133060:       03e0082d        move    at,ra
>> ffffffff80133064:       0c042930        jal     ffffffff8010a4c0 <_mcount>
>> ffffffff80133068:       00020021        nop
>>
>> but we can not get the exact stack address(which saved ra) directly in
>> _mcount, we need to search the content of at register in the stack space
>> or search the "s{d,w} ra, offset(sp)" instruction in the text. 'Cause we
>> can not prove there is only a match in the stack space, so, we search
>> the text instead.
>>
>> as we can see, if the first instruction above "move at, ra" is "move s8,
>> sp"(move fp, sp), it is a leaf function, so we hijack the at register
> 
> Are you sure it will always be the first instruction for leaf registers.
> You may want to search for that instruction and stop on it. If you have
> not yet found the storage of ra in the stack, then you know it is a leaf
> function.
> 

There is no deterministic way to identify MIPS function prologs.  This 
is especially true for leaf functions, but also for functions with 
multiple return sites.

For certain GCC versions there may be a set of command line options that 
would give good results, but in general it is not possible.  Attempts at 
fast backtrace generation using code inspection are not reliable and 
will invariably result in faults and panics when they fail.

David Daney
