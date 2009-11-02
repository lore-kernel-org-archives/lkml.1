Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbZKBRWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbZKBRWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbZKBRWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:22:00 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:48034 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZKBRV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:21:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sVYrM3Hlku7gVU+Xzc/OdoTyfMjVp8ld9G/EJ1V6QJc0BC92jOMBNgmkW7xd7YOzGA
         4MZdyT1b4JUKt2W76jDVraIMwI4OsbWSlGmgf8HvTzcsezwCSNog7VNPY2qRbiz8921q
         6iTHlrFDlFgtiHR4yY+PeraxAPSZg/8ZvYhJY=
Message-ID: <4AEF1534.4090506@gmail.com>
Date: Mon, 02 Nov 2009 12:21:56 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [net-next-2.6 PATCH RFC] TCPCT part 1d: generate Responder Cookie
References: <4AEAC763.4070200@gmail.com> <4AED86AD.6010906@gmail.com> <4AEDCD7C.2010403@gmail.com> <4AEEB6D2.7090505@gmail.com> <4AEEBAC6.7020308@gmail.com> <4AEED23A.7070009@gmail.com> <4AEEDBBC.40800@gmail.com>
In-Reply-To: <4AEEDBBC.40800@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Large part of network code is run by softirq handler, and a softirq handler
> is not preemptable with another softirq (including itself).
> 
Thank you.  That's helpful to know, as some existing locks have a "bh".
I've never figured out the ip_local_deliver_finish() context.

Knowing that there can only be one instance of the tcp stack running at
any one time, and the cpu never changes even after being interrupted, will
make it much easier to code.


>> Perhaps a function header comment that mentions it?
> 
> So we are going to add a header to thousand of functions repeating this prereq ?
> 
That's my usual practice.  (Dozens would be more accurate in this case.)
I've always found it helpful for those coming after me, and sure would have
found it helpful now myself....  Repetitious, but well worth it.

Especially at tcp_v4_rcv(), as that's called through a vector named
"handler", which was particularly hard to track down.

It has an innocuous header "From tcp_input.c", that doesn't seem to have
anything to do with current reality....  (It's really called from
ip_input.c via af_inet.c).


>> All I know is (from testing) that the tcp_minisockets.c caller is sometimes
>> called in a fashion that requires atomic allocation, and other times
>> does not!
> 
> Maybe callers have different contexts (running from softirq handler or
> from process context). Atomic ops are expensive and we try to avoid them
> if/when possible.
> 
>> See my "Subject: query: tcpdump versus atomic?" thread from Oct 14th.
> 
> You probably add a bug in your kernel, leaving a function with unpaired lock/unlock
> of notallow_something/allow_something
> 
(No, I've not yet added locks; obviously, I'm still asking about them.)

Unlikely, as it was easy to reproduce by changing one line, without *any* of
my code present.  Usually works, but doesn't work with tcpdump running on
the interface:

  struct sock *tcp_create_openreq_child(struct sock *sk, struct request_sock *req, struct sk_buff *skb)
  {
-	struct sock *newsk = inet_csk_clone(sk, req, GFP_ATOMIC);
+	struct sock *newsk = inet_csk_clone(sk, req, GFP_KERNEL);

  	if (newsk != NULL) {


[    2.876485] eth0: RealTek RTL8139 at 0x2000, 00:40:2b:6b:61:36, IRQ 17
[    2.876490] eth0:  Identified 8139 chip type 'RTL-8101'


[   88.997594] device eth0 entered promiscuous mode
[  114.827403] BUG: scheduling while atomic: swapper/0/0x10000100
[  114.827462] Modules linked in: lp snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd ppdev iTCO_wdt iTCO_vendor_support psmouse soundcore parport_pc intel_agp parport agpgart pcspkr serio_raw shpchp snd_page_alloc 8139too aic7xxx 8139cp 
scsi_transport_spi mii floppy
[  114.827493]
[  114.827497] Pid: 0, comm: swapper Not tainted (2.6.32-rc3 #4) Imperial
[  114.827501] EIP: 0060:[<c0123295>] EFLAGS: 00000246 CPU: 0
[  114.827512] EIP is at native_safe_halt+0x5/0x10
[  114.827515] EAX: c0740000 EBX: 00000000 ECX: ffff4b6e EDX: 00000000
[  114.827519] ESI: c07992c0 EDI: c0743000 EBP: c0741fa0 ESP: c0741fa0
[  114.827522]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  114.827525] CR0: 8005003b CR2: 09278fc4 CR3: 04b56000 CR4: 00000690
[  114.827529] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  114.827532] DR6: ffff0ff0 DR7: 00000400
[  114.827535] Call Trace:
[  114.827546]  [<c01098b5>] default_idle+0x65/0x90
[  114.827550]  [<c0102062>] cpu_idle+0x52/0x90
[  114.827558]  [<c056cc23>] rest_init+0x53/0x60
[  114.827565]  [<c079c93d>] start_kernel+0x328/0x390
[  114.827569]  [<c079c3ce>] ? unknown_bootoption+0x0/0x1f6
[  114.827574]  [<c079c07e>] i386_start_kernel+0x7e/0xa8
[  136.570632] device eth0 left promiscuous mode


> There are books about linux internals that you could read if you want some extra
> documentation. Dont ask me details, I never read them :)
> 
Sorry, I've only read much of the Documentation directory (some parts
repeatedly), and Googled for more specific information.  Pretty sparse!

Thank you again for your patient explanation.
