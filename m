Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbYJPGai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbYJPGai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYJPGaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:30:30 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:6701 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbYJPGa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:30:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=wBQAJbDd2qfKzTvBaXHLoGp55+rSMe0dLbgxhg/g2xr0q9+dNbn/Vu9P58S3L5+Z+a
         XVk47qxx13mpx5T8uIXLPbaw9AoxFfQz/E7Fdz8aXWSl01eUPxzVP0PN5EIoDISgETrU
         ERbmBk0gweMYmA66B9o+cmOHx3b7b8NNjJYVU=
Message-ID: <df9815e70810152330h7886c77arb01e1fd308b4a7ae@mail.gmail.com>
Date: Thu, 16 Oct 2008 14:30:25 +0800
From: "Jike Song" <albcamus@gmail.com>
To: gcosta@redhat.com
Subject: questions about rd{msr|tsc|pmc} instruction with x86-64
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi experts,

commit c210d24986dc19e387c10508c0bc2faadadc1a2e  introduced such codes
and comments in include/asm-x86/msr.h:

/*
 * i386 calling convention returns 64-bit value in edx:eax, while
 * x86_64 returns at rax. Also, the "A" constraint does not really
 * mean rdx:rax in x86_64, so we need specialized behaviour for each
 * architecture
 */
#ifdef CONFIG_X86_64
#define DECLARE_ARGS(val, low, high)	unsigned low, high
#define EAX_EDX_VAL(val, low, high)	((low) | ((u64)(high) << 32))
#define EAX_EDX_ARGS(val, low, high)	"a" (low), "d" (high)
#define EAX_EDX_RET(val, low, high)	"=a" (low), "=d" (high)
#else
#define DECLARE_ARGS(val, low, high)	unsigned long long val
#define EAX_EDX_VAL(val, low, high)	(val)
#define EAX_EDX_ARGS(val, low, high)	"A" (val)
#define EAX_EDX_RET(val, low, high)	"=A" (val)
#endif

By my reading of Intel & AMD manuals, this comment is wrong.  rdmsr of
x86-64 has the same behavior as i386, namely the high 32bit returns in
edx and the low 32bit in eax, not "returns at rax".  And the gcc
constraint "A" does mean edx:eax in x86-64 also, at least when testing
on my AMD Turion 64 processor.

So the question is, do we really need these macros? Why a single "A"
won't work?  Or do I have anything misunderstood?

-- 
Thanks,
Jike
