Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbZDTViD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbZDTViD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 17:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZDTVhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 17:37:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36829 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZDTVhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 17:37:50 -0400
Date: Mon, 20 Apr 2009 17:37:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: nauman@google.com, fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org,
       jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com,
       agk@redhat.com, balbir@linux.vnet.ibm.com,
       Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [dm-devel] Re: dm-ioband: Test results.
Message-ID: <20090420213738.GB9080@redhat.com>
References: <20090416.114750.226794985.ryov@valinux.co.jp> <20090416141125.GB8896@redhat.com> <e98e18940904161324p9833457vdf699d66bb323591@mail.gmail.com> <20090420.172959.193682665.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090420.172959.193682665.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 05:29:59PM +0900, Ryo Tsuruta wrote:
> Hi Vivek and Nauman,
> 
> > On Thu, Apr 16, 2009 at 7:11 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > On Thu, Apr 16, 2009 at 11:47:50AM +0900, Ryo Tsuruta wrote:
> > >> Hi Vivek,
> > >>
> > >> > General thoughts about dm-ioband
> > >> > ================================
> > >> > - Implementing control at second level has the advantage tha one does not
> > >> >   have to muck with IO scheduler code. But then it also has the
> > >> >   disadvantage that there is no communication with IO scheduler.
> > >> >
> > >> > - dm-ioband is buffering bio at higher layer and then doing FIFO release
> > >> >   of these bios. This FIFO release can lead to priority inversion problems
> > >> >   in certain cases where RT requests are way behind BE requests or
> > >> >   reader starvation where reader bios are getting hidden behind writer
> > >> >   bios etc. These are hard to notice issues in user space. I guess above
> > >> >   RT results do highlight the RT task problems. I am still working on
> > >> >   other test cases and see if i can show the probelm.
> > 
> > Ryo, I could not agree more with Vivek here. At Google, we have very
> > stringent requirement for latency of our RT requests. If RT requests
> > get queued in any higher layer (behind BE requests), all bets are off.
> > I don't find doing IO control at two layer for this particular reason.
> > The upper layer (dm-ioband in this case) would have to make sure that
> > RT requests are released immediately, irrespective of the state (FIFO
> > queuing and tokens held). And the lower layer (IO scheduling layer)
> > has to do the same. This requirement is not specific to us. I have
> > seen similar comments from filesystem folks here previously, in the
> > context of metadata updates being submitted as RT. Basically, the
> > semantics of RT class has to be preserved by any solution that is
> > build on top of CFQ scheduler.
> 
> I could see the priority inversion by running Vivek's script and I
> understand how RT requests has to be handled. I'll create a patch
> which makes dm-ioband cooperates with CFQ scheduler. However, do you
> think we need some kind of limitation on processes which belong to the
> RT class to prevent the processes from depleting bandwidth?

I think to begin with, we can keep the same behavior as CFQ. An RT task
can starve other tasks.

But we should provide two configurations and user can choose any one.
If RT task is in root group, it will starve other sibling tasks/groups. If
it is with-in a cgroup, then it will starve its sibling only with-in that
cgroup and will not impact other cgroups.

What I mean is following.

			root
			/  \
		      RT   group1

In above configuration RT task will starve everybody else.

			root
		        /   \
		   group1   group2
		   /  \
	         RT   BE

In above configuration  RT task will starve only sibling in group1 but
will not starve the tasks in group2 or in root.

Thanks
Vivek
