Return-Path: <linux-kernel-owner+w=401wt.eu-S1759739AbYGPWnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739AbYGPWnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 18:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758441AbYGPWmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 18:42:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758264AbYGPWmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 18:42:44 -0400
Message-ID: <487E78ED.30804@redhat.com>
Date: Wed, 16 Jul 2008 18:40:45 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
 (part1: use kprobe symbol_name/offset instead of address)
References: <1216146802.3312.95.camel@localhost.localdomain>
In-Reply-To: <1216146802.3312.95.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> One of the big nasties of systemtap is the way it tries to embed
> virtually the entirety of the kernel symbol table in the probe modules
> it constructs.  This is highly undesirable because it represents a
> subversion of the kernel API to gain access to unexported symbols.  At
> least for kprobes, the correct way to do this is to specify the probe
> point by symbol and offset.
> 
> This patch converts systemtap to use the correct kprobe
> symbol_name/offset pair to identify the probe location.

Hi James,

I think your suggestion is a good step. Of course, it might
have to solve some issues.

Unfortunately, current kprobe's symbol_name interface is not
so clever. For example, if you specify a static function
which is defined at several places in the kernel(ex. do_open),
it always pick up the first one in kallsyms, even if systemtap
can find all of those functions.
(you can find many duplicated symbols in /proc/kallsyms)

So, we might better improve kallsyms to treat this case
and find what is a better way to specify symbols and addresses.

> 
> This only represents a baby step:  after this is done, there are at
> least three other consumers of the systemtap module relocation
> machinery:
> 
>      1. unwind information.  I think the consumers of this can be
>         converted to use the arch specific unwinders that already exist
>         within the kernel
>      2. systemtap specific functions that use kernel internals.  This
>         was things like get_cycles() but I think they all now use a
>         sanctioned API ... need to check

Sure, those functions must be well isolated from other parts of kernel.
unfortunately, relayfs is not enough isolated. see below;
http://sources.redhat.com/bugzilla/show_bug.cgi?id=6487

>      3. Access to unexported global variables used by the probes.  This
>         one is a bit tricky; the dwarf gives a probe the ability to
>         access any variable available from the probed stack frame,
>         including all globals.  We could just make the globals off
>         limits, but that weakens the value of the debugger.
>         Alternatively, we could expand the kprobe API to allow probes
>         access to named global variables (tricky to get right without
>         effectively giving general symbol access).  Thoughts?

Could we provide a separated GPL'd interface to access named global
symbols which is based on kallsyms?

Thank you,

> If you're going to try this out, you currently need to specify --kelf on
> the command line to tell systemtap to use the kernel elf to derive
> symbol names and offsets (it will just segfault without this ATM).
> 
> James

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

