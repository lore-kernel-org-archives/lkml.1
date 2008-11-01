Return-Path: <linux-kernel-owner+w=401wt.eu-S1752297AbYKAKz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbYKAKz2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 06:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbYKAKzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 06:55:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:36096 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbYKAKzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 06:55:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZJylD1oYNJviNCWLJtXjhyCd4rj5dPdtbsOUGQ6zoHygYPSVedTGZJFkStyZMl9IsR
         qUhRgXsWvW0xO0fKWz6pV90IXLh8iW0KrOgvIVlgzDE9PR7cOs2Vkk+kaORMuSTst192
         LWnrgPVVP4MZWcKFwv8vY9Ankhca7D+MyIh4U=
Message-ID: <7a6abd110811010355v260a60a8uc9e951a633ad10e7@mail.gmail.com>
Date: Sat, 1 Nov 2008 11:55:15 +0100
From: "Jonas Bonn" <jonas.bonn@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] API for system clocks (oscillators)
Cc: "Dmitry Baryshkov" <dbaryshkov@gmail.com>,
       "Jon Smirl" <jonsmirl@gmail.com>, "Mark Brown" <broonie@sirena.org.uk>
In-Reply-To: <20081031112045.GC7516@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7a6abd110810300741wf73f838laa3754e23c22baf3@mail.gmail.com>
	 <9e4733910810300840v7cd45c2cu629d23a27a02c61a@mail.gmail.com>
	 <7a6abd110810300927l428b11f3u509ad31364c08f1f@mail.gmail.com>
	 <9e4733910810300939x40a7afear7a49557604ced628@mail.gmail.com>
	 <7a6abd110810301001r7fc311adifd85fece79cb5c45@mail.gmail.com>
	 <20081030201341.GD13678@sirena.org.uk>
	 <7a6abd110810301315h4f486412u7d88b4a75fc764ef@mail.gmail.com>
	 <20081031112045.GC7516@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Thanks for all your feedback.  It's been very helpful.

I have thought about this some more and it seems quite feasible to add
a reasonable device interface to the existing clk infrastructure to
allow for specifying device frequency constraints and for
notifications to devices when clock frequencies change.  Below is a
description of some of the new API... it only accounts for continuous
frequency range constraints right now, but it is planned to allow for
frequency tables, as well.

I have implemented this interface for the S3C2410 and it provides the
functionality that I want, namely that clocks become first-class
citizens and can be adjusted without specific knowledge about all the
underlying devices that may or may not be using them at any given
time.  Most of the code will fit nicely into the GENERIC_CLK
infrastructure as it's essentially just list manipulation and callback
invocation... but more on that another time as I'm mainly just
interested in feedback on the API at this point in time.

API follows...

Regards,
Jonas


/* Device functions */

enum {
	CLK_FREQ_PRECHANGE,
	CLK_FREQ_POSTCHANGE,
	CLK_FREQ_FAILED,
	CLK_FREQ_INVALID,
	CLK_FREQ_VALID
};

/**
 * clk_dev_set_freq_range - set bounds of continuous freq range constraints
 * @clk: clock source
 * @dev: device
 * @min: minimum acceptable frequency in Hz
 * @max: maximum acceptable frequency in Hz
 *
 * This sets minimum and maximum frequencies that are acceptable as input to
 * the device.  The device is guaranteed that the clock will respect these
 * constraints as long as the device is "engaged" (see below) to the clock.
 *
 * After this function returns, the clock "knows" about the device, but the
 * device is not automatically engaged to the clock (see below).
 *
 * Return success (0)
 * -EINVAL if clock is physically incapable of providing any frequency within
 *  		these bounds
 * ******FIXME******: select good errno's to return for these cases
 * -EWAIT_FOR_NOTIFCATION : the clock frequency must be adjusted to meet the
 *  		new device constraints; the device can consider itself engaged
 *  		to the clock, but should wait for a frequency change
 *  		notification before enabling itself
 * -EANOTHER_DEVICE_PREVENTS_THESE CONSTRAINTS:
 *		if the device is already engaged to the clock and tries to
 *		set a frequency range that does not intersect with the
 *		constraints of another _engaged_ device, then this errno
 *		will be returned; the device can disengage from the clock
 *		and then set the same constraints again, or it can remain
 *		engaged and try another set of constraints that hopefully
 *		will intersect with the constraints of other devices.
 */
