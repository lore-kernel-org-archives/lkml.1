Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbZLDPmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbZLDPmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 10:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbZLDPmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 10:42:49 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:40471 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbZLDPmr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 10:42:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xjn0zELq7qJdNWDBYWYM349P7hn8u+ra/4F47LSaQsfLUmGiaWncolN7eZG51kkLnz
         WixtoxHZEoezjn6EuVNI+oX2fLAbYjOEpN7rF0WG8NXdaMd3QA/FlI8fcPExB8N/017C
         9JEEqYMoz7X2QR3eQhxquOqCDZt2Cu9G1E5OI=
MIME-Version: 1.0
In-Reply-To: <20091204121234.5144836b@pedra>
References: <BDodf9W1qgB@lirc> <4B14EDE3.5050201@redhat.com>
	 <4B1524DD.3080708@redhat.com> <4B153617.8070608@redhat.com>
	 <A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com>
	 <4B17AA6A.9060702@redhat.com>
	 <20091203175531.GB776@core.coreip.homeip.net>
	 <20091203163328.613699e5@pedra>
	 <20091204100642.GD22570@core.coreip.homeip.net>
	 <20091204121234.5144836b@pedra>
Date: Fri, 4 Dec 2009 10:42:53 -0500
Message-ID: <9e4733910912040742y251d9fddr254260a328683c88@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Gerd Hoffmann <kraxel@redhat.com>, Jarod Wilson <jarod@wilsonet.com>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 4, 2009 at 9:12 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>> In-kernel decoding:
>>

[IR physical device] => [IR receiver driver] => [LIRC core] =>
[decoder] => [IR core] => [input core] => [evdev]
                                                  ||
                                                   => [Lirc API device]>>
>> Hardware decoder:
>> [IR physical device] => [IR receiver driver] => [IR core]
>>                                            => [input core] => [evdev]

My hope is that 90% of users can achieve "just works" via these two
models. There will need to be several default device/keymaps installed
to avoid the need to configure. For example, have udev install a
default map from Motorola DVR IR to Linux keycodes. Installing that
map creates a new evdev device.  Myth can then look for that device by
default and listen to it. Now the user just needs to set their
programmable remote to send Motorola DVR and everything should "just
work". Pick similar default maps/evdev device for music players and
home automation. Sophisticated users can change these default maps by
editing the udev scripts.

Long term the goal is to get IR profiles for Linux DVR, music player,
home automation, etc in to the IR database. Then we won't have to
override the profile for another company's device.

I believe it is a requirement to send the decoded IR events up to user
space (EV_IR). That would handle the case of the air conditioner
remote. It also allows construction of an app that automatically
searches the IR database for mapping tables. Normal apps would just
ignore these events.

Installing a map is what triggers the creation of another evdev
device. There should be one evdev device per map installed. The
current input API design does not provide for a way to do this.

The only solution I see to automatic device creation is to monitor
unmapped EV_IR events and search for them in the IR database. When a
match is found, install the map from the database - which then
triggers the creation of a new evdev device and the EV_IR event won't
be unmapped any more. Searching is not a simple process since the same
IR code often appears in more than one map. Some human intervention
will probably be required.

[IR physical device] => [IR receiver driver] => [LIRC core] =>
[decoder] => [IR core] => [input core] => [evdev]
                                                  ||
                                                            ||
                                                   => [Lirc API
device]                                               ==> [EV_IR
events]

The EV_IR events also allow a user space protocol decoder to inject
those events back into the input subsystem where they will flow
through the mapping tables.

The in-kernel protocol decoders should be designed as a set of modules
with the pulse data being simultaneously supplied to all modules. That
will make it easy to work on the protocol converters - just
insmod/rmmod as you make changes. These engines can be extracted from
the LIRC code and turned into modules.

Where are IR repeat bits going to be handled?

-- 
Jon Smirl
jonsmirl@gmail.com
