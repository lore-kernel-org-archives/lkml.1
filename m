Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbYKQUbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbYKQUbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYKQUbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:31:33 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:59195 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbYKQUbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:31:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QwYUOQYD6urC3kq+tyjHrabc4trFcrZSFg9LxyvvIKjSd7X725tW1RjRUyjEl9/jBY
         H4TCzoNphpcYHo9Zrx1YPwD6zMGnSewVaDsCX4Gc5Tuie4PBNkdPL0mWgBre5XxGPW7+
         bHNnZZxcypd8WUf12yVHAD1isy+HK55UyQsFc=
Message-ID: <3e8340490811171231i1449924cu37ca11451f3297d1@mail.gmail.com>
Date: Mon, 17 Nov 2008 15:31:31 -0500
From: "Bryan Donlan" <bdonlan@gmail.com>
To: "Victoria Muntean" <vikimun@gmail.com>
Subject: Re: size of swapped-out part of the process
Cc: "Hugh Dickins" <hugh@veritas.com>,
       "Kernel Linux" <linux-kernel@vger.kernel.org>
In-Reply-To: <ab4346860811171142je64d197keeb984bf7299e951@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab4346860811170452t2cbcb451u407edca19c9e0ba6@mail.gmail.com>
	 <ab4346860811170453i2bba95a6nb16c2c9e59424272@mail.gmail.com>
	 <Pine.LNX.4.64.0811171343340.11044@blonde.site>
	 <ab4346860811171142je64d197keeb984bf7299e951@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 2:42 PM, Victoria Muntean <vikimun@gmail.com> wrote:
> On 11/17/08, Hugh Dickins <hugh@veritas.com> wrote:
>> On Mon, 17 Nov 2008, Victoria Muntean wrote:
>>> How can I calculate size of swapped-out part of the process from
>>> /proc/PID/*, even if approximately ?
>>> For example, I have VmSize=1216192 kB, VmRSS = 628788 kB, but global
>>> swap-in-use==0.
>>> Hence (VmSize - VmRSS) is far from being swapped-out part of the
>>> process. What is ?
>>
>> I'm sorry, we don't record those numbers per process or per mm,
>> so you won't find them in /proc/PID/status or /proc/PID/statm.
>>
>> And we'd probably resist accepting a patch to add them,
>> so as not to enlarge key data structures to hold them.
>>
>> There's also an ambiguity about what "swapped-out" means: does
>> it include shared file pages which were once mapped into the
>> process, but have since been freed under memory pressure?
>>
>> But it looks like you're interested in swapped-out to mean written
>> on swap.  In that case, if you have CONFIG_PROC_PAGE_MONITOR=y,
>> you can read /proc/PID/smaps and add up all the "Swap:" lines.
>
> Can you possibly explain what types of pages create  "VSZ>>RSZ"
> effect in total absence of swapping and plenty of free memory ?

mmap(2) a file, then don't touch some pages in it. This happens all
the time with shared libraries - for example, if you link in
imagemagick, but never use JPEG encoding/decoding, the pages of memory
corresponding to libjpeg will never be touched, and so will be
accounted in VSZ but not RSZ.

If there's memory pressure (even if you have plenty of cache, this can
occur just from IO activity), long-unaccessed pages from these mmaps
may be evicted after being read as well.

Also, some programs have a habit of allocating much more memory than
they actually use - the pages they don't access are not mapped, and so
are not accounted in RSZ either. If they never write to them, they
won't be present in swap either.
