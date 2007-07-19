Return-Path: <linux-kernel-owner+w=401wt.eu-S938700AbXGSKdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938700AbXGSKdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760491AbXGSKSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:18:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57989 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938027AbXGSKSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:18:13 -0400
Date: Thu, 19 Jul 2007 12:17:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@ORACLE.COM>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070719101756.GA7277@elte.hu>
References: <20070716091236.GA10718@elte.hu> <200707181404.20458.olaf.kirch@oracle.com> <20070718124856.GB31215@elte.hu> <200707181641.45338.olaf.kirch@oracle.com> <20070718164341.GA6327@elte.hu> <20070719090930.GA27765@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719090930.GA27765@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> the e1000 in this laptop is historically pretty robust. The only 
> problem i ever had with it were some rx/tx hw-engine latency problems 
> [pings from the outside took up to 1 second to propagate] that were 
> quickly fixed by the e1000 driver guys. Maybe that's related. 
> (although it never caused total inavailability of networking - it was 
> only latency problems)

i've Cc:-ed Auke - maybe he has some ideas? I've also attached all the 
other possibly relevant ethtool dumps of eth0 below, done when the hung 
interface happens. (Auke, see more details about this problem in this 
thread on lkml.)

another thing: how can i make the tx timeout much longer than it is 
right now? Maybe an interrupt is delayed for long and we just dont 
tolerate things long enough - and once the device tx timeout has been 
noticed we kill the interface from subsequent use in essence?

there's one oddity i noticed:

 0x02810: RDH   (Receive desc head)       0x00000000
 0x02818: RDT   (Receive desc tail)       0x000000FE

 0x03810: TDH   (Transmit desc head)      0x00000000
 0x03818: TDT   (Transmit desc tail)      0x00000000

doesnt this suggest that we have a receive packet, just the irq didnt 
come and we didnt process it?

although .. the tx timeout disabled the transmitter and the receiver of 
the device, correct? That in itself could have destroyed any evidence of 
what happened earlier on. But ... i'm really only guessing here.

	Ingo

------------------------------------>

MAC Registers
-------------
0x00000: CTRL (Device control register)  0x00140248
      Endian mode (buffers):             little
      Link reset:                        reset
      Set link up:                       1
      Invert Loss-Of-Signal:             no
      Receive flow control:              disabled
      Transmit flow control:             disabled
      VLAN mode:                         disabled
      Auto speed detect:                 disabled
      Speed select:                      1000Mb/s
      Force speed:                       no
      Force duplex:                      no
0x00008: STATUS (Device status register) 0x80080783
      Duplex:                            full
      Link up:                           link config
      TBI mode:                          disabled
      Link speed:                        1000Mb/s
      Bus type:                          PCI
      Bus speed:                         33MHz
      Bus width:                         32-bit
0x00100: RCTL (Receive control register) 0x00008002
      Receiver:                          enabled
      Store bad packets:                 disabled
      Unicast promiscuous:               disabled
      Multicast promiscuous:             disabled
      Long packet:                       disabled
      Descriptor minimum threshold size: 1/2
      Broadcast accept mode:             accept
      VLAN filter:                       disabled
      Cononical form indicator:          disabled
      Discard pause frames:              filtered
      Pass MAC control frames:           don't pass
      Receive buffer size:               2048
0x02808: RDLEN (Receive desc length)     0x00001000
0x02810: RDH   (Receive desc head)       0x00000000
0x02818: RDT   (Receive desc tail)       0x000000FE
0x02820: RDTR  (Receive delay timer)     0x00000000
0x00400: TCTL (Transmit ctrl register)   0x310000F8
      Transmitter:                       disabled
      Pad short packets:                 enabled
      Software XOFF Transmission:        disabled
      Re-transmit on late collision:     enabled
0x03808: TDLEN (Transmit desc length)    0x00001000
0x03810: TDH   (Transmit desc head)      0x00000000
0x03818: TDT   (Transmit desc tail)      0x00000000
0x03820: TIDV  (Transmit delay timer)    0x00000008
PHY type:                                M88
Offset		Values
------		------
0x0000		00 16 41 17 49 d2 30 0b b2 ff 51 00 ff ff ff ff 
0x0010		53 00 03 01 6b 02 01 20 aa 17 9a 10 86 80 df 80 
0x0020		00 00 00 20 54 7e 00 00 14 00 da 00 04 00 00 27 
0x0030		c9 6c 50 31 3e 07 0b 04 8b 29 00 00 00 f0 02 0f 
0x0040		08 10 00 00 04 0f ff 7f 01 4d ff ff ff ff ff ff 
0x0050		14 00 1d 00 14 00 1d 00 af aa 1e 00 00 00 1d 00 
0x0060		00 01 00 40 1f 12 07 40 ff ff ff ff ff ff ff ff 
0x0070		ff ff ff ff ff ff ff ff ff ff ff ff ff ff ef 9f 
Ring parameters for eth0:
Pre-set maximums:
RX:		4096
RX Mini:	0
RX Jumbo:	0
TX:		4096
Current hardware settings:
RX:		256
RX Mini:	0
RX Jumbo:	0
TX:		256

driver: e1000
version: 7.3.20-k2-NAPI
firmware-version: 0.5-1
bus-info: 0000:02:00.0
Offload parameters for eth0:
rx-checksumming: on
tx-checksumming: on
scatter-gather: on
tcp segmentation offload: on
udp fragmentation offload: off
generic segmentation offload: off
NIC statistics:
     rx_packets: 0
     tx_packets: 591
     rx_bytes: 0
     tx_bytes: 58116
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
