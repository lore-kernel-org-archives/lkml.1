Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbZBPSJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbZBPSJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 13:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZBPSJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 13:09:03 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:25625 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbZBPSJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 13:09:02 -0500
MIME-Version: 1.0
In-Reply-To: <20090216161331.GB5008@kroah.com>
References: <5aa163d00902142008g138826br80d3ea989e7af691@mail.gmail.com>
	 <200902160931.34771.oliver@neukum.org>
	 <5aa163d00902160522r3a22412je3f5202076f57a0a@mail.gmail.com>
	 <20090216161331.GB5008@kroah.com>
Date: Mon, 16 Feb 2009 13:09:00 -0500
X-Google-Sender-Auth: 9e6c42858aac6601
Message-ID: <5aa163d00902161009l15dae120le96436d40f998d33@mail.gmail.com>
Subject: Re: [PATCH] input: xpad.c - Xbox 360 wireless and sysfs support
From: Mike Murphy <mamurph@cs.clemson.edu>
To: Greg KH <greg@kroah.com>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 11:13 AM, Greg KH <greg@kroah.com> wrote:
...
>
> The bigger question is why are you using a struct kobject in the first
> place?  As you are a device, just use a struct device.  What are you
> trying to do in sysfs here to make you want to use a "raw" kobject in a
> driver?
>
> thanks,
>
> greg k-h
>

The purpose of the struct xpad_data (which contains the struct
kobject) is to expose parameters that can be read and/or tweaked at
runtime. At the moment, the adjustable parameters are the size of the
dead zone around the center of the stick, and the choice of whether to
map to a square axis. Read-only data include a unique identifier for
each pad (wireless) and an indication as to whether the wireless pad
is actually connected.

The idea behind this interface is to enable a future userspace
application, likely using HAL and D-BUS, to receive events whenever a
wireless pad connects, and to identify the particular pad in question
(specifically, the unique ID of the pad). The user could then, for
example, have a different dead zone size for each pad, based upon the
actual manufacturing variations in the sticks on that pad (some appear
more precise at centering than others). Ideally, this functionality
could be designed in a "common" way so that the userspace code could
eventually work with other, non-xpad gaming devices.

So I really just wanted a way to get some parameters to userspace. The
consensus opinion of everything I read was that /proc additions were
frowned upon for cluttering up /proc with kernel stuff, ioctls were
viewed negatively because of their inconsistent nature from device to
device, and that sysfs was the best solution for this problem.

I didn't use a struct device because of the existing struct usb_xpad
that was created on a per-gamepad basis (not necessarily per device,
as the wireless 360 adapter is one physical device but exposes 4
gamepads by exposing 4 logical devices [and then each gamepad, in
turn, is technically a USB hub that can have other stuff
attached...]). I tried not to break existing functionality.
Additionally, struct usb_xpad contains two device pointers: one to the
actual USB device, and one to an input device (see source of the
in-tree xpad.c). So I followed your kobject.txt documentation and
samples to create a new object whose sole purpose in life is to expose
the sysfs interface, without interfering with the existing device
entries in the driver. I'm not sure I see a clean way to use a single
struct device here....

Thanks,
Mike
-- 
Mike Murphy
Ph.D. Candidate and NSF Graduate Research Fellow
Clemson University School of Computing
120 McAdams Hall
Clemson, SC 29634-0974 USA
Tel: +1 864.656.2838   Fax: +1 864.656.0145
http://cirg.cs.clemson.edu/~mamurph
