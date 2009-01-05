Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbZAEJCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbZAEJCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbZAEJCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:02:09 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:20040 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751317AbZAEJCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:02:06 -0500
Message-ID: <4961CC87.4030903@panasas.com>
Date: Mon, 05 Jan 2009 11:01:59 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, avishay@gmail.com,
       jeff@garzik.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       osd-dev@open-osd.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] exofs: osd Swiss army knife
References: <4947BFAA.4030208@panasas.com> <1229439174-30492-1-git-send-email-bharrosh@panasas.com> <20081229122959.2cb48cf7.akpm@linux-foundation.org> <20090102165201.GC1555@ucw.cz> <4960769D.2020509@panasas.com> <20090104200318.GA20375@elf.ucw.cz>
In-Reply-To: <20090104200318.GA20375@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jan 2009 09:01:58.0816 (UTC) FILETIME=[4407CA00:01C96F14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sun 2009-01-04 10:43:09, Boaz Harrosh wrote:
>> Pavel Machek wrote:
>>> Hi!
>>>
>>>>> +#ifdef ARCH_HAS_ATOMIC_UNSIGNED
>>>> This doesn't exist, and it would be fairly bad to introduce it.  Please
>>>> kill the ifdefs.
>>>>
>>>>> +typedef unsigned exofs_iflags_t;
>>>>> +#else
>>>>> +typedef unsigned long exofs_iflags_t;
>>>>> +#endif
>>>> Then please kill the typedef altogether and replace it with `unsigned
>>>> long' everywhere
>>> Hmmm.. .and at a note somewhere that we assume unsigned long to be atomic...?
>>>
>> I think I'll just use unsigned. It's more then enough I'm not using more then 3
>> bits for now. Is unsigned workable for all ARCHs?

<added>
> /*
>  * our extension to the in-memory inode
>  */
> struct exofs_i_info {
> 	unsigned long  i_flags;            /* various atomic flags            */
<snip>
> 
> /*
>  * our inode flags
>  */
> #define OBJ_2BCREATED	0	/* object will be created soon*/
> #define OBJ_CREATED	1	/* object has been created on the osd*/
> 
> static inline int obj_2bcreated(struct exofs_i_info *oi)
> {
> 	return test_bit(OBJ_2BCREATED, &(oi->i_flags));
> }
> 
> static inline void set_obj_2bcreated(struct exofs_i_info *oi)
> {
> 	set_bit(OBJ_2BCREATED, &(oi->i_flags));
> }
> 
> static inline int obj_created(struct exofs_i_info *oi)
> {
> 	return test_bit(OBJ_CREATED, &(oi->i_flags));
> }
> 
> static inline void set_obj_created(struct exofs_i_info *oi)
> {
> 	set_bit(OBJ_CREATED, &(oi->i_flags));
> }
</added>

> 
> Please just use atomic_t.
> 
> (see "atomics: document that linux expects certain atomic behaviour"
> thread for discussion)
> 									Pavel

I have a problem with this. The context of i_flags is to be used with
set_bit() and test_bit(). In some ARCHs like x86_64 they take an 
"unsigned long *" in most others they take a "void *" and cast internally
to a "u32 *". (for x86_64 I must use "unsigned long", anything else warns)

I think if I declare "unsigned long" but only use 32 bits flags then
I should be in the clear with ALL archs, I'll see if that works once
this code sits in linux-next. (That's real ugly I think)

Is set_bit() and test_bit() should only be used from arch/ code? What 
can regular kernel code use?

Thanks
Boaz
 
