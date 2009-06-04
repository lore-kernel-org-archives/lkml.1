Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbZFDQeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbZFDQeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbZFDQeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:34:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52621 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbZFDQeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:34:10 -0400
Date: Thu, 4 Jun 2009 12:34:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Philipp Reh <sefi@s-e-f-i.de>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: When does Linux drop UDP packets?
In-Reply-To: <alpine.DEB.2.00.0906041222450.14994@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0906041228170.14994@gandalf.stny.rr.com>
References: <20090604145347.GA27692@miyuki> <20090604155741.GA8999@goodmis.org> <20090604161015.GA17303@miyuki> <alpine.DEB.2.00.0906041222450.14994@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Oh, btw, you don't need to strip LKML from replys (or any Cc), unless it 
is off topic.  LKML is a public forum, and as long as things are on topic, 
it is nice to show others the solutions that are found.

> 
> On Thu, 4 Jun 2009, Philipp Reh wrote:
> 
> > I'm not really sure it is dropped but tcpdump sees the packet and
> > recvfrom doesn't see it, so I think that the kernel might drop it
> > somewhere when processing the IP stack logic.
> 
> Looking at the udp stack, selinux plays a role, and looks like it will 
> drop a packet if it is not in the routing table.
> 
> Try:
> 
> # setenforce 0
> 
> and see if you start seeing packets.

BTW, I used ftrace to look into this:

Enable:

	CONFIG_FTRACE
	CONFIG_FUNCTION_TRACER
	CONFIG_FUNCITON_GRAPH_TRACER
	CONFIG_DYNAMIC_FTRACE

Compile and boot:

# mount -t debugfs nodev /sys/kernel/debug
# cd /sys/kernel/debug
# echo udp_rcv > set_graph_function
# echo function_graph > current_tracer
# cat trace

and this is what I see:

# tracer: function_graph
#
# CPU  DURATION                  FUNCTION CALLS
# |     |   |                     |   |   |   |
 1)               |  udp_rcv() {
 1)               |    __udp4_lib_rcv() {
 1)               |      __udp4_lib_lookup() {
 1)   0.584 us    |        T.757();
 1)   2.905 us    |      }
 1)               |      udp_queue_rcv_skb() {
 1)   0.584 us    |        nf_reset();
 1)   0.996 us    |        _spin_lock();
 1)               |        __udp_queue_rcv_skb() {
 1)               |          sock_queue_rcv_skb() {
 1)               |            sk_filter() {
 1)               |              security_sock_rcv_skb() {
 1)               |                selinux_socket_sock_rcv_skb() {
 1)               |                  selinux_parse_skb() {
 1)   0.584 us    |                    skb_header_pointer();
 1)   0.569 us    |                    skb_header_pointer();
 1)   3.074 us    |                  }
 1)               |                  selinux_netlbl_sock_rcv_skb() {
 1)   0.561 us    |                    netlbl_enabled();
 1)   1.748 us    |                  }
 1)   6.792 us    |                }
 1)   8.095 us    |              }
 1)               |              local_bh_disable() {
 1)   0.599 us    |                __local_bh_disable();
 1)   1.790 us    |              }
 1)               |              local_bh_enable() {
 1)               |                _local_bh_enable_ip() {
 1)   0.566 us    |                  T.445();
 1)   1.906 us    |                }
 1)   3.149 us    |              }
 1) + 15.722 us   |            }
 1)               |            skb_queue_tail() {
 1)   1.059 us    |              _spin_lock_irqsave();
 1)               |              _spin_unlock_irqrestore() {
 1)   0.596 us    |                T.263();
 1)   1.913 us    |              }
 1)   4.718 us    |            }
 1)   0.565 us    |            sock_flag();
 1)               |            sock_def_readable() {
 1)   0.981 us    |              _read_lock();
 1)               |              __wake_up_sync_key() {
 1)   0.887 us    |                _spin_lock_irqsave();
 1)               |                __wake_up_common() {
 1)               |                  pollwake() {
 1)               |                    default_wake_function() {
 1)               |                      try_to_wake_up() {
 1)               |                        task_rq_lock() {
 1)   0.951 us    |                          _spin_lock();
 1)   2.030 us    |                        }
 1)   0.768 us    |                        update_rq_clock();
 1)               |                        select_task_rq_fair() {
 1)   0.501 us    |                          effective_load();
 1)   0.494 us    |                          effective_load();

-- Steve

