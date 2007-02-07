Return-Path: <linux-kernel-owner+w=401wt.eu-S1422861AbXBGS5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422861AbXBGS5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422904AbXBGS5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:57:06 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1571 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422858AbXBGS46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:56:58 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "lkml" <linux-kernel@vger.kernel.org>, <sen.horak@gmail.com>
Subject: RE: Performance of concurrent senders
Date: Wed, 7 Feb 2007 10:56:27 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKMEAGBHAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <a80eebd40702070749t103c2b5qa8ac627eb997056d@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 07 Feb 2007 10:56:58 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 07 Feb 2007 10:57:03 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I have been running some experiments involving processes sending large
> volumes of data concurrently. The results show (on Linux 2.6.19.2)
> that although the total throughput achieved by all the processes
> remains constant, the jitter increases as the number of processes
> increases. Beyond about 64 processes (on a 2.4GHz Xeon with 4Mb of
> cache), processes start getting starved and the streams get very
> bursty.

It's hard to know exactly what's going on in your case. But my guess is it's
basically this simple: all processes decide to send data at roughly the same
time (because they're using the same timesource) and it simply takes a while
to get around to all of them. If this is the issue, the solution is simply
to rig things so that not all processes decide to send at precisely the same
time.

This may involve raising the value of HZ. It may involve changing your
timing logic.

Think about it this way -- if each process is trying to send data every
tenth of a second, and they all try to send at precisely each even tenth of
a second of wall time, each process will on average have to wait for half of
the processes to finish before it sends. (And your CPU will be blasted each
tenth of a second and idle in-between.) But if they each pick a random
offset from the even second of wall time, the CPU will be evenly loaded and
processes won't have to wait so much.

If your CPU usage is lower than 75% or so, that would indicate that this may
be the issue. (Though it could also be the burstiness of any I/O needed to
get the stream data, if you're testing with real data. Look for processes
blocked on I/O.)

Basically, troubleshoot. Is the CPU maxed? If so, then you know what the
problem is. If not, why not?!

By the way, a process-per-stream model is really not likely to be a
particularly good one. For one thing, it forces a full process context
switch every time you switch which stream you're working on. For another
thing, it requires each stream to run completely independent timing code,
rather than leveraging one timing engine. (There may be other good reasons
to choose this model, of course, but you may be seeing some of its downsides
here.)

DS


