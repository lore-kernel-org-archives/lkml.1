Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982AbYHRAvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbYHRAvt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 20:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbYHRAvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 20:51:41 -0400
Received: from mail.suse.de ([195.135.220.2]:45955 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbYHRAvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 20:51:40 -0400
From: Neil Brown <neilb@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Mon, 18 Aug 2008 10:51:33 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18600.51093.613662.435395@notabene.brown>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC]  Resolve 2 year old issue with different demands
	on EVIOCGRAB
In-Reply-To: message from Dmitry Torokhov on Thursday August 14
References: <18596.58273.713075.332009@notabene.brown>
	<20080815022453.GA9438@anvil.corenet.prv>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday August 14, dmitry.torokhov@gmail.com wrote:
> Hi Neil,
> 
> On Fri, Aug 15, 2008 at 12:02:09PM +1000, Neil Brown wrote:
> > 
> > I'll let the comments in the patch below to most of the talking.
> > This came up because I wanted to use EVIOCGRAB in some code on an
> > Openmoko Freerunner, and found that EVIOCGRAG does different things on
> > that kernel to elsewhere.  I looked into why, and found that there was
> > a good reason but that the issues hadn't been completely resolved.  I
> > hope to help resolve the issues so that EVIOCGRAB can behave the same
> > everywhere, and still meet everybody's needs.
> > 
> > I would have Cc:ed to Magnus Vigerlof who wrote the original patch on
> > which this is based, but his Email address doesn't appear in lkml.org.
> > 
> 
> I don't think this is a viable solution - there are other "good"
> handlers beisdes evdev, such as rfkill-input, which will still get
> disabled by the "lightweight" grabs.
> 
> Overall I think it is application's responsibility to not use
> multiplexing devices if they use evdev, bit I can consider adding a new
> interface (maybe another ioctl) that would disable event delivery though
> certain interfaces for a device.

Hi,

 I think you are saying that if the X server (for example) uses evdev
 at all, it should use evdev exclusively for getting events, and not
 use /dev/mice or whatever the equivalent is for keyboard (/dev/tty??).
 But the X server still needs to know a little bit about /dev/tty to
 make sure that control-C doesn't get delivered the wrong way.  That's
 awkward.
 It also negates much of the power of the input layer (easy hot-plug).
 I don't much like that approach.

 I think your 'can consider' option involves the application (X
 server) saying  "I want to use both /dev/input/eventX and
 /dev/input/mice, so I'll break the connection between those so as not
 to cause problems".

 I can probably work with that, though it isn't clear how to request
 this break.  Should we tell /dev/input/mice not to listen on (the
 device served by) /dev/input/eventX, or tell (the device served by)
 /dev/input/eventX not to pass events to /dev/input/mice.
 The first seems to make more sense to me as /dev/input/mice is in a
 position to know about devices and disconnect individual devices.
 But how would you tell it, and what name would you use?  Any how
 would the device get back under the control of /dev/input/mice when
 the X server lets go of it?

 As I've been thinking through this problem I keep coming back to
 /dev/input/mice and /dev/tty.  They are where the issue lies.  They
 are both a strength and a weakness.  It seems to me that the right
 approach might be to special-case them.

 i.e.  keep the three-level grab that I proposed before (none, shared,
 exclusive), but change the 'shared' option to mean
     Send the events to everybody except /dev/input/mice or /dev/tty

 This would be implemented by those to drivers declaring themselves as
 "hotplug muxing" drivers which are only really interested in events
 that no-one else wants.
 There would then need to be two flavours of input_grab_device, one
 which grabs it for the given handle, and one which simply disables
 passing events to "hotplug muxing" drivers.

 Would you be happy with that degree of special-casing?  If so I can
 try to put together a patch.  I suspect an extra field in 'struct
 input_handle' to say "this is a muxing device", then input_pass_event
 checks if the device has a shared-grab and if it does, skip any
 handler which is muxing.

NeilBrown

