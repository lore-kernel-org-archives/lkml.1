Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060Ab0A0PVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0A0PVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 10:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167Ab0A0PVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 10:21:19 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:54057 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab0A0PVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 10:21:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OqbZaPzh9MdRhEaDycAyd2aJG9u2vNvgaQv8i7WvENJawqSMpOn/eHf7RC8JLyhDD+
         3dtiFopC6Yi1hNucyc7QxEgf2quyg6Ok+PSstagsYjHXrNnMo0wHRdOQPweFozA7QNz/
         Luv19E4QecJnEiiwDAnKUmyTnYNoKkFf5t2To=
MIME-Version: 1.0
In-Reply-To: <20100127130716.GA26908@elte.hu>
References: <1264434453-2204-1-git-send-email-brgerst@gmail.com>
	 <tip-f19a25c872b20ae4357f72687cf3e7b0da220ee2@git.kernel.org>
	 <20100127130716.GA26908@elte.hu>
Date: Wed, 27 Jan 2010 10:21:15 -0500
Message-ID: <73c1f2161001270721x3d07b507lb78fa8c53567dcaa@mail.gmail.com>
Subject: Re: [tip:x86/asm] x86-64: Use normal ptregs stub for execve
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 8:07 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * tip-bot for Brian Gerst <brgerst@gmail.com> wrote:
>
>> Commit-ID:  f19a25c872b20ae4357f72687cf3e7b0da220ee2
>> Gitweb:     http://git.kernel.org/tip/f19a25c872b20ae4357f72687cf3e7b0da220ee2
>> Author:     Brian Gerst <brgerst@gmail.com>
>> AuthorDate: Mon, 25 Jan 2010 10:47:33 -0500
>> Committer:  H. Peter Anvin <hpa@zytor.com>
>> CommitDate: Tue, 26 Jan 2010 23:38:14 -0800
>>
>> x86-64: Use normal ptregs stub for execve
>>
>> Execve historically passed regs by value, so it had a seperate stub.
>> This is no longer true, so change it to use a normal PTREGSCALL stub.
>>
>> Signed-off-by: Brian Gerst <brgerst@gmail.com>
>> LKML-Reference: <1264434453-2204-1-git-send-email-brgerst@gmail.com>
>> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>> ---
>>  arch/x86/kernel/entry_64.S |   17 +----------------
>>  1 files changed, 1 insertions(+), 16 deletions(-)
>
> FYI, -tip testing found that this commit breaks the grub binary on 64-bit,
> simply running /sbin/grub causes it to segfault:
>
> [ 3145.999766] grub[6706] general protection ip:805c481 sp:ff95629c error:0 in
> grub[8048000+8c000]
>
> i've excluded this commit for now.
>
>        Ingo
>
>

I see what is going on.  Grub is a 32-bit statically linked executable
even on a 64-bit distro.  The old execve stub forced return to
userspace via iret, but PTREGSCALL apparently doesn't.  This means
that the 32-bit %cs isn't getting set.  Drop this patch for now.

--
Brian Gerst