int clk_dev_set_freq_range(struct clk* clk, struct device* dev,
unsigned long min, unsigned long max);

/**
 * clk_dev_set_notifier - set callback for clock frequency changes
 * @clk: clock source
 * @dev: device
 * @notifier: frequency change callback
 *
 * This sets a callback to be invoked when the clock's frequency is changing.
 *
 * After this function returns, the clock "knows" about the device, but the
 * device is not automatically engaged to the clock (see below).
 *
 * The notifier gets called twice, once before and once after the clock has
 * switched frequency.  The device can take necessary measures depending on
 * its own requirements to adjust to the new input frequency from the clock.
 *
 * The type indicates whether the change is about to happen or has just
 * happened; or whether the attempt to physically change the clock rate failed.
 * Possible values for type are CPU_FREQ_PRECHANGE, CPU_FREQ_POSTCHANGE, or
 * CPU_FREQ_FAILED.
 *
 * If the type is CPU_FREQ_PRECHANGE, the clock is running at 'oldfreq'; for
 * CPU_FREQ_POSTCHANGE, the clock is running at 'newfreq'.
 *
 * If the type is CPU_FREQ_FAILED, then the driver is expected to reconfigure
 * itself to work with 'oldfreq'; this is important in the case where
the driver
 * made changes already in the PRECHANGE stage.  When CPU_FREQ_FAILED
 * notification is called, the clock should be assumed to be running at
 * oldfreq; newfreq is largely informational, but indicates to the driver which
 * frequency the clock _failed_ to be set to and which frequency the driver
 * may have made adjusts to in the PRECHANGE stage.
 *
 * Note that the notifier gets called for both engaged and disengaged devices.
 *
 * Returns success (0)
 */
int clk_dev_set_notifier(struct clk* clk,
			struct device* dev,
			void (*notifier)(struct clk *clk,
					 struct device *dev,
					 unsigned long newfreq,
					 unsigned long oldfreq,
					 int type));

/**
 * clk_dev_engage - "connect" the device to the clock.
 * @clk: clock source
 * @dev: device
 *
 * This activates the frequency constraints of this device for the clock.
 * After engaging the clock, the device is assumed to be actively using the
 * clock; the device can assume that its frequency constraints will be
 * respected by the clock.
 *
 * Returns:
 * 0 : if clock already meets device constraints
 * ******FIXME******: select good errno's to return for these cases
 * -EWAIT_FOR_NOTIFCATION : the clock frequency must be adjusted to meet the
 *  		device constraints; the device can consider itself engaged to
 *  		the clock, but should wait for a frequency change notification
 *  		before enabling itself
 * -EANOTHER_DEVICE_PREVENTS_ENGAGEMENT: another device is already
engaged to the
 *  		clock with constraints that do not intersect with this
 *  		device's constraints; it will be impossible to engage at
 *  		this time and the device remains unengaged (the device can
 *  		change its constraints and try again, if the device spec
 *  		allows)
 */
int clk_dev_engage(struct clk* clk, struct device* dev);

/**
 * clk_dev_disengage - "disconnect" the device from the clock.
 * @clk: clock source
 * @dev: device
 *
 * This deactivates the frequency constraints of this device for the clock.
 * After disengaging the device, the clock may run at frequencies outside of
 * the device constraints or even be turned off completely.  The device is
 * assumed to be "not listening" to the clock anymore.
 *
 * Returns nothing; disengaging always succeeds
 */
void clk_dev_disengage(struct clk* clk, struct device* dev);

/**
 * clk_max_freq - return maximum clock frequency under current constraints
 * @clk:
 *
 * This function takes into account the frequency constraints of all _engaged_
 * devices and all child clocks to return the highest frequency that the clock
 * may run at.
 */
unsigned long clk_max_freq(struct clk* clk);

/**
 * clk_min_freq - return minimum clock frequency under current constraints
 * @clk:
 *
 * This function takes into account the frequency constraints of all _engaged_
 * devices and all child clocks to return the lowest frequency that the clock
 * may run at.
 */
unsigned long clk_min_freq(struct clk* clk);
