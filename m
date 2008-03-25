Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbYCYF37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbYCYF37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 01:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbYCYF3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 01:29:50 -0400
Received: from mail.suse.de ([195.135.220.2]:60642 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbYCYF3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 01:29:49 -0400
From: Neil Brown <neilb@suse.de>
To: "Andrew Paprocki" <andrew@ishiboo.com>
Date: Tue, 25 Mar 2008 16:29:36 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18408.36288.352280.87141@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24.3 kernel panic in md raid1d queue_delayed_work_on
In-Reply-To: message from Andrew Paprocki on Sunday March 16
References: <76366b180803152325x63424d09vb775b5ed44b961e1@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday March 16, andrew@ishiboo.com wrote:
> I had an embedded machine hang last night with a kernel panic in
> queue_delayed_work_on. I couldn't scroll back the terminal to get more
> of the trace, but I jotted down what I could see on the screen. This
> is a Geode LX system running a SATA RAID1 array as md0 on a SiI 3114
> controller using libata. Any ideas? If the .config or boot log from
> this machine would be useful, let me know and I'll get them.

I'm afraid there isn't much here to base any guesses on.

> 
> Thanks,
> -Andrew
> 
> ----- top of scrollback
> handle_IRQ_event+0x1a/0x3f
> handle_level_irq+0x4f/0x84
> do_IRQ+0x53/0x6b
> common_interrupt+0x23/0x28
> __make_request+0x480/0x48a
> generic_make_request+0x1fd/0x22a
> common_interrupt+0x23/0x28
> __generic_unplug_device+0x14/0x1f
> generic_unplug_device+0x6/0x8
> blk_remove_plug+0x4e/0x5a

blk_remove_plug is always called with interrupts disabled.  So why
there are "do_IRQ" and similar calls further up the stack is
surprising.
However the list of function names is only indicative, not
definitive.... 

> raid1d+0xc3/0xc35
> irq_exit+0x40/0x58
> do_IRQ+0x58/0x6b
> update_curr+0x52/0xc4
> schedule+0x1f3/0x20d
> schedule_timeout+0x13/0x97
> sys_capget+0x54/0xcb
> md_thread+0xb5/0xcb
> autoremove_wake_function+0x0/0x35
> md_thread+0x0/0xcb
> kthread+0x36/0x5c
> kthread+0x0/0x5c
> kernel_thread_helper+0x7/0x10
> 
> Code: 8d 50 10 e9 48 ff ff ff 31 d2 e9 41 ff ff ff 57 89 c7 56 89 d6
> 53 8d 59 3(clipped)
>  0f ba 29 00 19 c0 31 d2 85 c0 75 61 83 79 10 00 74 04 <0f> 0b eb fe
                                                          ^^^^^^

This shows that it died on a "BUG" or "BUG_ON" call.  Did you see the
text of that?

Why do you say there was "a kernel panic in queue_delayed_work_on".
What exactly provided that information?

NeilBrown


> 8d 41 04 3(clipped)
>  41 04 74 04 0f 0b eb fe 8b 01 8b 16 a8
> EIP: [<c022609a>] queue_delayed_work_on+0x1c/0x7d SS:ESP 0068:cf359d80
> Kernel panic - not syncing: Fatal exception in interrupt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
