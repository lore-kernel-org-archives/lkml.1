Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbZCYGrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbZCYGrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 02:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbZCYGrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 02:47:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205AbZCYGrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 02:47:01 -0400
From: Nikanth Karthikesan <knikanth@novell.com>
Organization: Novell
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Strange code in include/linux/cpumask.h
Date: Wed, 25 Mar 2009 12:14:30 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.19-3.2-default; KDE/4.1.3; x86_64; ; )
Cc: nikanth@gmail.com, linux-kernel@vger.kernel.org
References: <200903251021.13811.knikanth@novell.com> <200903251541.12180.rusty@rustcorp.com.au>
In-Reply-To: <200903251541.12180.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903251214.31731.knikanth@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 March 2009 10:41:11 Rusty Russell wrote:
> On Wednesday 25 March 2009 15:21:13 Nikanth Karthikesan wrote:
> > Hi Rusty
> >
> > I do not understand this code.
>
> Hi Nikanth,
>
>    That's OK, it's a little tricky.
>
> > The conditional operator would always evaluates to true and return
> > bitmap. So all it seems to does is
> > #define to_cpumansk(bitmap) (struct cpumask *)(bitmap)
>
> Yes, except that this insists that bitmap be an unsigned long * or you'll
> get a warning.  Otherwise the macro could be used on anything.  And it
> needs to be a macro to use it as a static initializer.
>

Ah, got it. Thanks a lot for the explanation. May be a comment could be added 
to the source.

So if only type-checking is required, something like this should work.

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 9f31538..7857f8f 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -282,11 +282,11 @@ static inline void __cpus_shift_left(cpumask_t *dstp,
  */
 #define to_cpumask(bitmap)						\
 	((struct cpumask *)(1 ? (bitmap)				\
-			    : (void *)sizeof(__check_is_bitmap(bitmap))))
+			    : __check_is_bitmap(bitmap)))
 
-static inline int __check_is_bitmap(const unsigned long *bitmap)
+static inline void * __check_is_bitmap(const unsigned long *bitmap)
 {
-	return 1;
+	return 0;
 }
 
 /*

And for static initialization + type checking, will this work?

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 9f31538..d86b8d0 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -282,11 +282,11 @@ static inline void __cpus_shift_left(cpumask_t *dstp,
  */
 #define to_cpumask(bitmap)						\
 	((struct cpumask *)(1 ? (bitmap)				\
-			    : (void *)sizeof(__check_is_bitmap(bitmap))))
+			    :( __check_is_bitmap(bitmap),(void *)0)))
 
-static inline int __check_is_bitmap(const unsigned long *bitmap)
+static inline void * __check_is_bitmap(const unsigned long *bitmap)
 {
-	return 1;
+	return 0;
 }
 
 /*

>
> As the NR_CPUS bit arrays vanish, this macro will be used less and less;
> but some of them will probably take a while.
>

Also looks like, this is not being used as a static initializer anywhere. 
 i.e., Using my type-checking only version didn't trigger any error/warnings! 
Being a deprecated interface, no new users are expected? Or is gcc smart, not 
complaining when used as static initializer, as it would always evaluate to 
(struct cpumask *)(bitmap)? Can the sizeof constification be removed?

Thanks
Nikanth
