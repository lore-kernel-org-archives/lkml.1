Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbYKESsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbYKESsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYKESr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:47:58 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:39979 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbYKESr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:47:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KoGIU5yMP5WITRav637GdovXw0JALtIdxEM+HRz3wQMcHKt7p1nvjGIlRUAg8ntios
         VS88+wKQgaEBWzKJPCcUT7nWF6Hx+uwWhePBdxSHeXeI7ic+tJt5CHEztclKECqeprOu
         zdD7wIfkxe/qF6bDb+L17YTLAIkaxKrneKq6k=
Message-ID: <4911EA50.30905@gmail.com>
Date: Wed, 05 Nov 2008 20:47:44 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: /proc/pid/maps containg anonymous maps that have PROT_NONE
References: <49118010.20202@gmail.com> <Pine.LNX.4.64.0811051541470.19714@blonde.site> <4911DE36.6050706@gmail.com>
In-Reply-To: <4911DE36.6050706@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-05 19:56, Török Edwin wrote:
> On 2008-11-05 18:12, Hugh Dickins wrote:
>   
>>>    
>>>       
>> mmap PROT_NONE to reserve an arena, munmap to trim off top and bottom,
>> mprotect to make areas read+writable, madvise 0x4 to say MADV_DONTNEED
>> on some parts.  gcc?  Or the application itself (clamd) and its libs?
>>
>>   
>>     
>   
>> Why does it mmap too much then trim it down?  Perhaps it's trying to
>> minimize pagetable usage, perhaps it's internally convenient to base
>> on rounded addresses, I don't know.
>>
>> But the mmap is there: just easily overlooked because of the way it
>> munmaps too (with strace showing hex addresses but decimal sizes).
>>     
>
> I will get some stacktraces and figure out, know that I know which mmap
> to look for (the one with MAP_NORESERVE).
>   

I found it, glibc: arena.c:669 does it, there's a comment explaining why:

/* If consecutive mmap (0, HEAP_MAX_SIZE << 1, ...) calls return decreasing
   addresses as opposed to increasing, new_heap would badly fragment the
   address space.  In that case remember the second HEAP_MAX_SIZE part
   aligned to HEAP_MAX_SIZE from last mmap (0, HEAP_MAX_SIZE << 1, ...)
   call (if it is already aligned) and try to reuse it next time.  We need
   no locking for it, as kernel ensures the atomicity for us - worst case
   we'll call mmap (addr, HEAP_MAX_SIZE, ...) for some value of addr in
   multiple threads, but only one will succeed.  */

Anyway it is MAP_NORESERVE, and PROT_NONE so it doesn't waste physical
or swap memory.

Best regards,
--Edwin
