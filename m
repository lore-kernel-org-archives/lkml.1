Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbYGAPrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbYGAPrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbYGAPrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:47:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59349 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbYGAPrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:47:08 -0400
Date: Tue, 1 Jul 2008 17:46:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, sagar.abhishek@gmail.com,
       rostedt@goodmis.org
Subject: Re: next-0630: sparc64: build failed
Message-ID: <20080701154648.GA31057@elte.hu>
References: <a4423d670807010825t7ea2eb44oda3f08dc007c40a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670807010825t7ea2eb44oda3f08dc007c40a2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Beregalov <a.beregalov@gmail.com> wrote:

> Hi David, Abhishek
> 
> $ make CROSS_COMPILE=sparc64-unknown-linux-gnu- image modules && sudo
> make modules_install
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
> dnsdomainname: Unknown host
>   CC      arch/sparc64/kernel/sparc64_ksyms.o
> arch/sparc64/kernel/sparc64_ksyms.c:116: error: '_mcount' undeclared
> here (not in a function)
> cc1: warnings being treated as errors
> arch/sparc64/kernel/sparc64_ksyms.c:116: error: type defaults to 'int'
> in declaration of '_mcount'
> 
> This commit is cause.
> 
> commit 395a59d0f8e86bb39cd700c3d185d30c670bb958
> Author: Abhishek Sagar <sagar.abhishek@gmail.com>
> Date:   Sat Jun 21 23:47:27 2008 +0530
> 
>     ftrace: store mcount address in rec->ip

thanks Alexander - does the patch below fix it for you?

	Ingo

---------------->
commit 760378e1497841246ea7e42abad617d8a8ac0bcc
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Jul 1 17:35:06 2008 +0200

    fix "ftrace: store mcount address in rec->ip"
    
    Alexander Beregalov reported this build failure:
    
    $ make CROSS_COMPILE=sparc64-unknown-linux-gnu- image modules && sudo
    make modules_install
      CHK     include/linux/version.h
      CHK     include/linux/utsrelease.h
      CALL    scripts/checksyscalls.sh
      CHK     include/linux/compile.h
    dnsdomainname: Unknown host
      CC      arch/sparc64/kernel/sparc64_ksyms.o
    arch/sparc64/kernel/sparc64_ksyms.c:116: error: '_mcount' undeclared
    here (not in a function)
    cc1: warnings being treated as errors
    arch/sparc64/kernel/sparc64_ksyms.c:116: error: type defaults to 'int'
    in declaration of '_mcount'
    
    And bisected it back to:
    
    | commit 395a59d0f8e86bb39cd700c3d185d30c670bb958
    | Author: Abhishek Sagar <sagar.abhishek@gmail.com>
    | Date:   Sat Jun 21 23:47:27 2008 +0530
    |
    |     ftrace: store mcount address in rec->ip
    
    the mcount prototype is only available under CONFIG_FTRACE,
    extend it to CONFIG_MCOUNT as well.
    
    Reported-and-bisected-by: Alexander Beregalov <a.beregalov@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/sparc64/kernel/sparc64_ksyms.c b/arch/sparc64/kernel/sparc64_ksyms.c
index b80d982..49d3ea5 100644
--- a/arch/sparc64/kernel/sparc64_ksyms.c
+++ b/arch/sparc64/kernel/sparc64_ksyms.c
@@ -112,7 +112,7 @@ EXPORT_SYMBOL(__write_trylock);
 EXPORT_SYMBOL(smp_call_function);
 #endif /* CONFIG_SMP */
 
-#if defined(CONFIG_MCOUNT)
+#ifdef CONFIG_MCOUNT
 EXPORT_SYMBOL(_mcount);
 #endif
 
diff --git a/include/asm-sparc64/ftrace.h b/include/asm-sparc64/ftrace.h
index f76a40a..d27716c 100644
--- a/include/asm-sparc64/ftrace.h
+++ b/include/asm-sparc64/ftrace.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_SPARC64_FTRACE
 #define _ASM_SPARC64_FTRACE
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_MCOUNT
 #define MCOUNT_ADDR		((long)(_mcount))
 #define MCOUNT_INSN_SIZE	4 /* sizeof mcount call */
 
