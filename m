Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbZGLRaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbZGLRaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 13:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbZGLRaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 13:30:23 -0400
Received: from main.gmane.org ([80.91.229.2]:37326 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224AbZGLRaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 13:30:22 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: 2.6.31-rc2: BUG: unable to handle kernel NULL pointer dereference
Date: Sun, 12 Jul 2009 17:30:06 +0000 (UTC)
Message-ID: <loom.20090712T172408-520@post.gmane.org>
References: <1247410030.1095.1.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 24.169.237.222 (Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1) Gecko/20090624 Firefox/3.5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer <thomas <at> m3y3r.de> writes:

> 
> [ 6190.368242] Restarting tasks ... done.
> [ 6191.252241] BUG: unable to handle kernel NULL pointer dereference at
0000000000000040
> [ 6191.252253] IP: [<ffffffff8134beea>] strchr+0x24/0x45

[ ... ]

> [ 6191.252253] Call Trace:
> [ 6191.252253]  [<ffffffff812e37d7>] ? selinux_sb_show_options+0x246/0x33c
> [ 6191.252253]  [<ffffffff811306a2>] ? show_vfsmnt+0xbb/0x133
> [ 6191.252253]  [<ffffffff81134785>] ? seq_read+0x293/0x376
> [ 6191.252253]  [<ffffffff81117f49>] ? vfs_read+0xb1/0x123
> [ 6191.252253]  [<ffffffff811180a3>] ? sys_read+0x55/0x90
> [ 6191.252253]  [<ffffffff8102bf2b>] ? system_call_fastpath+0x16/0x1b
> [ 6191.252253] Code: d2 ff 48 83 c4 18 c3 48 83 ec 18 48 89 f8 65 48 8b 14 25
28 00 00 00 48 89 54 24 08 31 d2 eb 0b 84 d2 75 04
> 31 c0 eb 0a 48 ff c0 <8a> 10 40 38 f2 75 ee 48 8b 54 24 08 65 48 33 14 25 28
00 00 00 
> [ 6191.252253] RIP  [<ffffffff8134beea>] strchr+0x24/0x45
> [ 6191.252253]  RSP <ffff8801771b9d98>
> [ 6191.252253] CR2: 0000000000000040
> [ 6191.258135] ---[ end trace f7a4d612974b9b43 ]---

Hmm. It very likely died in selinux_write_opts. 
That is the only function that does the strchr in that code path -

static void selinux_write_opts(struct seq_file *m,
1012                                struct security_mnt_opts *opts)
1013 {
1014         int i;
1015         char *prefix;
1016
1017         for (i = 0; i < opts->num_mnt_opts; i++) {
1018                 char *has_comma;
1019
1020                 if (opts->mnt_opts[i])
1021                         has_comma = strchr(opts->mnt_opts[i], ',');
                                         ^^^^^^^^^^^^^^^^^^^^^^^^^
And that is a NULL pointer dereference - but we just checked for
opts->mnt_opts[i] for not NULL. 

Were there other problems before this trace.
The Tainted: G seems to suggest that?

Parag

