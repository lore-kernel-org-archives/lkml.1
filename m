Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYLEA2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYLEA2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 19:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbYLEA2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 19:28:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53574 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYLEA2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 19:28:04 -0500
Message-ID: <49387463.5070100@zytor.com>
Date: Thu, 04 Dec 2008 16:22:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
References: <20081204225345.654705757@linutronix.de>
In-Reply-To: <20081204225345.654705757@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> 
> We'd like to announce a brand new implementation of performance counter
> support for Linux. It is a very simple and extensible design that has the
> potential to implement the full range of features we would expect from such
> a subsystem.
> 

First of all, let me say I really like what I've seen so far.  The file
descriptor paradigm seems really elegant to me.

>  - Only one single new system call is needed: sys_perf_counter_open().
>    All performance-counter operations are implemented via standard
>    VFS APIs such as read() / fcntl() and poll().

As previously discussed, I think this should be a filesystem rather than
a system call.  There are a couple of advantages to doing it that way, IMO:

- Strings, rather than numbers, which means fewer constraints across
  architectures.
- The events available can be exported in the filesystem itself (via
  readdir) rather than via sysfs.
- Compatibility with existing tools, esp. non-C tools.

I'm thinking of something like:

/dev/perfctr/3/cache_misses/all/simple/300

i.e. /dev/perfctr/<cpu>/<event>/<pid>/<type>/<period>.  I am putting
<cpu> ahead of <event> in the hierarchy, so a readdir() on the <cpu>
directory can show the events available by name on that CPU.  Raw
hardware events can be accessed by something like
/dev/perfctr/<cpu>/0x4064/...

	-hpa
