Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbZJFGFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbZJFGFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 02:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756202AbZJFGFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 02:05:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756163AbZJFGFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 02:05:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jason Baron <jbaron@redhat.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       tglx@linutronix.de, rostedt@goodmis.org, ak@suse.de, rth@redhat.com,
       mhiramat@redhat.com
Subject: Re: [PATCH 0/4] jump label patches
In-Reply-To: Jason Baron's message of  Thursday, 24 September 2009 19:17:45 -0400 <cover.1253831945.git.jbaron@redhat.com>
References: <cover.1253831945.git.jbaron@redhat.com>
Emacs: Our Lady of Perpetual Garbage Collection
Message-Id: <20091006060410.CAF2528@magilla.sf.frob.com>
Date: Mon,  5 Oct 2009 23:04:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think text_poke_fixup() is a good safe place to start, and it seems wise
to merge a version using that before worrying anything subtler.  But it's
almost surely overkill and makes the enable/disable switching cost pretty
huge.  The rules as documented by Intel seem to indicate that simple
self-modification can work for UP and for SMP there should be some scheme
with IPIs that is not too terrible.  

Those can entail a multi-phase modification like the int3 patching style,
but int3 is not the only way to do it.  int3 has the benefit of being a
one-byte instruction you can patch in, but also the downside of requiring
the trap handling hair.  Another approach is:

start:
	   .balign 2
	2: nopl
	7: ...

phase 1:
	2: jmp 7
	4: <last 3 bytes of nopl>
	7: ...

phase 2:
	2: jmp 7
	4: {last 3 bytes of "jmp .Ldo_trace"}
	7: ...

phase 3:
	2: jmp .Ldo_trace
	7: ...

A scheme like that requires that the instruction to be patched be 2-byte
aligned so that the two-byte "jmp .+3" can be an atomic store not
straddling a word boundary.  On x86-64 (and, according to the Intel book,
everything >= Pentium), you can atomically store 8 bytes when aligned.  So
there you will usually actually be able to do this in one or two phases to
cover each particular 5 byte range with adequately aligned stores.


Thanks,
Roland
