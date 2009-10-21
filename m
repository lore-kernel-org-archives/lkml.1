Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbZJUSJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbZJUSJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 14:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZJUSJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 14:09:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43013 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbZJUSJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 14:09:19 -0400
Subject: Re: [PATCH -v4 9/9] tracing: add function graph tracer support for
 MIPS
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: David Daney <ddaney@caviumnetworks.com>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
In-Reply-To: <4ADF4982.9010306@caviumnetworks.com>
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
	 <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
	 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>
	 <96110ea5dd4d3d54eb97d0bb708a5bd81c7a50b5.1256135456.git.wuzhangjin@gmail.com>
	 <5dda13e8e3a9c9dba4bb7179183941bda502604f.1256135456.git.wuzhangjin@gmail.com>
	 <af3ec1b5cd06b6f6a461c9fa7d09a51fabccb08d.1256135456.git.wuzhangjin@gmail.com>
	 <a6f2959a69b6a77dd32cc36a5c8202f97d524f1e.1256135456.git.wuzhangjin@gmail.com>
	 <53bdfdd95ec4fa00d4cc505bb5972cf21243a14d.1256135456.git.wuzhangjin@gmail.com>
	 <1256141540.18347.3118.camel@gandalf.stny.rr.com>
	 <4ADF38D5.9060100@caviumnetworks.com>
	 <1256143568.18347.3169.camel@gandalf.stny.rr.com>
	 <4ADF3FE0.5090104@caviumnetworks.com>
	 <1256145813.18347.3210.camel@gandalf.stny.rr.com>
	 <4ADF4982.9010306@caviumnetworks.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 21 Oct 2009 14:09:22 -0400
Message-Id: <1256148562.18347.3264.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 10:48 -0700, David Daney wrote:

> Although I am quite interested in ftrace for MIPS, I a haven't spent the 
> effort to try to figure out how many levels of backtrace we need to be 
> generating here.
> 
> If you only need the caller's address, that is passed in register 'at'. 
>   If you need more than that, then things get tricky.  I would do one of 
> two things:

Ftrace function tracer only needs the address passed in by AT. That
output looks like this (run on x86):

# tracer: function
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
          <idle>-0     [000] 140973.465592: mwait_idle <-cpu_idle
          <idle>-0     [000] 140973.465592: need_resched <-mwait_idle
          <idle>-0     [000] 140973.465593: test_ti_thread_flag <-need_resched
          <idle>-0     [000] 140973.465593: T.389 <-mwait_idle
          <idle>-0     [000] 140973.465594: need_resched <-mwait_idle
          <idle>-0     [000] 140973.465594: test_ti_thread_flag <-need_resched
          <idle>-0     [000] 140973.465594: trace_power_end <-mwait_idle
          <idle>-0     [000] 140973.465595: test_ti_thread_flag <-cpu_idle
          <idle>-0     [000] 140973.465595: enter_idle <-cpu_idle
          <idle>-0     [000] 140973.465596: mwait_idle <-cpu_idle
          <idle>-0     [000] 140973.465596: need_resched <-mwait_idle
          <idle>-0     [000] 140973.465596: test_ti_thread_flag <-need_resched
          <idle>-0     [000] 140973.465597: T.389 <-mwait_idle

Which is very useful to have. But what we are trying to get is the
function graph tracer working. This is based off of ftrace's function
tracer. But it does a trick with the return address. Instead of just
reading it, it modifies it to call a hook (note kprobes does the same
thing). We replace the return address with a function that will also
trace the exit of the function. With this, we get a much nicer looking
trace, and also can record the time it took to execute the function
(note, graph tracing has overhead that skews this time).

Here's an example (again on x86):

# tracer: function_graph
#
# CPU  DURATION                  FUNCTION CALLS
# |     |   |                     |   |   |   |
 0)   0.535 us    |  find_vma();
 0)               |  handle_mm_fault() {
 0)               |    count_vm_event() {
 0)   0.333 us    |      test_ti_thread_flag();
 0)   1.029 us    |    }
 0)   0.336 us    |    pud_alloc();
 0)   0.333 us    |    pmd_alloc();
 0)   0.389 us    |    _spin_lock();
 0)               |    do_wp_page() {
 0)   0.322 us    |      vm_normal_page();
 0)   0.329 us    |      reuse_swap_page();
 0)               |      unlock_page() {
 0)               |        wake_up_page() {
 0)   0.352 us    |          page_waitqueue();
 0)   0.442 us    |          __wake_up_bit();
 0)   1.790 us    |        }
 0)   2.444 us    |      }
 0)               |      _spin_unlock() {
 0)   0.371 us    |        T.272();
 0)   1.089 us    |      }


> 
> 1) Use the mechanism used by the OOPS dump.
> 
> 2) Implement back traces based on DWARF2 unwinding data that is 
> generated by the compiler.


We're not doing back traces. We need to modify the return of the
function being called. Note, the above functions that end with ";" are
leaf functions. Non leaf functions show "{" and end with "}".

The trick here is to find a reliable way to modify the return address.

Thanks,

-- Steve


