Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbYIKIuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbYIKIuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 04:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYIKIuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 04:50:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57565 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbYIKIuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 04:50:21 -0400
Message-ID: <48C8DB0E.30705@redhat.com>
Date: Thu, 11 Sep 2008 10:47:10 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-2-git-send-email-jwilson@redhat.com> <20080910130851.GC25221@anvil.corenet.prv>
In-Reply-To: <20080910130851.GC25221@anvil.corenet.prv>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> Couple of questions - what is missing in the current input core to
> properly support IR devices?

One issue is *sending* IR codes.
Another one is access to the raw IR signal (more on this below).

Probably 90% of the users are happy without that.

> Could we try to work it in ininput core and
> maybe provide LIRC device access through an input handler
> implementation so that applications do not have to implement 2 types of
> interfaces?

Not needed.  Applications don't talk to the lirc device directly, they
talk to the lircd daemon.  The lircd daemon can handle linux input layer
devices just fine.  So moving drivers from lirc to the input layer can
be done transparently to the applications.

Quite some time ago, back the days when I maintained video4linux, I've
switched the tv card IR drivers from lirc to the input layer.  Main
reason for that was that having a in-kernel driver using an out-of-tree
subsystem was a PITA.  I think these days most (all?) TV card drivers
use the input layer for the IR remotes frequently shipped with those cards.


Some more background, using the Hauppauge cards as example, which
usually use rc5 coding with the remotes.

The older, bt878 based ones do decoding in hardware (i2c chip).  You'll
get the decoded rc5 keycode.

The newer, cx88 based ones just sample the raw IR signal and give you
that.  The decoding has to be done in software.  The driver can program
the sample rate and has to do the biphase decoding in software to get
the rc5 keycodes.  The driver gets that done just fine, and the remote
shipped with the TV card works without problems.

The part which doesn't work is supporting *any* remote.  The (newer)
hardware gives you the raw IR signal, so it is possible to decode any IR
signal in software.  The missing bit is some way to send the raw IR
samples to userspace (i.e. the lircd daemon) for decoding.  lirc drivers
do just that.

HTH,
  Gerd
