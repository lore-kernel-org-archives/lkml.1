Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbZEEIWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbZEEIWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 04:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbZEEIWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 04:22:32 -0400
Received: from [212.69.161.110] ([212.69.161.110]:52831 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZEEIWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 04:22:30 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
Date: Tue, 5 May 2009 10:21:32 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: david@lang.hm, Willy Tarreau <w@1wt.eu>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>, Kyle Moffett <kyle@moffetthome.net>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <200905041028.13865.philipp.reisner@linbit.com> <1241457851.3315.41.camel@mulgrave.int.hansenpartnership.com>
In-Reply-To: <1241457851.3315.41.camel@mulgrave.int.hansenpartnership.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905051021.33461.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 May 2009 19:24:11 James Bottomley wrote:
> On Mon, 2009-05-04 at 10:28 +0200, Philipp Reisner wrote:
> > On Sunday 03 May 2009 16:45:25 James Bottomley wrote:
> > > On Sun, 2009-05-03 at 07:36 -0700, david@lang.hm wrote:
> > > > On Sun, 3 May 2009, James Bottomley wrote:
> > > > > Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
> > > > >
> > > > > On Sat, 2009-05-02 at 22:40 -0700, david@lang.hm wrote:
> > > > >> On Sun, 3 May 2009, Willy Tarreau wrote:
> > > > >>> On Sat, May 02, 2009 at 09:33:35AM +0200, Bart Van Assche wrote:
> > > > >>>> On Fri, May 1, 2009 at 10:59 AM, Andrew Morton
> > > > >>>>
> > > > >>>> <akpm@linux-foundation.org> wrote:
> > > > >>>>> On Thu, 30 Apr 2009 13:26:36 +0200 Philipp Reisner
> >
> > <philipp.reisner@linbit.com> wrote:
> > > > >>>>>> This is a repost of DRBD
> > > > >>>>>
> > > > >>>>> Is it being used anywhere for anything?  If so, where and what?
> > > > >>>>
> > > > >>>> One popular application is to run iSCSI and HA software on top
> > > > >>>> of DRBD in order to build a highly available iSCSI storage
> > > > >>>> target.
> > > > >>>
> > > > >>> Confirmed, I have several customers who're doing exactly that.
> > > > >>
> > > > >> I will also say that there are a lot of us out here who would have
> > > > >> a use for DRDB in our HA setups, but have held off implementing it
> > > > >> specificly because it's not yet in the upstream kernel.
> > > > >
> > > > > Actually, that's not a particularly strong reason because we
> > > > > already have an in-kernel replicator that has much of the
> > > > > functionality of drbd that you could use.  The main reason for
> > > > > wanting drbd in kernel is that it has a *current* user base.
> > > > >
> > > > > Both the in kernel md/nbd and drbd do sync and async replication
> > > > > with primary side bitmaps.  The main differences are:
> > > > >
> > > > >      * md/nbd can do 1 to N replication,
> > > > >      * drbd can do active/active replication (useful for cluster
> > > > >        filesystems)
> > > > >      * The chunk size of the md/nbd is tunable
> > > > >      * With the updated nbd-tools, current md/nbd can do point in
> > > > > time rollback on transaction logged secondaries (a BCS requirement)
> > > > > * drbd manages the mirror state explicitly, md/nbd needs a user
> > > > > space helper
> > > > >
> > > > > And probably a few others I forget.
> > > >
> > > > one very big one:
> > > >
> > > > DRDB has better support for dealing with split brain situations and
> > > > recovering from them.
> > >
> > > I don't really think so.  The decision about which (or if a) node
> > > should be killed lies with the HA harness outside of the province of
> > > the replication.
> > >
> > > One could argue that the symmetric active mode of drbd allows both
> > > nodes to continue rather than having the harness make a kill decision
> > > about one.  However, if they both alter the same data, you get an
> > > irreconcilable data corruption fault which, one can argue, is directly
> > > counter to HA principles and so allowing drbd continuation is arguably
> > > the wrong thing to do.
> >
> > When you do asynchronous replication, how do you ensure that implicit
> > write-after-write dependencies in the stream of writes you get from
> > the file system above, are not violated on the secondary ?
>
> Are you telling me drbd doesn't currently do this?
>

No I am not. DRBD does exactly this!
But I am wondering how that is achieved in the MD/NBD stack when running 
in async mode.

The issue is covered since the early days in DRBD, (back in 2000).
The issue, and the solution we have in DRBD is described in this paper:

http://www.drbd.org/fileadmin/drbd/publications/drbd_paper_for_NLUUG_2001.pdf

> The way nbd does it (in the updated tools is to use DIRECT_IO and
> fsync).

Is that available in the existing tools ? -- Are the updated tools
something that will be available in the future ?

Are you telling me md/ndb (async) doesn't currently do this ?

> > There might be a disk scheduler on the secondary.
>
> There usually is a disk scheduler ... you just have to take the required
> action to persuade it to preserve ordering ... a simplistic way of doing
> this is to switch to the noop scheduler.

The issue actually goes further down the stack. Not only the in kernel
disk scheduler might reorder something, also the driver and finally the
drive might do so.

What we have in DRBD boils down to:

* We obey all possible write after write dependencies in the stream of
  writes we get from the upper layers. And generate DRBD internal
  reorder barriers for the packet stream.
* On the secondary node we impose these barriers onto the stream of writes
  submitted to the stack below us by either:

   - Let previously submitted write-IO drain before we submit write-IO after
     such an DRBD barrier. (That we have since 2000 or so)

   - Additionally issue a blkdev_issue_flush()

   - Use write requests with BIO_RW_BARRIER. This method has two advantages:
     We can continue to submit writes after the DRBD internal barrier
     immediately, and the number of requests with BIO_RW_BARRIER can be
     further reduced. 
     See section 6 of
     http://www.drbd.org/fileadmin/drbd/publications/drbd8.pdf
     for more details, and nice illustrations.

     Unfortunately only high end SAN devices seem to benefit from this
     method. For most in-machine-disk controlers this method does not
     achieve the highest throughput.

Expressed in other words: 
We allow reordering on the secondary node to an extend so that we can
guarantee that no implicit write-after-write dependencies are violated.

Coming back to the idea of disabling the in Linux IO scheduler. It might
solve the issue for some devices, but it does not guarantee to solve it.

-Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

