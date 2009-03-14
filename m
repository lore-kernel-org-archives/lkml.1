Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZCNWxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZCNWxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 18:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZCNWxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 18:53:07 -0400
Received: from gw.goop.org ([64.81.55.164]:33166 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbZCNWxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 18:53:07 -0400
Message-ID: <49BC354E.4070809@goop.org>
Date: Sat, 14 Mar 2009 15:53:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Screwy arch/x86/include/asm/string_32.h
References: <49BBD619.6050809@davidnewall.com>
In-Reply-To: <49BBD619.6050809@davidnewall.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> There's a lot of weirdness in __constant_memcpy in
> arch/x86/include/asm/string_32.h (2.6.29-rc7).
>
>    1. The first switch is missing a case for n equal 7.
>   
That's because there's no way to copy 7 bytes in two operations of 1/2/4 
bytes; it would need to be 3 (4+2+1), which I guess the author deemed 
overly complex.

>    2. When n < 20, the four tests (n > 16, n > 12, n > 8 & n > 4)
>       execute identical statements; always 'asm volatile("movsl" :
>       "=&D"(edi), "=&S"(esi) : "0"(edi), "1"(esi) : "memory")'.
>   

movs is a string instruction which has the side-effect of incrementing 
esi and edi, so each if() falls through to copy the next 4 bytes.

However, the tail switch should probably use plain "mov" rather than 
"movs" because nobody uses esi/edi afterwards.

    J
