Return-Path: <linux-kernel-owner+w=401wt.eu-S1757684AbYFWVXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbYFWVXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 17:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbYFWVXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 17:23:11 -0400
Received: from relay2.mail.vrmd.de ([81.28.224.28]:47151 "EHLO
	relay2.mail.vrmd.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbYFWVXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 17:23:09 -0400
X-Greylist: delayed 1497 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jun 2008 17:23:09 EDT
Date: Mon, 23 Jun 2008 20:57:22 +0000
From: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: fix module load failures on smp (bug #10926)
Message-ID: <20080623205722.GA3580@ds20.borg.net>
Reply-To: dl8bcu@dl8bcu.de
Mail-Followup-To: dl8bcu@dl8bcu.de,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Richard Henderson <rth@twiddle.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20080620232539.GA8061@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080620232539.GA8061@jurassic.park.msu.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Relay-User: dl8bcu@dl8bcu.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 03:25:39AM +0400, Ivan Kokshaysky wrote:
> To calculate addresses of locally defined variables, GCC uses 32-bit
> displacement from the GP. Which doesn't work for per cpu variables in
> modules, as an offset to the kernel per cpu area is way above 4G.
> 
> The workaround is to force allocation of a GOT entry for per cpu variable
> using ldq instruction with a 'literal' relocation.
> I had to use custom asm/percpu.h, as a required argument magic doesn't
> work with asm-generic/percpu.h macros.
> 
> Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> ---
>  include/asm-alpha/percpu.h |   72 +++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 71 insertions(+), 1 deletions(-)


This causes a regression for my ev4 uniprocessor build:


  CC      arch/alpha/mm/init.o
/export/data/repositories/linux-2.6/arch/alpha/mm/init.c:34: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘typeof’
make[2]: *** [arch/alpha/mm/init.o] Error 1
make[1]: *** [arch/alpha/mm] Error 2
make: *** [sub-make] Error 2


This patch fixes it for me (compile and boot tested):


diff --git a/include/asm-alpha/percpu.h b/include/asm-alpha/percpu.h
index 82e8a94..3495e8e 100644
--- a/include/asm-alpha/percpu.h
+++ b/include/asm-alpha/percpu.h
@@ -69,6 +69,8 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
 #define __get_cpu_var(var)		per_cpu_var(var)
 #define __raw_get_cpu_var(var)		per_cpu_var(var)
 
+#define PER_CPU_ATTRIBUTES
+
 #endif /* SMP */
 
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu_var(name)


Signed-off-by: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>

Thorsten.

-- 
| Thorsten Kranzkowski        Internet: dl8bcu@dl8bcu.de                      |
| Mobile: ++49 170 1876134       Snail: Kiebitzstr. 14, 49324 Melle, Germany  |
| Ampr: dl8bcu@db0lj.#rpl.deu.eu, dl8bcu@marvin.dl8bcu.ampr.org [44.130.8.19] |
