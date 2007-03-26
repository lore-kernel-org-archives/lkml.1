Return-Path: <linux-kernel-owner+w=401wt.eu-S933410AbXCZCaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410AbXCZCaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 22:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933416AbXCZCaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 22:30:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933410AbXCZCaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 22:30:14 -0400
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: "Stone, Joshua I" <joshua.i.stone@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       SystemTAP <systemtap@sources.redhat.com>,
       Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>,
       Yumiko Sugita <yumiko.sugita.yf@hitachi.com>, hch@infradead.org
Subject: Re: [RFC][Patch 1/4] kprobe fast unregistration
References: <20070323180527.GA13728@bambi.jf.intel.com>
	<16D5B9AB904B0B46B22A27002EE3A8C82793BB@scsmsx415.amr.corp.intel.com>
	<20070323182248.GA32364@redhat.com>
	<20070323190127.GA13974@bambi.jf.intel.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: 25 Mar 2007 22:29:51 -0400
In-Reply-To: <20070323190127.GA13974@bambi.jf.intel.com>
Message-ID: <y0mmz20n3ds.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.0808 (Gnus v5.8.8) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi -

"Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> writes:

> [...]
> > Really?  What possible problems can occur?  The worst that occurs
> > to me is that if someone forgets to call the commit function, the
> > kprobes will still be disabled, but memory won't be recycled for a
> > while.  [...]
>
> Yes, Have you looked at the code? 

A little, but we were talking more about the interface than the
implementation.

> If someone forgets to call the commit function, the kprobe will be
> disabled and yes the memory won't be recycled but the worst problem
> is that if the probe is on a module function then that module can't
> be unloaded at all [...]

I believe there is already a kprobes patch in the queue for
enumerating active probes in some /proc file.  Should a module be
locked into memory for such a reason, finding the culprit should not
be difficult.

> Hence, my suggestion would be to call them as disable_kprobe()
> (instead of unregister_kprobes_fast() which is confusing and error
> prone) and also to provide an opposite function to reenable_kprobe()
> and finally provide unregister_disabled_kprobes() which is
> essentially the same as commit_kprobes().

One problem with this idea is that if the unregister_fast()=disable()
is to become reversible, then the renamed commit_kprobes() will no
longer be indempotent.  There can no longer be a single system-wide
deferred-kprobe-cleanup list, since individual kprobes clients might
want to reinstate their probes in the future.

> > Would it be possible to allay even that concern with an automated
> > deferred/periodic commit?
> > 
> I would recomand that users call unregister_disabled_kprobes() explictly.

But this would solve both problems (memory leaks and outstanding
reference counts on modules).  In this variant,
unregister_kprobes_fast could replace unregister_kprobes outright, and
the (builtin deferred) commit function would need not be exported.

- FChE
