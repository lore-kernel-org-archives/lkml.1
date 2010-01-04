Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113Ab0ADNia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab0ADNia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 08:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457Ab0ADNi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 08:38:28 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:35507 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab0ADNi1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 08:38:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=muQn80gs33CTupFVa8zlBT6Csg38XD2UsqlkTvrQGFMqkKjlGNayJIgPxIVrUh82By
         dWDFPuIL+Br4HQ486Qf5zWYKRv/ZpOLRiI8Fbk/5oqXUdXGySHW7wgwsTCyc25S+5Mvm
         mSzMcMYeOh6Xj2gz2e07435Dm9vaPojFetDBg=
Date: Mon, 4 Jan 2010 14:38:23 +0100
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?UTF-8?B?QmFydMWCb21pZWogWmltb8WE?= <uzi18@o2.pl>,
       linux-kernel@vger.kernel.org, Andy Walls <awalls@radix.net>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [suspend/resume] Re: userspace notification from module
Message-ID: <20100104143823.1464643d@strolchi.home.s3e.de>
In-Reply-To: <201001032249.11510.rjw@sisk.pl>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl>
	<4B406C14.2070907@gmail.com>
	<43bd3f9d.71702a8b.4b407900.b542@o2.pl>
	<201001032249.11510.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.19.2; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 3 Jan 2010 22:49:11 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday 03 January 2010, Bartłomiej Zimoń wrote:
> > mhm, why not to create kernel based pm event messaging for processes?

I don't think you need the kernel for that.

> > How it is implemented on other platforms?
> > Because on MacOsX looks like program registers callback for such event.
> > 
> > I dont know if every pm_notifier blocks suspend until return from callback.
> > 
> > If we cant do it simple we can do it better.
> > Rafael what do You think about it?

Basically, modern desktops do it exactly this way. They have one "power
manager" (be it gnome-power-manager or KDE's solid) and the
applications are notified by it if a suspend is going to happen.

E.g. the power manager will tell the volume manager (the thing that
mounted the USB stick) "we will suspend, please unmount everything".
Other desktop components will also be notified.

Some processes might also wish to inhibit the suspend (e.g. a CD
burning application while it is burning).

The power manager is the "single point of decision". It might decide to
ignore the CD burning application, if the power is critically low
(better a ruined CD than data loss by hard poweroff), but honor it
otherwise. It might decide to ask the user (and it has an easy way to
do so, since it is running in the users session and thus has access to
the X display), but proceed after a timeout etc...

All this is already possible and does not need any kernel changes at
all.

> I've just said, roughly, in a message I sent to you a while back.
> 
> You need a power manager, but not necessarily in the kernel.  The role of the
> power manager would be to:
> (1) pass suspend requests from different sources in the user space (a GUI for
>     one example) to the kernel,
> (2) notify processes which registered for that when it's going to pass a
>     suspend (or hibernate) request to the kernel,
> (3) wait for the notified processes to complete the pre-suspend preparations
>     they require.

Exactly.

> There are a few more things to consider here.  For example, what if one of the
> registered processes becomes unresponsive?  Are we going to suspend anyway
> or notify the user and wait for him to resolve the problem?  In the latter
> case, what to do if that is, for example, an emergency hibernation started
> because we're running out of battery power?  Etc.
> 
> Some time ago openSUSE had a daemon called powersaved used for this purpose,
> but then it was replaced by pm-utils, apparently because everybody else was
> using pm-utils and it just wasn't worth maintaining a different solution for
> one distro only.  Maybe it's time to rethink this idea?

No. Because what powersaved did was not fundamentally different from
what gnome-power-manager / pm-utils does now. The difference was, that
it was a daemon running as root. Which brought a few problems of its
own:
 * communication with the user was not easily possible
 * it mixed up policy and mechanism (powersaved decided what to do if
   you press the power or sleep button, and you needed root to configure
   that behaviour).

And before somebody comes along with arguments like "but what about my
manually mounted NFS share - who will unmount that?", I can only tell
you: "go away". There is no way to imlement a sane solution that will
take care of all the crazy manual configurations people can dream of,
so you can only tell them "you mounted it manually - so unmount it
manually".

And you can give them pm-utils hooks that give them a mechanism to do
their manual stuff semi-automatically during suspend / resume.

Have fun :-)

	seife
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out."
