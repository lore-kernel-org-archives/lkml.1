Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbZJVQAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbZJVQAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZJVQAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:00:54 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16444 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbZJVQAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:00:53 -0400
Message-ID: <4AE08173.7070500@caviumnetworks.com>
Date: Thu, 22 Oct 2009 08:59:47 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: wuzhangjin@gmail.com
CC: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH -v4 9/9] tracing: add function graph tracer support for
 MIPS
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>	 <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>	 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>	 <96110ea5dd4d3d54eb97d0bb708a5bd81c7a50b5.1256135456.git.wuzhangjin@gmail.com>	 <5dda13e8e3a9c9dba4bb7179183941bda502604f.1256135456.git.wuzhangjin@gmail.com>	 <af3ec1b5cd06b6f6a461c9fa7d09a51fabccb08d.1256135456.git.wuzhangjin@gmail.com>	 <a6f2959a69b6a77dd32cc36a5c8202f97d524f1e.1256135456.git.wuzhangjin@gmail.com>	 <53bdfdd95ec4fa00d4cc505bb5972cf21243a14d.1256135456.git.wuzhangjin@gmail.com>	 <1256141540.18347.3118.camel@gandalf.stny.rr.com>	 <4ADF38D5.9060100@caviumnetworks.com>	 <1256143568.18347.3169.camel@gandalf.stny.rr.com>	 <4ADF3FE0.5090104@caviumnetworks.com>	 <1256145813.18347.3210.camel@gandalf.stny.rr.com> <1256211516.3852.47.camel@falcon>
In-Reply-To: <1256211516.3852.47.camel@falcon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Oct 2009 15:59:49.0705 (UTC) FILETIME=[AF3D5B90:01CA5330]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Zhangjin wrote:
> Hi,
> 
> On Wed, 2009-10-21 at 13:23 -0400, Steven Rostedt wrote:
>> On Wed, 2009-10-21 at 10:07 -0700, David Daney wrote:
>>
>>> I have not used -pg, so I don't know for sure, I think all it does is 
>>> add the calls to _mcount.  Someone could investigate 
>>> -fno-omit-frame-pointer, with that you may be able to use:
>> Note, -pg assumes -fno-omit-frame-pointer, since -fomit-frame-pointer
>> and -pg are incompatible.
> 
> Ralf have told me -pg really works with -fomit-frame-pointer, although
> the gcc tool tell us they are not incompatible when we use both of them
> together, but when I remove -fno-omit-frame-pointer in
> KBUILD_FLAGS(enabled by CONFIG_FRAME_POINTER), it definitely remove the
> s8(fp) relative source code(Seems -fomit-frame-pionter is used by
> default by gcc), the leaf function becomes this:
> 
> function:
> 
> 80101144 <au1k_wait>:
> 80101144:       03e00821        move    at,ra
> 80101148:       0c04271c        jal     80109c70 <_mcount>
> 
> No more instruction,
> 
> and the non-leaf function becomes,
> 
> 80126590 <copy_process>:
> 80126590:       27bdffa0        addiu   sp,sp,-96
> 80126594:       afbf005c        sw      ra,92(sp)
> 80126598:       afbe0058        sw      s8,88(sp)
> 8012659c:       afb70054        sw      s7,84(sp)
> 801265a0:       afb60050        sw      s6,80(sp)
> 801265a4:       afb5004c        sw      s5,76(sp)
> 801265a8:       afb40048        sw      s4,72(sp)
> 801265ac:       afb30044        sw      s3,68(sp)
> 801265b0:       afb20040        sw      s2,64(sp)
> 801265b4:       afb1003c        sw      s1,60(sp)
> 801265b8:       afb00038        sw      s0,56(sp)
> 801265bc:       03e00821        move    at,ra
> 801265c0:       0c04271c        jal     80109c70 <_mcount>
> 
> It may save about two instructions for us.
> 	
> 	sw	s8, offset(sp)
> 	move	s8, fp
> 
> and also, I have tried to just search "Save" instruction, if I find one,
> that should be a non-leaf function, otherwise, it's leaf function, but I
> can not prove no "Save" instruction before the leaf function's "move at,
> ra", for example:
> 
> 8010113c:       03e00008        jr      ra
> 80101140:       00020021        nop
> 
> 80101144 <au1k_wait>:
> 80101144:       03e00821        move    at,ra
> 80101148:       0c04271c        jal     80109c70 <_mcount>
> 
> if there is "save" instruction at address 80101140, it will fail.
> Although, I met not failure with several tries, but no prove on it! any
> ABI protection for this? if YES, this should be a better solution, for
> it may works without -fno-omit-frame-pointer and save several
> instructions for us.

This is what I was talking about up-thread.  Leaf functions may have no 
function prolog.  If you do code scanning you will fail.  While scanning 
backwards, there is no way to know when you have entered a new function. 
  Looking for function return sequences 'jr ra' doesn't work as there 
may be functions with multiple return sites, functions that never 
return, or arbitrary data before the function.  I think you have to 
force a frame pointer to be established if you want this to work.

David Daney
