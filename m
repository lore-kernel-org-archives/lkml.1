Return-Path: <linux-kernel-owner+w=401wt.eu-S1761033AbXGPOFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761033AbXGPOFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765850AbXGPODy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:03:54 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:16472 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760897AbXGPODv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:03:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZKasPwS93aV2yf/qVRQ1v6bA7XedcJRFl4cjDQFxJgKhJK9Gt2UXeQODzoFm5qAczg+AY5548lWsxlanwR7EStcvOycHxHl7esazwP8osToNP2wBqSGQd4l+AVAYG8eKVZym0Di8bhZsAB/rjyIw2INrUT79hJv7c0DroEYorVQ=
Date: Mon, 16 Jul 2007 22:53:47 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitriy Zavin <dmitriyz@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Ashok Raj <ashok.raj@intel.com>
Subject: [PATCH 4/10] cpu: deliver CPU_UP_CANCELED only to NOTIFY_OKed callbacks with CPU_UP_PREPARE
Message-ID: <20070716135347.GD2040@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Dmitriy Zavin <dmitriyz@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	Ashok Raj <ashok.raj@intel.com>
References: <20070716134855.GA1858@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716134855.GA1858@APFDCB5C>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The functions in a CPU notifier chain is called with CPU_UP_PREPARE event
before making the CPU online. If one of the callback returns NOTIFY_BAD,
it stops to deliver CPU_UP_PREPARE event, and CPU online operation is canceled.
Then CPU_UP_CANCELED event is delivered to the functions in a CPU notifier
chain again.

This CPU_UP_CANCELED event is delivered to the functions which have been
called with CPU_UP_PREPARE, not delivered to the functions which haven't
been called with CPU_UP_PREPARE.

The problem that makes existing cpu hotplug error handlings complex is
that the CPU_UP_CANCELED event is delivered to the function that has
returned NOTIFY_BAD, too.

Usually we don't expect to call destructor function against the
object that has failed to initialize. It is like:

	err = register_something();
	if (err) {
		unregister_something(); // bug
		return err;
	}

So it is natural to deliver CPU_UP_CANCELED event only to the functions
that have returned NOTIFY_OK with CPU_UP_PREPARE event and not to call
the function that have returned NOTIFY_BAD. This is what this patch is doing.

Otherwise, every cpu hotplug notifiler has to track whether
notifiler event is failed or not for each cpu.
(drivers/base/topology.c is doing this with topology_dev_map)

Similary this patch makes same thing with CPU_DOWN_PREPARE and
CPU_DOWN_FAILED evnets.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 kernel/cpu.c |    2 ++
 1 file changed, 2 insertions(+)

Index: 2.6-mm/kernel/cpu.c
===================================================================
--- 2.6-mm.orig/kernel/cpu.c
+++ 2.6-mm/kernel/cpu.c
@@ -138,6 +138,7 @@ static int _cpu_down(unsigned int cpu, i
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
+		nr_calls--;
 		__raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 					  hcpu, nr_calls, NULL);
 		printk("%s: attempt to take down CPU %u failed\n",
@@ -221,6 +222,7 @@ static int __cpuinit _cpu_up(unsigned in
 	ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE | mod, hcpu,
 							-1, &nr_calls);
 	if (ret == NOTIFY_BAD) {
+		nr_calls--;
 		printk("%s: attempt to bring up CPU %u failed\n",
 				__FUNCTION__, cpu);
 		ret = -EINVAL;
