Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbYAHXQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbYAHXQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:16:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbYAHXPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:15:55 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34649 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbYAHXPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:15:54 -0500
Subject: Re: [PATCH] Kprobes: Add kprobes smoke tests that run on boot
From: Jim Keniston <jkenisto@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: ananth@in.ibm.com, akpm@linux-foundation.org,
       lkml <linux-kernel@vger.kernel.org>, mingo@elte.hu, mhiramat@redhat.com,
       davem@davemloft.net, hskinnemoen@atmel.com
In-Reply-To: <p73zlvgowwn.fsf@bingen.suse.de>
References: <20080108063334.GA29385@in.ibm.com>
	 <p73zlvgowwn.fsf@bingen.suse.de>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 15:10:41 -0800
Message-Id: <1199833842.3914.33.camel@dyn9047018096.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-08 at 22:00 +0100, Andi Kleen wrote:
> Ananth N Mavinakayanahalli <ananth@in.ibm.com> writes:
> >  kernel/kprobes.c        |    2 
> >  kernel/test_kprobes.c   |  216 ++++++++++++++++++++++++++++++++++++++++++++++++
> 
> Can you put this somewhere else please? I know there are already some
> test files in kernel/* but imho they all belong into some other directory.
> 
> +	if (!err)
> +		init_test_probes();
>  	return err;
> 
> Couldn't this be just a normal initcall? Perhaps even a module_init(),
> then it would be possible to use as a module too.
> 
> -Andi

I have no problem with that, but if we want to make it buildable as a
module, the call to get_kprobe() needs to be replaced with some other
gcc-inline-defeating mechanism, or we need to export get_probe().  I
much prefer the former, since get_kprobe() is a kprobes-internal
function.

Anybody know an architecture-independent way (other than noinline, which
doesn't always work) of making gcc decide not to inline a function?
E.g., does taking (and using) the function's address do it?

Jim Keniston

>From Ananth's patch:
+static noinline u32 kprobe_target(u32 value)
+{
+       /*
+        * gcc ignores noinline on some architectures unless we stuff
+        * sufficient lard into the function. The get_kprobe() here is
+        * just for that.
+        *
+        * NOTE: We aren't concerned about the correctness of
get_kprobe()
+        * here; hence, this call is neither under !preempt nor with the
+        * kprobe_mutex held. This is fine(tm)
+        */
+       if (get_kprobe((void *)0xdeadbeef))
+               printk(KERN_INFO "Kprobe smoke test: probe on
0xdeadbeef!\n");
+
+       return (value / div_factor);
+}

