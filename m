Return-Path: <linux-kernel-owner+w=401wt.eu-S1762510AbYG1VTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762510AbYG1VTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760659AbYG1VPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:15:39 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33495 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761451AbYG1VPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:15:37 -0400
Message-ID: <488E3643.8000300@cs.helsinki.fi>
Date: Tue, 29 Jul 2008 00:12:35 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mhalcrow@us.ibm.com, stable@kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] eCryptfs - use page_alloc not kmalloc to get a page of
 memory
References: <488DF00F.3080809@redhat.com>	 <20080728133504.156f438f.akpm@linux-foundation.org> <84144f020807281342t2e1a3dc3id01314ac01de406f@mail.gmail.com> <488E3414.8020506@redhat.com>
In-Reply-To: <488E3414.8020506@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Eric Sandeen wrote:
> Pekka Enberg wrote:
>> On Mon, Jul 28, 2008 at 11:35 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>>> On Mon, 28 Jul 2008 11:13:03 -0500
>>> Eric Sandeen <sandeen@redhat.com> wrote:
>>>
>>>> With SLUB debugging turned on in 2.6.26, I was getting memory corruption
>>>> when testing eCryptfs.  The root cause turned out to be that eCryptfs
>>>> was doing kmalloc(PAGE_CACHE_SIZE); virt_to_page() and treating that
>>>> as a nice page-aligned chunk of memory.  But at least with SLUB debugging
>>>> on, this is not always true, and the page we get from virt_to_page does
>>>> not necessarily match the PAGE_CACHE_SIZE worth of memory we got from
>>>> kmalloc.
>>>>
>>>> My simple testcase was 2 loops doing "rm -f fileX; cp /tmp/fileX ." for
>>>> 2 different multi-megabyte files.  With this change I no longer see
>>>> the corruption.
>>> The fix applies to both 2.6.25 and to 2.6.26 and appears to be needed
>>> in both kernel versions, so I have tagged it for backporting into both.
>> Hmm, SLUB will use the page allocator directly for PAGE_CACHE_SIZE
>> regadless of whether debugging is enabled or not...
> 
> For whatever reason, I did see non-page-aligned memory returned from
> kmalloc(PAGE_CACHE_SIZE), and I think this is what caused the problem
> once virt_to_page() was used to get hold of a page to pass around in the
> ecryptfs/crypto code...

With SLUB? I can't see how that's possible. I can see this with SLAB, 
though, for 4K pages.

In any case, the patch, of course, make sense as kmalloc() behavior 
varies between allocators.

		Pekka
