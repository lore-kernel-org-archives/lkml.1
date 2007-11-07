Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbXKGRFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbXKGRFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbXKGRFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:05:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37585 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbXKGRFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:05:45 -0500
Date: Wed, 7 Nov 2007 09:05:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Boldi <a1426z@gawab.com>
Cc: neilb@suse.de, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Massive slowdown when re-querying large nfs dir
Message-Id: <20071107090529.f45626de.akpm@linux-foundation.org>
In-Reply-To: <200711071236.26780.a1426z@gawab.com>
References: <200711050758.38090.a1426z@gawab.com>
	<20071106221939.cfa79f9e.akpm@linux-foundation.org>
	<18225.26935.146395.366451@notabene.brown>
	<200711071236.26780.a1426z@gawab.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 7 Nov 2007 12:36:26 +0300 Al Boldi <a1426z@gawab.com> wrote:
> Neil Brown wrote:
> > On Tuesday November 6, akpm@linux-foundation.org wrote:
> > > > On Tue, 6 Nov 2007 14:28:11 +0300 Al Boldi <a1426z@gawab.com> wrote:
> > > > Al Boldi wrote:
> > > > > There is a massive (3-18x) slowdown when re-querying a large nfs dir
> > > > > (2k+ entries) using a simple ls -l.
> > > > >
> > > > > On 2.6.23 client and server running userland rpc.nfs.V2:
> > > > > first  try: time -p ls -l <2k+ entry dir>  in ~2.5sec
> > > > > more tries: time -p ls -l <2k+ entry dir>  in ~8sec
> > > > >
> > > > > first  try: time -p ls -l <5k+ entry dir>  in ~9sec
> > > > > more tries: time -p ls -l <5k+ entry dir>  in ~180sec
> > > > >
> > > > > On 2.6.23 client and 2.4.31 server running userland rpc.nfs.V2:
> > > > > first  try: time -p ls -l <2k+ entry dir>  in ~2.5sec
> > > > > more tries: time -p ls -l <2k+ entry dir>  in ~7sec
> > > > >
> > > > > first  try: time -p ls -l <5k+ entry dir>  in ~8sec
> > > > > more tries: time -p ls -l <5k+ entry dir>  in ~43sec
> > > > >
> > > > > Remounting the nfs-dir on the client resets the problem.
> > > > >
> > > > > Any ideas?
> > > >
> > > > Ok, I played some more with this, and it turns out that nfsV3 is a lot
> > > > faster.  But, this does not explain why the 2.4.31 kernel is still
> > > > over 4-times faster than 2.6.23.
> > > >
> > > > Can anybody explain what's going on?
> > >
> > > Sure, Neil can! ;)
> 
> Thanks Andrew!
> 
> > Nuh.
> > He said "userland rpc.nfs.Vx".  I only do "kernel-land NFS".  In these
> > days of high specialisation, each line of code is owned by a different
> > person, and finding the right person is hard....
> >
> > I would suggest getting a 'tcpdump -s0' trace and seeing (with
> > wireshark) what is different between the various cases.
> 
> Thanks Neil for looking into this.  Your suggestion has already been answered 
> in a previous post, where the difference has been attributed to "ls -l" 
> inducing lookup for the first try, which is fast, and getattr for later 
> tries, which is super-slow.
> 
> Now it's easy to blame the userland rpc.nfs.V2 server for this, but what's 
> not clear is how come 2.4.31 handles getattr faster than 2.6.23?
> 

We broke 2.6?  It'd be interesting to run the ls in an infinite loop on the
client them start poking at the server.  Is the 2.6 server doing physical
IO?  Is the 2.6 server consuming more system time?  etc.  A basic `vmstat
1' trace for both 2.4 and 2.6 would be a starting point.

Could be that there's some additional latency caused by networking changes,
too.  I expect the tcpdump/wireshark/etc traces would have sufficient
resolution for us to be able to see that.

