Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbYJNLSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbYJNLSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 07:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbYJNLSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 07:18:09 -0400
Received: from lazybastard.de ([212.112.238.170]:39154 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbYJNLSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 07:18:07 -0400
Date: Tue, 14 Oct 2008 13:18:00 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Stefan Monnier <monnier@iro.umontreal.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Filesystem for block devices using flash storage?
Message-ID: <20081014111800.GA32413@logfs.org>
References: <jwvvdw33v5p.fsf-monnier+gmane.linux.kernel@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <jwvvdw33v5p.fsf-monnier+gmane.linux.kernel@gnu.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rereading the thread, you haven't received a good answer yet.  Which is
understandable, given the diversity and secrecy of the subject.  The
properties of flash are reasonably well understood.  To create a block
device, you need to add an FTL.  How the FTL works depends on the device
in question, and you will never receive any documentation with the
device.  In short, you never know.

Unless the device comes from the cheap end.  Practically everyone is
using the same FTL for cheap devices, with some minor tweaks.  I've
written down the basics here:
http://www.linuxconf.eu/2007/papers/Engel.pdf

More expensive devices may still behave the same, may do something
better or may attempt to do something better and actually be worse.  One
never knows, so I'll pretend that every device is cheap from now on.

On Wed, 8 October 2008 12:38:51 -0400, Stefan Monnier wrote:
> 
> Google finds some people asking this same question, but I couldn't find
> any answer to it: what filesystem is recommended to use on an flash
> based disk that does not give access to the MTD layer (e.g. USB keys,
> most SSDs, ...)?

Currently: Either fat or none at all.

> Since they do their own wear-levelling, any filesystem should be "safe",
> but I expect there is still a lot of variance in terms of performance,
> wear, robustness, ...

The wear leveling is not done for the complete device, only for a subset
of usually 1024 blocks.  If you keep pounding the same (logical) block
over and over, the number of physical blocks you write to is either 25
or 1024, depending on whether the device does static wear leveling.

I have reports of people breaking their devices with a trivial script in
less than a day (an hour, iirc).

> Has anyone conducted serious experiemnts to try and find out what works
> better?  Also, since it appears that such devices are here to stay,
> would there be a need to design a new filesystem or to tune existing
> filesystems for this particular kind of device?

Some expensive device seem to work well with any filesystem.  As for the
cheap stuff, a new design is needed.  The shopping list includes:
1. vast majority of writes should be eraseblock-sized and -aligned
2. wear leveling
3. scrubbing

And quite frankly, no filesystem currently fits the bill.  Closest
contenders are btrfs, nilfs and logfs, all of which are still under
development.  Of those, logfs is the only one designed explicitly for
flash and happens to be my brainchild.  So naturally my opinion is
biased and I will refrain from any further arguments for or against. :)

Current status of logfs is that I'm currently fixing one design issue
that caused many small writes, then have to do some random minor changes
to the format and... it should be useable sometime this year.

> Or is there some hope for SSDs to provide access to the MTD layer in the
> not too distant future?

I've talked to manufacturers and not seen any enthusiasm for that idea.
Most actually have some undocumented commands for raw access - for
testing and QA.  They simply see no benefit in exposing these to the
public.  And it is trivial to brick a device with such commands - in the
sense that the FTL no longer works.

Jörn

-- 
Optimizations always bust things, because all optimizations are, in
the long haul, a form of cheating, and cheaters eventually get caught.
-- Larry Wall
