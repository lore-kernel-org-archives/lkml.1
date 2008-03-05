Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbYCETab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbYCETab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 14:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYCETaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 14:30:22 -0500
Received: from smtp.innovsys.com ([66.115.232.196]:2296 "EHLO
	mail.innovsys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355AbYCETaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 14:30:21 -0500
X-Greylist: delayed 975 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2008 14:30:21 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: pdflush weirdness
Date: Wed, 5 Mar 2008 13:13:59 -0600
Message-ID: <DCEAAC0833DD314AB0B58112AD99B93B0414B825@ismail.innsys.innovsys.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: pdflush weirdness
Thread-Index: Ach+9RC5dcfRHbYZQk20HZe3VnGxgQ==
From: "Rune Torgersen" <runet@innovsys.com>
To: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

While trying to find what is causing some hickups on our Freescale 8280
based system 
(ppc 603e core), i've found that pdflush is causing us some grief.

The system is runnign at 450MHz, have 1GB of memory, and we see the same

issue on 2.6.18 (arch/ppc) and 2.6.24.3 (arch/powerpc)
Filesystem is ext3, but we also see it using ext2. (have not tried any
other 
fs, but suspect the same result)
Disk is a SATAII Hitachi drive connected to a SiliconImage 3124
controller.

Basically we have a testprogram that (re)writes a 80k file to a random
directory.
There are 50000 target directories.
Directory tree has 5000 top level directories, and 10 direcories under
each one.

Average opens take around 100ms
Average writes take 2ms
Average close/fflush takes mostly 2ms but also a significant number
around 100ms.

Once in a while (sometimes 30seconds sometimes longer) a open or a close
takes 2-3 seconds.

if I disable pdflush (echo 0 > /proc/sys/vm/dirty_writeback_centisecs) I
see no accesses 
larger than 400 ms, and most writes/closes are 10ms. 
Opens stay at 100ms (expected as seek time of hd comes into play)

When the pdflush delays occur, the whole system seems to be
unresponsive.

If we have the same number of direcories, but only access a subset of
2-300 of the directories,
we never see this happening. (Max time is then comparable to pdflush
off)

The system is basically a voicemail storage system, and this causes us
problems, as it causes 
several second long timeouts in processing.

1) Is there any reason that we cannot run with pdflush permanetly
disabled (probably a bad idea...)
2) Are there any thing we can tune to make the system NOT have these
hickups?

I've also been trying to get PREEMPT_RT patches to work on our 2.6.24
kernel, but it blows up when doing the first diskaccess.
(getting a BUG_ON in rtmutex.c, line 691)

