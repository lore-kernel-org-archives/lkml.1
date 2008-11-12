Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbYKLXno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbYKLXno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYKLXnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:43:33 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1378 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYKLXnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:43:33 -0500
Date: Wed, 12 Nov 2008 23:43:31 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28] mfd: Correct WM8350 I2C return code usage
Message-ID: <20081112234331.GB8272@sirena.org.uk>
References: <1226324477-21022-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081112184956.GA17382@sortiz.org> <20081112200007.GA31451@sirena.org.uk> <20081112230636.GB17382@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112230636.GB17382@sortiz.org>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 12:06:36AM +0100, Samuel Ortiz wrote:

> I understand that. I'm just saying that I would prefer wm8350->read_dev() to
> return the actual bytes read, be it for SPI or I2C. Same for write_dev(), of
> course.

Hrm.  That's never been the case, even with the buggy code since the
register address was included in the physical access for at least the
writes.

> With this patch you're breaking that expectation because the read|write_dev()
> I'd prefer to fix the callers code, so that we keep the expected semantics

Just to clarify, when you say "expectation" and "fix" are you talking
about your preference that the hardware access functions return the
number of bytes read or written or is there something else going on
here? 

> for your read|write_dev() routines. For example with wm8350_clear_bits():

> -	if (err) {
> +	ret = wm8350_read(wm8350, reg, 1, &data);
> +	if (ret != 1) {
>  		dev_err(wm8350->dev, "read from reg R%d failed\n", reg);
> +		err = -EIO;

Note that wm8350_read() works a level up, only calling the physical read
function if the register cache can't satisfy the access.  Changing that
would be another layer of alteration.

To be honest I'm really not sure it's worth changing this - I'm having a
hard time thinking of a user that would be able to do anything useful
with a short access.  It also seems like it'd be a rather invasive
change for an -rc.
