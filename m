Return-Path: <linux-kernel-owner+w=401wt.eu-S1760300AbZKZORO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbZKZORO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 09:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760105AbZKZORN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 09:17:13 -0500
Received: from bamako.nerim.net ([62.4.17.28]:60412 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbZKZORM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 09:17:12 -0500
Date: Thu, 26 Nov 2009 15:17:16 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       "Michele De Candia (VT)" <michele.decandia@valueteam.com>,
       Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] ALS: TSL2550 driver move from i2c/chips
Message-ID: <20091126151716.303e4c7e@hyperion.delvare>
In-Reply-To: <20091012173824.0f3ef021@hyperion.delvare>
References: <4ACF4AC6.7070802@cam.ac.uk>
	<20091010183347.52b043ed@hyperion.delvare>
	<4AD3477D.4020904@cam.ac.uk>
	<20091012173824.0f3ef021@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 17:38:24 +0200, Jean Delvare wrote:
> On Mon, 12 Oct 2009 16:13:01 +0100, Jonathan Cameron wrote:
> > > The operating mode selects the measurable range. Standard range is from
> > > 0 to 1846 lux, extended range is from 0 to 9230 lux, with a resolution
> > > divided by 5. Extended mode is also 5 times faster.
> > > 
> > > What do we want to do with this? I am open to suggestions. There are
> > > several possibilities. The operating mode could be provided as platform
> > > data and stay internal to the driver. Or we can leave is visible to
> > > user-space, in which case I'd recommend that we do so in terms of
> > > "range" rather than "mode", so that other drivers can use the same
> > > convention, whatever it becomes. For example, one would write the range
> > > of values he/she wants to be able to measure and the driver would put
> > > the device in the most appropriate mode.
> >
> > That sounds like a sensible approach.  For now I guess a sysfs parameter
> > like illuminance_range_max would do the job and we can add a min for any
> > device that features an offset?
> 
> Yes, this sounds sensible.

Following up publicly so that everyone interested knows what's going on.

Jonathan and me tested the above idea on the tsl2550 driver, and it
turns out that it doesn't work well. The TSL2550 computes the lux of
visible light by computing a difference between total light (infra-red +
visible) and infra-red light. When there's a lot of infra-red light, it
is very easy to saturate the light sensors in standard mode, even
though the amount of visible light is low.

The bottom line is that one may need to reduce the integration time
(which is what the "extended mode" is really about) even if the result
fits in the standard mode's range. In the light of this, it seems
wrong to hide the mode behind the name "illuminance_range_max". It
seems better to export the exposure time as is, readable and writable.
Remains to agree on a file name and unit.

-- 
Jean Delvare
