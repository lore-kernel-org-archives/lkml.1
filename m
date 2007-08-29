Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbXH2Wec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbXH2Wec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 18:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760272AbXH2WeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 18:34:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759905AbXH2WeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 18:34:14 -0400
Message-ID: <46D5F462.9010401@redhat.com>
Date: Wed, 29 Aug 2007 17:34:10 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jesper Juhl <jesper.juhl@gmail.com>
Subject: 4KSTACKS + DEBUG_STACKOVERFLOW harmful
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed today that the combination of 4KSTACKS and DEBUG_STACKOVERFLOW
config options is a bit deadly.

DEBUG_STACKOVERFLOW warns in do_IRQ if we're within THREAD_SIZE/8 of the
end of useable stack space, or 512 bytes on a 4k stack.

If we are, then it goes down the dump_stack path, which uses most, if
not all, of the remaining stack, thereby turning a well-intentioned
warning into a full-blown catastrophe.

The callchain from the warning looks something like this, with stack
usage shown as found on my x86 box:

4 dump_stack
4   show_trace
8     show_trace_log_lvl
4       dump_trace
          print_context_stack
12          print_trace_address
              print_symbol
232             __print_symbol
164               sprint_symbol
20                  printk
___
448

448 bytes to tell us that we're within 512 bytes (or less) of certain
doom... and I think there's call overhead on top of that?

The large stack usage in those 2 functions is due to big char arrays, of
size KSYM_NAME_LEN (128 bytes) and KSYM_SYMBOL_LEN (223 bytes).

IOW, the stack warning effectively reduces useful stack left in our itty
bitty 4k stacks by over 10%.

Any suggestions for ways around this?  The warning is somewhat helpful,
and I guess the obvious option is to lighten up the dump_stack path, but
it's still effectively reducing precious available stack space by some
amount.

With CONFIG_DEBUG_STACK_USAGE, we could print at oops time: "oh, and by
the way, you blew your stack" if there is no zeroed stack space left, as
a post-mortem.  Even without that option, I think we could still check
whether the *current* %esp at oops time has gone too far?  But if we
blew the stack, returned, and *then* oops, I think it'd be hard to know
without the DEBUG_STACK_USAGE option that we ran out of room.

-Eric
