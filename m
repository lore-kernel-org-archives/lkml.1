Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbZBWL3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbZBWL3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 06:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZBWL3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 06:29:04 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:64062 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbZBWL3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 06:29:03 -0500
To: catalin.marinas@arm.com, penberg@cs.helsinki.fi
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to analyze kmemleak message?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200902230824.n1N8OV3P015018@www262.sakura.ne.jp>
	<84144f020902230140v83e153cr3a0c8195aab1b835@mail.gmail.com>
	<1235385947.14987.41.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1235385947.14987.41.camel@pc1117.cambridge.arm.com>
Message-Id: <200902232029.HGI04666.FLOOFSVFJtHQMO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 23 Feb 2009 20:29:00 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Thank you for explanation.

Catalin Marinas wrote:
> As Pekka said, they refer to the place where the object was allocated.
OK. The trace shows where that memory was allocated.

> This object can no longer be found to be referred by other objects or
> from the data section, hence it is assumed to be a leak (it could, as
> well, be a false positive, transient or not).
Kmemleak scans all data section for addresses returned by kmalloc() etc.

  void *p1;
  
  void foo(void)
  {
      void *p2 = kmalloc(1, GFP_KERNEL);
      p1 = kmalloc(1, GFP_KERNEL);
  }

"p1" will be reported by default.
To report "p2", we need to write "stack=on" to /sys/kernel/debug/kmemleak .
Is this correct?

> Basically, you need check
> where the pointer returned by kmalloc/kmem_cache_alloc etc. should be
> stored and whether it can still be referred from that place (or a
> different one) later.
> 
> Kmemleak tries to avoid the reporting of transient leaks by only
> reporting objects with a life time of more than 5 seconds.
kjournald's commit interval (default to 5 sec?) + a few seconds
might be better. (No reason. Just my feeling.)

> To make sure
> the reports you got aren't transient leaks, you can read
> the /sys/kernel/debug/kmemleak file a few times to see whether they
> disappear.
Well, I couldn't check /sys/kernel/debug/kmemleak etc. because
I couldn't reach login prompt.

> There is a Documentation/kmemleak.txt file where you may find some
> useful information.
I see.

I have a question. My module uses kmalloc(PATH_MAX, GFP_KERNEL) which
won't be released by kfree(). I count up how many bytes are allocated but
I don't want kmemleak to report such memory as memory leaks.
Can I do so by

  void bar(void)
  {
      static void *p;
      if (!p) {
          p = kmalloc(PATH_MAX, GFP_KERNEL);
          kmemleak_not_leak(p);
      }
      ...
  }

(or kmemleak_ignore() (which one to use and how to use))?

Regards.
