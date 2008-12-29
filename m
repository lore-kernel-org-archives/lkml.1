Return-Path: <linux-kernel-owner+w=401wt.eu-S1751739AbYL2Or0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbYL2Or0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 09:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbYL2OrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 09:47:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42634 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbYL2OrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 09:47:17 -0500
Subject: Re: [PATCH] Fix race in ring_buffer_consume()
From: Steven Rostedt <srostedt@redhat.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <54882.124.179.251.206.1230523141.squirrel@secure.greenhost.nl>
References: <54882.124.179.251.206.1230523141.squirrel@secure.greenhost.nl>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 29 Dec 2008 09:47:11 -0500
Message-Id: <1230562031.4863.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-12-29 at 04:59 +0100, Indan Zupancic wrote:
> Hello,
> 
> While doing a grep -r as root somewhere in /proc, grep founds its way
> into /mnt/debug/tracing and caused the below snippet:
> 
> ------------[ cut here ]------------
> kernel BUG at /home/indan/src/linux-2.6/kernel/trace/ring_buffer.c:1676!
> invalid opcode: 0000 [#1] PREEMPT
> last sysfs file: /sys/devices/virtual/backlight/thinkpad_screen/brightness
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in: i915 drm pl2303 usbserial usb_storage uhci_hcd ehci_hcd
> usbcore
> 
> Pid: 10660, comm: grep Not tainted (2.6.28phc #12) 2371GHG
> EIP: 0060:[<c0241464>] EFLAGS: 00010246 CPU: 0
> EIP is at rb_advance_reader+0xe/0xd7
> EAX: 00000000 EBX: f703c000 ECX: f717ea80 EDX: 00000003
> ESI: f70081c0 EDI: f7008240 EBP: 00000fff ESP: f6ac2f3c
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process grep (pid: 10660, ti=f6ac2000 task=f689b900 task.ti=f6ac2000)
> Stack:
>  f703c000 f70081c0 00000000 c024171e f2de2000 f2de2000 f2de3038 c0242fc8
>  00000a6a c0245105 089adff4 f2dca400 f2de2010 00005000 f2dca400 c0244f8f
>  089adff4 c0263633 f6ac2fa0 f2dca400 fffffff7 00001000 f6ac2000 c02636f9
> Call Trace:
>  [<c024171e>] ring_buffer_consume+0x2b/0x31
>  [<c0242fc8>] trace_consume+0x1d/0x23
>  [<c0245105>] tracing_read_pipe+0x176/0x1dc
>  [<c0244f8f>] tracing_read_pipe+0x0/0x1dc
>  [<c0263633>] vfs_read+0x73/0xa1
>  [<c02636f9>] sys_read+0x3c/0x63
>  [<c0202ef5>] sysenter_do_call+0x12/0x2a
> Code: 00 25 00 f0 ff ff e8 f9 fb ff ff 85 c0 74 05 e8 8c 61 1c 00
> 89 f0 5e 5f 5b 5e 5f 5d c3 57 89 c7 56 53 e8 c2 fe ff ff 85 c0 75
> 04 <0f> 0b eb fe 8b 47 1c 8b 70 1c 03 70 10 8a 06 24 03 3c 03 75 03
> EIP: [<c0241464>] rb_advance_reader+0xe/0xd7 SS:ESP 0068:f6ac2f3c
> ---[ end trace 77bf081d52bacbc7 ]---
> note: grep[10660] exited with preempt_count 1
> 
> I think preemptirqsoff tracing is enabled, can't check because doing
> cat on most files in debug/tracing hangs. Kernel was booted with
> initcall_debug. Kernel is 2.6.28.
> 
> $ zcat /proc/config.gz |grep TRACER=
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_IRQSOFF_TRACER=y
> CONFIG_PREEMPT_TRACER=y
> CONFIG_CONTEXT_SWITCH_TRACER=y
> CONFIG_BOOT_TRACER=y
> 
> ring_buffer.c:1676:
> 
> static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
> {
> 	struct ring_buffer_event *event;
> 	struct buffer_page *reader;
> 	unsigned length;
> 
> 	reader = rb_get_reader_page(cpu_buffer);
> 
> 	/* This function should not be called when buffer is empty */
> 	BUG_ON(!reader);
> 
> Called by ring_buffer_consume():
> 
> ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
> {
> 	struct ring_buffer_per_cpu *cpu_buffer;
> 	struct ring_buffer_event *event;
> 
> 	if (!cpu_isset(cpu, buffer->cpumask))
> 		return NULL;
> 
> 	event = ring_buffer_peek(buffer, cpu, ts);
> 	if (!event)
> 		return NULL;
> 
> 	cpu_buffer = buffer->buffers[cpu];
> 	rb_advance_reader(cpu_buffer);
> 
> ring_buffer_peek() is complicated, but boils down to:
> 
> ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
> {
> [...]
> 	cpu_buffer = buffer->buffers[cpu];
> [...]
> 	reader = rb_get_reader_page(cpu_buffer);
> 	if (!reader)
> 		return NULL;
> 
> 	event = rb_reader_event(cpu_buffer);
> [...]
> 	return event or return NULL;
> }
> 
> So between the rb_get_reader_page() call in ring_buffer_peek() and
> the one in rb_advance_reader() something happened causing the event
> to disappear. Also note: grep[10660] exited with preempt_count 1.
> There's no locking between the ring_buffer_peek and rb_advance_reader
> calls in ring_buffer_consume, so a tentative guess is that there should
> be some.
> 
> Then again, the double tracing_read_pipe() in the backtrace seems weird,
> so maybe something else is going on.
> 
> Easiest fix seems to merge ring_buffer_peek and ring_buffer_consume into
> ring_buffer_get, which is the same as the current peek, but with an extra
> parameter telling it to consume the buffer or not.
> 
> The same might be needed for ring_buffer_iter_peek() and ring_buffer_read().
> 
> Patch doing this:
> 
> commit 648cf957210619595856b78f12bd11752ae22aa5
> Author: Indan Zupancic <indan@nul.nu>
> Date:   Mon Dec 29 14:27:18 2008 +1100
> 
>     Fix race in ring_buffer_consume(): Replace ring_buffer_consume and
> ring_buffer_peek with ring_buffer_get_event
> 
>     Signed-off-by: Indan Zupancic <indan@nul.nu>
> 
>  include/linux/ring_buffer.h   |    4 +---
>  kernel/trace/ring_buffer.c    |   39 ++++++++-------------------------------
>  kernel/trace/trace.c          |   15 ++++++++-------
>  kernel/trace/trace_selftest.c |    2 +-
>  4 files changed, 18 insertions(+), 42 deletions(-)

Hi Indan,

I really would like to analyze this more, but I'm on leave till
January 5th. I'll definitely take a good look at what is happening then.

Thanks,

-- Steve


