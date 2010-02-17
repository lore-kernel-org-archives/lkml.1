Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab0BQWac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:30:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49440 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351Ab0BQWab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:30:31 -0500
Message-ID: <4B7C6DCE.3080609@zytor.com>
Date: Wed, 17 Feb 2010 14:29:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Zachary Amsden <zamsden@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] x86 rwsem optimization extreme
References: <1266443901-3646-1-git-send-email-zamsden@redhat.com> <alpine.LFD.2.00.1002171403160.4141@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002171403160.4141@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2010 02:10 PM, Linus Torvalds wrote:
> 
> 
> On Wed, 17 Feb 2010, Zachary Amsden wrote:
>>
>> The x86 instruction set provides the ability to add an additional
>> bit into addition or subtraction by using the carry flag.
>> It also provides instructions to directly set or clear the
>> carry flag.  By forcibly setting the carry flag, we can then
>> represent one particular 64-bit constant, namely
>>
>>    0xffffffff + 1 = 0x100000000
>>
>> using only 32-bit values.  In particular we can optimize the rwsem
>> write lock release by noting it is of exactly this form.
> 
> Don't do this.
> 
> Just shift the constants down by two, and suddenly you don't need any 
> clever tricks, because all the constants fit in 32 bits anyway, 
> regardless of sign issues.
> 

Why bother at all?  I thought it mattered when I saw __downgrade_write()
as an inline, but in fact it is only ever used inside the
downgrade_write() out-of-line function, so we're talking about saving
*five bytes* across the whole kernel in the best case.  I vote for
leaving it the way it is, and get the very slight extra readability.
There is no point in moving bits around, either.

	-hpa
