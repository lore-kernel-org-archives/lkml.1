Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398Ab0AVON0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab0AVON0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 09:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934Ab0AVONZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 09:13:25 -0500
Received: from mail.gmx.net ([213.165.64.20]:49564 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751783Ab0AVONY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 09:13:24 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18AMg1CydUA9lS3prw/rFzSUSYKpKbfbJjRjuXpkW
	D3+yIZXta0tAKL
Subject: Re: [patch] perf tools: fix dc8d6ab typo prohibiting perf top
 symbol annotation
From: Mike Galbraith <efault@gmx.de>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100122114537.GD1244@ghostprotocols.net>
References: <1264142379.8074.3.camel@marge.simson.net>
	 <20100122112231.GC1244@ghostprotocols.net>
	 <20100122114537.GD1244@ghostprotocols.net>
Content-Type: text/plain
Date: Fri, 22 Jan 2010 15:13:20 +0100
Message-Id: <1264169600.16546.44.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 09:45 -0200, Arnaldo Carvalho de Melo wrote:

> So the sequence is, right now, without Kirill's patch to autofind the
> right vmlinux: one needs to specify a --vmlinux /path/to/vmlinux, and
> that, dc8d6ab, made the only file to be considered.

ala perf top -k /lib/modules/2.6.33-tip-smpx/build/vmlinux

> This means that if dso__load_vmlinux for this specified file fails, we
> won't have kernel symbols, and in my test it failed because the buildid
> for the running kernel (/sys/kernel/notesr) didn't match the one in the
> specified vmlinux file...

(gdb) s
1602            if (symbol_conf.vmlinux_name != NULL) {
(gdb) s
1603                    err = dso__load_vmlinux(self, map, session,
(gdb) print symbol_conf.vmlinux_name
$1 = 0x7fffffffe21e "/lib/modules/2.6.33-tip-smpx/build/vmlinux"
(gdb) s
dso__load_vmlinux (self=0xecf480, map=0xecf590, session=0xecf2f0,
    vmlinux=0x7fffffffe21e "/lib/modules/2.6.33-tip-smpx/build/vmlinux", filter=0x4341ea <symbol_filter>)
    at util/symbol.c:1543
1543    {
(gdb) fin
Run till exit from #0  dso__load_vmlinux (self=0xecf480, map=0xecf590, session=0xecf2f0,
    vmlinux=0x7fffffffe21e "/lib/modules/2.6.33-tip-smpx/build/vmlinux", filter=0x4341ea <symbol_filter>)
    at util/symbol.c:1543
0x000000000044e61f in dso__load_kernel_sym (self=0xecf480, map=0xecf590, session=0xecf2f0, filter=0x4341ea <symbol_filter>)
    at util/symbol.c:1603
1603                    err = dso__load_vmlinux(self, map, session,
Value returned is $2 = 15008
(gdb)

Not failing here, but we jump down to out_try_fixup, and since
kallsyms_filename is NULL, change name to [kernel.kallsyms], and
TheBadThing follows, which made me think this was supposed to be an
error path.  Jumping to that conclusion made the bad thing go away :)

	-Mike

