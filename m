Return-Path: <linux-kernel-owner+w=401wt.eu-S938665AbXGSKcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938665AbXGSKcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933476AbXGSKCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:02:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53229 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765391AbXGSKCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:02:21 -0400
Date: Thu, 19 Jul 2007 12:01:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070719100135.GA2986@elte.hu>
References: <20070716091236.GA10718@elte.hu> <20070718164341.GA6327@elte.hu> <20070719090930.GA27765@elte.hu> <200707191144.24434.olaf.kirch@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707191144.24434.olaf.kirch@oracle.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Olaf Kirch <olaf.kirch@oracle.com> wrote:

>  -	You say that netconsole output continues to trickle after
> 	the network gets wedged. This could be caused by the
> 	e1000 watchdog, which triggers a NIC interrupt "to ensure
> 	rx ring is cleaned". I assume that this triggers the
> 	regular e1000_intr, which succeeds in putting the NIC on
> 	the poll_list, and net_rx_action call dev->poll once.

no - it appears that 'trickle' only happened with one of your patches 
(to which i replied with that 'trickle' mail). With what i have booted 
now (only your original patch and nothing else, 100 Hz and !dynticks), 
netconsole output stopped here:

 Calling initcall 0xc0603f55: netpoll_init+0x0/0x39()
 initcall 0xc0603f55: netpoll_init+0x0/0x39() returned 0.
 initcall 0xc0603f55 ran for 0 msecs: netpoll_init+0x0/0x39()
 Calling initcall 0xc0604257: netlink_proto_init+0x0/0x12a()
 NET: Registered protocol family 16

and no output ever since - and the box has been up for a few minutes.

> So, can you verify whether there are any interrupts arriving on the 
> NIC after the network got wedged? You could also try ethtool -s eth0 
> msglevel 65535 - would be interesting to see what dmesg contains. If 
> there's little to no debug output from the driver, let it run for 10 
> seconds or so, in order to catch the e1000 watchdog timer a few times.

eth0's irq count is stuck at 5 interrupts - and has not changed for 
minutes.

i tried ethtool -s eth0 msglvl 65535, but (sa expected) there's no 
output. I've attached below ifconfig output and ethtool -S output - 
maybe that tells you something new about the state of eth0. (to me it 
only tells what we already know: tx timed out once and eth0 is stuck 
ever since.)

Btw., i definitely need your help with this bug as it's now hopelessly 
out of my league :-/

	Ingo

------------------>
eth0      Link encap:Ethernet  HWaddr 00:16:41:17:49:D2
          inet addr:10.0.1.15  Bcast:10.255.255.255  Mask:255.0.0.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:873 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 b)  TX bytes:87076 (85.0 KiB)
          Base address:0x2000 Memory:ee000000-ee020000 

NIC statistics:
     rx_packets: 0
     tx_packets: 873
     rx_bytes: 0
     tx_bytes: 87076
     rx_broadcast: 0
     tx_broadcast: 0
     rx_multicast: 0
     tx_multicast: 0
     rx_errors: 0
     tx_errors: 0
     tx_dropped: 0
     multicast: 0
     collisions: 0
     rx_length_errors: 0
     rx_over_errors: 0
     rx_crc_errors: 0
     rx_frame_errors: 0
     rx_no_buffer_count: 0
     rx_missed_errors: 0
     tx_aborted_errors: 0
     tx_carrier_errors: 0
     tx_fifo_errors: 0
     tx_heartbeat_errors: 0
     tx_window_errors: 0
     tx_abort_late_coll: 0
     tx_deferred_ok: 0
     tx_single_coll_ok: 0
     tx_multi_coll_ok: 0
     tx_timeout_count: 1
     tx_restart_queue: 0
     rx_long_length_errors: 0
     rx_short_length_errors: 0
     rx_align_errors: 0
     tx_tcp_seg_good: 0
     tx_tcp_seg_failed: 0
     rx_flow_control_xon: 0
     rx_flow_control_xoff: 0
     tx_flow_control_xon: 0
     tx_flow_control_xoff: 0
     rx_long_byte_count: 0
     rx_csum_offload_good: 0
     rx_csum_offload_errors: 0
     rx_header_split: 0
     alloc_rx_buff_failed: 0
     tx_smbus: 0
     rx_smbus: 0
     dropped_smbus: 0
