Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbZBSVQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbZBSVQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 16:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbZBSVPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 16:15:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51061 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021AbZBSVPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:15:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFD] Automatic suspend
Date: Thu, 19 Feb 2009 22:15:16 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.0902190956570.3012-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0902190956570.3012-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902192215.18365.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009, Alan Stern wrote:
> On Thu, 19 Feb 2009, Rafael J. Wysocki wrote:
> 
> > On Thursday 19 February 2009, Alan Stern wrote:
> > > On Thu, 19 Feb 2009, Rafael J. Wysocki wrote:
> > > 
> > > > > If some devices are autosuspended after a local inactivity timeout, I
> > > > > don't want to wait for those devices to autosuspend if I know the code
> > > > > that needed to run is done. This could cause delays in the normal
> > > > > case,
> > > > 
> > > > Isn't it a matter of adjusting the inactivity timeouts in a suitable way?
> > > 
> > > It's not that simple.  A single device driver has a very local view, 
> > > not suitable for deciding whether the entire system should go to sleep.
> > > 
> > > So for example, a disk driver might think it's appropriate to spin down 
> > > the disk after 10 seconds of inactivity.  But an overall system monitor 
> > > might realize that nothing is going on right now and want to put the 
> > > system to sleep immediately, without waiting the 10 seconds for the 
> > > disk to autosuspend.
> > 
> > Now, the question is what criteria would the overall system monitor use to make
> > such a decision.
> > 
> > > > > and it could prevent suspend if a background process (not using
> > > > > wakelocks) is accessing a disk more frequently than its idle timeout.
> > > > 
> > > > Well, actually, shouldn't it prevent suspend from happening?  Arguably, it just
> > > > means that the disk is continuously being accessed with respect to the inactive
> > > > timeout granularity.
> > > 
> > > That's true, but it shows the problem of making the autosleep decision
> > > based on disk activity.  An auto-sleep should not have to wait for
> > > every device (or some suitable subset) to become idle for some minimum
> > > time; it should be able to kick in at short notice.
> > 
> > Again, the decision to trigger automatic suspend has to be based on some
> > well defined criteria and the (in)activity of devices seems to be one of them.
> 
> I don't know what criteria the system monitor would use.

I don't know either and this is the whole point.  They need to be specified
somehow and I'm not sure if "we suspend if no one is holding a wakelock" is the
right approach.

> It might have to be platform-specific.  The Android people seem to have a
> pretty good idea of what criteria will work for them.

I'd really like to know in what situations Androind is supposed to suspend
automatically.

> Inactivity of devices isn't always a good criterion.  There might be a
> background task which wakes up every few seconds to do something as
> long as the system is awake, thereby keeping some device always active.  
> The activity from this background task shouldn't prevent an auto-sleep.

In fact there are two problems here.  First, there may be a task preventing
some devices from becoming inactive (like syslog).  Second, there may be
a task waiting for something important to happen, such that automatic suspend
cannot be triggered while it's waiting.  In both cases, IMO, the kernel is not
in a point to decide whether to suspend or not, because the user space knows
better.

Thanks,
Rafael
