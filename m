Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbXJCU22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbXJCU22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 16:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbXJCU2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 16:28:20 -0400
Received: from 1wt.eu ([62.212.114.60]:2781 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208AbXJCU2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 16:28:19 -0400
Date: Wed, 3 Oct 2007 22:24:46 +0200
From: Willy Tarreau <w@1wt.eu>
To: Frans Pop <elendil@planet.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Subject: Re: Decreasing stime running confuses top (was: top displaying 9999% CPU usage)
Message-ID: <20071003202446.GQ10199@1wt.eu>
References: <200710031433.34504.elendil@planet.nl> <Pine.LNX.4.64.0710031731030.27745@kivilampi-30.cs.helsinki.fi> <Pine.LNX.4.64.0710031746260.27745@kivilampi-30.cs.helsinki.fi> <200710032127.42147.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200710032127.42147.elendil@planet.nl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 09:27:41PM +0200, Frans Pop wrote:
> On Wednesday 03 October 2007, you wrote:
> > On Wed, 3 Oct 2007, Ilpo Järvinen wrote:
> > > On Wed, 3 Oct 2007, Frans Pop wrote:
> > > > The only change is in 2 consecutive columns: "2911 502" -> "2912
> > > > 500". Is processor usage calculated from those? Can someone explain
> > > > how?
> > >
> > > The latter seems to be utime ...decreasing. No wonder if arithmetics
> > > will give strange results (probably top is using unsigned delta?)...
> >
> > Hmm, minor miscounting from my side, stime seems more appropriate...
> 
> Here is a series showing utime and stime for kontact over 2 minutes.
> 
> Values were obtained using (identical values removed):
> $ while true; do awk '{print $14" "$15}' /proc/5269/stat; sleep 1; done | ts
> 
> Oct 03 21:17:12 12220 1593
> Oct 03 21:17:18 12221 1594
> Oct 03 21:17:26 12222 1593  <--
> Oct 03 21:17:34 12223 1594
> Oct 03 21:17:43 12224 1594
> Oct 03 21:17:51 12224 1595
> Oct 03 21:17:59 12225 1596
> Oct 03 21:18:07 12226 1595  <--
> Oct 03 21:18:15 12227 1596
> Oct 03 21:18:18 12228 1596
> Oct 03 21:18:22 12229 1595  <--
> Oct 03 21:18:31 12230 1596
> Oct 03 21:18:39 12230 1597
> Oct 03 21:18:44 12231 1597
> Oct 03 21:18:48 12232 1596  <--
> Oct 03 21:18:56 12233 1597
> Oct 03 21:19:04 12234 1596  <--
> Oct 03 21:19:11 12235 1597
> 
> So, is it normal that stime decreases sometimes or a kernel bug?
> /me expects the last...

Let me guess... Dual core AMD64 ?

I'm 99.99% sure that if you boot with "notsc", the problem disappears. If
so, you have one of those wonderful AMD64 with unsynced clock and without
HPET to sync with. I wrote a simple program in the past to exhibit the
problem. It would bsimply run "date +%s" in a busy loops and display each
time it would change. Amazing. It could jump back and forth by up to 3
seconds!

Basically, it looked like this :

old=$(date +%s)
while : ; do
   x=$(date +%s)
   if [ $x != $old ]; then
      echo "$old -> $x"
      old=$x
   fi
done
 
Regards,
Willy

