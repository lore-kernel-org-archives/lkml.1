Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbYKER41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbYKER41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYKER4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:56:17 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:20706 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYKER4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:56:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JU5PlJU8lD8oHTq+zo+DqJVU79vQR3sxiXAoHQ/5Pd0IZL325vYf0A1wt79tkjHDFm
         f7t1E+s50iE2cBmmnmG+cYeJ5IA/ENtylgE3hhpd2qwf9CGPPLsAlzY60Wd3K2ldsV9n
         ySxdo168eBwAq1QjkcLLMBFsGDms9xOjrmQ4c=
Message-ID: <4911DE36.6050706@gmail.com>
Date: Wed, 05 Nov 2008 19:56:06 +0200
From: =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: /proc/pid/maps containg anonymous maps that have PROT_NONE
References: <49118010.20202@gmail.com> <Pine.LNX.4.64.0811051541470.19714@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0811051541470.19714@blonde.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-05 18:12, Hugh Dickins wrote:
> On Wed, 5 Nov 2008, Török Edwin wrote:
>   
>> I noticed that there are (quite large) entries in /proc/pid/maps that
>> have PROT_NONE, right after an existing mapping:
>> 7fffe4000000-7fffe406a000 rw-p 7fffe4000000 00:00 0
>> 7fffe406a000-7fffe8000000 ---p 7fffe406a000 00:00 0
>> 7ffff76d1000-7ffff76e0000 r-xp 00000000 09:03 260750                    
>> /lib/libbz2.so.1.0.4
>> 7ffff76e0000-7ffff78df000 ---p 0000f000 09:03 260750                    
>> /lib/libbz2.so.1.0.4
>>
>> I don't mind that 2Mb map, but what is 7fffe406a000-7fffe8000000 ---p ?
>> (63M)
>>
>> Is it coming from glibc mapping memory as PROT_NONE, and using
>> mprotect/madvise to make it writable, and then
>> caching the mappings for future use, rather than freeing them?
>>     
>
> mmap PROT_NONE to reserve an arena, munmap to trim off top and bottom,
> mprotect to make areas read+writable, madvise 0x4 to say MADV_DONTNEED
> on some parts.  gcc?  Or the application itself (clamd) and its libs?
>
>   
>> I straced the program creating these, and I couldn't find anything with
>> 7fffe406a000, but only before that address:
>>
>> [pid 31928] mprotect(0x7fffe4000000, 135168, PROT_READ|PROT_WRITE) = 0
>>     
> [snipped]
>   
>> [pid 31928] madvise(0x7fffe4021000, 4096, 0x4 /* MADV_??? */) = 0
>>
>> There is an mprotect and madvise that end at 0x7fffe406a000.
>> Those mprotects and madvise are coming from glibc. Its strange that I
>> don't see the mmap only the mprotect, but I used strace -f.
>>
>> This happens on:
>> Linux debian 2.6.26-1-amd64 #1 SMP Thu Oct 9 14:16:53 UTC 2008 x86_64
>> GNU/Linux
>>
>> strace is here:
>> http://edwintorok.googlepages.com/log2.bz2
>>     
>
> Just before your first mprotect above there's:
>
> [pid 31928] mmap(NULL, 134217728, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0 <unfinished ...>
> [pid 31938] futex(0x7ffff6e489e0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
> [pid 31928] <... mmap resumed> )        = 0x7fffe2bd3000
>
>   which maps 7fffe2bd3000-7fffeabd3000; then
>
> [pid 31928] munmap(0x7fffe2bd3000, 21155840 <unfinished ...>
> [pid 31938] <... futex resumed> )       = 0
> [pid 31928] <... munmap resumed> )      = 0
>
>   which unmaps 7fffe2bd3000-7fffe4000000; and then
>
> [pid 31928] munmap(0x7fffe8000000, 45953024) = 0
>
>   which unmaps 7fffe8000000-7fffeabd3000.
>
> So it's trimming off the rough edges to leave 7fffe4000000-7fffe8000000
> mapped PROT_NONE, then mprotecting what it needs of that.
>
>   

Thanks I completely missed the mmap, because I grepped for 7fffe4000000.

> Why does it mmap too much then trim it down?  Perhaps it's trying to
> minimize pagetable usage, perhaps it's internally convenient to base
> on rounded addresses, I don't know.
>
> But the mmap is there: just easily overlooked because of the way it
> munmaps too (with strace showing hex addresses but decimal sizes).

I will get some stacktraces and figure out, know that I know which mmap
to look for (the one with MAP_NORESERVE).

Best regards,
--Edwin
