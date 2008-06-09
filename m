Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbYFIINx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbYFIINx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 04:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755476AbYFIINp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 04:13:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:63015 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbYFIINo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 04:13:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VpH76PKCNvhsYvBqKV2wONyD+S3mghhrWm3+YnbQWTqP1pZj8sYBfatyH4ibhW1MnU
         ptqNKtJHlW+EplTG1/V/xtKSHr99sGl+o4v2+96Ygbi6mIijAB3ksM1ohbGRzBUdd2gl
         6FoUjR4bsBLd5USfWjRUVch/q/LD7wdGKgwbE=
Message-ID: <10a58eee0806090113j643e058bm1da6c8a5bfbc1701@mail.gmail.com>
Date: Mon, 9 Jun 2008 10:13:43 +0200
From: "Uli Brueggemann" <uli.brueggemann@gmail.com>
To: "Tarkan Erimer" <tarkan@netone.net.tr>
Subject: Re: 2.6.25.4-rt6
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <484CDDEC.7050405@netone.net.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212793171.7695.2.camel@localhost.localdomain>
	 <484CDDEC.7050405@netone.net.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2008 at 9:38 AM, Tarkan Erimer <tarkan@netone.net.tr> wrote:
>
> I got this error message at compile stage. Also it is the same error that was on -rt4. -rt3 compiles and runs fine.
>
>
> VDSOSYM arch/x86/vdso/vdso32-syms.lds
> LD arch/x86/vdso/built-in.o
> CC kernel/sched.o
> kernel/sched.c: In function 'sched_init':
> kernel/sched.c:7702: error: implicit declaration of function 'global_rt_runtime'
> make[2]: *** [kernel/sched.o] Error 1
> make[1]: *** [kernel] Error 2
> make[1]: Leaving directory `/usr/src/linux-2.6.25.4'
> make: *** [debian/stamp-build-kernel] Error 2
> root@tarkane:/usr/src/linux-2.6.25.4#
>



I got the same message but following previously sent patch works for me:

-------- Original Message --------

Subject: about 2.6.25.4-rt5 (missing global_rt_runtime)
Date: Thu, 05 Jun 2008 12:18:49 +0000
From: ciaby <ciaby@autistici.org>
To: rostedt@goodmis.org

Small patch to make it compile (missing global_rt_runtime function):

diff -uNr linux-2.6.25.4.orig/kernel
/sched.c linux-2.6.25.4/kernel/sched.c

--- linux-2.6.25.4.orig/kernel/sched.c  2008-06-05 14:12:30.000000000 +0200
+++ linux-2.6.25.4/kernel/sched.c       2008-06-05 13:58:48.000000000 +0200

@@ -671,6 +671,15 @@

 */
  #define RUNTIME_INF    ((u64)~0ULL)

+static u64 global_rt_runtime(void)
+{
+       if (sysctl_sched_rt_period < 0)
+               return RUNTIME_INF;
+       return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
+}
+
+
+
/*
 * We really dont want to do anything complex within switch_to()
 * on PREEMPT_RT - this check enforces this.
