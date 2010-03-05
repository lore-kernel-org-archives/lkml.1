Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab0CEGIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 01:08:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:46099 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab0CEGIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 01:08:13 -0500
Message-ID: <4B909FC5.8020800@kernel.org>
Date: Fri, 05 Mar 2010 15:08:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Sachin Sant <sachinp@in.ibm.com>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: -next March 3: Boot failure on x86 (Oops)
References: <20100303174603.5be197ba.sfr@canb.auug.org.au> <4B8E83D4.6090507@in.ibm.com> <4B8F0CD0.1040507@kernel.org> <4B8F43DD.10002@in.ibm.com>
In-Reply-To: <4B8F43DD.10002@in.ibm.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Mar 2010 06:08:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/04/2010 02:23 PM, Sachin Sant wrote:
>> Can you please feed the address to gdb and get the line number?  Also,
>> is it reproducible on mainline?
>>   
> I can recreate this with latest git as well (2.6.33-git9 [eaa5eec7..])
> 
> Disassembly from 2.6.33-git9 code base follows :
> 
> /usr/local/autobench/var/tmp/build/linux/mm/percpu.c:1137
>                        if (off >= 0)
>     e91:       0f 89 fd 00 00 00       jns    f94 <pcpu_alloc+0x2bd>
> /usr/local/autobench/var/tmp/build/linux/mm/percpu.c:1116
>        }
> 
> restart:
>        /* search through normal chunks */
>        for (slot = pcpu_size_to_slot(size); slot < pcpu_nr_slots; slot++) {
>                list_for_each_entry(chunk, &pcpu_slot[slot], list) {
>     e97:       8b 45 84                mov    -0x7c(%ebp),%eax
>     e9a:       8b 00                   mov    (%eax),%eax
>     e9c:       89 45 84                mov    %eax,-0x7c(%ebp)
> prefetch():
> /usr/local/autobench/var/tmp/build/linux/arch/x86/include/asm/processor.h:886
> 
>     e9f:       8b 55 84                mov    -0x7c(%ebp),%edx
>     ea2:       8b 02                   mov    (%edx),%eax
> 
> ^^^^^^^^^^^^^^^^^^^ EIP corresponds to this line

Hmmm... this means that on one of the chunks, chunk->list.next was
NULL (BTW, the disassembly is from unlinked object, right?).  The main
allocation code hasn't seen much change lately.  The only changes are,

22b737f4c75197372d64afc6ed1bccd58c00e549 : just refactoring
833af8427be4b217b5bc522f61afdbd3f1d282c2 : possible but isn't very new

Another possibility could be that the data structure before it was
overrun and corrupted the list part.  pcpu_chunk is allocated with
variable size array attached at the end, so maybe I screwed up
calculation somewhere?  This could explain the difference between 64
and 32bits.  If you add padding at the head of struct pcpu_chunk, say,
unsigned long pad[16], does the problem go away?

Thanks.

-- 
tejun
