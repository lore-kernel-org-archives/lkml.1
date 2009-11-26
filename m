Return-Path: <linux-kernel-owner+w=401wt.eu-S932471AbZKZGUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbZKZGUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 01:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbZKZGUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 01:20:21 -0500
Received: from cantor.suse.de ([195.135.220.2]:47892 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbZKZGUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 01:20:20 -0500
Date: Thu, 26 Nov 2009 07:20:20 +0100
From: Nick Piggin <npiggin@suse.de>
To: john stultz <johnstul@us.ibm.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>,
       Clark Williams <williams@redhat.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, cmm@us.ibm.com
Subject: Re: -rt dbench scalabiltiy issue
Message-ID: <20091126062020.GH17484@wotan.suse.de>
References: <1255723519.5135.121.camel@localhost.localdomain> <20091017223902.GA29439@wotan.suse.de> <1258507696.2077.61.camel@localhost> <20091118042516.GC21813@wotan.suse.de> <1258683764.3840.28.camel@localhost.localdomain> <20091123090630.GF5602@wotan.suse.de> <1259115377.2115.25.camel@localhost> <20091125071804.GE17484@wotan.suse.de> <1259187633.3585.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259187633.3585.31.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 02:20:33PM -0800, john stultz wrote:
> On Wed, 2009-11-25 at 08:18 +0100, Nick Piggin wrote:
> > If you're using acls or something on ext2 then lock free path walk
> > might fail more often.
> 
> CC'ed Ted and Mingming as they might be interested:
> 
> Got ext4 data up:
> http://sr71.net/~jstultz/dbench-scalability/graphs/ext4-scalability.png

Ahh, looks much nicer than ext3, at least on non-rt. -rt seems to
be running into journal lock contention.

 
> Looks pretty similar to ext2. I'm also seeing path_get contention as
> well with your patch on ext4 in the perflogs:
> http://sr71.net/~jstultz/dbench-scalability/perflogs/2.6.32-rc7-nick.ext4.perflog

That's *all* coming from reading /proc/mounts by the looks. I don't
think we're going to bother trying to make d_path incredibly scalable,
the fix is to fix glibc's statvfs call.

As I said, you can work around this by changing dbench's statvfs call
to statfs.

After that, the same journal locks look like they might hit next, but
it should get quite a lot further.


> > Anyway, I think all these problems should largely go away when path
> > walk fall back is improved.
> 
> Great, let me know when you have a rough shot at it ready for testing.

Will do
