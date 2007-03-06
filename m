Return-Path: <linux-kernel-owner+w=401wt.eu-S965907AbXCFO6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965907AbXCFO6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 09:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965908AbXCFO6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 09:58:25 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:6300 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965907AbXCFO6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 09:58:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JIVZBCUlFqGVGcZ48rlIOHIsmgeUa59AvUMwxU0B+jh2J9tHglZNbT2hk/F1uiU5CWJKDiKFrFzm9hhihni2a7m/pApGZCjaBRJym49ol1j1u18gOAh4H46DCmE3u0f9H1SkUtMv3apC1tXKWA+ELNu2fYa8DDcmh3KGlKzdcJ8=
Message-ID: <45ED818F.2030502@gmail.com>
Date: Tue, 06 Mar 2007 23:58:23 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use a zero-size array in the struct devres
References: <20070306095241.28180.76390.stgit@localhost.localdomain>	<45ED6221.5090003@gmail.com> <tnx649emo55.fsf@arm.com>
In-Reply-To: <tnx649emo55.fsf@arm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> Chapter 5.31 (http://gcc.gnu.org/onlinedocs/gcc/Alignment.html) states
> that "it is an error to ask for the alignment of an incomplete type"
> and flexible array members have incomplete type (according to ISO C99
> as described in http://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html).
> 
> It sounds to me like the alignment of an incomplete type is not
> guaranteed (as you can't even enquire about it, though I might be
> wrong). This is probably dependent on the compiler as well - with
> gcc-3.3 on x86, __alignof__(unsigned long long) is 8 but the
> "offsetof(struct test, data)" below is 12 (and it doesn't make any
> difference whether it is a 0-size array or not):
> 
> struct test {
>     unsigned long a;
>     unsigned long b;
>     unsigned long c;
>     unsigned long long data[];
> };

data[0] and data[1] or whatever will also give you offset of 12.  Dunno
why, but it is.  Anyways, whatever the wording in the manual is,
flexible arrays just have to have the required alignment to do its job
as advertised.  :-)

>>> I came across this when trying to build kmemleak as the modified
>>> container_of macro tries to get the size of the devres.data member and
>>> sizeof cannot be applied to incomplete types.
>> If kmemleak's container_of cannot deal with the current struct devres,
>> it means it can't deal with flexible arrays at all.  Flexible array
>> being the standard as opposed to 0 size array gcc extension, I guess a
>> lot of people would prefer flexible array.
> 
> I'm OK with flexible arrays (kmemleak uses them as well) but not as a
> member of structure getting passed to the container_of macro.
> 
> I did a quick grep through the kernel and it looks like Linux mainly
> uses 0-size rather than flexible arrays at the end of a structure
> (>500 vs ~14). This might be for historical reasons but it's not a big
> issue in modifying them.

I think it's mostly historical.  Flexible array is still a relatively
new thing.  I don't mind changing devres to zero sized array, but please
explain in the commit message and as a comment that the choice is for
kmemleak's container_of(), and cc Greg K-H as the change should probably
go through his tree.

Thanks.

-- 
tejun
