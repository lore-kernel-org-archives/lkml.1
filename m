Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbYLFCKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbYLFCKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 21:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbYLFCKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 21:10:35 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:45458 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbYLFCKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 21:10:35 -0500
Message-ID: <ac3eb2510812051810x8cf4256lf9fd31b15b9e0552@mail.gmail.com>
Date: Sat, 6 Dec 2008 03:10:33 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: Runaway loop with the current git.
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20081205212428.GB8075@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081205180350.GA25236@ioremap.net>
	 <20081205181610.518ecd13@lxorguk.ukuu.org.uk>
	 <ac3eb2510812051032g6b5ea866q30f097d765854196@mail.gmail.com>
	 <20081205192755.GA27712@ioremap.net>
	 <20081205193432.290a6f1a@lxorguk.ukuu.org.uk>
	 <20081205211223.GA8075@ioremap.net>
	 <ac3eb2510812051317q79ca88e9ya876ffb94162eeca@mail.gmail.com>
	 <20081205212428.GB8075@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2008 at 22:24, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> On Fri, Dec 05, 2008 at 10:17:01PM +0100, Kay Sievers (kay.sievers@vrfy.org) wrote:
>> > And what's with tty drivers? If kernel freezes there even if suddenly
>> > faulty userspace started to load them, where this can happen? Apparently
>> > it is not sleeping userspace since console does not respond to input.
>>
>> 5-1 dev_t request looks like something in initramfs accesses
>> /dev/console, but the driver for it is not properly
>> initialized/registered that time, and the kernel module loader tries
>> to load a module? The forked process might also try to access
>> /dev/console again, and hence the loop?
>
> But why system freezes? Is this init linking/__init calling order
> changes?

Can you add something like:
  +++ b/kernel/kmod.c
  @@ -108,6 +108,7 @@ int request_module(const char *fmt, ...)
                  return -ENOMEM;
          }

  +       printk("XXX call modprobe %s %s[%u]\n", module_name,
current->comm, task_pid_nr(current));

It may show which process is looking for /dev/console and causes
modprobe to run, and maybe we get an idea what's going on. It may at
least show if it's a /dev/console problem.

Thanks,
Kay
