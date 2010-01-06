Return-Path: <linux-kernel-owner+w=401wt.eu-S1756424Ab0AFWa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab0AFWa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963Ab0AFWa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:30:57 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39680 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab0AFWa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:30:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GRAyX6myNa6/YIBFt0Lz6baa+NT3HfHqkRpBE8xggWE9XzB4QC44VD/BuQKUR4XSIv
         HP+Vf7+EIejxUhVLxaJkE2FcT/mOiT7jmcKzoEf7ZZDYPsNY66dXv0QjXiFz2iXaPfMN
         HDQYxZiHlXK60DBKb3vr+jw0Sg8NXHqVW+PrE=
MIME-Version: 1.0
In-Reply-To: <4B44F665.6050008@suse.cz>
References: <alpine.LFD.2.00.1001061705140.3744@localhost.localdomain>
	 <4B44E5C8.2050006@suse.cz>
	 <520f0cf11001061210w4d33fca6y98f091c4260577c0@mail.gmail.com>
	 <4B44F665.6050008@suse.cz>
Date: Wed, 6 Jan 2010 23:30:54 +0100
X-Google-Sender-Auth: 2286a49aa341d82d
Message-ID: <520f0cf11001061430l2b363d90qce43bf94a384cf13@mail.gmail.com>
Subject: Re: [PATCH] Don't mkdir -p include/config in the sourcetree when 
	using O=outputdir option
From: John Kacur <jkacur@redhat.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 9:45 PM, Michal Marek <mmarek@suse.cz> wrote:
> John Kacur napsal(a):
>> Yes, I doubled checked that the problem exists, and it is quite easy for me to
>> reproduce. However, my proposed solution is also broken, please don't
>> apply, I'm still investigating.
>>
>> I am surprised that you are not able to reproduce the problem though.
>> Did you follow the steps I that I outlined?
>
> I did
>
> $ git checkout v2.6.33-rc3
> $ mkdir /bld/2.6.33-rc3
> $ zcat /proc/config.gz >/bld/2.6.33-rc3/.config
> $ make O=/bld/2.6.33-rc3/ oldconfig
> ...
> hit Enter several times
> ...
> $ ls -ld include/config /bld/2.6.33-rc3/include/config/
> ls: cannot access include/config: No such file or directory
> drwxr-xr-x 2 mmarek users 4096 2010-01-06 21:35
> /bld/2.6.33-rc3/include/config//
> $ make O=/bld/2.6.33-rc3/
>  GEN     /bld/2.6.33-rc3/Makefile
> scripts/kconfig/conf -s arch/x86/Kconfig
>  Using /home/mmarek/linux-2.6 as source for kernel
>  GEN     /bld/2.6.33-rc3/Makefile
>  CHK     include/linux/version.h
>  UPD     include/linux/version.h
>  CHK     include/generated/utsrelease.h
>  UPD     include/generated/utsrelease.h
>  CC      kernel/bounds.s
> ... continues building ...
>
>
> The mkdir command has been in the Makefile since 2006 (c955cca), so I
> think that your problem is caused by something else. Try a make V=1
> build with a read-only source tree to see which mkdir command fails.
>

Michal: The length of time that a bug exists in a piece of code is no
argument for
it's correctness!

I tried to debug this using
make -d V=1 O=/bld/2.6.33-rc3
and discovered that the bug did not always occur, but did sometimes.
This leads me to think that it is timing sensitive, and indeed the
problem shows up
more easily on a machine with multiple processors.

Is it possible that the step with mkdir -p can sometimes occur in a
Makefile parallel process
before the cd KBUILD_OUTPUT occurs? That would explain why it doesn't
reliably reproduce.

In any case, the idea behind my original patch is good, just specify
the full path
using the objtree variable and the problem goes away. The first round of my
implementation was simply lacking.

Following up this note with a patch.

John
