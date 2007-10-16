Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbXJPKLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbXJPKLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758732AbXJPKLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 06:11:45 -0400
Received: from hpsmtp-eml12.kpnxchange.com ([213.75.38.112]:47816 "EHLO
	hpsmtp-eml12.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756655AbXJPKLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:11:44 -0400
From: Frans Pop <elendil@planet.nl>
To: balbir@linux.vnet.ibm.com
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
Date: Tue, 16 Oct 2007 12:11:38 +0200
User-Agent: KMail/1.9.7
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Chuck Ebbert <cebbert@redhat.com>, Greg KH <greg@kroah.com>,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
References: <200710122231.50739.elendil@planet.nl> <200710161029.27132.borntraeger@de.ibm.com> <471484B3.9010903@linux.vnet.ibm.com>
In-Reply-To: <471484B3.9010903@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710161211.40285.elendil@planet.nl>
X-OriginalArrivalTime: 16 Oct 2007 10:11:42.0663 (UTC) FILETIME=[F325ED70:01C80FDC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2007, Balbir Singh wrote:
> I am trying to think out loud as to what the root cause of the problem
> might be. In one of the discussion threads, I saw utime going backwards,
> which seemed very odd, I suspect that those are rounding errors.

I only remembered stime going backwards, but looking back at the mails
you are right, there has been one case of utime going backwards too.
stime going backwards happens _much_ more frequently.

> I have tried and not had any success reproducing the problem, could you
> please help me with some pointers/steps to reproduce the problem?

I can reproduce the problem reliably for two KDE programs I have running
permanently on my system: kontact and amarok. Both of these wake up
regularly and use some (not very much) processor capacity before going to
sleep again. Any process that has that that characteristic should do.

/me thinks a bit and tries something

lol - I have just managed to reproduce this with 'top' itself :-P

Run 'top' in one terminal; then in another terminal:
$ ps ax | grep " [t]op"
17869 pts/0    S+     0:00 top
$ while true; do awk '{print $14" "$15}' /proc/17869/stat; sleep 1; done | ts
[...]
Oct 16 11:54:48 8 10
Oct 16 11:54:49 6 12  <-- utime
Oct 16 11:54:50 6 12
Oct 16 11:54:51 6 12
Oct 16 11:54:52 8 10  <-- stime
Oct 16 11:54:53 8 10
Oct 16 11:54:54 8 10
Oct 16 11:54:55 8 12
Oct 16 11:54:56 8 12

This example happens to have both stime _and_ utime decreasing...

'ts' is a small utility that prints the timestamps before the readings;
the test will work just as well without it.
Note that it may take a while for the error to show up. In this case it
was 40 seconds.

Cheers,
Frans Pop
