Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbYJXTt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbYJXTt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 15:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYJXTtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 15:49:49 -0400
Received: from main.gmane.org ([80.91.229.2]:51117 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbYJXTtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 15:49:49 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Thomas Guyot-Sionnest <dermoth@aei.ca>
Subject: Re: CFQ Idle class slowing down everything?
Date: Fri, 24 Oct 2008 15:49:29 -0400
Message-ID: <490226C9.4000406@aei.ca>
References: <gcm0sv$ra4$1@ger.gmane.org> <20081014121859.4778abcf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: dsl-216-221-37-62.aei.ca
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
In-Reply-To: <20081014121859.4778abcf.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/08 03:18 PM, Andrew Morton wrote:
>> On Thu, 09 Oct 2008 18:34:06 -0400 Thomas Guyot-Sionnest <dermoth@aei.ca> wrote:
>> Hey,
>>
>> I tried to use CFQ and ionice to help some I/O intensive tasks on a
>> MySQL slave, and it turned out to makes thing much worse to the point I
>> can figure out what it could be beside a bug. Tested on 2.6.20.1, but I
>> could eventually upgrade if there's CFQ bugfixes I'm missing. The
>> filesystem is ReiserFS.
>>
>> When "idle", the slave do mostly random writes: about 15 rtps and 200
>> wtps. For testing I ended up running dd to read files from disk to
>> /dev/null while avoiding the system cache (had 42GB of data to read
>> from, and <1GB of ram cache/buffers). Here's some sample results (I
>> tried them multiple times with similar results every time). I monitored
>> the iops with "sar -b 1 0"
>>
>> Under deadline-iosched:
>>
>> 262144000 bytes (262 MB) copied, 9.68511 seconds, 27.1 MB/s
>> rtps raised over 200, wtps gets down to ~100 and then back up after the
>> read operation (as MySQL catch up)
>>
>> Under cfq-ipoched without ionice:
>>
>> 262144000 bytes (262 MB) copied, 4.78834 seconds, 54.7 MB/s
>> rtps raise over 400, wtps gets down near 0 then back up after the read.
>> I can expect it as cfq does not manage the write queue, so it gives most
>> bandwidth to dd
>>
>> Under cfq-ipoched with ionice -c3 (mysqld was "best-effort: prio 4"):
>> 13369344 bytes (13 MB) copied, 39.7619 seconds, 336 kB/s (After pressing
>> CTRL-C to avoid tripping off alerting on MySQL replication)
>>
>> Mysql was lagging behind at pretty much the same rate with and without
>> "ionice -c3", but with the latter the copy operation was also incredibly
>> slower. During the read operation rtps was around 3 and wtps was between
>> 10 and 20, far beyond what that raid array is able to do with pure
>> random operations.
>>
>> Any ides what's going on with this scheduler?
>>
>> FWIW the dd command was:
>>
>> dd if=<file> of=/dev/null bs=128k skip=NNNN count=2000
>> Where NNNN is a multiple of 2000 incremented by 1 on every run.
>>
> 
> Yes, 2.6.20 is dreadfully old.  If you can retest a recent kernel it would really help, thanks.

Did it, although I had to patch it as the AACRAID driver is broken since
2.6.25! See:
http://bugzilla.kernel.org/show_bug.cgi?id=9133
https://bugzilla.redhat.com/show_bug.cgi?id=453472
https://bugzilla.redhat.com/show_bug.cgi?id=457552
http://marc.info/?l=linux-kernel&m=122166454808377&w=2

With 2.6.27.2 the Idle class performs much better now, and using it, my
dd command has less impact on the MySQL replication than using the
default class.

Interestingly though, the CFQ Idle class it still clearly having more
impact on replication than using the deadline scheduler. Anyone
interested in more details (I compiled the kernel with a bunch of IO
scheduler statistics in case it would be needed).


Thomas

