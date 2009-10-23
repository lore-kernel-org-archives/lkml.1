Return-Path: <linux-kernel-owner+w=401wt.eu-S1751400AbZJWBuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbZJWBuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 21:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbZJWBuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 21:50:03 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:35970 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZJWBuA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 21:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OkApIVfhEWGG9YRJA5cuvdxbLwwUEd1XUBoUqyDuDDH5aFxwt54GuCnQUGb48h2tEl
         Jy6yCIKDhzo09aDeb+C2XNLTYKfryMjH89TBOTzDviNYwCCPyhyR8/zJYOsuKHd8JaET
         0y6T5UDxskZSFGC10q6M3dkJFrMv04g5UvWoA=
MIME-Version: 1.0
In-Reply-To: <9b2b86520910200743h4e134cf8jd2860d42b3936597@mail.gmail.com>
References: <4AC1E15502000078000516B5@vpn.id2.novell.com>
	 <200910201142.34006.rusty@rustcorp.com.au>
	 <1256002193.6546.2.camel@slab>
	 <200910201415.34361.rusty@rustcorp.com.au>
	 <20091020135835.GB2462@hack>
	 <9b2b86520910200743h4e134cf8jd2860d42b3936597@mail.gmail.com>
Date: Fri, 23 Oct 2009 09:50:05 +0800
Message-ID: <2375c9f90910221850r584e16a9k924aa2e0861bd358@mail.gmail.com>
Subject: Re: [PATCH] BUILD_BUG_ON: make it handle more cases
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Hollis Blanchard <hollisb@us.ibm.com>,
       Jan Beulich <JBeulich@novell.com>, sfr@canb.auug.org.au,
       akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
       kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 10:43 PM, Alan Jenkins
<sourcejedi.lkml@googlemail.com> wrote:
> On 10/20/09, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> On Tue, Oct 20, 2009 at 02:15:33PM +1030, Rusty Russell wrote:
>>>BUILD_BUG_ON used to use the optimizer to do code elimination or fail
>>>at link time; it was changed to first the size of a negative array (a
>>>nicer compile time error), then (in
>>>8c87df457cb58fe75b9b893007917cf8095660a0) to a bitfield.
>>>
>>>bitfields: needs a literal constant at parse time, and can't be put under
>>>      "if (__builtin_constant_p(x))" for example.
>>>negative array: can handle anything, but if the compiler can't tell it's
>>>      a constant, silently has no effect.
>>>link time: breaks link if the compiler can't determine the value, but the
>>>      linker output is not usually as informative as a compiler error.
>>>
>>>If we use the negative-array-size method *and* the link time trick,
>>>we get the ability to use BUILD_BUG_ON() under __builtin_constant_p()
>>>branches, and maximal ability for the compiler to detect errors at
>>>build time.
>>>
>>>Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>>>
>>>diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>>>--- a/include/linux/kernel.h
>>>+++ b/include/linux/kernel.h
>>>@@ -683,12 +683,6 @@ struct sysinfo {
>>>      char _f[20-2*sizeof(long)-sizeof(int)]; /* Padding: libc5 uses this.. */
>>> };
>>>
>>>-/* Force a compilation error if condition is true */
>>>-#define BUILD_BUG_ON(condition) ((void)BUILD_BUG_ON_ZERO(condition))
>>>-
>>>-/* Force a compilation error if condition is constant and true */
>>>-#define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
>>>-
>>> /* Force a compilation error if condition is true, but also produce a
>>>    result (of value 0 and type size_t), so the expression can be used
>>>    e.g. in a structure initializer (or where-ever else comma expressions
>>>@@ -696,6 +690,33 @@ struct sysinfo {
>>> #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
>>> #define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
>>>
>>>+/**
>>>+ * BUILD_BUG_ON - break compile if a condition is true.
>>>+ * @cond: the condition which the compiler should know is false.
>>>+ *
>>>+ * If you have some code which relies on certain constants being equal, or
>>>+ * other compile-time-evaluated condition, you should use BUILD_BUG_ON to
>>>+ * detect if someone changes it.
>>>+ *
>>>+ * The implementation uses gcc's reluctance to create a negative array,
>>> but
>>>+ * gcc (as of 4.4) only emits that error for obvious cases (eg. not
>>> arguments
>>>+ * to inline functions).  So as a fallback we use the optimizer; if it
>>> can't
>>>+ * prove the condition is false, it will cause a link error on the
>>> undefined
>>>+ * "__build_bug_on_failed".  This error message can be harder to track
>>> down
>>>+ * though, hence the two different methods.
>>>+ */
>>>+#ifndef __OPTIMIZE__
>>>+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
>>>+#else
>>>+extern int __build_bug_on_failed;
>>
>> Hmm, what exactly is __build_bug_on_failed?
>
> Well, we haven't added a definition for it in this patch.  I'm sure
> grep will tell you it wasn't defined before hand either.  So any
> reference to it is an error - which will be reported at link time.
>
>>>+#define BUILD_BUG_ON(condition)                                      \
>>>+     do {                                                    \
>>>+             ((void)sizeof(char[1 - 2*!!(condition)]));      \
>>>+             if (condition) __build_bug_on_failed = 1;       \
>
> If "condition" is known false at compile time, gcc -O will eliminate
> the code which refers to __build_bug_on_failed.  If it's not proved to
> be false - it will break the build, which is exactly what we want
> BUILD_BUG_ON to do.

Ah, clever trick! Got it.
Thanks!

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
