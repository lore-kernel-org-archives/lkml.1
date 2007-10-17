Return-Path: <linux-kernel-owner+w=401wt.eu-S1764752AbXJQP5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764752AbXJQP5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757561AbXJQP5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:57:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:25362 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbXJQP5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:57:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZKEEtG3OFWs6E2556Y/w4Eh4EaeA8d9XTyAvRdfrUy5VyOVwRTpXLgnTSs2/nfanmOKCVUlg74CI65RIjIn/5rO6z44KeGMjtd+mfRTQBmTYiM1dDaz63F2PntBykMhu504VqDFDiDta6d49h8y3lL5hrDAnF6BCkeWMbq4aCLw=
Message-ID: <d120d5000710170857i3f534544pe9cab0ca6c1b0aa4@mail.gmail.com>
Date: Wed, 17 Oct 2007 11:57:18 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Jeremy Katz" <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com
In-Reply-To: <alpine.LFD.0.999.0710161325570.6887@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192481110-9299-1-git-send-email-katzj@redhat.com>
	 <20071016141153.GA3237@khazad-dum.debian.net>
	 <20071016142121.GA21431@srcf.ucam.org>
	 <20071016143124.GB3237@khazad-dum.debian.net>
	 <20071016144016.GA21749@srcf.ucam.org>
	 <20071016165623.GA13643@khazad-dum.debian.net>
	 <20071016184606.GB25181@srcf.ucam.org>
	 <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org>
	 <d120d5000710161312r5676cad8o60e0790a4e8d5256@mail.gmail.com>
	 <alpine.LFD.0.999.0710161325570.6887@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> On Tue, 16 Oct 2007, Dmitry Torokhov wrote:
> >
> > I agree that these are 2 different events. My argument is that
> > "VOLUME_UP_NOTIFY" event is similar to "BATTERY_OUT_NOTIFY",
> > "DOCK_UNDOCK_NOTIFY", etc, etc and should be sent not through input
> > layer but through a generic (yet to be designed) notification
> > mechanism. Something lighter than input. Something like uevents over
> > netlink.
>
> Well, I'd argue that:
>
>  - it's going to be the same entity that cares in both cases (ie anybody
>   who is ready to accept VOLUME_UP keypresses is also the exact same
>   party that also wants to know if VOLUME_UP happened *independently*)
>
>   Ergo: making it a separate "generic" notification is actually totally
>   counterproductive, because it just adds complexity.

That is a good argument. If there are no other users for this other
transport then I agree, inventing it just for keypress notifications
is bad idea.

>  - it really is a keypress. Yes, it's a keypress with side effects, but
>   it still tends to have a distinct source, and as such it is interesting
>   *as* a keypress.
>
>   IOW: it should have all the same "incidental" side effects as any other
>   keypress. Example: I think it's reasonable to consider it an event as
>   far as the screen saver is concerned. In other words, it's not *just* a
>   "volume was raised" event. It's a "volume was raised, and the user
>   actually pressed a key to do so".
>

This is a good argument for having 2 separate types of events but not
for which transport shoudl be used to deliver it.

> So I do think they are keypresses, although I also suspect that like many
> other magical keys, the "NOTIFY" version is often also totally hidden by
> hardware/firmware interactions (ie I'm pretty sure that many of those
> special keys will never be visible at all to the OS, because the firmware
> hides the fact that they were pressed entirely!)
>

Yes, on my old Inspiron brightness is completely handled by firmware.
There is no ACPI, nor keyboard events generated whatsoever.

OK, I guess I would like to hear once again from userspace guys -
DBUS/HAL/etc. Do they see a need for a generic interface that can be
used for all kinds of events, not only related to keypresses. If they
say that they only care about notifications arising from keypresses
then I will add EV_NOTIFY type of events to input layer. What events
would we need? I can imagine:

KEY_BRIGHTNESSUP_NOTIFY
KEY_BRIGHTNESSDOWN_NOTIFY
KEY_BRIGHTNESSMIN_NOTIFY
KEY_BRIGHTNESSMAX_NOTIFY
KEY_VOLUMEUP_NOTIFY
KEY_VOLUMEDOWN_NOTIFY
KEY_MUTE_NOTIFY
KEY_DISPLAYSWITCH_NOTIFY
KEY_WIFI_NOTIFY

What else? And it better have "key" in its name, BATTERY_OUT_NOTIFY
won't fly ;)

-- 
Dmitry
