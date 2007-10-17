Return-Path: <linux-kernel-owner+w=401wt.eu-S1760267AbXJQTAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267AbXJQTAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbXJQS77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:59:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:10112 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbXJQS75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:59:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ltkURy+462mFD548MNfPeJqjf3sTHpS93Q7eWQaZOT2b3H1TG/TVGMPcFpxb0s4oMigLbVkpq59LqrHSalW0t/J8FRqS+4zUe8JMY7bXu0RQ6wkX9y5/sUctxuNkddoxrKS5PQGKu00eguAveq/K0EYWth7jBLtWapE03lsGxd8=
Message-ID: <d120d5000710171159p617115d9w862aadf266c2470c@mail.gmail.com>
Date: Wed, 17 Oct 2007 14:59:52 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jeremy Katz" <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com
In-Reply-To: <20071017173532.GB2974@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071016142121.GA21431@srcf.ucam.org>
	 <20071016144016.GA21749@srcf.ucam.org>
	 <20071016165623.GA13643@khazad-dum.debian.net>
	 <20071016184606.GB25181@srcf.ucam.org>
	 <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org>
	 <d120d5000710161312r5676cad8o60e0790a4e8d5256@mail.gmail.com>
	 <alpine.LFD.0.999.0710161325570.6887@woody.linux-foundation.org>
	 <d120d5000710170857i3f534544pe9cab0ca6c1b0aa4@mail.gmail.com>
	 <20071017162827.GA9778@srcf.ucam.org>
	 <20071017173532.GB2974@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> On Wed, 17 Oct 2007, Matthew Garrett wrote:
> > On Wed, Oct 17, 2007 at 11:57:18AM -0400, Dmitry Torokhov wrote:
> > > say that they only care about notifications arising from keypresses
> > > then I will add EV_NOTIFY type of events to input layer. What events
> > > would we need? I can imagine:
> >
> > Why use EV_NOTIFY? They're still keys. I'd also quibble with the need
>
> Why not?  Why the heck do we have to keep the worst of the current mess,
> when many drivers CAN (and sometimes have to) tell appart the two classes of
> events?  Make notifications a separate thing from regular events, please.
>
> The use of the same path for notifications and events are already a big
> enough concession to the HAL model.  AFAIK, HAL is the only reason why on
> most systems the userspace consumer of events and notification events are
> the same.  HAL gets them all (as well as ACPI events, and whatever else its
> helpers poll the system for), and then distributes them over to various
> other paths.

I have a nagging feeling that we rely on HAL and windows environments
too much nowadays. Last night I tried to susped my laptop while at KDM
prompt but apparently some service is only running in context of user
session and so nothing was there to recognize that suspend button was
pressed (Fedora 8).

>
> On a HAL-less system, it is far less clear that anything that needs the real
> events would bother with the notifications.  The only class of applications
> that have an use for the notifications are OSD applets and the like.
>
> > for adding _NOTIFY varients of already existing keys - the existing
> > consumers can all cope already.
>
> If one adds EV_NOTIFY, one can just allow for the same KEY constants that
> are valid for EV_KEY, and be done with that, I suppose.  But my take is that
> Dmitry wants to limit the number of notifications going over input.
>

That was not my primary goal. We have bitmaps of supported events in
input_dev structure. If we were to reuse KEY_* constants for EV_NOTIFY
then I have to make this bitmap the same size as input_dev->keybit,
which is 512 bit at the moment (and I am thinking that we do need to
extend it to 1024). I expect that we need much less KEY_*_NOTIFY
events so that we could easily fit them into 32 bits.

> I'd rather we added an EV_NOTIFY *bit* that gets or-ed to the real EV_*
> type, so that one can turn any event into a notification.  This is certainly
> to be useful at least for EV_KEY and EV_SWITCH.
>

The problem with this scenario is that userspace can never be sure if
input device is capable of only KEY_BLAH, only KEY_BLAH_NOTIFY or
both. Normally we let userspace query device for all supported events.

-- 
Dmitry
