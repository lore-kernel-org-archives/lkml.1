Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbXGZHHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbXGZHHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 03:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761238AbXGZHH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 03:07:26 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:50580 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760978AbXGZHHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 03:07:25 -0400
Date: Thu, 26 Jul 2007 16:06:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: jidong xiao <jidong.xiao@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What's does KPROBE_ENTRY mean?
Message-ID: <20070726070652.GA26229@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	jidong xiao <jidong.xiao@gmail.com>, linux-kernel@vger.kernel.org
References: <4104961b0706202213p16df5ca5s579de4b949efbf16@mail.gmail.com> <4104961b0707252243l41addce8wca35d19c5de729ee@mail.gmail.com> <20070726061117.GA25926@linux-sh.org> <4104961b0707252350g163dc133r420422dd4dde40f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4104961b0707252350g163dc133r420422dd4dde40f2@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 02:50:38PM +0800, jidong xiao wrote:
> Thanks.So if I don't care any probes, and I actually don't need to
> take use of kprobes, then I can use the functions defined through
> KPROBE_ENTRY() the same way as those defined via ENTRY(), right?
> 
Yes, there's nothing special about KPROBE_ENTRY() other than the section
placement. It even wraps in to ENTRY() after the .pushsection.

As you can see from kernel/kprobes.c:

	static int __kprobes in_kprobes_functions(unsigned long addr)
	{
		if (addr >= (unsigned long)__kprobes_text_start &&
		    addr < (unsigned long)__kprobes_text_end)
			return -EINVAL;
		return 0;
	}


...

and in __register_kprobe():

        if (!kernel_text_address((unsigned long) p->addr) ||
            in_kprobes_functions((unsigned long) p->addr))
                return -EINVAL;

So the only behavioural change for these symbols is that insertion of
probes is prohibited. There is nothing inherently special about them
otherwise, and platforms that don't enable kprobes aren't going to
care either.

One curious thing is that while KPROBE_ENTRY() unconditionally does
a .pushsection .kprobes.text, __kprobes does this conditionally
depending on CONFIG_KPROBES. While this doesn't hurt anything, it's
inconsistent to say the least. We should probably either make __kprobes
explicitly always use .kprobes.text, or just wrap KPROBE_ENTRY to ENTRY
directly and forego the .pushsection when CONFIG_KPROBES=n.
