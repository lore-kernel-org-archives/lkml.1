Return-Path: <linux-kernel-owner+w=401wt.eu-S1754393AbZENPCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbZENPCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZENPBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:01:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49900 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbZENPBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:01:50 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Olga Kornievskaia <aglo@citi.umich.edu>,
       "J. Bruce Fields" <bfields@fieldses.org>, Jim Rees <rees@umich.edu>,
       linux-nfs@vger.kernel.org
Subject: Re: 2.6.30-rc deadline scheduler performance regression for iozone over NFS
References: <x49hc0f79k9.fsf@segfault.boston.devel.redhat.com>
	<20090508120119.8c93cfd7.akpm@linux-foundation.org>
	<20090511081415.GL4694@kernel.dk>
	<x49skjb21b7.fsf@segfault.boston.devel.redhat.com>
	<20090511165826.GG4694@kernel.dk>
	<x494ovp4r51.fsf@segfault.boston.devel.redhat.com>
	<20090512204433.7eb69075.akpm@linux-foundation.org>
	<x49y6t1rqw0.fsf@segfault.boston.devel.redhat.com>
	<x49k54ku7i2.fsf@segfault.boston.devel.redhat.com>
	<1242258338.5407.244.camel@heimdal.trondhjem.org>
	<x49octv7qr8.fsf@segfault.boston.devel.redhat.com>
	<1242311620.6560.14.camel@heimdal.trondhjem.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 14 May 2009 11:00:28 -0400
In-Reply-To: <1242311620.6560.14.camel@heimdal.trondhjem.org> (Trond
	Myklebust's message of "Thu, 14 May 2009 10:33:40 -0400")
Message-ID: <x49ws8j686r.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <trond.myklebust@fys.uio.no> writes:

> On Thu, 2009-05-14 at 09:34 -0400, Jeff Moyer wrote:
>> Trond Myklebust <trond.myklebust@fys.uio.no> writes:
>> 
>> > On Wed, 2009-05-13 at 15:29 -0400, Jeff Moyer wrote:
>> >> Hi, netdev folks.  The summary here is:
>> >> 
>> >> A patch added in the 2.6.30 development cycle caused a performance
>> >> regression in my NFS iozone testing.  The patch in question is the
>> >> following:
>> >> 
>> >> commit 47a14ef1af48c696b214ac168f056ddc79793d0e
>> >> Author: Olga Kornievskaia <aglo@citi.umich.edu>
>> >> Date:   Tue Oct 21 14:13:47 2008 -0400
>> >> 
>> >>     svcrpc: take advantage of tcp autotuning
>> >>  
>> >> which is also quoted below.  Using 8 nfsd threads, a single client doing
>> >> 2GB of streaming read I/O goes from 107590 KB/s under 2.6.29 to 65558
>> >> KB/s under 2.6.30-rc4.  I also see more run to run variation under
>> >> 2.6.30-rc4 using the deadline I/O scheduler on the server.  That
>> >> variation disappears (as does the performance regression) when reverting
>> >> the above commit.
>> >
>> > It looks to me as if we've got a bug in the svc_tcp_has_wspace() helper
>> > function. I can see no reason why we should stop processing new incoming
>> > RPC requests just because the send buffer happens to be 2/3 full. If we
>> > see that we have space for another reply, then we should just go for it.
>> > OTOH, we do want to ensure that the SOCK_NOSPACE flag remains set, so
>> > that the TCP layer knows that we're congested, and that we'd like it to
>> > increase the send window size, please.
>> >
>> > Could you therefore please see if the following (untested) patch helps?
>> 
>> I'm seeing slightly better results with the patch:
>> 
>> 71548
>> 75987
>> 71557
>> 87432
>> 83538
>> 
>> But that's still not up to the speeds we saw under 2.6.29.  The packet
>> capture for one run can be found here:
>>   http://people.redhat.com/jmoyer/trond.pcap.bz2
>> 
>> Cheers,
>> Jeff
>
> Yes. Something is very wrong there...
>
> See for instance frame 1195, where the client finishes sending a whole
> series of READ requests, and we go into a flurry of ACKs passing
> backwards and forwards, but no data. It looks as if the NFS server isn't
> processing anything, probably because the window size falls afoul of the
> svc_tcp_has_wspace()...
>
> Does something like this help?

Sorry for the previous, stupid question.  I applied the patch in
addition the last one and here are the results:

70327
71561
68760
69199
65324

A packet capture for this run is available here:
  http://people.redhat.com/jmoyer/trond2.pcap.bz2

Any more ideas?  ;)

-Jeff
