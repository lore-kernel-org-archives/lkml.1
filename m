Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321AbZIWLcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbZIWLcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 07:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbZIWLcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 07:32:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:37170 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752231AbZIWLcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 07:32:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX189hSAhOfY9ncK/AhgAtfFwbKicxyL3dpy9U4PQsI
	e681p1jRHQ2v3Z
Subject: Re: [patch] Re: [perf] Finding uninstalled modules Was Re: mailing
 list for trace users
From: Mike Galbraith <efault@gmx.de>
To: Avi Kivity <avi@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, rostedt@goodmis.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <4AB9F08E.1020106@redhat.com>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>
	 <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net>
	 <4AB8B65F.7030602@redhat.com> <1253620041.13917.24.camel@marge.simson.net>
	 <4AB8BA37.4010305@redhat.com> <20090922201746.GH5216@ghostprotocols.net>
	 <4AB9DCC8.5050603@redhat.com> <1253697658.11461.36.camel@marge.simson.net>
	 <4AB9F08E.1020106@redhat.com>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 13:31:55 +0200
Message-Id: <1253705515.7835.41.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 12:55 +0300, Avi Kivity wrote:
> On 09/23/2009 12:20 PM, Mike Galbraith wrote:
> >
> > Yup, brown baggie variety.  Oh darn.
> >
> > perf_counter tools: fix brown baggie module symbol loading bug.
> >
> > If there are no modules currently loaded, or the last module scanned is not
> > loaded, dso__load_modules() steps on the value from dso__load_vmlinux(), so
> > we happily load the kallsyms symbols on top of what we've already loaded.
> >
> > Fix that such that the total count of symbols loaded is returned.  Should
> > module symbol load fail after parsing of vmlinux, is's a hard failure, so
> > do not silently fall-back to kallsyms.
> >
> >    
> 
> Still fails, but differently.  Now 'annotate -k ... -m -v -v' doesn't 
> list vmx_vcpu_run at all, even though it's prominent in 'perf top'.

Hm.  I just did a record, then report with and without -k -m, and now
get identical reports with your config (plus some more modules) here.

> In addition to applying your patch I've merged current linus, so that 
> may have introduced the problem.

I'm testing with freshly pulled and built tip+patch
.
> If I don't supply -k -m, I get
> 
> $ perf annotate  -v -v vmx_vcpu_run | grep vmx_vcpu
> new symbol: ffffffffa006f596 [0000dead]: vmx_vcpu_run    [kvm_intel], 
> hist: (nil), obj_start: (nil)
> new symbol: ffffffffa007025f [0000dead]: vmx_vcpu_put    [kvm_intel], 
> hist: (nil), obj_start: (nil)
> new symbol: ffffffffa0070bf6 [0000dead]: vmx_vcpu_load    [kvm_intel], 
> hist: (nil), obj_start: (nil)
> new symbol: ffffffffa0070d99 [0000dead]: vmx_vcpu_reset    [kvm_intel], 
> hist: (nil), obj_start: (nil)
> ffffffffa006f596-ffffffffa006fb73 vmx_vcpu_run    [kvm_intel]
>   ffffffffa007025f-ffffffffa007026e vmx_vcpu_put    [kvm_intel]
>   ffffffffa0070bf6-ffffffffa0070d98 vmx_vcpu_load    [kvm_intel]
>   ffffffffa0070d99-ffffffffa0071191 vmx_vcpu_reset    [kvm_intel]
>   Error: symbol 'vmx_vcpu_run' not present amongst the samples.

You can't annotate module symbols without -m.  If you don't provide -k,
annotate will look for vmlinux in cwd.  If there's one there, it'll
silently parse it.  For a module symbol, no -m means no symbol.

marge:/root/tmp # perf annotate -v -v -m ext3_mark_iloc_dirty 2>&1| grep ext3_mark_iloc_dirty
new symbol: ffffffffa005f8cf [0000dead]: ext3_mark_iloc_dirty   [ext3], hist: (nil), obj_start: (nil)
 ffffffffa005f8cf-ffffffffa005fc20 ext3_mark_iloc_dirty [ext3]
 Error: symbol 'ext3_mark_iloc_dirty' not present amongst the samples.

With -k -m it works here.

marge:/root/tmp # perf annotate -v -v -k vmlinux.avi -m ext3_mark_iloc_dirty 2>&1| grep ext3_mark_iloc_dirty
new symbol: ffffffffa005f8cf [00000352]: ext3_mark_iloc_dirty, hist: (nil), obj_start: 0x38cf
 ffffffffa005f8cf-ffffffffa005fc20 ext3_mark_iloc_dirty         [ext3]
