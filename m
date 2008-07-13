Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbYGMUH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbYGMUH2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 16:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYGMUHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 16:07:17 -0400
Received: from hs-out-0708.google.com ([64.233.178.248]:53282 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbYGMUHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 16:07:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=J8DkTKMfox1taHxxpztL7hdJzN9FdvSSAwqYwpbOJy9/iS+teyY/9/7xnfR6jNi23e
         sudj7lZypRD68NLaOqlsQMXJJWUEV1+iu9lUCDEG3hIjrd9V0xUU75KHG0jnkWQZE0Xo
         Vj0TuEZCalbyfBJy/+zdtngH5ScbgjN6LGcHQ=
Message-ID: <487A606E.5040202@gmail.com>
Date: Sun, 13 Jul 2008 17:07:10 -0300
From: "Rafael C. de Almeida" <almeidaraf@gmail.com>
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: /proc/data information
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm interested in knowing how the cpu data from /proc/stat is gathered.
Following my way from this function:

	http://lxr.linux.no/linux+v2.6.25.10/fs/proc/proc_misc.c#L459

I've figured that the time is probably gathered using those
account_*_time on sched.c. I'm not sure where the times are read from,
though.

Anyhow, I thought I'd do a little test. I expected that if I added
together all the values on the cpu line of /proc/stat, waited 1 second
and added together all the values again, then their difference would be
a constant value. That is, the value should be the same any time I would
repeat the experiment. My reasoning was that those values accounted for
some unit of time and that the amount of time units between seconds
should always be the same. I expected a small variation due to the
kernel not always being able to wake the process that was doing the
measurement in exactly one second.

What I noticed, though, was that sometimes there's a very big variation.
For this experiment I used the following bash code:

t=`head -n1 /proc/stat |
   awk '{ print $2 + $3 + $4 + $5 + $6 + $7 + $8 + $9 }'`
sleep 1
for (( i=0; i < 1800; i=i+1 )); do
        nt=`head -n1 /proc/stat |
            awk '{ print $2 + $3 + $4 + $5 + $6 + $7 + $8 + $9 }'`
        echo $(( $nt - $t )) >> /tmp/values
        t=$nt
        sleep 1
done

The file with all the values can be reached at:
	http://homepages.dcc.ufmg.br/~rafaelc/values

The mean of the numbers in the values file was: 109.85
The standard deviation was: 29.47
The maximum was: 589
The minimum was: 99

I found those values rather odd. They were gathered while I was using
the system like I usually do. There were 40 values above 200 and 7
above 300. I didn't expect those big values to show up. Why does it happen?

It looks like that when I run:

	% dd if=/dev/zero of=/tmp/foo

things get more variable. I'm not sure why that would happen. Running
CPU-bound process added for some variation, but not nearly as much as if
I used the dd command (remembert that my computer is rather old).

A little info about my system (Debian etch):
$ uname  -a
Linux gaz 2.6.18-6-686 #1 SMP Fri Jun 6 22:22:11 UTC 2008 i686 GNU/Linux
$ cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 8
model name	: Pentium III (Coppermine)
stepping	: 10
cpu MHz		: 898.087
cache size	: 256 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat
pse36 mmx fxsr sse up
bogomips	: 1797.57

$

[]'s
Rafael
