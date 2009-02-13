Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbZBMJrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbZBMJrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbZBMJrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:47:13 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:40239 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013AbZBMJrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:47:11 -0500
Message-ID: <49954F9A.5020801@st.com>
Date: Fri, 13 Feb 2009 11:46:50 +0100
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-mm@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] slab: fix slab flags for archs use alignment larger 
 64-bit
References: <1234461073-23281-1-git-send-email-peppe.cavallaro@st.com>	 <20090212185640.GA6111@linux-sh.org> <499544AD.3030804@st.com> <84144f020902130122y471dd92em4a72de43a0cfc681@mail.gmail.com>
In-Reply-To: <84144f020902130122y471dd92em4a72de43a0cfc681@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,
thanks for your prompt feedback.
Feel free to ask again if you need some other information.

Peppe

Kernel 2.6.23.17
=============================================
1) LOG with my patch:
root@linux:~# cat /proc/meminfo | grep Slab
Slab:             2612 kB

root@linux:~# cat /proc/slab_allocators
rpc_buffers: 8 mempool_alloc_slab+0x10/0x1c
rpc_tasks: 11 mempool_alloc_slab+0x10/0x1c
rpc_inode_cache: 10 rpc_alloc_inode+0x10/0x2c
...
anon_vma: 62 anon_vma_prepare+0x38/0xd4
pid: 20 alloc_pid+0x1e/0x2cc
size-2048: 1 tty_write+0xac/0x1d8
size-2048: 1 alloc_netdev_mq+0x40/0xbc
...

=============================================
2) LOG without my patch:
root@linux:~# cat /proc/meminfo | grep Slab
Slab:             2504 kB

root@linux:~# cat /proc/slab_allocators
rpc_buffers: 8 mempool_alloc_slab+0x10/0x1c
rpc_tasks: 11 mempool_alloc_slab+0x10/0x1c
rpc_inode_cache: 10 rpc_alloc_inode+0x10/0x2c
...
pid: 20 alloc_pid+0x1e/0x2cc

Pekka Enberg wrote:
> Hi Giuseppe,
>
> On Fri, Feb 13, 2009 at 12:00 PM, Giuseppe CAVALLARO
> <peppe.cavallaro@st.com> wrote:
>   
>> IIUC, and as you explained above, ralign is already set to the cache
>> line size by the following code:
>> ...
>> /* 3) caller mandated alignment */
>> if (ralign < align)
>> ralign = align;
>>
>> Then, there is following check:
>> ...
>> /* disable debug if necessary */
>> if (ralign > _alignof__(unsigned long long))
>> flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
>>
>> In my point of view, just this check appears "incoherent" (please, note
>> I'm not familiar with the slab internals).
>> It always makes sense in case of x86 where ARCH_KMALLOC_MINALIGN is
>> defined as: __alignof__(unsigned long long) as well.
>>     
>
> The code is indeed quite cryptic but I don't think the above statement
> is correct. Both SLAB_RED_ZONE and SLAB_STORE_USER add padding in
> front of an object and the maximum size of that padding is 2 *
> sizeof(unsigned long long). That's why we check for
> __alignof__(unsigned long) there to make sure the object can begin
> immediately after the padding added for red-zone and user pointer.
>
> On Fri, Feb 13, 2009 at 12:00 PM, Giuseppe CAVALLARO
> <peppe.cavallaro@st.com> wrote:
>   
>> In case of sh, we always disable debug for 32 aligned objects. As side
>> effect, within the leaks_show function we immediately exit for them.
>> Indeed, after applying the patch, I attached, I was able to find size-X
>> fields within the slab_allocators proc entry.
>>     
>
> That sounds unfortunate. Can you post
>
>   cat /proc/meminfo | grep Slab
>
> results on sh without and with your patch? Bumping the limit up to
> ARCH_KMALLOC_MINALIGN does make sense but we'd need to know what kind
> of problems it might cause.
>
>                                 Pekka
>
>   

