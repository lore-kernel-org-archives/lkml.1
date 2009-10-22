Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbZJVCNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbZJVCNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 22:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZJVCNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 22:13:33 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62083 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbZJVCNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 22:13:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZuSgkaBkVCLviXo8fNRHf5L7J+PeQ3Y5Q/i2pRENnzdkNERk9YRk+KGGkWOLKnPlUT
         ZsOPwXaXseJXo1HlDITXh+I4YidCAzQYdfminI2kBoG3eu2I1ebAvsS4JCvlKmNFygLv
         t32RbAsfy4aYQe3L1pEtLMmvcOV1SlpPL5uPg=
MIME-Version: 1.0
In-Reply-To: <200910212341.06025.rusty@rustcorp.com.au>
References: <s5haazv1sw5.wl%tiwai@suse.de>
	 <200910212341.06025.rusty@rustcorp.com.au>
Date: Thu, 22 Oct 2009 04:13:36 +0200
Message-ID: <6dc076840910211913l1cf12e82tbb9151da78e41422@mail.gmail.com>
Subject: Re: Problems with string (charp) module parameters
From: Takashi Iwai <takashi.iwai@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

(sending from gmail address since VPN doesn't work here in hotel...)

On Wed, Oct 21, 2009 at 3:11 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Tue, 13 Oct 2009 09:07:46 pm Takashi Iwai wrote:
>> * The handling of parameter array is pretty buggy now.
>>   kp->perm and kp->flags aren't properly initialized in
>>   param_array().  Thus, you might call kfree() with invalid pointers,
>>   or pass a wrong type for bool.
>
> Yes, an array of charp isn't going to work.  Erk, I switched one bug for
> another :(
>
>> So, the situation looks messy right now, not only about the section
>> issue.  If we allow kmalloc of each parameter array element, the flag
>> must be associated to each element, not a global one to the array.
>>
>> Thoughts?
>
> Yes, that's hard.  There's only one place which currently has a writable
> array parameter: drivers/usb/atm/ueagle-atm.c, and it's root only.
>
> OK, for 2.6.32, we remove the const.  In the longer term, I'm reworking how
> this is done entirely.

As far as I checked, removing only const doesn't suffice on x86.
The problem is rather the __param section assignment.
We'd need to get rid of that, too, if we keep the code in the current way.

Anyway, I've thought of this for a while, but couldn't find any smart solution.
Judging from the current usage pattern, I think we should rather take
a simpler solution:
don't allow sysfs-write for charp type but use string type for
writable parameters.

It's not only for avoiding the mess to separate static and kmalloc
strings but also for
avoiding races between the referrer and the sysfs-write of char
pointer.  (In general, we
have no lock for parameters.)

As you pointed out, there are no many users of writable charp parameters.
So, replacing is easy task.  In that way, we can keep struct
kernel_parameter as const
gracefully without hustling any big code change.


thanks,

Takashi
