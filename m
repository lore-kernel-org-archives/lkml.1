Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbZDGTvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbZDGTvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbZDGTvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:51:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045AbZDGTvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:51:41 -0400
Date: Tue, 7 Apr 2009 12:49:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: holt@sgi.com
Cc: linux-kernel@vger.kernel.org, holt@sgi.com, dcn@sgi.com
Subject: Re: [Patch 2/3] Prevent false sgi-xpc heartbeat failures.
Message-Id: <20090407124933.c2fb210f.akpm@linux-foundation.org>
In-Reply-To: <20090403160449.144474404@attica.americas.sgi.com>
References: <20090403160440.637837240@attica.americas.sgi.com>
	<20090403160449.144474404@attica.americas.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Apr 2009 11:04:42 -0500
holt@sgi.com wrote:

> +void (*xpc_allow_hb) (short partid);
> +void (*xpc_disallow_hb) (short partid);
> +void (*xpc_disallow_all_hbs) (void);
>  void (*xpc_heartbeat_init) (void);
>  void (*xpc_heartbeat_exit) (void);
>  void (*xpc_increment_heartbeat) (void);

The driver adds a huge number of globals.

As a pointless cleanup it might be nice to convert all this:

: int (*xpc_setup_partitions_sn) (void);
: void (*xpc_teardown_partitions_sn) (void);
: enum xp_retval (*xpc_get_partition_rsvd_page_pa) (void *buf, u64 *cookie,
: 						  unsigned long *rp_pa,
: 						  size_t *len);
: int (*xpc_setup_rsvd_page_sn) (struct xpc_rsvd_page *rp);
: 
: void (*xpc_allow_hb) (short partid);
: void (*xpc_disallow_hb) (short partid);
: void (*xpc_disallow_all_hbs) (void);
: void (*xpc_heartbeat_init) (void);
: void (*xpc_heartbeat_exit) (void);
: void (*xpc_increment_heartbeat) (void);
: void (*xpc_offline_heartbeat) (void);
: void (*xpc_online_heartbeat) (void);
: enum xp_retval (*xpc_get_remote_heartbeat) (struct xpc_partition *part);
: 
: enum xp_retval (*xpc_make_first_contact) (struct xpc_partition *part);
: void (*xpc_notify_senders_of_disconnect) (struct xpc_channel *ch);
: u64 (*xpc_get_chctl_all_flags) (struct xpc_partition *part);
: enum xp_retval (*xpc_setup_msg_structures) (struct xpc_channel *ch);
: void (*xpc_teardown_msg_structures) (struct xpc_channel *ch);
: void (*xpc_process_msg_chctl_flags) (struct xpc_partition *part, int ch_number);
: int (*xpc_n_of_deliverable_payloads) (struct xpc_channel *ch);
: void *(*xpc_get_deliverable_payload) (struct xpc_channel *ch);
: 
: void (*xpc_request_partition_activation) (struct xpc_rsvd_page *remote_rp,
: 					  unsigned long remote_rp_pa,
: 					  int nasid);
: void (*xpc_request_partition_reactivation) (struct xpc_partition *part);
: void (*xpc_request_partition_deactivation) (struct xpc_partition *part);
: void (*xpc_cancel_partition_deactivation_request) (struct xpc_partition *part);
: 
: void (*xpc_process_activate_IRQ_rcvd) (void);
: enum xp_retval (*xpc_setup_ch_structures_sn) (struct xpc_partition *part);
: void (*xpc_teardown_ch_structures_sn) (struct xpc_partition *part);
: 
: void (*xpc_indicate_partition_engaged) (struct xpc_partition *part);
: int (*xpc_partition_engaged) (short partid);
: int (*xpc_any_partition_engaged) (void);
: void (*xpc_indicate_partition_disengaged) (struct xpc_partition *part);
: void (*xpc_assume_partition_disengaged) (short partid);
: 
: void (*xpc_send_chctl_closerequest) (struct xpc_channel *ch,
: 				     unsigned long *irq_flags);
: void (*xpc_send_chctl_closereply) (struct xpc_channel *ch,
: 				   unsigned long *irq_flags);
: void (*xpc_send_chctl_openrequest) (struct xpc_channel *ch,
: 				    unsigned long *irq_flags);
: void (*xpc_send_chctl_openreply) (struct xpc_channel *ch,
: 				  unsigned long *irq_flags);
: 
: enum xp_retval (*xpc_save_remote_msgqueue_pa) (struct xpc_channel *ch,
: 					       unsigned long msgqueue_pa);
: 
: enum xp_retval (*xpc_send_payload) (struct xpc_channel *ch, u32 flags,
: 				    void *payload, u16 payload_size,
: 				    u8 notify_type, xpc_notify_func func,
: 				    void *key);
: void (*xpc_received_payload) (struct xpc_channel *ch, void *payload);

into

struct xpc_operations {
	int (*setup_partitions_sn)(void);
	...
	void (*xpc_received_payload)(struct xpc_channel *ch, void *payload);
} xpc_operations;

Or not ;)
