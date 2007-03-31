Return-Path: <linux-kernel-owner+w=401wt.eu-S933294AbXCaBlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbXCaBlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 21:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933304AbXCaBlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 21:41:37 -0400
Received: from stinky.trash.net ([213.144.137.162]:51345 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294AbXCaBlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 21:41:36 -0400
Message-ID: <460DBC4C.1060602@trash.net>
Date: Sat, 31 Mar 2007 03:41:32 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: Re: [patch 32/37] CRYPTO: api: scatterwalk_copychunks() fails to
 advance through scatterlist
References: <20070330205938.984247529@mini.kroah.org> <20070330210651.GI29450@kroah.com>
In-Reply-To: <20070330210651.GI29450@kroah.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> -stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: J. Bruce Fields <bfields@citi.umich.edu>
> 
> [CRYPTO] api: scatterwalk_copychunks() fails to advance through scatterlist


This patch seems to cause some problems, I get reproducable freezes
on the receiving system with net-2.6.22 when sending IPsec packets
larger than the mtu (reproduced about 10 times). Reverting this
patch seems to fix it. In a few cases the oops also occured on the
sending system.

Backtrace from UML (sending system):

uml:~# ping 10.0.0.1 -s 20000
PING 10.0.0.1 (10.0.0.1) 20000(20028) bytes of data.
BUG: soft lockup detected on CPU#0!
Call Trace:
61787408:  [<602b346f>] _spin_lock+0x9/0xb
61787418:  [<6004f7b7>] softlockup_tick+0xa1/0xaf
61787438:  [<6003c9d3>] run_local_timers+0x13/0x15
61787448:  [<6003c7e8>] update_process_times+0x49/0x73
61787478:  [<6001926e>] timer_handler+0x21/0x4f
617874a8:  [<60029327>] sig_handler_common_skas+0xff/0x118
617874e8:  [<6002625f>] real_alarm_handler+0x37/0x3b
61787508:  [<600262b6>] alarm_handler+0x53/0x63
61787538:  [<60027e65>] hard_handler+0x15/0x18
617875f8:  [<6015bfd9>] scatterwalk_copychunks+0x6d/0xb4
617876d8:  [<6001adda>] maybe_map+0x32/0x9f
61787728:  [<6015d332>] blkcipher_walk_next+0x11d/0x30f
61787738:  [<6006b58c>] poison_obj+0x27/0x32
61787740:  [<6015d332>] blkcipher_walk_next+0x11d/0x30f
61787758:  [<6006cc92>] cache_alloc_debugcheck_after+0xe5/0x12e
61787780:  [<6015bfbf>] scatterwalk_copychunks+0x53/0xb4
61787788:  [<6006d14e>] __kmalloc+0xb7/0xc4
617877c8:  [<6015d3b6>] blkcipher_walk_next+0x1a1/0x30f
61787828:  [<6015d186>] blkcipher_walk_done+0x12e/0x1bd
61787838:  [<6002dae3>] aes_encrypt+0x0/0xb
61787850:  [<601643d8>] xor_128+0x0/0x1c
61787878:  [<6016416d>] crypto_cbc_encrypt+0x7a/0x8b
61787918:  [<60244183>] esp_output+0x32b/0x44c
61787948:  [<602b34dc>] _spin_unlock_bh+0x12/0x14
617879c8:  [<60257051>] xfrm4_output_one+0xaa/0x16a
61787a08:  [<60257234>] xfrm4_output_finish2+0x123/0x131
61787a28:  [<6025728f>] xfrm4_output_finish+0x3d/0xb9
61787a58:  [<60257366>] xfrm4_output+0x5b/0x5d
61787a78:  [<602183a9>] ip_push_pending_frames+0x374/0x442
61787ac8:  [<6023008d>] raw_sendmsg+0x2d0/0x396
61787b78:  [<60237edd>] inet_sendmsg+0x46/0x53
61787ba8:  [<601bb5ca>] sock_sendmsg+0xea/0x103
61787c18:  [<600473b9>] autoremove_wake_function+0x0/0x39
61787c38:  [<600192d3>] add_mmap+0x37/0x149
61787c98:  [<6001b10d>] buffer_op+0x2e/0x5f
61787cd8:  [<6001b1d5>] copy_from_user_skas+0x7a/0x7c
61787d08:  [<601c2747>] verify_iovec+0x4f/0x90
61787d38:  [<601bcc32>] sys_sendmsg+0x172/0x1db
61787d68:  [<602b34b5>] _spin_unlock_irqrestore+0x18/0x1d
61787d88:  [<601924bf>] __up_read+0x76/0x7f
61787db8:  [<60049ae1>] up_read+0x9/0xb
61787dc8:  [<60019d78>] handle_page_fault+0x1f4/0x224
61787e28:  [<60019f29>] segv+0xa7/0x27e
61787ef8:  [<6001ab91>] handle_syscall+0x65/0x80
61787f08:  [<60019e7c>] segv_handler+0x68/0x6e
61787f28:  [<600287ab>] handle_trap+0xd0/0xdb
61787f68:  [<60028c2d>] userspace+0x139/0x181
61787fc8:  [<6001a8ba>] fork_handler+0x86/0x8d

