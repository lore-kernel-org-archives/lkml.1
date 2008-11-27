Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYK0Nue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYK0Nue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYK0Nu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:50:26 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:19878 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbYK0NuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:50:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OpE/jcsMyEDgXPGtBjWRVaWFHbsEzY80pd/sE+9HF8IzhFXAc2r5xAfo6iubNyELY2
         JUWXjfALMgftSARt+4J4hO9THA8lDwWQqmdmBnNWUtzuhpXjRUExMjtT8p2DblEM+Xb/
         6fzS8LexcwvANsGnzku4CzxHXRFiHowyxjvkU=
Message-ID: <19f34abd0811270550v89dff92id40189386e8682a2@mail.gmail.com>
Date: Thu, 27 Nov 2008 14:50:24 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: 2.6.28-rc6-git1 -- BUG: unable to handle kernel paging request at ffff8800be8b0019
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Miles Lane" <miles.lane@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Tejun Heo" <htejun@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Hugh Dickins" <hugh@veritas.com>
In-Reply-To: <84144f020811270537l3798b2f5ka63caacbee43b075@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0811250850g725a5a5nd7d93a23ffd2fce6@mail.gmail.com>
	 <200811270026.37941.rjw@sisk.pl>
	 <84144f020811270537l3798b2f5ka63caacbee43b075@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 2:37 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hi,
>
> (I'm jumping in as Andrew forwarded the bug to us thinking it's SLUB related.)
>
> On Thu, Nov 27, 2008 at 1:26 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> [ 3866.841128] RIP  [<ffffffff80262f07>] kallsyms_lookup+0x20/0x120
>>> [ 3866.841134]  RSP <ffff880073d63da8>
>>> [ 3866.841136] CR2: ffff8800be8b0019
>>> [ 3866.841140] ---[ end trace ebccc2f1a2509fb0 ]---
>>
>> Did that happen after a resume from suspend to RAM, by chance?
>
> Could be. I looked at the oops and I'm pretty sure SLUB is not at
> fault here. Decoding the oopsing code:
>
>  [ 3866.841062] Code: df e8 39 d2 ff ff 5b 41 5c c9 c3 55 48 89 e5 41 57 49 89
>  cf 41 56 49 89 f6 41 55 49 89 d5 41 54 4d 89 c4 53 48 89 fb 48 83 ec
> 08 <41> c6
>  40 7f 00 41 c6 00 00 48 81 ff 00 90 20 80 72 09 48 81 ff
>
> results in:
>
>  0000000000000000 <.text>:
>     0:   41 c6 40 7f 00          movb   $0x0,0x7f(%r8)   <<<<----
>     5:   41 c6 00 00             movb   $0x0,(%r8)
>     9:   48 81 ff 00 90 20 80    cmp    $0xffffffff80209000,%rdi
>    10:   72 09                   jb     0x1b
>    12:   48                      rex.W
>    13:   81                      .byte 0x81
>    14:   ff                      .byte 0xff
>
> which looks like this:
>
>  000000000000023e <kallsyms_lookup>:
>   */
>  const char *kallsyms_lookup(unsigned long addr,
>                              unsigned long *symbolsize,
>                              unsigned long *offset,
>                              char **modname, char *namebuf)
>  {
>   23e:   41 56                   push   %r14
>   240:   49 89 f6                mov    %rsi,%r14
>   243:   41 55                   push   %r13
>   245:   49 89 d5                mov    %rdx,%r13
>   248:   41 54                   push   %r12
>   24a:   49 89 cc                mov    %rcx,%r12
>   24d:   55                      push   %rbp
>   24e:   48 89 fd                mov    %rdi,%rbp
>   251:   53                      push   %rbx
>          namebuf[KSYM_NAME_LEN - 1] = 0;
>   252:   41 c6 40 7f 00          movb   $0x0,0x7f(%r8) <<<<----
>   */
>
> That is, we're oopsing because someone is passing a bogus 'namebuf' to
> kallsyms_lookup(). This is further confirmed by looking at the value of R8:
>
>  [ 3866.840962] RBP: ffff880073d63dd8 R08: ffff8800be8aff9a R09:
> 0000000000000000
>
> and adding 0x7f to it:
>
>  0xffff8800be8aff9a + 0x7f = 0xffff8800be8b0019
>
> which equals to the faulting address:
>
>  [ 3866.840809] BUG: unable to handle kernel paging request at ffff8800be8b0019
>
> Furthermore, the value of KSYM_NAME_LEN is 128 so the offset matches as well
> after subtracting one from it (0x7f).
>
> Looking at the call trace:
>
>  [ 3866.841017] Call Trace:
>  [ 3866.841020]  [<ffffffff8026302f>] sprint_symbol+0x28/0xaa
>  [ 3866.841025]  [<ffffffff8029e972>] list_locations+0x170/0x2ef
>  [ 3866.841031]  [<ffffffff8029eb34>] alloc_calls_show+0x1c/0x24
>  [ 3866.841036]  [<ffffffff8029cbbc>] slab_attr_show+0x23/0x27
>  [ 3866.841041]  [<ffffffff802efdff>] sysfs_read_file+0xba/0x13c
>  [ 3866.841046]  [<ffffffff802a4795>] vfs_read+0xa4/0xde
>  [ 3866.841052]  [<ffffffff802a4893>] sys_read+0x47/0x6e
>  [ 3866.841056]  [<ffffffff8020b6fb>] system_call_fastpath+0x16/0x1b
>
> we can see that kallsyms_lookup() is being called by sprint_symbol() which is,
> in turn, called by the SLUB code. However, SLUB never touches 'namebuf',
> instead it's being allocated on the stack by sprint_symbol():
>
>  /* Look up a kernel symbol and return it in a text buffer. */
>  int sprint_symbol(char *buffer, unsigned long address)
>  {
>          char *modname;
>          const char *name;
>          unsigned long offset, size;
>          char namebuf[KSYM_NAME_LEN];
>
>          name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
>
> Hmm?

Looks good, but I think you're looking at the wrong version of
sprint_symbol(). Try:

commit 966c8c12dc9e77f931e2281ba25d2f0244b06949
Author: Hugh Dickins <hugh@veritas.com>
Date:   Wed Nov 19 15:36:36 2008 -0800

    sprint_symbol(): use less stack

...

@@ -304,17 +304,24 @@ int sprint_symbol(char *buffer, unsigned long address)
        char *modname;
        const char *name;
        unsigned long offset, size;
-       char namebuf[KSYM_NAME_LEN];
+       int len;

-       name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
+       name = kallsyms_lookup(address, &size, &offset, &modname, buffer);


...so it might just be the caller's fault (depending on whether this
patch was correct or not).


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
