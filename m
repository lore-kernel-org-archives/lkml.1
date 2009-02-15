Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbZBOKFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbZBOKFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 05:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZBOKFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 05:05:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43317 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbZBOKFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 05:05:31 -0500
Date: Sun, 15 Feb 2009 11:04:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, bugme-daemon@bugzilla.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected) [Bug
	12465]
Message-ID: <20090215100454.GA30314@elte.hu>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <ROx6X68CGJG.A.54H.w40lJB@chimera> <1234691284.4967.23.camel@kulgan.wumi.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234691284.4967.23.camel@kulgan.wumi.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin Shanahan <kmshanah@ucwb.org.au> wrote:

> On Sat, 2009-02-14 at 21:50 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.27 and 2.6.28.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> > be listed and let me know (either way).
> 
> Yes, this should still be listed.
> 
> I just tested against 2.6.29-rc5 and the problem is as bad as ever
> (perhaps worse?)
> 
> --- hermes-old.wumi.org.au ping statistics ---
> 900 packets transmitted, 448 received, +317 errors, 50% packet loss, time 899845ms
> rtt min/avg/max/mdev = 0.131/420.015/10890.699/1297.022 ms, pipe 11

i looked at the trace you did earlier and which you uploaded to:

  http://disenchant.net/tmp/bug-12465/trace-1/

Here is one 3 seconds (!) latency:

 0)  qemu-sy-4237  |               |      kvm_vcpu_block() {
 0)  qemu-sy-4237  |               |        kvm_cpu_has_interrupt() {
 0)  qemu-sy-4237  |               |          kvm_apic_has_interrupt() {
 0)  qemu-sy-4237  |   0.291 us    |          }
 0)  qemu-sy-4237  |               |          kvm_apic_accept_pic_intr() {
 0)  qemu-sy-4237  |   0.291 us    |          }
 0)  qemu-sy-4237  |   1.476 us    |        }
 0)  qemu-sy-4237  |               |        kvm_cpu_has_pending_timer() {
 0)  qemu-sy-4237  |   0.325 us    |        }
 0)  qemu-sy-4237  |               |        kvm_arch_vcpu_runnable() {
 0)  qemu-sy-4237  |   0.288 us    |        }
 0)  qemu-sy-4237  |               |        kvm_arch_vcpu_put() {
 0)  qemu-sy-4237  |   0.415 us    |        }
 0)  qemu-sy-4237  |               |        schedule() {
 0)  qemu-sy-4237  |               |          wakeup_preempt_entity() {
 0)  qemu-sy-4237  |   0.300 us    |          }
 ------------------------------------------
 0)  qemu-sy-4237  =>   ksoftir-4   
 ------------------------------------------

 0)   ksoftir-4    | ! 3010470 us |  }
 ------------------------------------------
 0)   ksoftir-4    =>  qemu-sy-4355 
 ------------------------------------------

 0)  qemu-sy-4355  |   1.575 us    |          }
 0)  qemu-sy-4355  |   6.520 us    |        }
 0)  qemu-sy-4355  |   7.121 us    |      }
 0)  qemu-sy-4355  |               |      __wake_up() {
 0)  qemu-sy-4355  |               |        __wake_up_common() {
 0)  qemu-sy-4355  |               |          autoremove_wake_function() {
 0)  qemu-sy-4355  |               |            default_wake_function() {

qemu-sy-4237 has been scheduled away, and the system appeared to have done
nothing in the meantime. That's not something that really looks like a
scheduler regression - there is nothing the scheduler can do if KVM
decides to block a task.

It would be nice to enhance this single-CPU trace some more - to more
surgically see what is going on. Firstly, absolute timestamps would be
nice:

  echo funcgraph-abstime  > trace_options
  echo funcgraph-proc     > trace_options

as it's a bit hard to see the global timescale of events.

Secondly, not all events are included - in particular i dont really see
the points when packets are passed. Would it be possible to add a tracing
hypercall so that the guest kernel can inject trace events that can be seen
on the native-side trace? Regarding ping latencies really just two things
matter: the loopback network device's rx and tx path. We should trace the
outgoing sequence number and the incoming sequence number of IP packets,
and inject that to the host side. This way we can correlate the delays
precisely.

	Ingo
