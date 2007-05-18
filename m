Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbXERJMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbXERJMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 05:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbXERJMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 05:12:36 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:35163 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbXERJMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 05:12:35 -0400
Message-ID: <464D6E87.7060605@sw.ru>
Date: Fri, 18 May 2007 13:14:47 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dhowells@redhat.com, chas@cmf.nrl.navy.mil, axboe@kernel.dk,
       herbert@gondor.apana.org.au, dmitry.torokhov@gmail.com, kkeil@suse.de,
       David Miller <davem@davemloft.net>, Patrick McHardy <kaber@trash.net>,
       viro@zeniv.linux.org.uk, devel@openvz.org
Subject: [PATCH 0/15] Make common helpers for seq_files that work with list_head-s
 (v2)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Many places in kernel use seq_file API to iterate over a regular
list_head. The code for such iteration is identical in all the
places, so it's worth introducing a common helpers.

This makes code about 300 lines smaller:

 block/genhd.c                                         |   40 +++-----
 crypto/proc.c                                         |   17 ---
 drivers/char/misc.c                                   |   18 ----
 drivers/input/input.c                                 |   29 ------
 drivers/isdn/capi/kcapi_proc.c                        |   28 ------
 fs/afs/proc.c                                         |   81 ++----------------
 fs/namespace.c                                        |   14 ---
 fs/nfs/client.c                                       |   54 +-----------
 fs/proc/proc_tty.c                                    |   15 ---
 fs/seq_file.c                                         |   34 +++++++
 include/linux/seq_file.h                              |   11 ++
 kernel/module.c                                       |   17 ---
 mm/slab.c                                             |   28 +-----
 net/atm/br2684.c                                      |   22 ----
 net/core/sock.c                                       |   39 --------
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c |   27 ------
 net/netfilter/nf_conntrack_expect.c                   |   27 ------
 net/rxrpc/ar-proc.c                                   |   48 +---------
 18 files changed, 126 insertions(+), 423 deletions(-)

The first version of this patch made the helper functions static inline
in the seq_file.h header. This patch moves them to the fs/seq_file.c as
Andrew proposed. The vmlinux .text section sizes are as follows:

2.6.22-rc1-mm1:              0x001794d5
with the previous version:   0x00179505
with this patch:             0x00179135

The config file used was make allnoconfig with the "y" inclusion of all
the possible options to make the files modified by the patch compile plus
drivers I have on the test node.
