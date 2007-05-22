Return-Path: <linux-kernel-owner+w=401wt.eu-S933963AbXEVPqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963AbXEVPqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbXEVPp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:45:58 -0400
Received: from outbound-mail-80.bluehost.com ([69.89.22.29]:57779 "HELO
	outbound-mail-80.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757448AbXEVPp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:45:57 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2007 11:45:57 EDT
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: dri-devel@lists.sourceforge.net
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Date: Tue, 22 May 2007 08:39:04 -0700
User-Agent: KMail/1.9.6
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
References: <200705171423.46748.jesse.barnes@intel.com> <1179792587.32247.769.camel@localhost.localdomain>
In-Reply-To: <1179792587.32247.769.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705220839.04773.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 21, 2007, Benjamin Herrenschmidt wrote:
> > In collaboration with the FB guys, we've been working on enhancing
> > the
> > kernel's graphics subsystem in an attempt to bring some sanity to the
> > Linux graphics world and avoid the situation we have now where
> > several
> > kernel and userspace drivers compete for control of graphics devices.
>
>  .../...
>
> A little note about initial mode setting at boot...
>
> I do stongly beleive that the decision of what mode to choose should not
> be made in the kernel. At boot the kernel should either leave the HW in
> whatever state the FW set it (and text mode is fine) or setup some sane
> default (ie 640x480 has the most chances of working) if that's not an
> option, maybe some very minimum EDID parsing in case you have a fixed
> frequency weirdo panel, but that's it (unless it's a mac an OF tells you
> what to use :-)
>
> The kernel would provide userland with connector infos (presence load
> detect, EDID, ...) and userland gets to decide what to do.

The current code does its best to figure out what modes are available and 
tries to pick a good one for each display.  It sounds like you're mainly 
concerned with the actual mode picking, not the mode and output detection 
and enumeration?  If so, that's a pretty easy change to make.  But if 
you're also worried about the kernel building mode lists, then we'll have 
bigger changes to make...

> Some reasons to keep that policy completely out of the kernel even at
> boot time are:
>
>  - User may want to configure his default gfx setup and have it up early
>
>  - EDID do lie, monitors routinely ship with windows .inf files
> containing "updated" infos apple has that too in OS X (EDID overrides
> afaik) etc.... and if we're going to do such a database of known
> monitors, it should definitely not be in the kernel. Besides, we want to
> add more infos that EDIDs don't provide most of the time to it like
> subpixel ordering etc...
>
>  - It sounds better that way :-) (yeah, that's the best reason !)
>
> So while I agree that the register frobbing, memory management, etc...
> should be indeed moved to the kernel as you guys have been doing lately,
> the policy of deciding what mode to set should totally stick to
> userland.
>
> IMHO, the best would be a lib (or daemon or both) for monitor detection
> & mode setting that is separate from X :-) That could handle storing the
> admin's default setup (including weird monitor info if any) and
> restoring it at boot time, etc...

I'm not really sure how much of a problem broken EDIDs will be.  The X 
server only has a few quirks for broken EDIDs now, nothing major afaict, 
and apparently the FB layer already has some code for handling EDID 
quirks, so I don't think that'll be our biggest problem.  So far, it looks 
like handling laptop panels is a bit trickier (at least for Intel 
chips)...

Jesse

