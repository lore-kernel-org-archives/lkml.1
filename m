Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbZFHXgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbZFHXgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 19:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbZFHXg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 19:36:28 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:49616 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbZFHXg1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 19:36:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=fC+Woht9UyaRvmiNF1LSQUtaUnuvLMubqJQtra3deSjClkr53V7kY3X+R18oQxES4N
         hgz7hLdI2PWuQxj06bdpKaj8q/LB7CO2eQD3zJSQt9Hkh8ZBdO0Z/XvfKj1R6i47+Zjg
         p5jasnoVjbjGQ24HIIUG57rPs0WURbGAh+fC0=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0906081628o7d30e05ld961c00a690c140d@mail.gmail.com>
References: <8bd0f97a0906081628o7d30e05ld961c00a690c140d@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 8 Jun 2009 19:36:09 -0400
Message-ID: <8bd0f97a0906081636p760f190cue9ef01454658dd46@mail.gmail.com>
Subject: Re: adding lockdep support to the Blackfin arch
To: Ingo Molnar <mingo@redhat.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 8, 2009 at 19:28, Mike Frysinger wrote:
> ive been extending the Blackfin arch recently to support lockdep.
> since i also had to implement irqflags/stacktrace as well, i wouldnt
> be surprised if this issue is nested in there, plus this is a no-mmu
> system.
>
> at any rate, when i boot up a Blackfin system with PROVE_LOCKING
> enabled, i end up with this warning:
> Badness at kernel/fork.c:988
>
> which correlates to this in copy_process():
>    DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);

sorry, stupid stuck keys triggered gmail sending before i finished

when i trace the code, i can see hardirqs_enabled toggling between 0
and 1 ... but when it makes it to copy_process(), apparently it's 0
which annoys the lockdep code.  any tips for me ?

btw, in order to get this to work in the first place, i had to extend
kernel/lockdep.c's static_obj() function as the Blackfin has custom
data regions where some locks live (thus outside of the normal
start/end map).  should this code use kallsyms' helper functions
instead ?  otherwise, i needed this:

--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -634,6 +634,27 @@ static int static_obj(void *obj)
    if ((addr >= start) && (addr < end))
        return 1;

+#ifdef CONFIG_BLACKFIN
+   if (L1_DATA_A_LENGTH) {
+       start = (unsigned long) &_sdata_l1;
+       end   = (unsigned long) &_ebss_l1;
+       if ((addr >= start) && (addr < end))
+           return 1;
+   }
+   if (L1_DATA_B_LENGTH) {
+       start = (unsigned long) &_sdata_b_l1;
+       end   = (unsigned long) &_ebss_b_l1;
+       if ((addr >= start) && (addr < end))
+           return 1;
+   }
+   if (L2_LENGTH) {
+       start = (unsigned long) &_sdata_l2;
+       end   = (unsigned long) &_ebss_l2;
+       if ((addr >= start) && (addr < end))
+           return 1;
+   }
+#endif
+
 #ifdef CONFIG_SMP
    /*
     * percpu var?
-mike
