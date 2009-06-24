Return-Path: <linux-kernel-owner+w=401wt.eu-S1759124AbZFXPxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124AbZFXPxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 11:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZFXPxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 11:53:32 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:60215 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbZFXPxb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 11:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xh6iTy+tD7OmNGemOpbEHHLgabp7aZwJCPoU0AmZdotzwk5Jl0UpOumP0A7l/yLPtf
         aG4tl/A5caaGPvt8euesWIpuZQY4ZJaR+oMHtb3P6KitRFsztr9HCouye8c2PBcKpHmX
         U29dGQlDfZofW6IgnDoN6tz/YQu4QW9jZDLZI=
MIME-Version: 1.0
In-Reply-To: <20090623100040.GD30634@elte.hu>
References: <817ecb6f0906181833m77dcbeder76f0e8c6e85555ef@mail.gmail.com>
	 <alpine.LRH.2.00.0906231240060.31540@tundra.namei.org>
	 <20090623100040.GD30634@elte.hu>
Date: Wed, 24 Jun 2009 11:53:32 -0400
Message-ID: <817ecb6f0906240853jcfa96dep336bda6892fe7ebe@mail.gmail.com>
Subject: Re: [PATCH] RO/NX protection for loadable kernel modules
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 6:00 AM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * James Morris <jmorris@namei.org> wrote:
>
>> On Thu, 18 Jun 2009, Siarhei Liakh wrote:
>>
>> > This patch is a logical extension of the protection provided by
>> > CONFIG_DEBUG_RODATA to LKMs. The protection is provided by splitting
>> > module_core and module_init into three logical parts each and setting
>> > appropriate page access permissions for each individual section:
>> >
>> >    1. Code: RO+X
>> >    2. RO data: RO+NX
>> >    3. RW data: RW+NX
>> >
>> > In order to achieve proper protection, layout_sections() have been
>> > modified to align each of the three parts mentioned above onto page
>> > boundary. Next, the corresponding page access permissions are set
>> > right before successful exit from load_module(). Further,
>> > module_free() have been modified to set module_core or module_init as
>> > RW+NX right before calling vfree(). Functionality of this patch is
>> > enabled only when CONFIG_DEBUG_RODATA defined at compile time.
>> >
>>
>> This looks potentially useful to me, but I'm not an x86 expert
>> (several now added to Cc:).
>
> Pinged a few folks about this already. It looks useful, with the
> main worry being:
>
>  1) the increase in effective module size (probably worth the price)
>  2) some uglies in the patch (fixable)
>
> The main ugliness is the excessive use of #ifdefs - those should be
> eliminated. Also, most scripts/checkpatch.pl warnings about this
> patch should be taken seriously.
>
>        Ingo

1: You are correct. This patch effectively sets the lower limit of 3
pages for a module (well, there are some modules that do not have
.text and/or .data, but we are not talking about these extremes). So,
for small (sub-one-page) modules this will create 300% overhead.
However, for large modules the overhead is not that significant.

2: Agree. Will fix.

The main reason the #ifdefs are there is to make this patch dependent
on CONFIG_DEBUG_RODATA, since not everyone may be willing to pay 300%
overhead for the modules they use. I guess I could do some code
re-factoring, but #ifdefs will still be there. Or did you really mean
to eliminate all of them, making this patch a permanent feature of the
kernel? Can you please point me into right direction on how to
eliminate the #ifdefs while allowing to exclude the patch at compile
time if necessary?

Thanks.
