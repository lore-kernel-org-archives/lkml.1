Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbYJCNTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbYJCNTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 09:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYJCNTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 09:19:13 -0400
Received: from 184-111-204-62-static.cable.fcom.ch ([62.204.111.184]:53608
	"EHLO blinkeye.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYJCNTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 09:19:12 -0400
Message-ID: <1b770184b5cfdc7638dd863f415bfaf0.squirrel@blinkeye.ch>
Date: Fri, 3 Oct 2008 15:19:06 +0200 (CEST)
Subject: BUG: processes hang indefinitely
From: "Reto Glauser" <linux@blinkeye.ch>
To: "Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm having a repeatable bug, namely that arbitrarily processes claim a CPU and hang
indefinitely. They recover sometimes, be it after 5 minutes or after 30 minutes, and
sometimes not.

Latest example was libtool-wrap while compiling the jpeg library:

# emerge media-libs/jpeg
...

# top
16973 root      39  19 10860  608  444 R  100  0.0 113:59.68 libtool-wrap

# while true; do cat /proc/16973/stat; sleep 1; done
16973 (libtool-wrap) R 15444 30375 6434 34816 30375 4194304 178 0 0 0 10604 1 0 0 39
19 1 0 6722416 11120640 152 18446744073709551615 4194304 4906172 140734787246416
18446744073709551615 47039760684325 0 0 16777216 0 0 0 0 17 3 0 0 0 0 0
16973 (libtool-wrap) R 15444 30375 6434 34816 30375 4194304 178 0 0 0 10704 1 0 0 39
19 1 0 6722416 11120640 152 18446744073709551615 4194304 4906172 140734787246416
18446744073709551615 47039760684325 0 0 16777216 0 0 0 0 17 3 0 0 0 0 0
16973 (libtool-wrap) R 15444 30375 6434 34816 30375 4194304 178 0 0 0 10805 1 0 0 39
19 1 0 6722416 11120640 152 18446744073709551615 4194304 4906172 140734787246416
18446744073709551615 47039760684325 0 0 16777216 0 0 0 0 17 3 0 0 0 0 0
...
16973 (libtool-wrap) R 15444 30375 6434 34816 30375 4194304 178 0 0 0 431667 65 0 0
39 19 1 0 6722416 11120640 152 18446744073709551615 4194304 4906172 140734787246416
18446744073709551615 47039760684325 0 0 16777216 0 0 0 0 17 3 0 0 0 0 0
16973 (libtool-wrap) R 15444 30375 6434 34816 30375 4194304 178 0 0 0 431767 65 0 0
39 19 1 0 6722416 11120640 152 18446744073709551615 4194304 4906172 140734787246416
18446744073709551615 47039760684325 0 0 16777216 0 0 0 0 17 3 0 0 0 0 0
16973 (libtool-wrap) R 15444 30375 6434 34816 30375 4194304 178 0 0 0 431868 65 0 0
39 19 1 0 6722416 11120640 152 18446744073709551615 4194304 4906172 140734787246416
18446744073709551615 47039760684325 0 0 16777216 0 0 0 0 17 3 0 0 0 0 0

I tried different kernels (gentoo-2.6.25, gentoo-2.6.26, git-2.6.27-rc8) and tried
all three preemption models without noticing any difference (except that on
git-2.6.27-rc8 processes seem never to recover). Processes which I noticed hanging
are: sed, awk, rm, touch, libtool-wrap, ... It's not happening instantly, but it
doesn't take long to force it to happen.

It's happening on:

# /usr/src/linux/scripts/ver_linux

Linux quadux 2.6.27-rc8-git1 #1 SMP Wed Oct 1 08:53:31 CEST 2008 x86_64 Intel(R)
Core(TM)2 Quad CPU Q6600 @ 2.40GHz GenuineIntel GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               2.18
util-linux             2.13.1.1
mount                  2.13.1.1
module-init-tools      3.4
e2fsprogs              1.40.9
reiserfsprogs          3.6.19
Linux C Library        2.6.1
Dynamic linker (ldd)   2.6.1
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.13
Sh-utils               6.10
udev                   124
Modules Loaded

I was *not* yet able to observe this behaviour on a x86_64 Intel(R) Core(TM)2 Duo CPU.

What can I do to get down to this issue?

Thanks,
Reto



