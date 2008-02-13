Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbYBMVHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbYBMVHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbYBMVHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:07:20 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:58696 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbYBMVHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:07:19 -0500
Date: Wed, 13 Feb 2008 22:07:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc1, weird build error
Message-ID: <20080213210726.GA13773@uranus.ravnborg.org>
References: <20080212070448.GA20033@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212070448.GA20033@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 08:04:48AM +0100, Ingo Molnar wrote:
> 
> i've got a build log from a weird build error below:
> 
>   LD      init/built-in.o
> distcc[12023] ERROR: compile (null) on localhost failed
> make: *** [vmlinux.o] Error 1
> make: *** Waiting for unfinished jobs....
>   LD      .tmp_vmlinux1
> 
> but there's no actual error visible in the logs. On a second attempt, it 
> built just fine. (unfortunately erasing most evidence of the previous 
> failure.) This happened after a rather long randconfig build series so i 
> doubt it's readily reprodicible.
> 
> any ideas? Is this something benign? Or should i start doing all builds 
> with V=1, in the hope of catching more information?

building vmlinux.o were moved up in the dependency chain so we started
to build it before the kallsym stuff. This was done to let modpost
report section mismatch bugs even when the final link failed.

Originally I had expected the dependency of $(kallsyms.o) to
cover this but it turns out that we need to be even more explicit.
With attached patch this is addressed and I now get the desired
behaviour.
The drawback is that the final steps are serialized and we seems
to be pretty CPU bound doing all the linking stuff.

I assume the patch is safe but a bit testing from your side
is appreciated.
That randconfig qa thing is excellent to find these subtle things.

	Sam

diff --git a/Makefile b/Makefile
index c162370..bec8da3 100644
--- a/Makefile
+++ b/Makefile
@@ -810,7 +810,9 @@ endif
 	$(Q)rm -f .old_version
 
 # build vmlinux.o first to catch section mismatch errors early
-$(kallsyms.o): vmlinux.o
+ifdef CONFIG_KALLSYMS
+.tmp_vmlinux1: vmlinux.o
+endif
 vmlinux.o: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) FORCE
 	$(call if_changed_rule,vmlinux-modpost)
 
