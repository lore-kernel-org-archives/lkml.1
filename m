Return-Path: <linux-kernel-owner+w=401wt.eu-S1764087AbXESSnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764087AbXESSnn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758137AbXESSnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:43:33 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:15040 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395AbXESSnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:43:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=kq0/+BLUEEps0jy8VGIO3EHLtnShQmPdjLp+x9NHIQEN0tqYs6TgWRXCiHTGVK+LFG6H5VZ789gD4Q2tUhBZ4iCSeZQCRP2VOwaYHieVgJOqqKZD2YJ5VzgiTh4sqzfGMl+JU0EwqfNs6VCVbMnajLMNRFj+AALPuh7zQ0x5cZ8=
Message-ID: <464F4548.6020101@gmail.com>
Date: Sat, 19 May 2007 20:43:20 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Paul Mundt <lethal@linux-sh.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       garyhade@us.ibm.com
Subject: Re: [PATCH] libata: implement ata_wait_after_reset()
References: <20070510072005.GA27316@linux-sh.org>    <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com>    <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com>    <20070511005217.GA23186@li <464B3505.20004@gmail.com> <2229.81.207.0.53.1179592754.squirrel@secure.samage.net>
In-Reply-To: <2229.81.207.0.53.1179592754.squirrel@secure.samage.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
> Doesn't the controller generate an interrupt when it detects a harddisk?
> Is it really needed to do polling?

It depends on the controller but the closest thing is usually PHY status
changed interrupt and PHY readiness doesn't imply device readiness.  On
some controllers, you can play smart and try to do these things by
interrupt but polling is much more reliable for this kind of stuff.

> Idea: What about implementing a sata_sil specific .check_status function,
> instead of using the generic ata_check_status()? That one could check other
> registers to find out what's really going on in the case ENODEV is returned
> by ata_check_status(), or something like that.

Yeah, if SCR registers are accessible, 0xff doesn't indicate the device
isn't there, so the whole skip-0xff logic probably shouldn't apply in
such cases, but we can also achieve pretty good result by just making
the first reset tries a bit more aggressive.

The first timeout of 10secs was chosen because most desktop drives take
somewhere around 7~10 secs to spin up, so retrying before that didn't
make much sense, but mobile devices usually spin up faster, so it might
be worth to try one more time inbetween.

-- 
tejun
