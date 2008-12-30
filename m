Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbYL3JPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYL3JPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 04:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYL3JP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 04:15:29 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:5740 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbYL3JP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 04:15:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=gb6/fInpEKAsPVX1zLlziX2sdSjKalX+VXkDLELsIUAqdVumzYkwSyYAXEtjy6Bl9s
         f3JK07cPa6trPMTJoRQJiKG6CYyngByuY0C38yttQk5PlFd/fnMrRKwnPxg+lVI8v5zU
         YLIb54s/7mJFLEFofNWNxQSybQM+X+6i7Bpds=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: Re: 2.6.28 thinks that my PS/2 mouse is a touchpad
Date: Tue, 30 Dec 2008 01:15:01 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.9-159.fc10.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Arjan Opmeer <arjan@opmeer.net>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
References: <gj4r8h$okm$1@ger.gmane.org> <20081229185619.GA18394@adopmeer.homeip.net> <4959B9B7.2050800@gmail.com>
In-Reply-To: <4959B9B7.2050800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812300115.02408.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 December 2008 22:03:35 Alexander E. Patrakov wrote:
> Arjan Opmeer wrote:
> > On Sat, Dec 27, 2008 at 02:06:29PM +0500, Alexander E. Patrakov wrote:
> >> elantech.c: Elantech version query result 0x00, 0x01, 0x64.
> >> elantech.c: assuming hardware version 1, firmware version 0.100
> >> elantech.c: Synaptics capabilities query result 0x00, 0x02, 0x64.
> >
> > However, all version query results I have seen from Elantech touchpads
> > have a non-zero first byte and a zero second byte. So we could test for
> > that to prevent this mouse from being detected as a touchpad.
> >
> > Dmitry, do you think something like this is sufficient?
> >
> > --- elantech.c.ORIG	2008-12-29 19:35:01.000000000 +0100
> > +++ elantech.c.NEW	2008-12-29 19:38:59.000000000 +0100
> > @@ -618,6 +618,10 @@ int elantech_init(struct psmouse *psmous
> >  	}
> >  	pr_info("elantech.c: Elantech version query result 0x%02x, 0x%02x,
> > 0x%02x.\n", param[0], param[1], param[2]);
> > +	if (param[0] == 0 || param[1] != 0) {
> > +		pr_info("elantech.c: Probably not a real Elantech touchpad.
> > Aborting.\n"); +		goto init_fail;
> > +	}
> >  	etd->fw_version_maj = param[0];
> >  	etd->fw_version_min = param[2];
>
> This is still slightly wrong. The mouse does work, but is misnamed in
> the dmesg output and in /proc/bus/input/devices:
>
> psmouse serio1: ID: 10 00 64<6>elantech.c: Elantech version query result
> 0x00, 0x01, 0x64.
> elantech.c: Probably not a real Elantech touchpad. Aborting.
> input: ImExPS/2 Elantech Touchpad as /class/input/input8
>

Yeah, elantech_init() is too late, we need to do something in
elantech_detect()... What did /proc/bus/input/devices show before
2.6.28? Logitech, right? Maybe we need to pull part of Logitech check (number
of buttons for example) from logips2pp.c. We'd need to test with real elantech
touchpads too though.

-- 
Dmitry
