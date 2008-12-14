Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbYLNBlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbYLNBlz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 20:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYLNBlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 20:41:47 -0500
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:38769 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087AbYLNBlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 20:41:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=t4CPJHxyEJYAViRgodZBatMYa9mIcgdJvH7z7Ig5BUGDz+hv8blCIBXsfIElu/4v;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Sat, 13 Dec 2008 20:41:37 -0500
From: Bill Fink <billfink@mindspring.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 2/2] ieee1934: dv1394 interrupt enabling/disabling
 broken on big-endian
Message-Id: <20081213204137.d150645c.billfink@mindspring.com>
In-Reply-To: <4944561D.4010608@s5r6.in-berlin.de>
References: <1229210489.11257.16.camel@brick>
	<4944561D.4010608@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4dc44255ce2a200a4956c54ee2c2fcd2ac350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 96.234.158.88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2008, Stefan Richter wrote:

> For linux1394-devel to know:
> 
> Harvey Harrison wrote at LKML:
> > After annotating the frame structs, this was left:
> > drivers/ieee1394/dv1394.c:2113:23: warning: invalid assignment: |=
> > drivers/ieee1394/dv1394.c:2113:23:    left side has type restricted __le32
> > drivers/ieee1394/dv1394.c:2113:23:    right side has type int
> > drivers/ieee1394/dv1394.c:2121:24: warning: invalid assignment: &=
> > drivers/ieee1394/dv1394.c:2121:24:    left side has type restricted __le32
> > drivers/ieee1394/dv1394.c:2121:24:    right side has type int
> > drivers/ieee1394/dv1394.c:2123:24: warning: invalid assignment: |=
> > drivers/ieee1394/dv1394.c:2123:24:    left side has type restricted __le32
> > drivers/ieee1394/dv1394.c:2123:24:    right side has type int
> > 
> > Which looks like a real bug on a big-endian arch as it would set/clear
> > the wrong bit.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> >  drivers/ieee1394/dv1394.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/ieee1394/dv1394.c b/drivers/ieee1394/dv1394.c
> > index f258e61..a329e6b 100644
> > --- a/drivers/ieee1394/dv1394.c
> > +++ b/drivers/ieee1394/dv1394.c
> > @@ -2110,17 +2110,17 @@ static void ir_tasklet_func(unsigned long data)
> >  			f = video->frames[next_i / MAX_PACKETS];
> >  			next = &(f->descriptor_pool[next_i % MAX_PACKETS]);
> >  			next_dma = ((unsigned long) block - (unsigned long) f->descriptor_pool) + f->descriptor_pool_dma;
> > -			next->u.in.il.q[0] |= 3 << 20; /* enable interrupt */
> > -			next->u.in.il.q[2] = 0; /* disable branch */
> > +			next->u.in.il.q[0] |= cpu_to_le32(3 << 20); /* enable interrupt */
> > +			next->u.in.il.q[2] = cpu_to_le32(0); /* disable branch */
> >  
> >  			/* link previous to next */
> >  			prev_i = (next_i == 0) ? (MAX_PACKETS * video->n_frames - 1) : (next_i - 1);
> >  			f = video->frames[prev_i / MAX_PACKETS];
> >  			prev = &(f->descriptor_pool[prev_i % MAX_PACKETS]);
> >  			if (prev_i % (MAX_PACKETS/2)) {
> > -				prev->u.in.il.q[0] &= ~(3 << 20); /* no interrupt */
> > +				prev->u.in.il.q[0] &= ~cpu_to_le32(3 << 20); /* no interrupt */
> >  			} else {
> > -				prev->u.in.il.q[0] |= 3 << 20; /* enable interrupt */
> > +				prev->u.in.il.q[0] |= cpu_to_le32(3 << 20); /* enable interrupt */
> >  			}
> >  			prev->u.in.il.q[2] = cpu_to_le32(next_dma | 1); /* set Z=1 */
> >  			wmb();
> 
> Looks like a bug + correct fix indeed.  Apparently dv1394 was never used on big
> endian PCs.  Which is good, because we want to phase out dv1394 eventually.

I use dv1394 on a big-endian PPC system (2.6.15 kernel) to watch DV video
via xine, and this has always worked fine for me.  And this shouldn't be
phased out until the equivalent functionality is added to ffmpeg via the
new APIs.

						-Bill
