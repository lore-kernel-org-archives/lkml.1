Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbZD2PTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbZD2PTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 11:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZD2PTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 11:19:42 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47536 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbZD2PTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 11:19:41 -0400
Message-ID: <49F87009.1000905@monstr.eu>
Date: Wed, 29 Apr 2009 17:19:37 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com
Subject: Re: [PATCH 20/30] microblaze_mmu_v1: uaccess MMU update
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu> <20090428225352.4a54f277.akpm@linux-foundation.org> <49F827F1.8010308@monstr.eu> <200904291258.40667.arnd@arndb.de>
In-Reply-To: <200904291258.40667.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 29 April 2009, Michal Simek wrote:
>> Here is that change which remove address space problem.
>>
>> #define __clear_user(addr, n)   (memset((__force void *)(addr), 0, (n)), 0)
>>
>> Am I right?
>>
>> The same mishmash is for memset_fromio/memset_toio and maybe some others which I want to fix too.
> 
> This will work, but a better fix would be to define an inline
> function that explicitly takes a __user pointer. This would give
> you warnings when code accidentally calls __clear_user on a
> kernel pointer (this also adds the might_sleep()):
> 
> static inline unsigned long __must_check 
> __clear_user(void __user *to, unsigned long n)
> {
> 	memset((__force void *)addr, 0, n);
> 	return 0;
> }
> 
> static inline unsigned long __must_check 
> clear_user(void __user *to, unsigned long n)
> {
> 	might_sleep();
> 	if (unlikely(!access_ok(VERIFY_WRITE, to, n)))
> 		return n;
> 
> 	return __clear_user(to, n);
> }
> 
> The above is just the nommu variant. For mmu, you need to
> have exception handling in __clear_user to take care of the
> case where the address is part of the user mapping (access_ok)
> but not currently mapped.

Is it possible to do it for noMMU kernel too? I mean current MMU implementation of
__clear_user in asm is faster than call memset for noMMU. I think I can use MMU implementation for
noMMU too. Add two words to __ex_table
just extend size of one section but not too much and won't be used for noMMU.

Michal


> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
