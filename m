Return-Path: <linux-kernel-owner+w=401wt.eu-S1762147AbYGaD05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762147AbYGaD05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 23:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755503AbYGaD0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 23:26:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:13762 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbYGaD0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 23:26:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FobeJkhoOYwoYpAMWcNTG5ocLHFtpbr9sFcg3bM2EjR0bjQxx4dvqRX/zrLjLeiYWw
         u1Y3VHWoEzYJHoFxV8bo8aQSzRlNBXr/Flc1yq6Aqn6WtGS83zkl1IP1BlAY48Gnv+jw
         XRDwnqh5Q9t4Fab+06sAT0d30TFWl6Z7FR/j8=
Message-ID: <8bd0f97a0807302026x41d143b6p5c9eb63ef3185f06@mail.gmail.com>
Date: Wed, 30 Jul 2008 23:26:47 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] blackfin / h8300 build error fix
Cc: "Yoshinori Sato" <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080730130117.3495cba9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87provuzwk.wl%ysato@users.sourceforge.jp>
	 <8bd0f97a0807300911n4ae81b70v97276abf612f6b3e@mail.gmail.com>
	 <87hca7npmp.wl%ysato@users.sourceforge.jp>
	 <20080730130117.3495cba9.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 4:01 PM, Andrew Morton wrote:
> On Wed, 30 Jul 2008 15:22:38 -0400 Yoshinori Sato wrote:
>> At Wed, 30 Jul 2008 12:11:37 -0400 Mike Frysinger wrote:
>> > On Wed, Jul 30, 2008 at 11:58 AM, Yoshinori Sato wrote:
>> > > init/main.c:781: undefined reference to `___early_initcall_end'
>> > >
>> > > Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
>> > >
>> > > ---
>> > >  include/asm-generic/vmlinux.lds.h |    2 +-
>> > >  1 files changed, 1 insertions(+), 1 deletions(-)
>> > >
>> > > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
>> > > index 6d88a92..07b2784 100644
>> > > --- a/include/asm-generic/vmlinux.lds.h
>> > > +++ b/include/asm-generic/vmlinux.lds.h
>> > > @@ -362,7 +362,7 @@
>> > >
>> > >  #define INITCALLS                                                      \
>> > >        *(.initcallearly.init)                                          \
>> > > -       __early_initcall_end = .;                                       \
>> > > +       VMLINUX_SYMBOL(__early_initcall_end) = .;                       \
>> > >        *(.initcall0.init)                                              \
>> > >        *(.initcall0s.init)                                             \
>> > >        *(.initcall1.init)                                              \
>> > > --
>> > > 1.5.6.3
>> >
>> > nice catch, thanks ... looks like BUG_TABLE, TRACEDATA, and PERCPU are
>> > also broken, but blackfin/etc... arent using those which is why we
>> > havent noticed yet ...
>> > -mike
>>
>> Thanks.
>> I fixed same.
>>
>> Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
>>
>>  include/asm-generic/vmlinux.lds.h |   14 +++++++-------
>>  1 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
>> index 6d88a92..04cae96 100644
>> --- a/include/asm-generic/vmlinux.lds.h
>> +++ b/include/asm-generic/vmlinux.lds.h
>> @@ -333,9 +333,9 @@
>>  #define BUG_TABLE                                                    \
>>       . = ALIGN(8);                                                   \
>>       __bug_table : AT(ADDR(__bug_table) - LOAD_OFFSET) {             \
>> -             __start___bug_table = .;                                \
>> +             VMLINUX_SYMBOL(__start___bug_table) = .;                \
>>               *(__bug_table)                                          \
>> -             __stop___bug_table = .;                                 \
>> +             VMLINUX_SYMBOL(__stop___bug_table) = .;                 \
>>       }
>
> Sorry, but I haven't been following this topic very well and I rather
> dislike plucking unchangelogged patches out of the middle of email
> discussions.
>
> If there's some patch which I should be applying then please resend it,
> with a meaningful title, a description of what it does, etc.

i thought the fix was self-evident ;)

you cant just use straight symbol names in common header files as they
dont take into consideration weird arch-specific ABI conventions.  in
the case of Blackfin/h8300, the ABI dictates that any C-visible
symbols have an underscore prefixed to them.  thus all symbols in
vmlinux.lds.h need to be wrapped in VMLINUX_SYMBOL() so that each arch
can put hide this magic in their own files.
-mike
