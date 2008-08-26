Return-Path: <linux-kernel-owner+w=401wt.eu-S1758496AbYHZOPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496AbYHZOPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 10:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYHZOP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 10:15:28 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:50570 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbYHZOP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 10:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FF5SRw7AeupPfnErI21AMpuIpyDEP4y0q2TAzohKjYhiGxHICW8m3pCjJK5F3gR8Al
         rV0aTxAnJkxNw8c9cd7iTVKaopDdz2bv0ewxnznWSCxKn6jDZxtcIyw2C9zAVBF9MKlL
         aDWVVYZaieD9hsMOxpeiKo+E9cPlCjIlP6eWM=
Message-ID: <48f7fe350808260715y30ef89a1le7f8abdf0be61351@mail.gmail.com>
Date: Tue, 26 Aug 2008 10:15:25 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: [-mmotm] BUG: scheduling while atomic: swapper
Cc: "james toy" <unk.nown@unix.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
In-Reply-To: <b647ffbd0808260302r1d50dbacr3595d160e0203ce3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350808251909g26207e7agdda6408c0b46a1ed@mail.gmail.com>
	 <b647ffbd0808260111r2aed706cvc4c5d483912ec8c2@mail.gmail.com>
	 <20080826012458.abe3bbba.akpm@linux-foundation.org>
	 <9f8af95f0808260225u162da49aj1d6f6fd9db79499f@mail.gmail.com>
	 <b647ffbd0808260302r1d50dbacr3595d160e0203ce3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for getting back to me on this guys.  Yes I am using mmotm, the
daily -mm broken out tree... THe bug happens while booting, and it
shows up many times. Anyway I checked microcode_intel.c and the
function in question looks like this:

static int __init microcode_intel_module_init(void)
{
       struct cpuinfo_x86 *c = &cpu_data(get_cpu());

       if (c->x86_vendor == X86_VENDOR_INTEL)
               return microcode_init(&microcode_intel_ops, THIS_MODULE);
       else
               return -ENODEV;
}

I will try the changes in he patch in Jame's post.... and report back. THanks.

-Ryan

On Tue, Aug 26, 2008 at 6:02 AM, Dmitry Adamushko
<dmitry.adamushko@gmail.com> wrote:
> 2008/8/26 james toy <unk.nown@unix.net>:
>> Andrew,
>>
>> Yes, ours does look like this -- however when i checked the git diff on git
>> web i found:
>>
>> index d2d9d74..6dd8907 100644 (file)
>> --- a/arch/x86/kernel/microcode_intel.c
>> +++ b/arch/x86/kernel/microcode_intel.c
>> @@ -531,12 +531,14 @@ static struct microcode_ops microcode_intel_ops = {
>>
>>  static int __init microcode_intel_module_init(void)
>>  {
>> -       struct cpuinfo_x86 *c = &cpu_data(get_cpu());
>> +       struct cpuinfo_x86 *c = &cpu_data(0);
>
> (err... I'm a bit confused by the use of "fixed" here. The snippet
> posted by Andrew illustrates how it was _before_ the fix,
> i.e. it's the version that causes the "scheduling while atomic" bug).
>
> IOW, If your local version has cpu_data(get_cpu()) in
> microcode_intel_module_init(), then it explains the trace you have
> observed. That also means you are not up-to-date with -next.
>
>
> --
> Best regards,
> Dmitry Adamushko
>
