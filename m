Return-Path: <linux-kernel-owner+w=401wt.eu-S1760812AbXIUPwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812AbXIUPwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 11:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbXIUPwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 11:52:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:33407 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbXIUPwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 11:52:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=B+2Fm9HMLp04YzcBVlfHxMmbmaFY6WVvoHe9GYRNJlSVvr+wjTLLoy0BxjXu19xzilxPC3/CwlqSRdsKDpWzKTS+DZJSvcNeboaIaeg1TYFYkRudsKNpLCjH5fm18SrBUeoSRYF3P3rWga7/0XXCupCmsG5GoLu/XgmNVc7POBw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 7/8] Immediate Values - Documentation
Date: Fri, 21 Sep 2007 16:51:51 +0100
User-Agent: KMail/1.9.1
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070827155910.336723755@polymtl.ca> <200709201146.57334.vda.linux@googlemail.com> <20070921133103.GA14844@Krystal>
In-Reply-To: <20070921133103.GA14844@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211651.51851.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 September 2007 14:31, Mathieu Desnoyers wrote:
> > Immediates make code bigger, right?
> 
> Nope.
> 
> Example:
> 
> char x;
> 
> void testb(void)
> {
>         if (x > 5)
>                 testa();
> }
> 
> Would turn into:
>   56:   b0 00                   mov    $0x0,%al
>   58:   3c 05                   cmp    $0x5,%al
>   5a:   7e 05                   jle    61 <testb+0x11>
> 
> (6 bytes)
> 
> Rather than:
> 
>   56:   80 3d 00 00 00 00 05    cmpb   $0x5,0x0
>   5d:   7e 05                   jle    64 <testb+0x14>
> 
> (9 bytes)

For 32-bit value, you won't be so lucky.

> So actually, immediate values well used make the code smaller. By the
> way, I recommend using the smallest immediate values required, which
> will often be a single byte.

I agree on this wholeheartedy. However, current kernel mostly uses int
even for yes/no style flags.

> > getppid is one of the lightest syscalls out there.
> > What kind of speedup do you see on a real-world test
> > (two processes exchaging data through pipes, for example)?
> > 
> 
> With the size of the caches we currently have, that kind of workload
> will not show any measurable difference: the signal/noise ratio is way
> to small to detect that kind of performance difference under such
> workload. Try it if you want.

Exactly my point: this speedup is not measurable on realistic workload.

> The real-world speedup I am interested into is to have almost -zero-
> tracer impact, which imples being undetectable even in the smallest and
> shortest functions. I guess nobody is interested in adding a measurable
> performance hit to kmalloc fast path, right?
> 
> > > +Therefore, not only is it interesting to use the immediate values to dynamically
> > > +activate dormant code such as the markers, but I think it should also be
> > > +considered as a replacement for many of the "read mostly" static variables.
> > 
> > What effect that will have on "size vmlinux" on AMD64?
> 
> Without considering kernel/immediate.o, it will make the code smaller
> and add 3*8bytes=24bytes of data in the __immediate section per
> immediate value reference (data only used for updates).

Yes. *Per immediate value reference*.

Therefore I don't think it's wise to recommend to use __immediate
for any variables which are referenced many times. "Many" defined as
"more than ten".

IOW: I think that this last paragraph shouldn't be there:

On Tuesday 18 September 2007 22:07, Mathieu Desnoyers wrote:
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  Documentation/immediate.txt |  228 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 228 insertions(+)
>...
> +Therefore, not only is it interesting to use the immediate values to dynamically
> +activate dormant code such as the markers, but I think it should also be
> +considered as a replacement for many of the "read-mostly" static variables.


A few crazy ideas how you can make it slightly less painful for 64-bit arch:

* Pack last long ('size') into low bits of other fields.
  (I expect link stage problems, tho)


* Make last field uint8_t and pack whole struct into 17 bytes (__attribute__((packed)))
  instead of 24 bytes.
  Expect align-happy folks faint left and right at such horrendous crime :) but
  other than that, it will work. Updates of immediates will *maybe* get a tiny bit slower
  (which is unimportant anyway).

  [btw, this can be done for i386 too]


* Turn long's into int32_t, since kernel's text addresses (at least on AMD64)
  fit into int32_t (sign-extend will give you correct 64-bit address):

  ffffffff80200000 A _text
  ffffffff80200000 T startup_64
  ffffffff802000b7 t ident_complete
  ffffffff80200110 T secondary_startup_64
  ffffffff802001a8 T initial_code
  ffffffff802001b0 T init_rsp
  ffffffff802001b8 t bad_address
  ffffffff802001c0 T early_idt_handler

  [I hope there is suitable reloc type for AMD64 and ld won't complain]
--
vda
