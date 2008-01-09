Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbYAIU3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbYAIU3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 15:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbYAIU32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 15:29:28 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56606 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbYAIU31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 15:29:27 -0500
Subject: Re: [PATCH] Kprobes: Add kprobes smoke tests that run on boot
From: Jim Keniston <jkenisto@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: ananth@in.ibm.com, akpm@linux-foundation.org,
       lkml <linux-kernel@vger.kernel.org>, mingo@elte.hu, mhiramat@redhat.com,
       davem@davemloft.net, hskinnemoen@atmel.com
In-Reply-To: <20080108232841.GD2117@one.firstfloor.org>
References: <20080108063334.GA29385@in.ibm.com>
	 <p73zlvgowwn.fsf@bingen.suse.de>
	 <1199833842.3914.33.camel@dyn9047018096.beaverton.ibm.com>
	 <20080108232841.GD2117@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 12:24:00 -0800
Message-Id: <1199910240.4162.31.camel@dyn9047018096.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-09 at 00:28 +0100, Andi Kleen wrote:
> > I have no problem with that, but if we want to make it buildable as a
> > module, the call to get_kprobe() needs to be replaced with some other
> > gcc-inline-defeating mechanism, or we need to export get_probe().  I
> 
> It's still unclear where noinline does not work (do you have details on that? 
> It sounds a little dubious) ...

Here's a simplified version of a module we've used to gauge kprobes
performance.  On my system (i386, 2.6.23-rc8 at the moment, gcc version
4.1.2), the module calls the (empty) probed function (probeme) niter
times, but reports zero probe hits -- indicating probeme was inlined
even though it was declared noinline.

If I change probeme to a varargs function, per your suggestion -- see
diffs below -- the proper number of probe hits are reported.
----- noinline.c -----
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/jiffies.h>
#include <linux/kprobes.h>

/*
 * Sample usage: insmod noinline.ko niter=5000000
 * printk should report 5000000 calls.
 */

static int niter = 0;
module_param(niter, int, 0);
MODULE_PARM_DESC(niter, "iterations");

static int ncalls = 0;

static int counter_hdlr(struct kprobe *p, struct pt_regs *regs)
{
	ncalls++;
	return 0;
}

// #define noinline __attribute__((noinline))
noinline static void probeme(void)
{
}

struct kprobe kp = {
	.addr = (kprobe_opcode_t*) probeme,
	.pre_handler = counter_hdlr
};

static int __init noinline_init(void)
{
	int ret;
	int i;
	u64 start, stop;

	ret = register_kprobe(&kp);
	if (ret != 0) {
		printk(KERN_ERR "register_kprobe returns %d\n", ret);
		return ret;
	}

	start = get_jiffies_64();
	for (i = 1; i <= niter; i++)
		probeme();
	stop = get_jiffies_64();
	printk(KERN_INFO "noinline test: %d iterations in %lld jiffies\n",
		niter, stop-start);
	printk(KERN_INFO "Counted %d calls\n", ncalls);
	return 0;
}

static void __exit noinline_exit(void)
{
	unregister_kprobe(&kp);
	printk(KERN_INFO "noinline test: exiting...\n");
}

module_init(noinline_init);
module_exit(noinline_exit);
MODULE_LICENSE("GPL");
----- Change probeme to a varargs function -----
--- noinline.c	2008-01-09 11:26:09.000000000 -0800
+++ noinline2.c	2008-01-09 11:59:54.000000000 -0800
@@ -22,8 +22,13 @@
 }
 
 // #define noinline __attribute__((noinline))
-noinline static void probeme(void)
+noinline static void probeme(int nargs, ...)
 {
+	va_list args;
+	va_start(args, nargs);
+	while (nargs-- > 0)
+		printk(KERN_INFO "%p\n", va_arg(args, char*));
+	va_end(args);
 }
 
 struct kprobe kp = {
@@ -45,9 +50,9 @@
 
 	start = get_jiffies_64();
 	for (i = 1; i <= niter; i++)
-		probeme();
+		probeme(0);
 	stop = get_jiffies_64();
-	printk(KERN_INFO "noinline test: %d iterations in %lld jiffies\n",
+	printk(KERN_INFO "noinline2 test: %d iterations in %lld jiffies\n",
 		niter, stop-start);
 	printk(KERN_INFO "Counted %d calls\n", ncalls);
 	return 0;
@@ -56,7 +61,7 @@
 static void __exit noinline_exit(void)
 {
 	unregister_kprobe(&kp);
-	printk(KERN_INFO "noinline test: exiting...\n");
+	printk(KERN_INFO "noinline2 test: exiting...\n");
 }
 
 module_init(noinline_init);

...
> -Andi

Thanks for the suggestions.
Jim

