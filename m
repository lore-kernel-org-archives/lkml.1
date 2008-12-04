Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbYLDUUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbYLDUUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 15:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbYLDUUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 15:20:01 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:40984 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbYLDUUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 15:20:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=JgTB7Ccig81hXFUJ0Ba4KAmfk09ShlVNSnUTzs4QQFjZDhfyWP8pgFyR1B6F9KqASb
         cWtsj8hfdcnatAJT59Q/XONc2d0m/Lt1ZUeLSROWARPtpR2lks42CK6UaFPBvWSAFT59
         OWVMFFkuwGjj16IoO/6xUN8RXRXq4CFUoGd9o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: vanilla kernels hang randomly under Fedora 10 on system with Radeon card
Date: Thu, 4 Dec 2008 21:18:17 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-next-20081128; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, Benny Amorsen <benny+usenet@amorsen.dk>
References: <200812012342.32575.bzolnier@gmail.com> <200812040107.36616.bzolnier@gmail.com> <200812042055.13731.bzolnier@gmail.com>
In-Reply-To: <200812042055.13731.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812042118.17921.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2008, Bartlomiej Zolnierkiewicz wrote:
> On Thursday 04 December 2008, Bartlomiej Zolnierkiewicz wrote:
> > On Wednesday 03 December 2008, Bartlomiej Zolnierkiewicz wrote:
> > > On Tuesday 02 December 2008, Dave Airlie wrote:
> > > > On Tue, Dec 2, 2008 at 8:42 AM, Bartlomiej Zolnierkiewicz
> > > > <bzolnier@gmail.com> wrote:
> > > > >
> > > > > Hi,
> > > > >
> > > > > After Fedora 9 -> Fedora 10 upgrade vanilla kernels which previously
> > > > > worked fine (next-20081128 and next-20081121) started to hang randomly
> > > > > on my Pentium M / 855PM / RV350 laptop.  Since (surprisingly) stock
> > > > > Fedora kernel (2.6.27.5-117.fc10.i686) was not affected I got the idea
> > > > > that either userspace changes uncovered some kernel regression or some
> > > > > Fedora specific patch must be fixing the issue.  Unfortunately vanilla
> > > > > 2.6.27 also freezed so after the usual pain caused by hitting bunch of
> > > > > unrelated problems [1] it turned out that drm-modesetting-radeon.patch
> > > > > is the magic patch and CONFIG_DRM_RADEON_KMS is the magic change.  With
> > > > > the patch and enabling the option next-20081128 works stable again...
> > > > >
> > > > > Since the following error gets logged by kernel:
> > > > >
> > > > > [drm:drm_buffer_object_validate] *ERROR* Failed moving buffer. cef578c0 1444 4000027 10000a0
> > > > > [drm:drm_buffer_object_validate] *ERROR* Out of aperture space or DRM memory quota.
> > > > >
> > > > > and it also seems that system is more responsive now (it was kind of
> > > > > sluggish previously) my draft theory is that F9 -> F10 triggered some
> > > > > AGP memory management bug and CONFIG_DRM_RADEON_KMS happens to fix it
> > > > > but I'll leave figuring this up to the more knowledgeable people... ;)
> > > > 
> > > > Well KMS is a purely Fedora thing, and enabling it completely avoids
> > > > the old driver codepaths so
> > > > while it might fix it, its more by accident than design.
> > > > 
> > > > I'm trying to track down the rv3xx hangs with hpa at the moment as he
> > > > sees them also, something in
> > > >  the 2.6.26->2.6.27 timeframe. I'm hoping running the 2.6.26 drm on
> > > > the 2.6.27 will help narrow it down.
> > > > 
> > > > Bisecting 2.6.26->2.6.27 might also help.
> > > 
> > > It could be a different issue.  I tried 2.6.26, 2.6.25 and 2.6.24
> > > and they all hang (they all worked fine with Fedora 9)...
> > > 
> > > I will try some older kernels but I start thinking that the xorg's ati
> > > driver update is the main cause (xorg-x11-drv-ati-6.8.0-19.fc9.i386.rpm
> > > -> xorg-x11-drv-ati-6.9.0-54.fc10.i386.rpm).
> > 
> > I just went straight to trying downgrading the driver and the older driver
> > indeed works fine.  Then I tried to narrow down the problem and the lucky
> > winner this time is the cute (== undocumented and unsigned-off) patch
> > called radeon-6.9.0-remove-limit-heuristics.patch.  The newer driver with
> > only this patch reverted fixes hangs for vanilla kernels and drm errors
> > for Fedora kernel.  Also performance problems that I've noticed in the
> > meantime (slower playback of 720p videos, sluggish window scrolling in
> > kmail) are completely gone.  That being said I'm not entirely sure whether
> 
> I was too quick here -- performance problems are still present with
> _Fedora_ kernel.
> 
> Reassuming: what I currently need to do to get my gfx working properly
> with F10 is reverting radeon-6.9.0-remove-limit-heuristics.patch from
> xorg-x11-drv-ati and using vanilla kernel instead of Fedora's one.

Heh, and it just hang on me after sending the above mail (it took like
1h or so for hang to occur) => the patch is just a very good trigger for
the "real" bug.  I'll now be running vanilla 6.9.0 to see how it goes...

Thanks,
Bart
