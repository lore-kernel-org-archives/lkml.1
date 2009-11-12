Return-Path: <linux-kernel-owner+w=401wt.eu-S1751920AbZKLKKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbZKLKKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 05:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZKLKKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 05:10:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:42611 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbZKLKKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 05:10:11 -0500
Message-ID: <4AFBDF43.3010703@kernel.org>
Date: Thu, 12 Nov 2009 19:11:15 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
References: <alpine.LFD.2.01.0911100903370.31845@localhost.localdomain> <4AF9B1FD.1010408@kernel.org> <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain> <4AF9BE3A.40409@kernel.org> <20091110193705.GA9011@elte.hu> <4AF9C402.9040800@kernel.org> <alpine.LFD.2.01.0911101338190.31845@localhost.localdomain> <4AFA35CB.5030801@kernel.org> <20091111113147.GB7487@elte.hu> <4AFAAC32.4020104@kernel.org> <20091111195751.GA13574@elte.hu>
In-Reply-To: <20091111195751.GA13574@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

11/12/2009 04:57 AM, Ingo Molnar wrote:
> Sure - pulled it into tip:master for testing earlier today and after a 
> few hours of it's looking good so far in x86 runtime tests. I also did 
> cross-build testing to a dozen non-x86 architectures and it was fine 
> there too.

Great.

> btw., there's some 80-cols checkpatch warning artifacts in the commit:
> 
> +                       if (pcpu_extend_area_map(chunk, new_alloc) < 0) {
> +                               err = "failed to extend area map of "
> +                                       "reserved chunk";
> 
> which suggest that the logic here is perhaps nested a bit too deep. It 
> could be improved by moving the reserved allocation branch of 
> pcpu_alloc():

Strange, although the line break isn't the prettiest thing, the only
checkpatch problem I can see is the following.

  > scripts/checkpatch.pl 0001-percpu-restructure-pcpu_extend_area_map-to-fix-bugs-.patch 
  ERROR: trailing whitespace
  #80: FILE: mm/percpu.c:382:
  +^Ireturn new_alloc;^I$

  total: 1 errors, 0 warnings, 179 lines checked

  0001-percpu-restructure-pcpu_extend_area_map-to-fix-bugs-.patch has style problems, please review.  If any of these errors
  are false positives report them to the maintainer, see
  CHECKPATCH in MAINTAINERS.

The patch adds a trailing tab.  I'll fix that up (I usually catch
these while using quilt but this one didn't go through quilt and I
forgot to run checkpatch).

>         if (reserved && pcpu_reserved_chunk) {
> 
> into a helper inline function, something like __pcpu_alloc_reserved().
> 
> It's a rare special case anyway. It could be changed to return with the 
> pcpu_lock always taken, so the above branch would look like this:
> 
> 	if (unlikely(reserved)) {
> 		off = __pcpu_alloc_reserved(&chunk, size, align, &err);
> 		if (off < 0)
> 			goto fail_unlock;
> 		goto area_found;
> 	}
> 
> Which is a cleaner flow IMO, and which simplifes pcpu_alloc().

Hmmm... The thing is that the nesting isn't that deep there and
breaking string in the middle is something we do quite often.  What
checkpatch warning did you see?

Thanks.

-- 
tejun
