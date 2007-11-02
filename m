Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbXKBHmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbXKBHmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 03:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXKBHmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 03:42:09 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:21865 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbXKBHmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 03:42:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ADPmVRERUL3xNf7ncSSghLA+Ros4jUqIzwLJkEBflBIArRvNIqPKFtItOgRIY8gvwKn+1aR1GTYuugnsnL48k/39nRr5SA2zilXwX3J8D20eK7JXBRNj9fJtQIrTpGrWUUSVhIdle2LLNVT67fa+oKvTwVMUBJSmW2NT9zYK6cU=
Message-ID: <64bb37e0711020042x190592abm7d7d7a74995eff54@mail.gmail.com>
Date: Fri, 2 Nov 2007 08:42:05 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Fengguang Wu" <wfg@mail.ustc.edu.cn>
Subject: Re: writeout stalls in current -git
Cc: "Maxim Levitsky" <maximlevitsky@gmail.com>,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Chinner" <dgc@sgi.com>, linux-fsdevel@vger.kernel.org
In-Reply-To: <393968464.13148@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710220822.52370.maximlevitsky@gmail.com>
	 <200710221421.21439.maximlevitsky@gmail.com>
	 <393056632.00561@ustc.edu.cn>
	 <200710221505.35397.maximlevitsky@gmail.com>
	 <20071022131045.GA5357@mail.ustc.edu.cn> <393060478.03650@ustc.edu.cn>
	 <64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com>
	 <393903856.06449@ustc.edu.cn>
	 <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com>
	 <393968464.13148@ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Subject is still missleading, I'm using 2.6.23-mm1.

On 11/2/07, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> On Thu, Nov 01, 2007 at 07:20:51PM +0100, Torsten Kaiser wrote:
> > On 11/1/07, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> > > On Wed, Oct 31, 2007 at 04:22:10PM +0100, Torsten Kaiser wrote:
> > > > Since 2.6.23-mm1 I also experience strange hangs during heavy writeouts.
> > > > Each time I noticed this I was using emerge (package util from the
> > > > gentoo distribution) to install/upgrade a package. The last step,
> > > > where this hang occurred, is moving the prepared files from a tmpfs
> > > > partion to the main xfs filesystem.
> > > > The hangs where not fatal, after a few second everything resumed
> > > > normal, so I was not able to capture a good image of what was
> > > > happening.
> > >
> > > Thank you for the detailed report.
> > >
> > > How severe was the hangs? Only writeouts stalled, all apps stalled, or
> > > cannot type and run new commands?
> >
> > Only writeout stalled. The emerge that was moving the files hung, but
> > everything else worked normaly.
> > I was able to run new commands, like coping the /proc/meminfo.
>
> But you mentioned in the next mail that `watch cat /proc/meminfo`
> could also be blocked for some time - I guess in the same time emerge
> was stalled?

The behavior was different on these stalls.
On first report the writeout stopped completly, the emerge stopped,
but at that time a cat /proc/meminfo >~/stall/meminfo did succedd and
not stall.
About the watch cat /proc/meminfo, I will write in the answer to the
other mail...

> > [snip]
> > > > After this SysRq+W writeback resumed again. Possible that writing
> > > > above into the syslog triggered that.
> > >
> > > Maybe. Are the log files on another disk/partition?
> >
> > No, everything was going to /
> >
> > What might be interesting is, that doing cat /proc/meminfo
> > >~/stall/meminfo did not resume the writeback. So there might some
> > threshold that only was broken with the additional write from
> > syslog-ng. Or syslog-ng does some flushing, I dont now. (I'm using the
>
> Have you tried explicit `sync`? ;-)

No. I wanted to see what is stalled. So I startet by collecting info
from /proc and then the SysRq+W. And after hitting SysRQ the writeout
started to resume without any further action.

But I think I have seen a `sync` stall also. During an other emerge I
noticed the system slowing down and wanted to use `sync` to speed up
the writeout. The result was, that the writeout did not speed up
imiedetly only after around a minitue. The `sync` only returned at
that time.
Can writers starve `sync`?

> > syslog-ng package from gentoo:
> > http://www.balabit.com/products/syslog_ng/ , version 2.0.5)
> >
> > > > The source tmpfs is mounted with any special parameters, but the
> > > > target xfs filesystem resides on a dm-crypt device that is on top a 3
> > > > disk RAID5 md.
> > > > During the hang all CPUs where idle.
> > >
> > > No iowaits? ;-)
> >
> > No, I have a KSysGuard in my taskbar that showed no activity at all.
> >
> > OK, the subject does not match for my case, but there was also a tmpfs
> > involved. And I found no thread with stalls on xfs. :-)
>
> Do you mean it is actually related with tmpfs?

I don't know. It's just that I have seen tmpfs also redirtieing inodes
in these logs and the stalling emerge is moving files from tmpfs to
xfs.
It could be, but I don't know enough about tmpfs internals to really be sure.
I just wanted to mention, that tmpfs is involved somehow.

Torsten
