Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbXFLNI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbXFLNI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 09:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757943AbXFLNIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 09:08:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:25539 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927AbXFLNI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 09:08:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NEjI1h3czQhIfn6tAyvK/6izJrSt/BR8dNg/8dCoxdh+DhW0a0Q35jykrcXolPjPcsmvbInpTzmgHThbXm3822wQQbqORE5Q307UPUYhRWwKqx252/UQqVazFHgdg7AlUr7HZAyi9VgxamFwxzJFHBRsxPJP9/nzboK4L3LWSCk=
Message-ID: <d9b9d95f0706120608g979b89oc79dbc277d19862b@mail.gmail.com>
Date: Tue, 12 Jun 2007 14:08:27 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: joydev.c and saitek cyborg evo force
Cc: linux-kernel@vger.kernel.org,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0706121436070.10204@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
	 <d9b9d95f0705301526i66e99ef3v6c35165aa1a5f5c6@mail.gmail.com>
	 <d120d5000705311253n67d4247eh194e6f4457a0b4c@mail.gmail.com>
	 <Pine.LNX.4.64.0705312220250.5177@jikos.suse.cz>
	 <d9b9d95f0706011116j59fff917x9a86aac377f88937@mail.gmail.com>
	 <Pine.LNX.4.64.0706031139570.5177@jikos.suse.cz>
	 <d9b9d95f0706041506l257819a7pbcb8b8efc2eec049@mail.gmail.com>
	 <Pine.LNX.4.64.0706050008160.5177@jikos.suse.cz>
	 <d9b9d95f0706041546h4eef0b4eo2e191968be13d59a@mail.gmail.com>
	 <Pine.LNX.4.64.0706121436070.10204@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/07, Jiri Kosina <jkosina@suse.cz> wrote:
> the thing is that the aim of this quirk is to normalize the values that
> are being reported by bogus devices, so we don't really want to trust the
> values they provide here, do we?

Hi Jiri,

I don't know about the other joysticks, but Saitek did reported [0,
4096] which is the right answer, but between HID and Joydev it was
converted to [-127, 127]. I thought that the quirk was about that.

But seeing the quirk code it seems that if the range doesn't match it
forces [0, 256] (not trusting anything the device sends) and that's
not really needed for Saitek.

I'm not at all sure how the other devices behave and I do understand
the difficulty in testing every single one.

My opinion is that we shouldn't fall back to a hard-coded range for
all types of errors and rely on user calibration. Normally, game users
tend to dislike having to quit the game and recalibrate the joystick
to restart the game again (I do, at least). Furthermore, dealing with
every single type of error is impossible unless you have all devices
available for a recursive test every time something change, which is
not true.

Therefore, my view is that the only neat solution to all that is to
report the range as [0, 0] and auto-calibrate afterwards, while the
device is in use and reporting the real range. I found out that, not
all times the range goes to 4096, most of the time it stays as far as
4038, and setting the final range to that value (with
auto-calibration) is even more precise than the reported by the
device.

The drawback is the few calculations done during the first movements
of the joystick (function call and four small formulas) and the two
"IF (a > b)" for every axis event afterwards.

As this is my first kernel mode code I'm not sure how would that
schedule with other kernel processes (normally I rely on kernel's
scheduling process) but for a user-land program (real-time games
included) I wouldn't say it's too much overhead.

Let me know if I got it all backwards... ;)

cheers,
--renato

Reclaim your digital rights, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm
