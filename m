Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296Ab0AJBuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab0AJBuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 20:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009Ab0AJBuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 20:50:08 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:54781 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab0AJBuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 20:50:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pM7RlvUz8Fxhwr7irwv5oUsYDfFtxZFqD+1MeQ6l59dDAZkPGR5EwFShLxZc5dmu2Y
         Xw9KtS3yqnJ8e21cn72MF+TSKxfROmzePlh1tkhO1h64a28P62OIEtZflM6RgYPA+Fcd
         OdCsNL0S9Lx66a+Ka/gevUMX2dzJtwoPRTt/Y=
MIME-Version: 1.0
In-Reply-To: <20100108215039.GD4967@lenovo>
References: <alpine.DEB.2.01.1001051649100.3483@bogon.housecafe.de>
	 <4B4405B5.9040205@goop.org>
	 <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de>
	 <20100106112133.GA5815@lenovo>
	 <alpine.DEB.2.01.1001060434330.3483@bogon.housecafe.de>
	 <4B4633D3.2070903@zytor.com>
	 <alpine.DEB.2.01.1001071123220.3483@bogon.housecafe.de>
	 <20100108215039.GD4967@lenovo>
Date: Sat, 9 Jan 2010 20:50:04 -0500
Message-ID: <73c1f2161001091750y67a852dfk7539021dcc82fa1f@mail.gmail.com>
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page 
	tables
From: Brian Gerst <brgerst@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 8, 2010 at 4:50 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Thu, Jan 07, 2010 at 11:30:46AM -0800, Christian Kujau wrote:
>> On Thu, 7 Jan 2010 at 11:19, H. Peter Anvin wrote:
>> > The big difference between the code before and after this commit is that
>> > before, kernel_thread() would initialize the pt_regs structure with
>> > whatever state happened to be passed into it by the caller, whereas
>> > afterwards it is initialized to zero.
>>
>> To be honest, bisection was kinda hazy in the last step (see my previous
>> mails), but from looking at the bisection log, it's definitely one of
>> your/Brians commit (sorry!), so it may be 3bd95dfb in combination with the
>> other 4 changes. However, only with 3bd95dfb applied, the DomU wouldn't
>> start at all. With the only other patches applied, the DomU would start,
>> and then die with a GPF.
>>
>> Christian.
>> --
>> BOFH excuse #191:
>>
>> Just type 'mv * /dev/null'.
>>
>
> OK, perhaps the patch below is not _that_ stupid so I
> would like to get it reviewed and tested if possible.
> Just a thought. Wonder if it help but definitely it will
> not harm anyway :)
>
>        -- Cyrill
> ---
> x86: kernel_thread -- initialize SS to a known state
>
> Before the kernel_thread was converted into "C" we had
> pt_regs::ss set to __KERNEL_DS (by SAVE_ALL asm macro).
>
> Though I must admit I didn't find any *explicit* load of
> %ss from this structure the better to be on a safe side
> and set it to a known value.

It shouldn't make any difference, but maybe Xen is doing something
subtle.  In 64-bit mode the %ss segment register is supposed to be
ignored, which is why it is left set to zero.  It works properly on
real hardware.  It can't hurt anything to put __KERNEL_DS back in, but
I'd just like to know why Xen requires it if this does fix it.

--
Brian Gerst
