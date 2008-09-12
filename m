Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbYILEoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbYILEoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 00:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbYILEoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 00:44:23 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:19325 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYILEoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 00:44:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ML+wi9OkQuyW9fpyTGYxSdgwMYyWFsA5CrBkkXR12i6dbl2UjnfmUJzjReMqdj+9Iq
         VKdd/Yls4X0bx0wKqwCBZTBYoS0FUvhZTUHHv5+4IJhKyrygix0XMlvOEmZewIaWl3wV
         +aJPeFIBbK0PdxO4va9EpL4mb2SkWkex553io=
Date: Fri, 12 Sep 2008 00:44:16 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Message-ID: <20080912044416.GA18385@anvil.corenet.prv>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-2-git-send-email-jwilson@redhat.com> <20080910130851.GC25221@anvil.corenet.prv> <48C8DB0E.30705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C8DB0E.30705@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerd,

On Thu, Sep 11, 2008 at 10:47:10AM +0200, Gerd Hoffmann wrote:
> Dmitry Torokhov wrote:
> > Couple of questions - what is missing in the current input core to
> > properly support IR devices?
> 
> One issue is *sending* IR codes.
> Another one is access to the raw IR signal (more on this below).
> 
> Probably 90% of the users are happy without that.
> 
> > Could we try to work it in ininput core and
> > maybe provide LIRC device access through an input handler
> > implementation so that applications do not have to implement 2 types of
> > interfaces?
> 
> Not needed.  Applications don't talk to the lirc device directly, they
> talk to the lircd daemon.  The lircd daemon can handle linux input layer
> devices just fine.  So moving drivers from lirc to the input layer can
> be done transparently to the applications.
> 
> Quite some time ago, back the days when I maintained video4linux, I've
> switched the tv card IR drivers from lirc to the input layer.  Main
> reason for that was that having a in-kernel driver using an out-of-tree
> subsystem was a PITA.  I think these days most (all?) TV card drivers
> use the input layer for the IR remotes frequently shipped with those cards.
> 
> 
> Some more background, using the Hauppauge cards as example, which
> usually use rc5 coding with the remotes.
> 
> The older, bt878 based ones do decoding in hardware (i2c chip).  You'll
> get the decoded rc5 keycode.
> 
> The newer, cx88 based ones just sample the raw IR signal and give you
> that.  The decoding has to be done in software.  The driver can program
> the sample rate and has to do the biphase decoding in software to get
> the rc5 keycodes.  The driver gets that done just fine, and the remote
> shipped with the TV card works without problems.
> 
> The part which doesn't work is supporting *any* remote.  The (newer)
> hardware gives you the raw IR signal, so it is possible to decode any IR
> signal in software.  The missing bit is some way to send the raw IR
> samples to userspace (i.e. the lircd daemon) for decoding.  lirc drivers
> do just that.
> 

I see. I guess what I would like to see it first to have "smart"
devices that do decoding in hardware to be converted to input subsystem
since lirc can use it and other programs can do that too. We should
probably start using KEY_NUMERIC_* there to help userspace
distinguishing RC keys from normal numeric/keypad keys.

For protocols that require decoding in userspace the best solution IMHO
is to route them back via uinput so that applications would not need to
keep implementing 2 interfaces, one for standard input devices and
another for lirc.

I am not sure if input devices are the best for transmittign raw IR
signal. It is pretty easy to add EV_MSC/IR_RAW event type to the input
core... It would give you a timestamp and a 32 bit value... I guess I
need to start looking at extending number of event devices in the
system.

-- 
Dmitry
