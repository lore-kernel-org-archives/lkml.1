Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZLBBxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZLBBxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 20:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbZLBBxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 20:53:35 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:43157 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbZLBBxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 20:53:34 -0500
Subject: Re: -rt dbench scalabiltiy issue
From: john stultz <johnstul@us.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>,
       Clark Williams <williams@redhat.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, cmm@us.ibm.com
In-Reply-To: <20091126062020.GH17484@wotan.suse.de>
References: <1255723519.5135.121.camel@localhost.localdomain>
	 <20091017223902.GA29439@wotan.suse.de> <1258507696.2077.61.camel@localhost>
	 <20091118042516.GC21813@wotan.suse.de>
	 <1258683764.3840.28.camel@localhost.localdomain>
	 <20091123090630.GF5602@wotan.suse.de> <1259115377.2115.25.camel@localhost>
	 <20091125071804.GE17484@wotan.suse.de>
	 <1259187633.3585.31.camel@localhost.localdomain>
	 <20091126062020.GH17484@wotan.suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 01 Dec 2009 17:53:34 -0800
Message-ID: <1259718814.2163.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 07:20 +0100, Nick Piggin wrote:
> On Wed, Nov 25, 2009 at 02:20:33PM -0800, john stultz wrote:
> > On Wed, 2009-11-25 at 08:18 +0100, Nick Piggin wrote:
> > > If you're using acls or something on ext2 then lock free path walk
> > > might fail more often.
> > 
> > CC'ed Ted and Mingming as they might be interested:
> > 
> > Got ext4 data up:
> > http://sr71.net/~jstultz/dbench-scalability/graphs/ext4-scalability.png
> 
> Ahh, looks much nicer than ext3, at least on non-rt. -rt seems to
> be running into journal lock contention.

Yep.


> 
> > Looks pretty similar to ext2. I'm also seeing path_get contention as
> > well with your patch on ext4 in the perflogs:
> > http://sr71.net/~jstultz/dbench-scalability/perflogs/2.6.32-rc7-nick.ext4.perflog
> 
> That's *all* coming from reading /proc/mounts by the looks. I don't
> think we're going to bother trying to make d_path incredibly scalable,
> the fix is to fix glibc's statvfs call.
> 
> As I said, you can work around this by changing dbench's statvfs call
> to statfs.
> 
> After that, the same journal locks look like they might hit next, but
> it should get quite a lot further.

Thanks for reminding me. I had tried this for ext2, but didn't see much
change, so I forgot to try it for ext4. 

But your right. I've verified changing dbench to use statfs() does cause
the path_get contention to fall out for the mainline ext4 case. It
doesn't change too much in the -rt case, but it does help (and gives a
really nice boost for the non-rt case).

See:
http://sr71.net/~jstultz/dbench-scalability/graphs/ext4-statfs-scalability.png
vs
http://sr71.net/~jstultz/dbench-scalability/graphs/ext4-scalability.png


Perflogs here:
http://sr71.net/~jstultz/dbench-scalability/perflogs/


So yea from -rt's perspective, with this patchset we're down to journal
lock contention for ext3 and ext4 as the main issue now.


Nick: So what's your plan to upstream this work?  With 2.6.32 around the
corner and 2.6.32-rt likely following shortly, I don't think pushing the
backport to 2.6.31-rt make much sense right at this moment. But when
2.6.32-rt does arrive, it might be nice to have the broken out patches.

Thomas/Ingo: Any thoughts on how receptive you guys would be to picking
up these changes for -rt (maybe for 2.6.32-rt)? Or should they go
mainline first?

thanks
-john

