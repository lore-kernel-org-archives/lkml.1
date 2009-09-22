Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbZIVQ7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbZIVQ7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbZIVQ7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:59:36 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:3035 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbZIVQ7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:59:35 -0400
From: James Cloos <cloos@jhcloos.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Mike Galbraith <efault@gmx.de>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
Subject: Re: Poor desktop responsiveness with background I/O-operations
In-Reply-To: <1253603193.6875.118.camel@marge.simson.net> (Mike Galbraith's
	message of "Tue, 22 Sep 2009 09:06:33 +0200")
References: <4AB59CBB.8090907@datenparkplatz.de>
	<20090920080728.73bfe2a1@infradead.org>
	<4AB5ECD0.7010903@datenparkplatz.de>
	<1253475521.9224.43.camel@marge.simson.net>
	<4AB6C73C.1030004@gmail.com>
	<1253507034.23414.90.camel@marge.simson.net>
	<4AB72FDC.5090403@datenparkplatz.de>
	<1253520364.25640.57.camel@marge.simson.net>
	<m3tyyw6pvz.fsf@lugabout.jhcloos.org>
	<1253603193.6875.118.camel@marge.simson.net>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.50 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Tue, 22 Sep 2009 12:58:55 -0400
Message-ID: <m33a6e3ogo.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mike" == Mike Galbraith <efault@gmx.de> writes:

Mike> If someone has a definite good/bad cutoff for the problem they're
Mike> seeing, a git bisect (yeah, takes time) would be a good thing to try.

Yes, I wanted to try that for this, but given how long it takes to
compile a kernel on this box, and how long it takes to get everything
up so that I can test my real-life load, added to the difference in
performance after each day of uptime, I could do at best one kernel
per day; it would take weeks to finish.

That said, I jsut took a look at the git log for my /boot/grub repo
and can confirm that the last really good kernel -- the one I had up
for more than a month for the first time in years -- was pulled 
between 2.6.30-rc6 and 2.6.30-rc7 and installed on 2009/05/17 which,
since I keep .config in git in my compile repo, lets me narrow down
the make oldconfig to 2009/05/17 18:37:24Z.

So, whatever Linus' tree looked like on that date is GOOD.  His last
commit before that was 0f6f49a8cd0163fdb1723ed29f01fc65177108dc.

My next make oldconfig was on 2009/06/25 04:32:03Z, when I started
testing the radeon kms.  (I'm back to non-KMS now.)  There were too
many issues directly caused by KMS itself for me to comment on non-
KMS kernel issues from the kernels I ran with KMS enabled.

My return from KMS as on 2009/08/31; Linus' last commit before I did
that was adda766193ea1cf3137484a9521972d080d0b7af.

To give an idea of how little that narrows things:

  :; git log 0f6f49a8cd..adda766193|egrep -c ^commit
  12094

For those who use the tars, that means 30-rc6 was fast and 31-rc8 slow.

Mike> Git doesn't cause me any woes whatsoever, but my box's primary
Mike> drive isn't a slow laptop drive, ram isn't tight, 

That does make a difference.  Git is *great* when it fits into ram, but
a pull or merge on a clone of Linus' tree takes a quarter gig of VM on
x86-32, which guarantees paging, including to the swap partitions. (The
laptop is old enough to support three platters — including the optical —
so I have my primary swap partition on the second drive to reduce some
of the load to the / /var /boot drive.  The first disk's swap partition
only gets hit when I boot w/o the second drive.  It helps.)

The problem isn't that paging occurs, but rather that now, when
paging occurs, said paging is much slower than it had been.

IOW, the priority of paging vs other disk I/O has changed for the worse,
at some point after 0f6f49a8cd and before adda766193.  But, as I wrote
above, to actually test kernels between those to determine where would
take weeks.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
