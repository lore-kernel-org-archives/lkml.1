Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbYADUhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbYADUhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 15:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbYADUho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 15:37:44 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55688 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbYADUho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 15:37:44 -0500
Date: Fri, 4 Jan 2008 21:37:45 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: [PATCH] profile: further Codying Style fixes, take 2
Message-ID: <20080104203745.GB32174@uranus.ravnborg.org>
References: <20080104185209.111adeed@paolo-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104185209.111adeed@paolo-desktop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 06:52:09PM +0100, Paolo Ciarrocchi wrote:
> Further fixes to profile.c, checkpatch.pl now reports:
> 
> 	total: 0 errors, 2 warnings, 601 lines checked
> 
>   WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
>   #410: FILE: profile.c:410:
>   +EXPORT_SYMBOL_GPL(profile_hits);
> I cannot fix this without changing the funtionality in case of non-SMP build.

If you look a bit more you will see two functions named
profile_hits.
So you just add the export twice - like this:
diff --git a/kernel/profile.c b/kernel/profile.c
index 5e95330..fc4570d 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -337,6 +337,7 @@ out:
        local_irq_restore(flags);
        put_cpu();
 }
+EXPORT_SYMBOL_GPL(profile_hits);

 static int __devinit profile_cpu_callback(struct notifier_block *info,
                                        unsigned long action, void *__cpu)
@@ -408,9 +409,8 @@ void profile_hits(int type, void *__pc, unsigned int nr_hits)
        pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
        atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
 }
-#endif /* !CONFIG_SMP */
-
 EXPORT_SYMBOL_GPL(profile_hits);
+#endif /* !CONFIG_SMP */

 void profile_tick(int type)
 {

Which has the added benefit that it is now documented for
both implementations that they are exported.

> 
> 
>   WARNING: externs should be avoided in .c files
>   #509: FILE: profile.c:509:
>   +       extern int setup_profiling_timer(unsigned int multiplier);
> I don't know what to do with this warning.

Stick the prototype in profile.h maybe?
I can see that not all implementers of this function
includes profile.h so it is not foolproof.

	Sam
