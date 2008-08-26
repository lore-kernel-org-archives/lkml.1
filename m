Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbYHZJaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbYHZJaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 05:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbYHZJ3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 05:29:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:25466 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbYHZJ3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 05:29:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=mcVms9OdFIKQHtQQ/5jIjGA25Ixex8LUq8iCTX1D7+4m9ZVxr0RXfQxrnb7z3UeWhg
         SMK6riR7CjAnXCXnqlzPlTQEror7jgDhzaHt1HktZhNpIouk63G1JmFHm41a88euYqwR
         HZffRkTVuqu9rFQWL/KkLu6lNvA5RNL7nJ00o=
Message-ID: <9f8af95f0808260229p2fa3cdddy1aa713e0610a9710@mail.gmail.com>
Date: Tue, 26 Aug 2008 05:29:51 -0400
From: "james toy" <unk.nown@unix.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [-mmotm] BUG: scheduling while atomic: swapper
In-Reply-To: <9f8af95f0808260225u162da49aj1d6f6fd9db79499f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350808251909g26207e7agdda6408c0b46a1ed@mail.gmail.com>
	 <b647ffbd0808260111r2aed706cvc4c5d483912ec8c2@mail.gmail.com>
	 <20080826012458.abe3bbba.akpm@linux-foundation.org>
	 <9f8af95f0808260225u162da49aj1d6f6fd9db79499f@mail.gmail.com>
X-Google-Sender-Auth: d5865f1baf061a1a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Yes, ours does look like this -- however when i checked the git diff
on git web i found:

index d2d9d74..6dd8907 100644 (file)
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -531,12 +531,14 @@ static struct microcode_ops microcode_intel_ops = {

 static int __init microcode_intel_module_init(void)
 {
-       struct cpuinfo_x86 *c = &cpu_data(get_cpu());
+       struct cpuinfo_x86 *c = &cpu_data(0);

-       if (c->x86_vendor == X86_VENDOR_INTEL)
-               return microcode_init(&microcode_intel_ops, THIS_MODULE);
-       else
+       if (c->x86_vendor != X86_VENDOR_INTEL) {
+                printk(KERN_ERR "microcode: CPU platform is not
Intel-capable\n");
                return -ENODEV;
+       }
+
+       return microcode_init(&microcode_intel_ops, THIS_MODULE);
 }

 static void __exit microcode_intel_module_exit(void)

am I missing something?  It seems that the code you requested to be
checked is being nixed in the diff (i could be wrong it is 0500 EST
here)

again to confirm -- we have what you initially posted if that _is_ the
fixed version.

respectfully,

/jT


On Tue, Aug 26, 2008 at 4:24 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Tue, 26 Aug 2008 10:11:24 +0200 "Dmitry Adamushko" <dmitry.adamushko@gmail.com> wrote:
>
> > 2008/8/26 Ryan Hope <rmh3093@gmail.com>:
> > > BUG: scheduling while atomic: swapper/1/0x00000002
> > > Modules linked in:
> > > Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc4-zenmmotm1 #4
> > >  [<c057a0c7>] schedule+0x287/0x6d0
> > >  [<c03672e6>] vsnprintf+0x3a6/0x6c0
> > >  [<c057a92d>] schedule_timeout+0x7d/0xb0
> > >  [<c021e0c8>] __wake_up+0x38/0x50
> > >  [<c057a74a>] wait_for_common+0x8a/0x130
> > >  [<c0220ab0>] default_wake_function+0x0/0x10
> > >  [<c0237743>] call_usermodehelper_exec+0xc3/0xf0
> > >  [<c0362ede>] kobject_uevent_env+0x37e/0x3a0
> > >  [<c03d5921>] device_add+0x551/0x630
> > >  [<c03d5ac3>] device_create_vargs+0xb3/0xd0
> > >  [<c06ccc47>] microcode_intel_module_init+0x0/0x39
> >
> > It doesn't look like Linus's tree... there is no
> > microcode_intel_module_init() in .27+. So what is it?
>
> mmotm is linux-next plus -mm stuff
>
> > Anyway, your trace might be explained by a bug that has been already
> > fixed in Ingo's -tip.
> >
> > Here is the commit:
> > http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commit;h=8343ef2437c599d30568e6b5a257a40bf2f4902b
>
> Yes, an unbalanced get_cpu() would explain it.
>
> However that patch is already in current -mm.  Ryan, can you please
> check to see if it's in the version you tested?  The "fixed" version
> looks like this:
>
> static int __init microcode_intel_module_init(void)
> {
>        struct cpuinfo_x86 *c = &cpu_data(get_cpu());
>
>        if (c->x86_vendor == X86_VENDOR_INTEL)
>                return microcode_init(&microcode_intel_ops, THIS_MODULE);
>        else
>                return -ENODEV;
> }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
