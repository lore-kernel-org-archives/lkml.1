Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbYHKQE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbYHKQE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYHKQEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:04:14 -0400
Received: from web82107.mail.mud.yahoo.com ([209.191.84.220]:44252 "HELO
	web82107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751933AbYHKQEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:04:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=u/oLpcWnliIBtBSIYmfVlI0CfEyU0vKMs73VmQRa9aK+uBVcW/qF8NoQZVH2DxuXDkfIp4hBiLH1ge5Z5ms4UmhHck2mTd18OoBrzk05EqGsrhP0DWxeJ0TPEbtVoz6ThEDqtw591EI/sLcedlhS0y+5Tr75eFUDAQEcT6Xbl4Q=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Mon, 11 Aug 2008 09:04:12 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: [PATCH diagnostic] Re: HPET regression in 2.6.26 versus 2.6.25 -- RCU problem
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <433343.88181.qm@web82107.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I didn't check my email yesterday -- sorry about that, but sometimes life
intervenes -- so I'm a bit late replying.

Also, I see several messages relevant to this thread in my inbox:  I have
decided to address each in order, so that I don't mix something up and do
something foolish.



> And here is the patch.  It is still a bit raw, so the results should
> be viewed with some suspicion.  It adds a default-off kernel parameter
> CONFIG_RCU_CPU_STALL which must be enabled.

Thanks for the patch.  I had a problem applying the patch because I
have not yet transitioned my email system from my old machine to my new
3-system home network setup.  (I used to share a data partition between
Windows and Linux so that my archives would stay in sync; my new setup
will allow keeping the POP downloads on one machine, and sharing the
archives via IMAP, but even since May I still haven't gotten around to 
it.)

My ISP's webmail interface altered the whitespace, and I'm so new to
git that I couldn't figure out how to keep it from rejecting the
patch.  I had updated Linus' git tree to 2.6.27-rc2, and when I saw
that your patch was against something in 2.6.27-rc1 I thought this
might be the problem.  Visually inspecting the files, I saw that the
lines matched perfectly, other than whitespace, so I just gave up and
applied the patches manually.

I ran 'make menuconfig', but nothing about your new feature was asked.
Then I realized that I had changed the .config to CONFIG_PREEMPT because
of an experiment you had my try a few days ago.  When I disabled that,
I was able to see the new option and enable it.

The kernel built fine, so I installed and rebooted...


> Rather than exponential backoff, it backs off to once per 30 seconds.
> My feeling upon thinking on it was that if you have stalled RCU grace
> periods for that long, a few extra printk() messages are probably the
> least of your worries...

Well, I was hoping to see something interesting.  I ran it with parameters
"debug initcall_debug", and it locked up at the same place.  I let it for
15 minutes, in case of some delayed reaction.  Nada.

The output was nearly identical to what I posted last Tuesday (see
http://www.uwsg.indiana.edu/hypermail/linux/kernel/0808.0/2224.html).
Here are the last few lines:
==================================
[snip]
calling pci_bios_assign_resources+0x0/0x8b
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0xe000-0xefff
pci 0000:00:01.0:   MEM window: 0xfdd00000-0xfdefffff
pci 0000:00:01.0:   PREFETCH window: 0x000000d8000000-0x000000dfffffff
pci 0000:00:14.4: PCI bridge, secondary bus 0000:02
pci 0000:00:14.4:   IO window: 0xd000-0xdfff
pci 0000:00:14.4:   MEM window: 0xfdc00000-0xfdcfffff
pci 0000:00:14.4:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
initcall pci_bios_assign_resources returned 0 after 285702 msecs
calling inet_init+0x0/0x250
NET: Registered protocol family 2
===== END OUTPUT =================

The only difference in the output was trivial:  "285696 msecs" became
"285702 msecs".  None of the printk()'s from your driver were executed.

(As I mentioned on Tuesday, that number of milliseconds is WAY off, and
it still bothers me.  The total time from the GRUB screen disappearing
to the last line printed is < 5 secs (maybe < 3 secs), not 285 secs!)

Moving on to the other LKML messages....

Thanks,
Dave W.