annotating [0x22c10f0]                       [kernel] : [0x25821c0]           ext3_mark_iloc_dirty
         :      00000000000038cf <ext3_mark_iloc_dirty>:
         :      int ext3_mark_iloc_dirty(handle_t *handle,
    0.00 :          38e0:       e8 00 00 00 00          callq  38e5 <ext3_mark_iloc_dirty+0x16>
    5.93 :          392a:       74 1d                   je     3949 <ext3_mark_iloc_dirty+0x7a>
    0.02 :          394c:       e8 00 00 00 00          callq  3951 <ext3_mark_iloc_dirty+0x82>
    1.39 :          3975:       75 2a                   jne    39a1 <ext3_mark_iloc_dirty+0xd2>
    0.88 :          3989:       75 41                   jne    39cc <ext3_mark_iloc_dirty+0xfd>
    0.32 :          399f:       eb 37                   jmp    39d8 <ext3_mark_iloc_dirty+0x109>
    0.00 :          39a8:       74 06                   je     39b0 <ext3_mark_iloc_dirty+0xe1>
    0.00 :          39aa:       8b 15 00 00 00 00       mov    0x0(%rip),%edx        # 39b0 <ext3_mark_iloc_dirty+0xe1>
    0.00 :          39c0:       74 06                   je     39c8 <ext3_mark_iloc_dirty+0xf9>
    0.00 :          39c2:       8b 15 00 00 00 00       mov    0x0(%rip),%edx        # 39c8 <ext3_mark_iloc_dirty+0xf9>
    0.00 :          3a3c:       74 0d                   je     3a4b <ext3_mark_iloc_dirty+0x17c>
    0.00 :          3a46:       e9 ab 00 00 00          jmpq   3af6 <ext3_mark_iloc_dirty+0x227>
    0.24 :          3a60:       0f 86 90 00 00 00       jbe    3af6 <ext3_mark_iloc_dirty+0x227>
    0.04 :          3a7d:       74 06                   je     3a85 <ext3_mark_iloc_dirty+0x1b6>
    0.11 :          3a83:       75 71                   jne    3af6 <ext3_mark_iloc_dirty+0x227>
    0.00 :          3a89:       e8 00 00 00 00          callq  3a8e <ext3_mark_iloc_dirty+0x1bf>
    0.00 :          3aa4:       e8 00 00 00 00          callq  3aa9 <ext3_mark_iloc_dirty+0x1da>
    0.00 :          3aae:       0f 85 f5 00 00 00       jne    3ba9 <ext3_mark_iloc_dirty+0x2da>
    0.00 :          3ab7:       e8 00 00 00 00          callq  3abc <ext3_mark_iloc_dirty+0x1ed>
    0.00 :          3ae9:       e8 00 00 00 00          callq  3aee <ext3_mark_iloc_dirty+0x21f>
    0.00 :          3af1:       e9 26 fe ff ff          jmpq   391c <ext3_mark_iloc_dirty+0x4d>
    0.02 :          3b14:       74 09                   je     3b1f <ext3_mark_iloc_dirty+0x250>
    0.38 :          3b1d:       75 3e                   jne    3b5d <ext3_mark_iloc_dirty+0x28e>
    0.00 :          3b2f:       0f 87 ba 00 00 00       ja     3bef <ext3_mark_iloc_dirty+0x320>
    0.00 :          3b41:       0f 87 a8 00 00 00       ja     3bef <ext3_mark_iloc_dirty+0x320>
    0.00 :          3b5b:       eb 12                   jmp    3b6f <ext3_mark_iloc_dirty+0x2a0>
    6.64 :          3b6d:       75 ee                   jne    3b5d <ext3_mark_iloc_dirty+0x28e>
    0.04 :          3b77:       74 07                   je     3b80 <ext3_mark_iloc_dirty+0x2b1>
    0.09 :          3b84:       e8 00 00 00 00          callq  3b89 <ext3_mark_iloc_dirty+0x2ba>
    0.00 :          3b98:       e8 00 00 00 00          callq  3b9d <ext3_mark_iloc_dirty+0x2ce>
    0.00 :          3bb5:       74 17                   je     3bce <ext3_mark_iloc_dirty+0x2ff>
    0.00 :          3bc9:       e8 00 00 00 00          callq  3bce <ext3_mark_iloc_dirty+0x2ff>
    0.00 :          3c1c:       e9 4e ff ff ff          jmpq   3b6f <ext3_mark_iloc_dirty+0x2a0>


