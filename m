Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbZL3Uj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbZL3Uj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbZL3Uj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:39:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:45717 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbZL3Uj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:39:57 -0500
Date: Wed, 30 Dec 2009 18:39:36 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       fche LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86: record relocation offset
Message-ID: <20091230203936.GA2384@ghostprotocols.net>
References: <4B3AC5CD.1000502@cn.fujitsu.com>
 <4B3AC629.4030504@cn.fujitsu.com>
 <20091230131518.GD2956@ghostprotocols.net>
 <4B3BADDA.8040102@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3BADDA.8040102@zytor.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 30, 2009 at 11:45:30AM -0800, H. Peter Anvin escreveu:
> On 12/30/2009 05:15 AM, Arnaldo Carvalho de Melo wrote:
> > I'm no expert on the intricacies of boot_params, but all the other hunks
> > seems sensible, but can't we provide a non-perf specific way of getting
> > the relocate_offset? I guess other tools would also love to have it.

> > What about systemtap, don't they solve this in some other way? Frank?
> 
> I at one point proposed that boot_params should be exported in toto via
> sysfs.  This got rather brutally shut down as "it's just a debugging
> feature" and got moved to debugfs (/debug/boot_params/data).  However,
> the entire boot_params structure is available there.
> 
> Regardless of the reporting method, the patch passing this in by
> modifying the early assembly code, though, is more than a little
> pointless.  The kernel already knows where it is loaded -- obviously, by
> sheer necessity -- and knows how it was itself configured, and as such
> we can do this calculation in C code without modifying boot_params or
> the early bootstrap.

Yeah, rereading the start of this discussion it now seems to me that
what is happening is that a valid vmlinux is found, i.e. one with the
same buildid as the buildid found in the perf.data file but then the
kernel, at the time of perf record, was relocated, not matching what is
in the vmlinux file.

So what we need to do is to figure this out at 'perf record' time and
encode this in the header, so that later, at 'perf report' time, we can
use a matching vmlinux and do the relocation (store this relocation
offset in struct map->start for the kernel map)  to get the right
results.

Problem is that at 'perf record' time we may not have access to the
vmlinux file, and thus not be able to figure out the relocation applied
in that boot.

Then, at a later time, and possibly on another machine, on another arch,
we try to map back IPs to symbols, the /proc/kallsyms is completely
unrelated and we now have a vmlinux unrelocated...

So we need a way to get the relocation applied at 'perf record' time and
encode it in the perf.data header. Ideas about how to do that?

- Arnaldo
