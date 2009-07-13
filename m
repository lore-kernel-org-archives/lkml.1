Return-Path: <linux-kernel-owner+w=401wt.eu-S1751586AbZGMFaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbZGMFaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 01:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbZGMFaC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 01:30:02 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3781 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbZGMFaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 01:30:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=to:cc:subject:references:from:date:in-reply-to:message-id:
	user-agent:mime-version:content-type:x-system-of-record;
	b=HXlp9jK3qKwxgODfsQt36jWIZAKNIXBfqzX24xetTScbnAoYVzRlyuH3CPfoQ3BtS
	FyjSRFPG8CuEnLqlsuyBA==
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       barryn@pobox.com, bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 13012] 2.6.28.9 causes init to segfault on Debian etch; 2.6.28.8 OK
References: <200907100928.07369.elendil@planet.nl>
	<200907101659.31813.elendil@planet.nl>
	<alpine.LFD.2.01.0907121058040.3552@localhost.localdomain>
From: Ian Lance Taylor <iant@google.com>
Date: Sun, 12 Jul 2009 22:29:50 -0700
In-Reply-To: <alpine.LFD.2.01.0907121058040.3552@localhost.localdomain> (Linus Torvalds's message of "Sun\, 12 Jul 2009 10\:58\:21 -0700 \(PDT\)")
Message-ID: <m3k52d1775.fsf@google.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Ian: we generally do try to be careful and use explicit unsigned types for 
> code that cares about overflow, but we use -fwrapv because there have been 
> some cases where we didn't (and used pointer comparisons or signed 
> integers).
>
> The problem is that apparently gcc-4.1.x was literally generating buggy 
> code with -fwrapv. So now the choice for us is between switching to an 
> explicit version test:
>
> 	-KBUILD_CFLAGS  += $(call cc-option,-fwrapv)
> 	+KBUILD_CFLAGS  += $(shell if [ $(call cc-version) -ge 0402 ]; then \
> 	+                   echo $(call cc-option,-fwrapv); fi ;)
>
> or just switching to -fno-strict-overflow instead:
>
> 	-KBUILD_CFLAGS  += $(call cc-option,-fwrapv)
> 	+KBUILD_CFLAGS  += $(call cc-option,-fno-strict-overflow)
>
> which avoids the buggy gcc versions because it's simply not even supported 
> by gcc-4.1.x (and even if that wasn't the case, possibly because only 
> 'wrapv' is the problematic case - apparently the difference _does_ 
> matter to gcc).

My instinctive advice is that y'all should track down and fix the cases
where the program relies on signed overflow being defined.  However, if
that is difficult--and it is--then I agree that -fno-strict-overflow is
preferable when using a compiler which supports it (gcc 4.2.0 and
later).

(The gcc 4.2 and later option -Wstrict-overflow=N can help find the
cases where a program relies on defined signed overflow, but only if
somebody is patient enough to wade through all the false positives.)

Ian
