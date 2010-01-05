Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932Ab0AEQHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab0AEQHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797Ab0AEQHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:07:24 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:64692 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab0AEQHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:07:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=qv+WOaA3RNeDiYmYzSzlTdUBnDqz7izBFxM/IJ3COOmNyHHcU7RyDCnGOfxLwQz3g2
         0pjP6Zj1hE1BkwSyrqyiEB0u9l6818lJMuOhKJK4ZZ94cyApIHvYKP1rYMfg2YhT5NgR
         SXSXXmoutkMw2T5wm7Z9L0Oli5chbovgzrwgI=
MIME-Version: 1.0
Date: Tue, 5 Jan 2010 10:07:22 -0600
X-Google-Sender-Auth: a423181100c3b850
Message-ID: <58965d8a1001050807l31ddf8d1l55ebcfbadbfc206d@mail.gmail.com>
Subject: Multi-file USB mass-storage copy from PC to Nokia N900 slow when 
	using CFQ
From: Paul Hartman <paul.hartman+linux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Copying more than one file from my PC (kernel 2.6.32) to my Nokia N900
over USB mass storage mode is very slow when CFQ is the i/o scheduler.
The target uses vfat filesystem.

I am using iotop to monitor the I/O in general, plus I performed the
following test. file1 and file2 are each 700M and both housed on a
ramdrive for this test. They were deleted from the destination between
runs.

# one file at a time with sync in-between, fast speeds:
$ sync; time sh -c "cp file1 /mnt/usb; sync; cp file2 /mnt/usb; sync"

real    1m25.697s
user    0m0.005s
sys     0m2.509s

# copy two files in a row, then sync, speed is bad:
$ sync; time sh -c "cp file1 file2 /mnt/usb; sync"

real    6m51.439s
user    0m0.007s
sys     0m2.615s


Using all I/O schedulers, the speed of the first test was the same. So
it's only related to writing more than 1 file to the N900. The timing
results for the second test ended up as such:

cfq: 6m51.439s
noop: 3m0.733s
anticipatory: 1m44.348s
deadline: 1m36.804s


Also, in 2.6.31 the speed was four times slower, so the removal of old
pdflush code may have made a difference in this case. Copying 1
gigabyte takes about 1 minute at optimal speed, about 5 minutes using
CFQ in kernel 2.6.32, and took about 20 minutes using CFQ in kernel
2.6.31.

I thought you may be interested in case there's room to improve the
scheduler.  If you want any other info let me know!

Thanks
Paul
