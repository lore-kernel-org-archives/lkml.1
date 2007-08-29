Return-Path: <linux-kernel-owner+w=401wt.eu-S932574AbXH2QCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbXH2QCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 12:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbXH2QC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 12:02:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbXH2QC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 12:02:27 -0400
Message-ID: <46D59890.3020508@redhat.com>
Date: Wed, 29 Aug 2007 12:02:24 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: x86_64 vdso patch is broken somehow?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit:     2aae950b21e4bc789d1fc6668faf67e8748300b7

With new vdso gettimeofday support in glibc:



[https://bugzilla.redhat.com/show_bug.cgi?id=262481]

After 5 minutes of uptime, the system clock goes screwy.

When running a simple 'while /bin/true ; date ; uptime ; sleep 2 ; done' loop:


Wed Aug 29 01:01:14 EDT 2007
 01:01:14 up 4 min,  4 users,  load average: 0.13, 0.40, 0.21
Wed Aug 29 01:01:16 EDT 2007
 01:01:16 up 4 min,  4 users,  load average: 0.13, 0.40, 0.21
Wed Aug 29 02:09:36 EDT 2007
 01:01:18 up 5 min,  4 users,  load average: 0.12, 0.39, 0.21
Wed Aug 29 02:09:38 EDT 2007
 01:01:20 up 5 min,  4 users,  load average: 0.12, 0.39, 0.21
Wed Aug 29 02:09:40 EDT 2007
 01:01:22 up 5 min,  4 users,  load average: 0.19, 0.40, 0.22

At the 5 minute mark, the time jumps forward an hour as reported by date, *even
though the kernel variant appears to be unchanged*.

If you then try and reset the time (with 'date -s "01:04"):

Wed Aug 29 02:11:06 EDT 2007
 01:02:48 up 6 min,  4 users,  load average: 0.99, 0.60, 0.30
Wed Aug 29 02:12:19 EDT 2007
 01:04:01 up 6 min,  4 users,  load average: 0.99, 0.60, 0.30
Wed Aug 29 02:12:21 EDT 2007
 01:04:03 up 6 min,  4 users,  load average: 0.99, 0.61, 0.30

the kernel's date (as seen by uptime) is correctly set, but the date as returned
by /bin/date remains wrong (although it changes by the same amount.)

