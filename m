Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbYE0Oev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbYE0Oev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 10:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbYE0Oen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 10:34:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:21098 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbYE0Oem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 10:34:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=eRbe2AwL7TEDHnQX4davn0QSKhGTZw2taoJa7t7319BvtK94/73/hq2A/aIJICK8cjHmEvMqnws1ENxSVoBv9eRX8BVQxE3sxeVmTDyyq92pcheSJDb0vTJjs1rzmFuosfx+rF7TZXqCmFaleU1JlvG/GboZjxHahAvjjDOq9L4=
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH 14/15] rfkill: do not allow userspace to override ALL RADIOS OFF
Date: Tue, 27 May 2008 16:38:04 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "Thomas Renninger" <trenn@suse.de>,
       "Dmitry Torokhov" <dtor@mail.ru>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <200805231615.33414.IvDoorn@gmail.com> <1211897317.22073.1255269155@webmail.messagingengine.com>
In-Reply-To: <1211897317.22073.1255269155@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805271638.04290.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > You get that event when someone moves that slider switch in the side/top
> > > of a laptop which has to kill all RF output in hardware as far as safety
> > > regulations go.  Therefore, it refers to the only rfkill switch that has
> > > guidelines that say that it must always work, and that it must not be
> > > possible to override it in software.
> > 
> > That is a valid point, and rfkill is supposed to do that, but making
> > a difference between RFKILL_ALL and the individual types is wrong
> > because that won't result in a clearly defined expected behavior for all
> > rfkill keys.
> 
> IMO, the big difference between regular KEY_* and RFKILL_ALL is that
> RFKILL_ALL has EPO (emergency power-off) semanthics, while the others don't.
> 
> KEY_WLAN is usually easily overriden in firmware and software, vendors often
> don't even bother to implement it in firmware, it is just software.  RFKILL_ALL
> switches cannot be overriden at all in any hardware worth its weight, and they
> work even if the entire system has gone out for lunch and is deadlocked.
> That's quite a big difference.
> 
> The only reason I don't usually call the hardware rfkill switches "radio EPO
> switches" is because they are not big, red, and shaped like a mushroom.  But
> they are in fact required to act like one in airline regulations, AFAIK.  And
> that certainly matches the good implementations of the hardware rfkill switch
> I know of (they wire-kill the radios, not even firmware gets in the way).
> 
> So yes, I do feel RFKILL_ALL is different, and it warrants EPO semanthics in
> the kernel, while all other rfkill events, such as KEY_WLAN, don't.
> 
> I don't feel strongly about not giving EPO semanthics to other rfkill events,
> but I recommend against giving anything else EPO semanthics in rfkill.

You just made my 2 laptops very happy because apparently they
don't behave like most keys do. ;)

Laptop 1)
	- Key to control WLAN (Broadcom)
	- Key to control Bluetooth (Broadcom??)
Laptop 2)
	- Key to control WLAN (Intel)

And each key really controls the hardware, without any software required.
Especially for Laptop one it will not be nice to attack RFKILL_ALL to both keys,
since both control specific radio types.

> > > IMO, "kill ALL radios" events are is the only kind of rfkill input event
> > > that have to *always work*, even if something in userspace tried to
> > > configure it not to.
> > 
> > Well the definition of "ALL radios" is the part that is the question,
> > when the KEY_WLAN is
> > pressed it would be "ALL WLAN radios" and should still have the same
> > rules for allowing
> > or disallowing userspace to overwrite the status.
> 
> Not really.  If you are concerned with a type, it is not an emergency situation,
> nor is it a "you are entering a no-RF-emission area" situation.  There *IS* a
> difference when a human decides to shut down EVERYTHING regardless of type, or
> when he just wants the WLAN to stop wasting power but still wants Bluetooth up
> so that he can listen to music on his wireless headphones.

True, but the trick is that you don't know exactly when the radio is the emergency
key or not. Perhaps you do know with some hardware like thinkpad, but with my second
laptop for example, it only has 1 kind of radio and that is WLAN it also has 1 key.
When it is pressed, you simply don't know if it is switched off because of the
no-RF area or to powersave.

With my first laptop, the broadcom WLAN driver will register the key, but it doesn't know
if it is alone or if Bluetooth hardware is also present. So it cannot know if it is a master
switch or not.

> But of course, you have to make sure the master switch WILL bloody well stay off
> when off by design.  You engineer it so that all possible failure modes will
> cause it to go to the off state.
> 
> I would really appreciate that the rfkill class would abide to this UI notion for
> the master rfkill events (*_RFKILL_ALL).

Such a thing would indeed be nice, as long as you can positively identify a master switch,
but as long as that is not possible/implemented it will only be confusing for driver developers,
userspace developers and the users.

Ivo
