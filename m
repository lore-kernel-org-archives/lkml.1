Return-Path: <linux-kernel-owner+w=401wt.eu-S1751359AbXEXQSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbXEXQSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750738AbXEXQSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:18:13 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707AbXEXQSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:18:12 -0400
Date: Thu, 24 May 2007 09:16:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Romano Giannetti <romanol@upcomillas.es>
cc: Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch 00/69] -stable review
In-Reply-To: <1180008394.15600.26.camel@localhost>
Message-ID: <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org>  <4652070D.3090509@redhat.com>
  <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org> 
 <20070521212522.GL3429@sequoia.sous-sol.org>  <1179870110.16656.2.camel@localhost>
  <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
 <1180008394.15600.26.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 24 May 2007, Romano Giannetti wrote:
> 
> I discovered that SysRq-t works during the pause. So I pressed it more
> or less halfway the pause; the full result is here:
> http://www.dea.icai.upcomillas.es/romano/linux/info/dmesg-resume.txt
> 
> It seems that most of the tasks are in
> 
> [<c0138931>] refrigerator+0x41/0x60

Yeah, but the interesting one is this pair:

  events/0      R running     0     4      1 (L-TLB)

  sleep.sh      D 0000014F     0  5798   5789 (NOTLB)
  Call Trace:
   [<c01d3c01>] kobject_uevent_env+0x3a1/0x4a0
   [<c02d8509>] wait_for_completion+0x79/0xb0
   [<c0116640>] default_wake_function+0x0/0x10
   [<c0238a08>] _request_firmware+0x1c8/0x310
   [<c0238bef>] request_firmware+0xf/0x20
   [<e0a35d5d>] pcmcia_bus_match+0x28d/0x3c0 [pcmcia]
   [<c02864a7>] netlink_broadcast+0x1f7/0x310
   [<c0233d74>] driver_probe_device+0x34/0xc0
   [<c02d79ee>] klist_next+0x4e/0xa0
   [<c0233014>] bus_for_each_drv+0x44/0x70
   [<c0233eba>] device_attach+0x7a/0x80
   [<c0233e00>] __device_attach+0x0/0x10
   [<c0232f56>] bus_attach_device+0x26/0x60
   [<c0231d06>] device_add+0x5e6/0x6e0
   [<c01d350f>] kobject_init+0x2f/0x50
   [<e0a360f5>] pcmcia_device_add+0x185/0x220 [pcmcia]
   [<e0a36261>] pcmcia_card_add+0xa1/0xc0 [pcmcia]
   [<e0913900>] ti12xx_power_hook+0x180/0x1d0 [yenta_socket]
   [<e0a36300>] ds_event+0x80/0xb0 [pcmcia]
   [<e0967359>] send_event+0x39/0x70 [pcmcia_core]
   [<e09677b6>] socket_insert+0x86/0xe0 [pcmcia_core]
   [<e0967c2b>] pcmcia_socket_dev_resume+0x7b/0x90 [pcmcia_core]
   [<c01e135f>] pci_device_resume+0x1f/0x60
   [<c023815f>] resume_device+0x5f/0xf0

ie we have a deadlock because resume wants to do that firmware request,
but the event daemon is apparently spinning like mad. 

And yes, request_firmware() has a "loading_timeout" in seconds.  And
it's 60. So that explains your pause right there!

It might be some unfortunate interaction with process freezing (my
favorite whipping boy), but it could also be something else.  I suspect
we should treat suspend/resume as a bootup event, and not allow execve()
for that case at all. Right now we have:

        retval = -EPERM;
        if (current->fs->root)
                retval = kernel_execve(sub_info->path,
                                sub_info->argv, sub_info->envp);

in kernel/kmod.c, and that "current->fs->root" thing basically protects
us from trying to run a user-mode helper early in the boot sequence, but
we might want to add a conditional like "&& !resuming" to that test..

		Linus

