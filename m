Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbYJTPxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbYJTPxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 11:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbYJTPxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 11:53:39 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2728 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYJTPxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 11:53:38 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <swivel@shells.gnugeneration.com>, <ncannasse@motion-twin.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: poll() blocked / packets not received ?
Date: Mon, 20 Oct 2008 08:53:10 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKAEJCAIAD.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <48FC7BEE.1020701@motion-twin.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 20 Oct 2008 08:55:13 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 20 Oct 2008 08:55:13 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nick Cannasse wrote:

> Ok, funny thing is that we just found what is occurring...
>
> We had a process that was on a regular basis doing the following :
>
> conntrack -F
>
> This was done in order to prevent the table to grow too big, because we
> were reaching the maximum size as told by :
>
> /proc/sys/net/ipv4/netfilter/ip_conntrack_max
>    and
> /proc/sys/net/ipv4/netfilter/ip_conntrack_count
>
> Seems like when there are active connections, this will break netfilter
> and stop delivering packets to the socket.
>
> At least I will have nice sleep tonight.

Note that this solved your symptom, not your problem. You actually have two
problems:

1) You rely on TCP to detect a lost connection even by a side that will
never transmit any data. TCP simply does not do this. If you are not trying
to send data, you are not assured that a lost connection will be detected.
(You either need a timeout, or you need to send or dribble some data,
depending on the protocl.)

2) You hold a lock on a shared resource while you wait for a reply over a
network. If this is a low-level "block and wait indefinitely" lock, this
will cause many threads to line up behind a slow/stuck thread. The right fix
depends on your circumstances, but you need to use a synchronization
primitive that is suitable. (You need to be able to use multiple connections
or defer operations without holding a thread.)

With both of these bugs, you are vulnerable to precisely the scenario you
observed. The TCP connection close packets were lost (in this case due to
premature expiration of the connnection tracking, but other things can do
it, such as the server rebooting), TCP could not detect the lost connection
because you never sent any data, so one thread blocked forever, and other
threads got in line behind it.

DS


