Return-Path: <linux-kernel-owner+w=401wt.eu-S934439AbXEPVAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934439AbXEPVAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758598AbXEPVAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:00:05 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1223 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943AbXEPVAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:00:01 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "David Schwartz" <davids@webmaster.com>, <david@lang.hm>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: scheduling oddity on 2.6.20.3 stock
Date: Wed, 16 May 2007 13:59:43 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKMEIIDNAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKCEIIDNAC.davids@webmaster.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 16 May 2007 15:00:07 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 16 May 2007 15:00:09 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > >> bunzip2 -c $file.bz2 |gzip -9 >$file.gz

So here are some actual results from a dual P3-1Ghz machine (2.6.21.1,
CFSv9). First lets time each operation individually:

$ time bunzip2 -k linux-2.6.21.tar.bz2

real    1m5.626s
user    1m2.240s
sys     0m3.144s


$ time gzip -9 linux-2.6.21.tar

real    1m17.652s
user    1m15.609s
sys     0m1.912s

The compress was the most complex (no surprise there) but they are close
enough that efficient overlap will definitely affect the total wall time. If
we can both decompress and compress in 1:17, we are optimal. First, let's
try the normal way:

$ time (bunzip2 -c linux-2.6.21.tar.bz2 | gzip -9 > test1)

real    1m45.051s
user    2m16.945s
sys     0m2.752s

1:45, or 1/3 over optimal. Now, with a 32MB non-blocking cache between the
two processes ('accel' creates a 32MB cache and uses 'select' to fill from
stdin and empty to stdout without blocking either direction):

$ time (bunzip2 -c linux-2.6.21.tar.bz2 | ./accel | gzip -9 > test2)

real    1m18.361s
user    2m19.589s
sys     0m6.356s

Within testing accuracy of optimal.

So it's not the scheduler. It's the fact that bunzip2/gzip have inadequate
input/output buffering. I don't think it's unreasonable to consider this a
defect in those programs.

DS


