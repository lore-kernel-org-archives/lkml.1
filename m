Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbZIVW01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbZIVW01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 18:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZIVW00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 18:26:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZIVW0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 18:26:25 -0400
Date: Tue, 22 Sep 2009 13:17:46 -0700
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, rostedt@goodmis.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [perf] Finding uninstalled modules Was Re: mailing list for trace
	users
Message-ID: <20090922201746.GH5216@ghostprotocols.net>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com> <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net> <4AB8B65F.7030602@redhat.com> <1253620041.13917.24.camel@marge.simson.net> <4AB8BA37.4010305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB8BA37.4010305@redhat.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 22, 2009 at 02:51:19PM +0300, Avi Kivity escreveu:
> On 09/22/2009 02:47 PM, Mike Galbraith wrote:
>>
>> Hm, must me a problem with parsing then.  If you add -v -v to the
>> command line it'll spit out debug data.  For vmx_vcpu_run you should see
>> a line like so if the module was parsed.
>>
>> new symbol: ffffffffa0065a49 [00000466]: ahci_interrupt, hist: (nil), obj_start: 0x2a49
>>
>> 	-Mike
>
> $ perf annotate -v -v -k ~avi/kvm/linux-2.6/vmlinux -m vmx_vcpu_run  |  

Here is the problem, he is passing a vmlinux, that way we don't parse
/proc/kallsyms, so no module symbols, he uses -m to load the modules
symbols but mod_dso__load_module_paths only looks at /lib/modules/, i.e.
installed modules.

I guess Avi hasn't installed modules, right? So the right fix for this
case is to figure out where modules are from the path given to -k, i.e.
we first use ~avi/kvm/linux-2.6/ as the modules path prefix and then
fallback to /lib/modules if we can't find modules there, right?

> grep vmx_vcpu_run
> new symbol: ffffffffa006f596 [0000dead]: vmx_vcpu_run    [kvm_intel],  
> hist: (nil), obj_start: (nil)
>  ffffffffa006f596-ffffffffa006fb73 vmx_vcpu_run    [kvm_intel]
>  Error: symbol 'vmx_vcpu_run' not present amongst the samples.
>
> Looks like internal confusion.
>
> -- 
> error compiling committee.c: too many arguments to function
