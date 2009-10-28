Return-Path: <linux-kernel-owner+w=401wt.eu-S932505AbZJ1DFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505AbZJ1DFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932472AbZJ1DFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:05:04 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:48836 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468AbZJ1DFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:05:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=go+NdCQEHg6oOLdgDnG4Mi5X0QBKPLlWpQEKjlg8zSx0eZAz+6W7ynnaz0Ky3KdCLJ
         fF5HSBrSo1A184qnYyeyI14Gik1FDLNO7xatGU8o7kVKDUxnUdo2PXbkT1SyHyDez80s
         gmjvJSUsUfCYuyx2nZ7J+AMOKL7+Z1ETjksd0=
MIME-Version: 1.0
In-Reply-To: <87hbtkjkki.fsf@basil.nowhere.org>
References: <21d7e9970910271822p3751b2fdnd78e1bc3326b9b0b@mail.gmail.com>
	 <87hbtkjkki.fsf@basil.nowhere.org>
Date: Wed, 28 Oct 2009 13:05:08 +1000
Message-ID: <21d7e9970910272005mbb268r7b16493a22ca275a@mail.gmail.com>
Subject: Re: is avoiding compat ioctls possible?
From: Dave Airlie <airlied@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       DRI Development Mailing List 
	<dri-devel@lists.sourceforge.net>,
       Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 12:53 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Dave Airlie <airlied@gmail.com> writes:
>
>> They used uint64_t to represent userspace pointers and userspace
>> casted into those and the kernel casts back out and passes it to copy_*_user
>
> uint64_t is actually dangerous due to different alignment on x86-32 vs 64,
> better use compat_u64/s64

We've designed that into a/c also, we pad all 64-bit values to 64-bit
alignment on all the
ioctls we've added to the drm in the past couple of years. Just because of
this particular insanity.

>
>> Now I thought cool I don't need to worry about compat ioctl hackery I can
>> run 32 on 64 bit apps fine and it'll all just work.
>>
>> Now Dave Miller points out that I'm obivously deluded and we really need
>> to add compat ioctls so that the kernel can truncate correctly 32-bit address
>> in case userspace shoves garbage into the top 32bits of the u64.
>
> When the user space sees a u64 field it should never shove garbage here.
> You just have to cast on 32bit for this, which is a bit ugly.
>
> However some architectures need special operations on compat pointers
> (s390 iirc), but if you don't support those it might be reasonable
> to not support that.
>
>> Is there really no way to avoid compat ioctls? was I delusional in
>> thinking there was?
>
> Experience shows that people make mistakes and you sooner or
> later need them anyways to work around them.
>

Assume no mistakes are made, new ioctls designed from scratch
and reviewed to do 32/64-bit properly. The s390 was something I didn't
know about but KMS on s390 is probably never going to be something
that sees the light of day.

I'm just amazed that compat_ioctl should be required for all new code.

DrNick on irc suggested just doing:
if (is_compat_task()) ptr &= 0x00000000FFFFFFFF;

Is there a one liner I can just do in the actual ioctls instead of
adding 20 compat
ones?

Dave.
