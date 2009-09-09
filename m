Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbZIISqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbZIISqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 14:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZIISqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 14:46:06 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40394 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbZIISqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 14:46:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ir+B5p8c8agRFOcprUiLwnacfG+LtT60SaYBXG6BChGPrlhQBesYNyO3o9cdPFR1va
         jjAdCob0+26TkVXG9sEl7yaqm7+BMruPiO1AIk07KeTRAo0VvzDlcU6gfGOBKzaVvr4l
         x1EMiVizDXsTnn5D+SyJ8L3GpDYPdXO1T2v8E=
MIME-Version: 1.0
Date: Wed, 9 Sep 2009 20:46:07 +0200
Message-ID: <c67e3dc60909091146j4aeaf422v4e0543eff87c7f9a@mail.gmail.com>
Subject: TCP kernel tables overflowing after sustained 1000 new connections 
	per second
From: Paul Sheer <paulsheer@gmail.com>
To: linux-kernel@vger.kernel.org, roque@di.fc.ul.pt
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am developing a high-performance application, and testing against Apache.
It makes 1000 new connections to Apache per second.

After 16 seconds the test grinds to a halt. A Linux kernel problem. There are
several hurdles to overcome when trying to sustain such through-put. Some
are configuration issues, others I believe are real problems with the kernel
internals. I'll discuss these all below.

Configuration:

These are the relavent kernel configuration parameters:

 /proc/sys/net/ipv4/tcp_tw_recycle
 /proc/sys/net/ipv4/tcp_tw_reuse
 /proc/sys/net/ipv4/tcp_max_tw_buckets
 /proc/sys/net/ipv4/ip_local_port_range
 /proc/sys/net/ipv4/tcp_timestamps
 /proc/sys/net/ipv4/tcp_fin_timeout
 /proc/sys/net/ipv4/tcp_orphan_retries
 /proc/sys/net/ipv4/tcp_rfc1337
 /proc/sys/net/ipv4/tcp_max_orphans
 /proc/sys/net/ipv4/tcp_max_syn_backlog
 /proc/sys/net/ipv4/tcp_mem

On a gigabit local LAN I can set the timeouts very low to encourage
port reuse. A well known configuration issue with all OS's - just search
for MyOS+TIMED_WAIT on google. No problems here.


The second problem is the ip_conntrack module.

If you don't know that your distribution has enabled this module
by default, it not easy to work out that it has internal tables
that max out at 16384.  So this explains why my system
stops accepting connections after exactly 16 seconds.
If you stop the application, give it a few minutes, try again,
then you can do another 16 seconds of flat out load for it
grinds to a halt again. Doing an rm on the module ko and
rebooting fixed *this* problem.

The third problem seems to be connected to /proc/net/tcp6

look at the output of the script

while true ; do echo "`date`: `cat /proc/net/tcp6 | wc -l`  vs  `cat
/proc/net/tcp | wc -l`" ; sleep 1 ; done

while I run my load test:


 Wed Sep  9 20:39:26 SAST 2009: 5  vs  20
 Wed Sep  9 20:39:27 SAST 2009: 5  vs  20
 Wed Sep  9 20:39:28 SAST 2009: 5  vs  20
 Wed Sep  9 20:39:29 SAST 2009: 5  vs  20
 Wed Sep  9 20:39:31 SAST 2009: 1233  vs  20
 Wed Sep  9 20:39:32 SAST 2009: 2640  vs  21
 Wed Sep  9 20:39:33 SAST 2009: 4190  vs  20
 Wed Sep  9 20:39:34 SAST 2009: 5813  vs  20
 Wed Sep  9 20:39:35 SAST 2009: 7527  vs  20
 Wed Sep  9 20:39:37 SAST 2009: 9568  vs  44
 Wed Sep  9 20:39:38 SAST 2009: 11819  vs  21
 Wed Sep  9 20:39:40 SAST 2009: 14510  vs  21
 Wed Sep  9 20:39:42 SAST 2009: 16971  vs  20
 Wed Sep  9 20:39:44 SAST 2009: 16971  vs  20
 Wed Sep  9 20:39:46 SAST 2009: 17013  vs  20
 Wed Sep  9 20:39:48 SAST 2009: 17013  vs  20
 Wed Sep  9 20:39:50 SAST 2009: 17013  vs  20

So it is clear "something" is filling up in tcp_ipv6.c

any ideas Pedro?
anyone?

Many thanks.

-paul
