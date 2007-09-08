Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbXIHHf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbXIHHf2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 03:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXIHHfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 03:35:20 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:5104 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbXIHHfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 03:35:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=Ff92m03rIqUoLJoR+5tXoe/4ZS5ZG3EGikJ3beIbctwL3v5rQ6Uoc5qe8d5NFxo5MbKzkmyj+vG5L8n2SsrvCzQfHQgBsAJhh+E/EwZmFmxwTGDNdRcURr1Gx1d7gAQs74ghIcYa4qsllzMQB5FQTkdGL/vevZ4C9x9WJAFVQ7U=
Message-ID: <a781481a0709080035h3df2c664x6586ca09c727a096@mail.gmail.com>
Date: Sat, 8 Sep 2007 13:05:18 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc4-mm1 build issue: ia64 link error
Cc: "Luck, Tony" <tony.luck@intel.com>, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070907040104.fad5fc70.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_5818_24001923.1189236918174"
References: <20070906183546.GA1449@Krystal>
	 <617E1C2C70743745A92448908E030B2A025B103D@scsmsx411.amr.corp.intel.com>
	 <20070907040104.fad5fc70.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_5818_24001923.1189236918174
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 9/7/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Fri, 7 Sep 2007 00:34:59 -0700 "Luck, Tony" <tony.luck@intel.com> wrote:
> > > local symbol 0: discarded in section `.exit.text' from arch/ia64/kernel/built-in.o
> >
> > This usually means that there is a static __exit function (or __devexit etc.)
> > somewhere in the object being linked.  The error message is pretty unhelpful
> > in figuring out *where* in the module.  Look at the 'mm' patches that touch
> > arch/ia64/kernel to see if one of them tinkers with __exit* attributes.
>
> Confused.  There are >2500 static __exit functions in the tree, including
> ones like
>
> arch/ia64/kernel/esi.c:static void __exit esi_exit (void)

That message means the linker found someone referencing an .exit.text
function -- on other archs this would've been a section mismatch but on
ia64 its a link error due to reasons below (although it would not have ever
caused an oops).

The message /is/ quite helpful actually -- you just need to objdump the
mentioned object file (arch/ia64/kernel/built-in.o) and see all functions
present in .exit.text (which turns out to be only four). Then cscope them
in the kernel tree and see which (if any) are referenced from non-__exit
code ...

> Could we have some more details on what you think has gone wrong here?

... and it turns out my ia64-tree-wide-misc-__cpuinitdata-init-exit.patch is
to blame here.

I just confirmed from arch/ia64/kernel/vmlinux.ld.S, that ia64 discards .exit.*
sections at link time itself -- unlike other archs such as x86 that drop it at
boot (after initcalls) time instead. And hence the "function that is referenced
only from __cpuinit or __exit can be marked __cpuexit" rule does not hold
true for ia64, sadly.

Now that patch made remove_palinfo_proc_entries() a __cpuexit function,
with the reasoning that it was only referenced from the __cpuinit notifier
callback and the general __exit function of that module. But the following
combination:

1. HOTPLUG_CPU=n in Mathieu's .config, and,
2. ia64's build-time .exit.* discarding, and,
3. an old toolchain (gcc-3.4.5) -- therefore ensuring that the notifier callback
   wasn't elided from arch/ia64/kernel/built-in.o although nobody references it

ensured that the .init.text-resident palinfo_cpu_callback() referenced the
.exit.text-resident remove_palinfo_proc_entries(), thereby causing link error.

So this is the second goof-up in that "misc cpuinit/exit annotations" series
of mine, apologies. I've installed the ia64 cross-compile toolchain now, so
hopefully should be able to avoid such in future ...

Patch attached (have gmail access only for next few days).


Satyam

------=_Part_5818_24001923.1189236918174
Content-Type: text/x-diff;
 name="ia64-tree-wide-misc-__cpuinitdata-init-exit-fix.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ia64-tree-wide-misc-__cpuinitdata-init-exit-fix.patch"
X-Attachment-Id: f_f6bt4hbz

U2lnbmVkLW9mZi1ieTogU2F0eWFtIFNoYXJtYSA8c2F0eWFtQGluZnJhZGVhZC5vcmc+CgotLS0K
CiBhcmNoL2lhNjQva2VybmVsL3BhbGluZm8uYyB8ICAgIDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKLS0tIGxpbnV4LTIuNi4yMy1yYzQtbW0xL2Fy
Y2gvaWE2NC9rZXJuZWwvcGFsaW5mby5jfmZpeAkyMDA3LTA5LTA4IDEyOjU0OjEyLjAwMDAwMDAw
MCArMDUzMAorKysgbGludXgtMi42LjIzLXJjNC1tbTEvYXJjaC9pYTY0L2tlcm5lbC9wYWxpbmZv
LmMJMjAwNy0wOS0wOCAxMjo1NDo0NS4wMDAwMDAwMDAgKzA1MzAKQEAgLTk0Nyw3ICs5NDcsNyBA
QCBjcmVhdGVfcGFsaW5mb19wcm9jX2VudHJpZXModW5zaWduZWQgaW50CiAJfQogfQogCi1zdGF0
aWMgdm9pZCBfX2NwdWV4aXQKK3N0YXRpYyB2b2lkCiByZW1vdmVfcGFsaW5mb19wcm9jX2VudHJp
ZXModW5zaWduZWQgaW50IGhjcHUpCiB7CiAJaW50IGo7Cg==
------=_Part_5818_24001923.1189236918174--
