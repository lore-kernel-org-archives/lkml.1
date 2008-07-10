Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYGJUQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYGJUQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 16:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbYGJUQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 16:16:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:18862 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbYGJUQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:16:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=iA6Y5BGu/3fX8ZVrfAR5p/+jhDtZy6XY0BlK+1ROnPgVs1SSCCdvHDttdmJi7DyL/t
         RgVi+MZX5k9lskQV514hmlK3LHAyIOg8VdIpTk8aOX6OGoHQmD35jj+d5jquzN4g31V2
         FQ9wZ0exV8Ud1z/8tLr9cm+CwDRpd+WMztNfk=
Message-ID: <b647ffbd0807101316o97fe6d4p5b2cbcda472f2ae1@mail.gmail.com>
Date: Thu, 10 Jul 2008 22:16:06 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: v2.6.26-rc9: kernel BUG at kernel/sched.c:5858!
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Christoph Lameter" <clameter@sgi.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>, miaox@cn.fujitsu.com,
       "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807101249y24632b50h769a7af2c9514864@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_17854_19785469.1215720966995"
References: <20080710115954.GA3639@damson.getinternet.no>
	 <19f34abd0807100512y7fff3716r3ff37305e863f26@mail.gmail.com>
	 <b647ffbd0807100550l44fae9fate511dafbf87564a4@mail.gmail.com>
	 <19f34abd0807100604p70c2fec6geca65b2ba772dea@mail.gmail.com>
	 <b647ffbd0807100703q442a9825hb857c321452027e7@mail.gmail.com>
	 <19f34abd0807100716k35e937batb4059f99fe46731b@mail.gmail.com>
	 <19f34abd0807101249y24632b50h769a7af2c9514864@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_17854_19785469.1215720966995
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/7/10 Vegard Nossum <vegard.nossum@gmail.com>:
> Okay, some more info on this one...
>
> On Thu, Jul 10, 2008 at 4:16 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> BUG: unable to handle kernel paging request at da87d000
>> IP: [<c01991c7>] kmem_cache_alloc+0xc7/0xe0
>> *pde = 28180163 *pte = 1a87d160
>> Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>> Pid: 3850, comm: grep Not tainted (2.6.26-rc9-00059-gb190333 #5)
>> EIP: 0060:[<c01991c7>] EFLAGS: 00210203 CPU: 0
>> EIP is at kmem_cache_alloc+0xc7/0xe0
>> EAX: 00000000 EBX: da87c100 ECX: 1adad71a EDX: 6b6b6b6b
>> ESI: 00200282 EDI: da87d000 EBP: f60bfe74 ESP: f60bfe54
>>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>
> The register %ecx looks innocent but is very important here. The disassembly:
>
> mov    %edx,%ecx
> shr    $0x2,%ecx
> rep stos %eax,%es:(%edi) <-- the fault
>
> So %ecx has been loaded from %edx... which is 0x6b6b6b6b/POISON_FREE.
> (0x6b6b6b6b >> 2 == 0x1adadada.)
>
> %ecx is the counter for the memset, from here:
>
>        memset(object, 0, c->objsize);
>
> i.e. %ecx was loaded from c->objsize, so "c" must have been freed.
> Where did "c" come from? Uh-oh...
>
>        c = get_cpu_slab(s, smp_processor_id());
>
> This looks like it has very much to do with CPU hotplug/unplug. Is
> there a race between SLUB/hotplug since the CPU slab is used after it
> has been freed?

Good analysis.

[ quick look ]

Yeah, it's possible that a caller of kmem_cache_alloc() ->
slab_alloc() can be migrated on another CPU right after
local_irq_restore() and before memset(). The inital cpu can become
offline in the mean time (or a migration is a consequence of the CPU
going offline) so its 'kmem_cache_cpu' structure gets freed (
slab_cpuup_callback).

At some point of time the caller continues on another CPU having an
obsolete pointer...

does something like this help?

diff --git a/mm/slub.c b/mm/slub.c
index 1a427c0..315c392 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1628,9 +1628,11 @@ static __always_inline void *slab_alloc(struct
kmem_cache *s,
        void **object;
        struct kmem_cache_cpu *c;
        unsigned long flags;
+       unsigned int objsize;

        local_irq_save(flags);
        c = get_cpu_slab(s, smp_processor_id());
+       objsize = c->objsize;
        if (unlikely(!c->freelist || !node_match(c, node)))

                object = __slab_alloc(s, gfpflags, node, addr, c);
@@ -1643,7 +1645,7 @@ static __always_inline void *slab_alloc(struct
kmem_cache *s,
        local_irq_restore(flags);

        if (unlikely((gfpflags & __GFP_ZERO) && object))
-               memset(object, 0, c->objsize);
+               memset(object, 0, objsize);

        return object;
 }


>
>
> Vegard
>
> --
> "The animistic metaphor of the bug that maliciously sneaked in while
> the programmer was not looking is intellectually dishonest as it
> disguises that the error is the programmer's own creation."
>        -- E. W. Dijkstra, EWD1036
>



-- 
Best regards,
Dmitry Adamushko

------=_Part_17854_19785469.1215720966995
Content-Type: text/x-diff; name=002-fix-slub-hotplug.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fihslkhf0
Content-Disposition: attachment; filename=002-fix-slub-hotplug.patch

ZGlmZiAtLWdpdCBhL21tL3NsdWIuYyBiL21tL3NsdWIuYwppbmRleCAxYTQyN2MwLi4zMTVjMzky
IDEwMDY0NAotLS0gYS9tbS9zbHViLmMKKysrIGIvbW0vc2x1Yi5jCkBAIC0xNjI4LDkgKzE2Mjgs
MTEgQEAgc3RhdGljIF9fYWx3YXlzX2lubGluZSB2b2lkICpzbGFiX2FsbG9jKHN0cnVjdCBrbWVt
X2NhY2hlICpzLAogCXZvaWQgKipvYmplY3Q7CiAJc3RydWN0IGttZW1fY2FjaGVfY3B1ICpjOwog
CXVuc2lnbmVkIGxvbmcgZmxhZ3M7CisJdW5zaWduZWQgaW50IG9ianNpemU7CiAKIAlsb2NhbF9p
cnFfc2F2ZShmbGFncyk7CiAJYyA9IGdldF9jcHVfc2xhYihzLCBzbXBfcHJvY2Vzc29yX2lkKCkp
OworCW9ianNpemUgPSBjLT5vYmpzaXplOwogCWlmICh1bmxpa2VseSghYy0+ZnJlZWxpc3QgfHwg
IW5vZGVfbWF0Y2goYywgbm9kZSkpKQogCiAJCW9iamVjdCA9IF9fc2xhYl9hbGxvYyhzLCBnZnBm
bGFncywgbm9kZSwgYWRkciwgYyk7CkBAIC0xNjQzLDcgKzE2NDUsNyBAQCBzdGF0aWMgX19hbHdh
eXNfaW5saW5lIHZvaWQgKnNsYWJfYWxsb2Moc3RydWN0IGttZW1fY2FjaGUgKnMsCiAJbG9jYWxf
aXJxX3Jlc3RvcmUoZmxhZ3MpOwogCiAJaWYgKHVubGlrZWx5KChnZnBmbGFncyAmIF9fR0ZQX1pF
Uk8pICYmIG9iamVjdCkpCi0JCW1lbXNldChvYmplY3QsIDAsIGMtPm9ianNpemUpOworCQltZW1z
ZXQob2JqZWN0LCAwLCBvYmpzaXplKTsKIAogCXJldHVybiBvYmplY3Q7CiB9Cg==
------=_Part_17854_19785469.1215720966995--
