Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbXJ2GIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbXJ2GIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 02:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbXJ2GIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 02:08:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:46474 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751186AbXJ2GIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 02:08:11 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/dyh0HR23dcnMXgPLRe/Bc2HM7S8LZ3Cj+LFbJjh
	JEZ8uQj2GivSK0
Subject: 2.6.23 regression: second access of empty ntfs file leads to D
	state hang
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>, linux-ntfs-dev@lists.sourceforge.net
Content-Type: text/plain
Date: Mon, 29 Oct 2007 07:08:06 +0100
Message-Id: <1193638086.7409.21.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I've stumbled across a 2.6.22->2.6.23 regression.  First md5sum access
of an empty NTFS file leads to kernel I/O error gripe, a second access
leaves md5sum hung.  2.6.22.10 has no trouble accessing this file.

Looking at the 22->23 diff, I don't see a quick and dirty stab
candidate, and since I'm preparing for a 5 week separation from my box
<twitch>, I doubt I'll have time to do a bisect.  /me punts.

root@Homer: md5sum '/windows/C/Dokumente und Einstellungen/All Users/Anwendungsdaten/Microsoft/Network/Connections/Pbk/rasphone.pbk'
md5sum: /windows/C/Dokumente und Einstellungen/All Users/Anwendungsdaten/Microsoft/Network/Connections/Pbk/rasphone.pbk: Input/output error

[  228.551859] NTFS-fs error (device hda1): ntfs_read_compressed_block(): ntfs_map_runlist() failed. Cannot read compression block.

[  401.721890] md5sum        D eee53d64     0  7249   7019
[  401.727155]        eee53d78 00200082 00000002 eee53d64 eee53d5c 00000000 e9b006b0 e9b00700 
[  401.735469]        5f6b3463 c0677060 c067a080 e9b00860 c180d080 00000000 c180d080 c180d108 
[  401.743991]        00000001 00200086 e9b006e0 00200086 f79ca640 eee53d94 0000b4d3 00200202 
[  401.752514] Call Trace:
[  401.755155]  [<c04b57bf>] io_schedule+0x1e/0x28
[  401.759711]  [<c015a269>] sync_page+0x34/0x3f
[  401.764102]  [<c04b5b78>] __wait_on_bit_lock+0x40/0x63
[  401.769281]  [<c015a221>] __lock_page+0x54/0x5c
[  401.773845]  [<c015a826>] do_generic_mapping_read+0x236/0x4e7
[  401.779629]  [<c015c165>] generic_file_aio_read+0xff/0x198
[  401.785138]  [<c017851c>] do_sync_read+0xd0/0x106
[  401.789873]  [<c0178cff>] vfs_read+0x89/0x11d
[  401.794266]  [<c0179164>] sys_read+0x3d/0x64
[  401.798569]  [<c01041ba>] syscall_call+0x7/0xb
[  401.803039]  =======================


