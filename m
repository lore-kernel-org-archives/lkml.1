Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbYGUVbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbYGUVbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 17:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbYGUVbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 17:31:18 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:42603 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbYGUVbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 17:31:17 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] filldir write data missing size
References: <87k5fi4l49.wl%ysato@users.sourceforge.jp>
	<871w1pn5wz.fsf@devron.myhome.or.jp>
	<87iqv1wwy1.wl%ysato@users.sourceforge.jp>
	<87r69pk51q.fsf@devron.myhome.or.jp>
	<87abgbgrvt.wl%ysato@users.sourceforge.jp>
Date: Tue, 22 Jul 2008 06:31:12 +0900
In-Reply-To: <87abgbgrvt.wl%ysato@users.sourceforge.jp> (Yoshinori Sato's
	message of "Mon, 21 Jul 2008 11:48:38 -0400")
Message-ID: <878wvu9b6n.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yoshinori Sato <ysato@users.sourceforge.jp> writes:

> This problem is sh-linux-gcc v4.1.2 and target sh2(a)-bigendian.
>
> "__put_user(s64, u32_ptr)" compiled.
>
> Correct code.
> *u32_ptr = s64 & 0xffffffff;
>
> Bad code.
> *u32_ptr = s64 >> 32;
>
> I'm add cast put_user 4byte case.

I see. How about the following patch? I guess the problems of this type
should be fixed.

diff -puN include/asm-sh/uaccess_32.h~sh-fix include/asm-sh/uaccess_32.h
--- linux-2.6/include/asm-sh/uaccess_32.h~sh-fix	2008-07-22 06:20:15.000000000 +0900
+++ linux-2.6-hirofumi/include/asm-sh/uaccess_32.h	2008-07-22 06:25:26.000000000 +0900
@@ -211,8 +211,9 @@ do {							\
 ({								\
 	long __pu_err;						\
 	__typeof__(*(ptr)) __user *__pu_addr = (ptr);		\
+	__typeof__(*(ptr)) __pu_val = x;			\
 	__chk_user_ptr(ptr);					\
-	__put_user_size((x), __pu_addr, (size), __pu_err);	\
+	__put_user_size(__pu_val, __pu_addr, (size), __pu_err);	\
 	__pu_err;						\
 })
 
@@ -220,8 +221,9 @@ do {							\
 ({								\
 	long __pu_err = -EFAULT;				\
 	__typeof__(*(ptr)) __user *__pu_addr = (ptr);		\
+	__typeof__(*(ptr)) __pu_val = x;			\
 	if (likely(access_ok(VERIFY_WRITE, __pu_addr, size)))	\
-		__put_user_size((x), __pu_addr, (size),		\
+		__put_user_size(__pu_val, __pu_addr, (size),	\
 				__pu_err);			\
 	__pu_err;						\
 })
_
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
