Return-Path: <linux-kernel-owner+w=401wt.eu-S1752445AbZLRHUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbZLRHUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 02:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZLRHUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 02:20:44 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57425 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751440AbZLRHUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 02:20:43 -0500
X-Sasl-enc: XYhQwouUMV62Q5XfTOpTrI2CWLKQXHB45TA2cl49c/ow 1261120842
Message-ID: <4B2B2D47.8050700@ladisch.de>
Date: Fri, 18 Dec 2009 08:20:39 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] drm_fb_helper: fix regression in pixclock check
References: <1261092303-4570-1-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1261092303-4570-1-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel wrote:
> Commit 5349ef3127c77075ff70b2014f17ae0fbcaaf199 changed pixclock to be
> initialized to zero instead of -1.

Zero meaning "there is no pixel clock value".  When I wrote the patch,
the FB (helper) code did not use this value at all, so zero was the only
value that could possibly be used.

> The validation routine always returns -EINVAL for a valid pixclock

It declares that the only valid pixclock value is "none".  This was
required to make the userspace API work, since the GET ioctls return
this value, and all programs expect to be able to PUT this value back.

> which prevents atomic kernel mode setting from working correctly.
> ...
> @@ -602,7 +602,7 @@ int drm_fb_helper_check_var(struct fb_var_screeninfo *var,
>  
> -	if (var->pixclock != 0)
> +	if (!var->pixclock)
>  		return -EINVAL;

This change breaks the userspace API again, unless the other parts of
the code have been changed to always return a valid pixclock value when
reading the current mode settings.

If we want to accept both zero and non-zero values for pixclock, this
check should be dropped altogether.

In drm_fb_helper_set_par(), there is a corresponding check that must be
kept in sync with this one.


Best regards,
Clemens
