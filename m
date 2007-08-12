Return-Path: <linux-kernel-owner+w=401wt.eu-S937395AbXHLSG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937395AbXHLSG1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 14:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765244AbXHLSGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 14:06:15 -0400
Received: from astra.simleu.ro ([80.97.18.177]:45226 "EHLO astra.simleu.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760902AbXHLSGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 14:06:13 -0400
X-Greylist: delayed 1217 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Aug 2007 14:06:13 EDT
Date: Sun, 12 Aug 2007 19:45:49 +0200
From: Iustin Pop <iusty@k1024.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: david@lang.hm, Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: [RFD] Layering: Use-Case Composers (was: DRBD - what is it,
	anyways? [compare with e.g. NBD + MD raid])
Message-ID: <20070812174549.GA2915@teal.hq.k1024.org>
Mail-Followup-To: Jan Engelhardt <jengelh@computergmbh.de>, david@lang.hm,
	Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
	linux-raid@vger.kernel.org
References: <200708121335.17267.a1426z@gawab.com> <Pine.LNX.4.64.0708121325170.28963@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0708120933210.19502@asgard.lang.hm> <Pine.LNX.4.64.0708121901290.28963@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708121901290.28963@fbirervta.pbzchgretzou.qr>
X-Linux: This message was written on Linux
X-Header: /usr/include gives great headers
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 07:03:44PM +0200, Jan Engelhardt wrote:
> 
> On Aug 12 2007 09:39, david@lang.hm wrote:
> >
> > now, I am not an expert on either option, but three are a couple things that I
> > would question about the DRDB+MD option
> >
> > 1. when the remote machine is down, how does MD deal with it for reads and
> > writes?
> 
> I suppose it kicks the drive and you'd have to re-add it by hand unless done by
> a cronjob.

>From my tests, since NBD doesn't have a timeout option, MD hangs in the
write to that mirror indefinitely, somewhat like when dealing with a
broken IDE driver/chipset/disk.

> > 2. MD over local drive will alternate reads between mirrors (or so I've been
> > told), doing so over the network is wrong.
> 
> Certainly. In which case you set "write_mostly" (or even write_only, not sure
> of its name) on the raid component that is nbd.
> 
> > 3. when writing, will MD wait for the network I/O to get the data saved on the
> > backup before returning from the syscall? or can it sync the data out lazily
> 
> Can't answer this one - ask Neil :)

MD has the write-mostly/write-behind options - which help in this case
but only up to a certain amount.


In my experience DRBD wins hands-down over MD+NBD because of MD doesn't
know (or handle) a component that never returns from a write, which is
quite different from returning with an error. Furthermore, DRBD was
designed to handle transient errors in the connection to the peer due to
its network-oriented design, whereas MD is mostly designed with local or
at least high-reliability disks (where disk can be SAN, SCSI, etc.) and
a failure is not normal for MD. Thus the need for manual reconnect in MD
case and the automated handling of reconnects in case of DRBD.

I'm just a happy user of both MD over local disks and DRBD for networked
raid.

regards,
iustin
