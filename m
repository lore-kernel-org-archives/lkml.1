Return-Path: <linux-kernel-owner+w=401wt.eu-S1751701AbXCNPok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbXCNPok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXCNPoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:44:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:60478 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbXCNPoi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rZ5QHv82TNCTH3XyuWORCOhvL+tnhNOzfPQrY/WmteLeRZoIO2mTZu/5bg7GNGxyhGFyfNEm2Tm6D7J6jMszbtJzABCt5HawxbNrfBAagCMuX2Mq17sHI2bF85HkLxSDkj4A67UXCNbnS86dmQj2HZj19i6vUg23D+B960+rSyo=
Message-ID: <d120d5000703140844q736d47te89c8b388dc13969@mail.gmail.com>
Date: Wed, 14 Mar 2007 11:44:36 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "=?ISO-8859-1?Q?=C9ric_Piel?=" <Eric.Piel@tremplin-utc.net>
Subject: Re: [PATCH 0/2] wistron_btns: More keymaps
Cc: mitr@volny.cz, otauber@web.de, linux-kernel@vger.kernel.org,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>,
       "Vojtech Pavlik" <vojtech@suse.cz>
In-Reply-To: <45F812A1.3060108@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <45ECA23A.5010503@tremplin-utc.net>
	 <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com>
	 <45ED8809.70309@tremplin-utc.net> <45F72D37.6090004@tremplin-utc.net>
	 <d120d5000703140654y4d8cb0a3oafd49c48a045bd77@mail.gmail.com>
	 <45F812A1.3060108@tremplin-utc.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/07, Éric Piel <Eric.Piel@tremplin-utc.net> wrote:
> 03/14/2007 02:54 PM, Dmitry Torokhov wrote/a écrit:
> > Hi Eric,
> >
> :
> > I have couple of comments/requests:
> >
> > 1. KEY_OPEN and KEY_CLOSE should not be used to signal state of the
> > lid, they correspond to Accpication Control Open and Close keys from
> > USB HID HUT spec:
> >
> >     http://www.usb.org/developers/devclass_docs/Hut1_12.pdf
> >
> > SW_LID shoudl be used to signal lid state instead.
> The keycodes put in the keymap are simply the same as in acerhk, just
> because I couldn't think of better. Indeed, KEY_OPEN and KEY_CLOSE seem
> to badly fit if they might be interpreted by userland as opening or
> closing a document! That would be better to generate a SW_LID event, but
> I'm not sure how to do that, is it just about using
> input_report_switch(x, SW_LID, 0 or 1) instead of using
> input_report_key()?

Yes.

> Probably I need to update input_dev->swbit as well.

Yes.

> Do I have to anything else to generate switch events?

No, that should be it. Oh, you need to set SW_BIT in dev->evbit.

>
> Sincerely, I don't think anyone is using this info (especially because
> probably the info is also passed though ACPI) so that would be fine with
> me to just not generate any event :-P Tell me if you think it worths it.
>

I think it shoudl be OK to send this event even if ACPI also sends it.
Recently I changed ACPI button driver to send SW_LID events and since
siwiches have state (on/off, open/closed) applications shoudl not get
confised by getting 2 events in a row (they shoudl not interpret it as
toggle).

> > 2. I also have a concern about using KEY_SCREEN to signal toggling
> > display on and off. I am CCing Vojtech - he must know what the
> > original intent of this key code was. BTW, when user presses
> > corresponding button - does the display actually goes off? Maybe we
> > need another switch.
> Only few laptops generate an event for this key (most of the laptop
> simply switch the screen). I don't have access to any of those, so I've
> no idea if it's the userland which has to control the display or if it's
> just information for the userland. Maybe Olaf knows? I don't think it's
> possible to convert it to a switch event because it doesn't report the
> information about if screen is on or off.
>
> On the same topic, there are some "KEY_MEDIA" generated when key to
> change display output is pressed. Is it fine for you or do have a more
> suiting keycode in mind?
>

I wonder what KEY_SWITCHVIDEOMODE does on Macs... Any Mac users out there?

>
> > 3. The number of keymap tables grew considerably ;) Do you think it
> > woudl make sense to allocate memory for keymap at device creation time
> > and copy selected keymap and them mark all original keymaps as
> > __initdata so they are discarded one module completed initialization?
> In the patch, I've reduced the keymap structure to only take 32bits per
> key. So, in the absolute, it's not that terrible with each keymap taking
> about 40 bytes. Still, it wouldn't hurt to save space knowing that it's
> likely that the list keeps growing up. It shouldn't be hard to do as you
> propose with the __initdata.
>
> I had thought about a different way: as the generic keymap should fit
> most of the laptop, we could save only the difference of a given laptop
> to this keymap (then behaving more like a "quirk"). This would have the
> advantage of saving space even in the source file ;-)
>
> I'll try to tinker a bit with both approaches and see what fit best.
> Anyway, is it ok for you to merge those patches first and later I'll
> come up with a space-saver patch?
>

Yes, I will merge the fisrt 2 patches once we work out the proper
keycodes/other events.

-- 
Dmitry
