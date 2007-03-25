Return-Path: <linux-kernel-owner+w=401wt.eu-S932386AbXCYSVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbXCYSVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 14:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932359AbXCYSVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 14:21:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386AbXCYSVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 14:21:35 -0400
Date: Sun, 25 Mar 2007 11:19:30 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       zaitcev@redhat.com
Subject: Re: Fix sudden warps in mousedev
Message-Id: <20070325111930.f6428509.zaitcev@redhat.com>
In-Reply-To: <200703250134.03416.dtor@insightbb.com>
References: <20070324001610.724a820a.zaitcev@redhat.com>
	<200703250134.03416.dtor@insightbb.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007 01:34:02 -0400, Dmitry Torokhov <dtor@insightbb.com> wrote:

> > +                * Without this, a touchpad may report an unchanged position,
> > +                * then a sync. The input_event() eats the position report, but
> > +                * lets the sync through. We increment pkt_count and leave 
> > +                * a stale position in the ring. If a future reference to fx(2)
> > +                * hits the stale position, a large dx is reported, and the
> > +                * pointer warps across the screen.
> > +                */
> > +               dev = mousedev->handle.dev;
> > +               fx(0) = dev->abs[ABS_X];
> > +               fy(0) = dev->abs[ABS_Y];
> 
> I do not like input hanlders poking into input devices... Can't we just
> reset pkt_count at the beginning of the touch to get rid of stale data?

The pkt_count is zero at the moment of assignment above.

Please look at the included trace again:

> > Event: time 1174703243.305535, type 1 (Key), code 330 (Touch), value 1
> >           <---- touch!=0 now, we're on
> > Event: time 1174703243.305538, type 3 (Absolute), code 24 (Pressure), value 31
> > Event: time 1174703243.305541, -------------- Report Sync ------------
> >           <---- We increment the pkt_count, leaving value of 3687 in old_y
> > Event: time 1174703243.342452, type 3 (Absolute), code 0 (X), value 4747
> > Event: time 1174703243.342455, type 3 (Absolute), code 1 (Y), value 1988
> >           <----- Later to be fy(1), not used for warping purposes :-)
> > Event: time 1174703243.342459, -------------- Report Sync ------------
> > Event: time 1174703243.356225, type 3 (Absolute), code 0 (X), value 4749
> > Event: time 1174703243.356237, type 3 (Absolute), code 1 (Y), value 1987
> >           <----- warp here, by the difference of 3687 and 1987, plus
> >                  some small frac_dy value. Easily jumps half the screen.
> > Event: time 1174703243.356246, -------------- Report Sync ------------

The assignment happens at .305535. The pkt_count is zero, and fy(0) contains
stale data (ovewritten by the assignment). The touchpad reports a position
next with input_report_abs(). If the position were different, we'd receive
an event between .305535 and .305538 and it would be stored in fy(0).

However, if position is the same, as in this case, input_report eats it.
At .305541 we increment pkt_count. The fy(0) location becomes fy(1) at
this point. Without the assignment it contains the stale position.

I can explore alternatives, but for now using dev->abs[] seems to be most
expedient.

-- Pete
