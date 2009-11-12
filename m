Return-Path: <linux-kernel-owner+w=401wt.eu-S1751491AbZKLH1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbZKLH1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 02:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZKLH1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 02:27:33 -0500
Received: from gw1.transmode.se ([213.115.205.20]:42908 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbZKLH1d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 02:27:33 -0500
In-Reply-To: <25e057c00911111546w414cbebbx5e7142866b925f65@mail.gmail.com>
References: <1257762136-17593-1-git-send-email-Joakim.Tjernlund@transmode.se> <25e057c00911111546w414cbebbx5e7142866b925f65@mail.gmail.com>
Subject: Re: [PATCH] zlib: Optimize inffast even more
X-KeepSent: B722E663:C2FD29AD-C125766C:002805EE;
 type=4; name=$KeepSent
To: roel kluin <roel.kluin@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OFB722E663.C2FD29AD-ONC125766C.002805EE-C125766C.00289A56@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.com>
Date: Thu, 12 Nov 2009 08:23:29 +0100
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5 HF964|October 21, 2009) at
 2009-11-12 08:27:37
MIME-Version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

roel kluin <roel.kluin@gmail.com> wrote on 12/11/2009 00:46:41:
>
> On Mon, Nov 9, 2009 at 11:22 AM, Joakim Tjernlund
> <Joakim.Tjernlund@transmode.se> wrote:
> > This improves zlib: Optimize inffast when copying direct from output
> > and gives another 3-4% improvement for my MPC8321 target.
> > Does not need CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS,
> > uses get_unaligned() but only in one place.
> > The copy loop just above this one can also use this
> > optimization, but I havn't done so as I have not tested if it
> > is a win there too.
> >
> > Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
> > ---
>
>
> > @@ -240,52 +243,49 @@ void inflate_fast(z_streamp strm, unsigned start)
> >                 }
> >                 else {
> >                     from = out - dist;          /* copy direct from output */
> > -#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> >                     /* minimum length is three */
> >                    if (dist > 2 ) {
> > -                       unsigned short *sout = (unsigned short *)(out - OFF);
> > -                       unsigned short *sfrom = (unsigned short *)(from - OFF);
> > -                       unsigned long loops = len >> 1;
> > +                       unsigned short *sout;
> > +                       unsigned short *sfrom;
> > +                       unsigned long loops;
> >
> > +                       /* Align out addr, only sfrom might be unaligned */
> > +                       if (!((long)(out - 1 + OFF)) & 1) {
>
> I think this is wrong
>
> did you mean
>
> if (!((long)(out - 1 + OFF) & 1))

Yes, will fix and send out a new patch with
cleanups and fixes for CPUs that cannot do unaligned
accesses. Thanks

      Jocke

