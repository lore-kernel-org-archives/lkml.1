Return-Path: <linux-kernel-owner+w=401wt.eu-S1764140AbZCXUYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764140AbZCXUYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762509AbZCXUYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:24:22 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:13673 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763033AbZCXUYU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:24:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=mQU3UvEh/P19V9U2Dd2fE3KknW0urQyTpo5zQ3ZlXaqkdmVdo/aGINVpx++t21CJ5k
         +VQ2UIhprtGa9kb7V+hkt0KU497yS2hDmMaEIob/DD/5R/K1af2Cdvwcq3zTxL5anToR
         +cYDX1zw1CYSjqMpE30Cu6OC04OVyKc/SJASs=
MIME-Version: 1.0
In-Reply-To: <20090324132032.GK5814@mit.edu>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	 <49C87B87.4020108@krogh.cc>
	 <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	 <20090324091545.758d00f5@lxorguk.ukuu.org.uk>
	 <20090324093245.GA22483@elte.hu>
	 <20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
	 <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu>
Date: Tue, 24 Mar 2009 13:24:18 -0700
Message-ID: <72dbd3150903241324n2d77b34cx5681ce0520e80887@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: David Rees <drees76@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 6:20 AM, Theodore Tso <tytso@mit.edu> wrote:
> However, what I've found, though, is that if you're just doing a local
> copy from one hard drive to another, or downloading a huge iso file
> from an ftp server over a wide area network, the fsync() delays really
> don't get *that* bad, even with ext3.  At least, I haven't found a
> workload that doesn't involve either dd if=/dev/zero or a massive
> amount of data coming in over the network that will cause fsync()
> delays in the > 1-2 second category.  Ext3 has been around for a long
> time, and it's only been the last couple of years that people have
> really complained about this; my theory is that it was the rise of >
> 10 megabit ethernets and the use of systems like distcc that really
> made this problem really become visible.  The only realistic workload
> I've found that triggers this requires a fast network dumping data to
> a local filesystem.

It's pretty easy to reproduce it these days.  Here's my setup, and
it's not even that fancy:  Dual core Xeon, 8GB RAM, SATA RAID1 array,
GigE network.  All it takes is a single client writing a large file
using Samba or NFS to introduce huge latencies.

Looking at the raw throughput, the server's disks can sustain
30-60MB/s writes (older disks), but the network can handle up to
~100MB/s.  Throw in some other random seeky IO on the server, a bunch
of fragmentation and it's sustained write throughput in reality for
these writes is more like 10-25MB/s, far slower than the rate at which
a client can throw data at it.

5% dirty_ratrio * 8GB is 400MB.  Let's say in reality the system is
flushing 20MB/s to disk, this is a delay of up to 20 seconds.  Let's
say you have a user application which needs to fsync a number of small
files (and unfortunately they are done serially) and now I've got
applications (like Firefox) which basically remain unresponsive the
entire time the write is being done.

> (I'm sure someone will be ingeniuous enough to find something else
> though, and if they're interested, I've attached an fsync latency
> tester to this note.  If you find something; let me know, I'd be
> interested.)

Thanks - I'll give the program a shot later with my test case and see
what it reports.  My simple test case[1] for reproducing this has
reported 6-45 seconds depending on the system.  I'll try it with the
previously mentioned workload as well.

-Dave

[1] http://bugzilla.kernel.org/show_bug.cgi?id=12309#c249
