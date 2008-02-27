Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbYB0AjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbYB0AjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:39:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbYB0Aiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:38:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52859 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757564AbYB0Aix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:38:53 -0500
Message-ID: <47C4AFFC.7090500@zytor.com>
Date: Tue, 26 Feb 2008 16:34:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: (regression) kernel/timeconst.h bugs with HZ=128
References: <20080226183224.DE5BB8DE50@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20080226160958.3f58a5c1.akpm@linux-foundation.org>
In-Reply-To: <20080226160958.3f58a5c1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 26 Feb 2008 10:32:24 -0800 David Brownell <david-b@pacbell.net> wrote:
> 
>> I see these warnings on 32 bit ARM systems:
>>
>>   CC      kernel/time.o
>> kernel/time.c: In function 'msecs_to_jiffies':
>> kernel/time.c:472: warning: integer constant is too large for 'long' type
>> kernel/time.c: In function 'usecs_to_jiffies':
>> kernel/time.c:487: warning: integer constant is too large for 'long' type
>>
>> Line 472: 
>> 	return ((u64)MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
>> line 487:
>> 	return ((u64)USEC_TO_HZ_MUL32 * u + USEC_TO_HZ_ADJ32)
>>
>> The problem seems to be that these constants from kernel/timeconst.h
>> have too many digits:
>>
>> #define ONLY_THIRTYTWO_BITS	0x01234567
>>
>> #define MSEC_TO_HZ_ADJ32        0x3f7ced916
>> #define USEC_TO_HZ_ADJ32        0xfffbce4217d
>>
>> Those *_ADJ32 constants should have "ULL" suffixes, yes?
>> Adding that by hand resolves the problem, but only until
>> the next time that header file gets regenerated.
>>
>> Someone with observable Perl-fu should fix this ...
>>
> 

<barf>

The real issue is that we don't have any equivalent to the UINTxx_C() 
creation macros in Linux, and even though we're using a cast -- which is 
totally correct -- makes gcc issue a (spurious) warning.

The right thing would be to create _C() macros and use those in the C 
code, i.e. UINT64_C(MSEC_TO_HZ_MUL32).

I'll write up a patch, but probably not today.

	-hpa
