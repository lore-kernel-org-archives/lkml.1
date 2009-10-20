Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbZJTOnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbZJTOnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 10:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZJTOnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 10:43:13 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:46536 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbZJTOnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 10:43:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YtherSlma3bhCwZsO5vp/vdQ/H3T8cZCd7ppeJcGNf6ASi+5bnoyrXCElqGcXYyGdF
         EbmowA9/R+M7phfyzeEoig+WhJnrWHl2PxYhffZUwcRwAvokVX80kvqSBZiQ6UjbnHW6
         AWsTmyx4AsxgcdJGOE7ShwC4234JDlIIptFHw=
MIME-Version: 1.0
In-Reply-To: <20091020135835.GB2462@hack>
References: <4AC1E15502000078000516B5@vpn.id2.novell.com>
	 <200910201142.34006.rusty@rustcorp.com.au>
	 <1256002193.6546.2.camel@slab>
	 <200910201415.34361.rusty@rustcorp.com.au>
	 <20091020135835.GB2462@hack>
Date: Tue, 20 Oct 2009 15:43:13 +0100
Message-ID: <9b2b86520910200743h4e134cf8jd2860d42b3936597@mail.gmail.com>
Subject: Re: [PATCH] BUILD_BUG_ON: make it handle more cases
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Hollis Blanchard <hollisb@us.ibm.com>,
       Jan Beulich <JBeulich@novell.com>, sfr@canb.auug.org.au,
       akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
       kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/09, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Tue, Oct 20, 2009 at 02:15:33PM +1030, Rusty Russell wrote:
>>BUILD_BUG_ON used to use the optimizer to do code elimination or fail
>>at link time; it was changed to first the size of a negative array (a
>>nicer compile time error), then (in
>>8c87df457cb58fe75b9b893007917cf8095660a0) to a bitfield.
>>
>>bitfields: needs a literal constant at parse time, and can't be put under
>>	"if (__builtin_constant_p(x))" for example.
>>negative array: can handle anything, but if the compiler can't tell it's
>>	a constant, silently has no effect.
>>link time: breaks link if the compiler can't determine the value, but the
>>	linker output is not usually as informative as a compiler error.
>>
>>If we use the negative-array-size method *and* the link time trick,
>>we get the ability to use BUILD_BUG_ON() under __builtin_constant_p()
>>branches, and maximal ability for the compiler to detect errors at
>>build time.
>>
>>Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>>
>>diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>>--- a/include/linux/kernel.h
>>+++ b/include/linux/kernel.h
>>@@ -683,12 +683,6 @@ struct sysinfo {
>> 	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
>> };
>>
>>-/* Force a compilation error if condition is true */
>>-#define BUILD_BUG_ON(condition) ((void)BUILD_BUG_ON_ZERO(condition))
>>-
>>-/* Force a compilation error if condition is constant and true */
>>-#define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
>>-
>> /* Force a compilation error if condition is true, but also produce a
>>    result (of value 0 and type size_t), so the expression can be used
>>    e.g. in a structure initializer (or where-ever else comma expressions
>>@@ -696,6 +690,33 @@ struct sysinfo {
>> #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
>> #define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
>>
>>+/**
>>+ * BUILD_BUG_ON - break compile if a condition is true.
>>+ * @cond: the condition which the compiler should know is false.
>>+ *
>>+ * If you have some code which relies on certain constants being equal, or
>>+ * other compile-time-evaluated condition, you should use BUILD_BUG_ON to
>>+ * detect if someone changes it.
>>+ *
>>+ * The implementation uses gcc's reluctance to create a negative array,
>> but
>>+ * gcc (as of 4.4) only emits that error for obvious cases (eg. not
>> arguments
>>+ * to inline functions).  So as a fallback we use the optimizer; if it
>> can't
>>+ * prove the condition is false, it will cause a link error on the
>> undefined
>>+ * "__build_bug_on_failed".  This error message can be harder to track
>> down
>>+ * though, hence the two different methods.
>>+ */
>>+#ifndef __OPTIMIZE__
>>+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
>>+#else
>>+extern int __build_bug_on_failed;
>
> Hmm, what exactly is __build_bug_on_failed?

Well, we haven't added a definition for it in this patch.  I'm sure
grep will tell you it wasn't defined before hand either.  So any
reference to it is an error - which will be reported at link time.

>>+#define BUILD_BUG_ON(condition)					\
>>+	do {							\
>>+		((void)sizeof(char[1 - 2*!!(condition)]));	\
>>+		if (condition) __build_bug_on_failed = 1;	\

If "condition" is known false at compile time, gcc -O will eliminate
the code which refers to __build_bug_on_failed.  If it's not proved to
be false - it will break the build, which is exactly what we want
BUILD_BUG_ON to do.

>>+	} while(0)
>>+#endif
>>+#define MAYBE_BUILD_BUG_ON(condition) BUILD_BUG_ON(condition)
>>+
>> /* Trap pasters of __FUNCTION__ at compile-time */
>> #define __FUNCTION__ (__func__)
>>
