Return-Path: <linux-kernel-owner+w=401wt.eu-S932991AbXAWMTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbXAWMTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 07:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932993AbXAWMTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 07:19:21 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:48099 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991AbXAWMTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 07:19:20 -0500
Message-ID: <45B5FCDF.4040201@hitachi.com>
Date: Tue, 23 Jan 2007 21:17:35 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, james.bottomley@steeleye.com,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] binfmt_elf: core dump masking support
References: <20061220154056.GA4261@ucw.cz> <45A2EADF.3030807@hitachi.com> 
    <20070109143912.GC19787@elf.ucw.cz> <45A74B89.4040100@hitachi.com> 
    <20070114200157.GA2582@elf.ucw.cz> <45B01387.7010207@hitachi.com> 
    <20070119004548.GE10351@elf.ucw.cz> <45B42194.3050601@hitachi.com> 
    <20070122100610.GC16309@elf.ucw.cz> <45B59218.4040201@hitachi.com> 
    <20070123090838.GD5560@ucw.cz>
In-Reply-To: <20070123090838.GD5560@ucw.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>>>>>(run echo 1 > coremask, echo 0 > coremask in a loop while dumping
>>>>>core. Do you have enough locking to make it work as expected?)
>>>>
>>>>Currently, any lock isn't acquired.  But I think the kernel only
>>>>have to preserve the coremask setting in a local variable at the
>>>>begining of core dumping.  I'm going to do this in the next version.
>>>
>>>No, I do not think that is enough. At minimum, you'd need atomic_t
>>>variable. But I'd recomend against it. Playing with locking is tricky.
>>
>>Why do you think it is not enough?  I think that any locking is not
>>needed.
> 
> You are wrong.
> 
>>  unsigned int mask = current->mm->coremask;
> 
> Not a valid C; coremask can change from another cpu.

Sure.  Although I thought it was no problem because coremask uses only
1 bit, it will be problematic when coremask grows beyond byte alignment.


>>>No, I do not think that is enough. At minimum, you'd need atomic_t
>>>variable. But I'd recomend against it. Playing with locking is tricky.

But Andrew proposed:

> Regarding the implementation: if we add
> 
> 	unsigned char coredump_omit_anon_memory:1;
> 
> into the mm_struct right next to `dumpable' then we avoid increasing the
> size of the mm_struct, and the code gets neater.

So I'm going to use a bit field to store the bitmask. Because of this,
I can't use an atomic_t variable.
Instead, I'll use a spin lock to read/write atomically.

Best regards,
-- 
Hidehiro Kawai
Hitachi, Ltd., Systems Development Laboratory


