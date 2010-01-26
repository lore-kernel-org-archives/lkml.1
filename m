Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169Ab0AZKLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab0AZKLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 05:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702Ab0AZKLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 05:11:42 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:62937 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab0AZKLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 05:11:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MxX//oiv6qfi07Dy+J4ub4uFe2CSIHMCbEO6cXLQ1xKgB6/0HRY/fhAq1HGAAtigQg
         Eq+78BmJxywGumZn184jpLxbFSPax4NudQ3kfOJ/ZJf0tQIEytg61S4HRdEEY/E3U2JW
         AhIDo42XKKP+XtuSlxeRYR2pfHjiU6/cB4a4I=
Date: Tue, 26 Jan 2010 02:11:35 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: Greg KH <greg@kroah.com>, Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
       "Frysinger, Michael" <Michael.Frysinger@analog.com>,
       "Getz, Robin" <Robin.Getz@analog.com>,
       Jean Delvare <khali@linux-fr.org>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [RFC] Staging:IIO: New ABI
Message-ID: <20100126101135.GA3630@core.coreip.homeip.net>
References: <4B571DA4.6070603@cam.ac.uk>
 <20100120153748.GA29401@kroah.com>
 <4B573501.9090001@jic23.retrosnub.co.uk>
 <20100122204718.GA15759@kroah.com>
 <20100123001414.GB14538@core.coreip.homeip.net>
 <20100123003112.GA7836@kroah.com>
 <20100126093422.GA3480@core.coreip.homeip.net>
 <8A42379416420646B9BFAC9682273B6D0F1DB670@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A42379416420646B9BFAC9682273B6D0F1DB670@limkexm3.ad.analog.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 09:55:45AM +0000, Hennerich, Michael wrote:
> 
> 
> >From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> >
> >On Fri, Jan 22, 2010 at 04:31:12PM -0800, Greg KH wrote:
> >> On Fri, Jan 22, 2010 at 04:14:15PM -0800, Dmitry Torokhov wrote:
> >> > On Fri, Jan 22, 2010 at 12:47:18PM -0800, Greg KH wrote:
> >> > > On Wed, Jan 20, 2010 at 04:53:21PM +0000, Jonathan Cameron wrote:
> >> > > > I am not aware of these. Could you direct me to the current api? Also note that these
> >> > > > aren't the actual alarms, merely a means of enabling the relevant event on the related
> >> > > > event character device.
> >> > >
> >> > > Hm, I thought we had an accelerator interface somewhere...
> >> > >
> >> >
> >> > Nope. And I am also interested in this since I am sittign on a bunch of
> >> > accelerometers, magnetometers, etc drivers that are trying to plug into
> >> > input sysbsystem and quite unsure what to do with them.
> >> >
> >> > It was OK whch HDAPS and friends when they were using input for
> >> > secondary, toyish purposes, but these new drivers trying to use input
> >> > devnts as primary API and I am unsure if it is the best solution.
> >> > Accelerometer might be used as an input device but not always an input
> >> > device.
> >>
> >> Yeah, I see it using a joystick interface, which might be acceptable for
> >> "toy" devices like you say.
> >>
> >> But for "real" ones, we should do something else.
> >>
> >> Maybe, for devices that are going to be used by x.org, like the "toy"
> >> ones, we stick with the current input interface, but for others, we use
> >> a "real" interface, probably through hwmon, so that users can get the
> >> real data out in a consistant manner.
> >>
> >
> >I'd rather have all of them use real interface and then have a bridge
> >to input module to enable toyish mode (unless the device in question
> >is really truly an input device).
> >
> >--
> >Dmitry
> 

> I really don't see that hwmon provides facilities like input/evdev
> does.  Queuing of events with time stamping and multiple reader
> support.

I understand that using evdev might be very convenient but I still
believe that input should be used for human interfaces, not for generic
data acquisition. The idea is that userpsace consumers should be able to
query device's capabilities and based on those capabilities be able to
classify and properly handle the device. Now it all breaks when we get
random hardware using EV_ABS/ABS_* for delivering some datastream that
has nothing to do with coordinates.

>  The adxl34x accelerometer driver for example is really
> intended to be a input device.  Send EV_KEY for x,y,z_TAP detections,
> send EV_KEY for 3D orientation sensing, and EV_ABS for acceleration.
> With very minor platform data customization you can use this device
> for game controls or GUI interaction.  A few examples include digital
> picture frames, ebook readers, etc.
> 

I see. However, can it be reasonably used for other purposes? If yes
than maybe input is not the best primary subsystem the driver should
belong to. Having said that I need to look at the driver again...

-- 
Dmitry
