Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbZCYHap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbZCYHap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 03:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbZCYHaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 03:30:35 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:51211 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547AbZCYHae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 03:30:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=lvBXFfqmgUo+/qZ4uFuoRygVLxPGzVfwQ+179W1S4XOAeH9QKX+hX0u5hfgec+E0wx
         yBJZmiqyUag8z3XaDDjSf/pSe4ZQWzhAnfeW41eNbMenvl1216FvAaw/+kpzWu2eTN1A
         vwi9j9aNADj5DIFVcs2QF0XlKe1TX1uR8wYs0=
MIME-Version: 1.0
In-Reply-To: <72dbd3150903241324n2d77b34cx5681ce0520e80887@mail.gmail.com>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	 <49C87B87.4020108@krogh.cc>
	 <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	 <20090324091545.758d00f5@lxorguk.ukuu.org.uk>
	 <20090324093245.GA22483@elte.hu>
	 <20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
	 <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu>
	 <72dbd3150903241324n2d77b34cx5681ce0520e80887@mail.gmail.com>
Date: Wed, 25 Mar 2009 00:30:32 -0700
Message-ID: <72dbd3150903250030y6db62ac2r5144befed2ef2206@mail.gmail.com>
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

On Tue, Mar 24, 2009 at 1:24 PM, David Rees <drees76@gmail.com> wrote:
> On Tue, Mar 24, 2009 at 6:20 AM, Theodore Tso <tytso@mit.edu> wrote:
>> The only realistic workload
>> I've found that triggers this requires a fast network dumping data to
>> a local filesystem.
>
> It's pretty easy to reproduce it these days.  Here's my setup, and
> it's not even that fancy:  Dual core Xeon, 8GB RAM, SATA RAID1 array,
> GigE network.  All it takes is a single client writing a large file
> using Samba or NFS to introduce huge latencies.
>
> Looking at the raw throughput, the server's disks can sustain
> 30-60MB/s writes (older disks), but the network can handle up to
> ~100MB/s.  Throw in some other random seeky IO on the server, a bunch
> of fragmentation and it's sustained write throughput in reality for
> these writes is more like 10-25MB/s, far slower than the rate at which
> a client can throw data at it.
>
>> (I'm sure someone will be ingeniuous enough to find something else
>> though, and if they're interested, I've attached an fsync latency
>> tester to this note.  If you find something; let me know, I'd be
>> interested.)

OK, two simple tests on this system produce latencies well over 1-2s
using your fsync-tester.

The network client writing to disk scenario (~1GB file) resulted in this:
fsync time: 6.5272
fsync time: 35.6803
fsync time: 15.6488
fsync time: 0.3570

One thing to note - writing to this particular array seems to have
higher than expected latency without the big write, on the order of
0.2 seconds or so.  I think this is because the system is not idle and
has a good number of programs on it doing logging and other small bits
of IO. vmstat 5 shows the system writing out about 300-1000 under the
bo column.

Copying that file to a separate disk was not as bad, but there were
still some big spikes:

fsync time: 6.8808
fsync time: 18.4634
fsync time: 9.6852
fsync time: 10.6146
fsync time: 8.5015
fsync time: 5.2160

The destination disk did not have any significant IO on it at the time.

The system is running Fedora 10 2.6.27.19-78.2.30.fc9.x86_64 and has
two RAID1 arrays attached to an aacraid controller. ext3 filesystems
mounted with noatime.

-Dave
