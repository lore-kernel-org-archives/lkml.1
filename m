Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbYKCOsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbYKCOsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbYKCOr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:47:58 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:40035 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754685AbYKCOr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:47:57 -0500
X-Sasl-enc: liKlRyp56nannBCiTgZ238NQ4mTzhzPsq1jDoKWg7CXF 1225723676
Date: Mon, 3 Nov 2008 12:47:49 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: eeepc-laptop rfkill, stupid question #4
Message-ID: <20081103144749.GC31078@khazad-dum.debian.net>
References: <490B3BB5.8060801@tuffmail.co.uk> <20081031171126.GA17313@srcf.ucam.org> <490B4014.4040009@tuffmail.co.uk> <490B70A3.8010108@tuffmail.co.uk> <20081102040008.GB29606@khazad-dum.debian.net> <490D8C4E.3010201@tuffmail.co.uk> <20081102130655.GA12766@srcf.ucam.org> <490DAA33.7010905@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490DAA33.7010905@tuffmail.co.uk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Nov 2008, Alan Jenkins wrote:
> No, the current rfkill core forces the device to restore the state on  
> resume.  So it can't be of sync after resume.  And there's no way for  
> the platform driver to affect this behaviour, aside from illegally  
> generating input events.

Actually, there might be some sort of mess in this (i.e. a bug in the core).

Here's what it is doing:

At resume, it does a forced rfkill_toggle_radio() with either the value
cached in rfkill->state or SOFT_BLOCK (if EPO is active), so
rfkill_toggle_radio() will call your driver's toggle_radio() hook regardless
of whether it thinks the rfkill state is already correct or not.

HOWEVER, rfkill->state *IS* updated by rfkill_force_state(), which your
driver is supposed to have called in its resume handling, that runs BEFORE
rfkill core's rfkill class resume hander (devices resume before their
classes AFAIK).

So, the core will NOT restore the pre-sleep state of the transmitter.  It
will sync itself, and not cause worse trouble, but it seems not to be doing
what it is supposed to.

Argh.

I will send a patch after I do some testing to validate the above (and if
the bug is validated, after making sure the patch fixes it).

> If we want resume from hibernation to preserve the hardware state  
> instead of overriding it, the rfkill API needs changing.  I'm not sure  

Oh, we DO want to override UNLESS what changed was actually something
capable of HARD_BLOCK (in which case the core already does things right if
you used rfkill_force_state()).   It is the path of least surprise for the
user.

Frankly, I do not *CARE* to think about things like hibernate, boot another
OS, hibernate again or shutdown, try to boot back on the previous OS.  This
is in NO WAY supported by ACPI, and can cause massive crappage if either OS
uses S4 instead of S5 for hibernation (and you ARE supposed to use S4, so
you can see the big pitfall right away).

All that matters is straight sleep-resume, hibernate-resume, and the fact
that the user IS allowed to mess with the hardware config (e.g. eject bays,
undock, remove non-fixed storage, and of course, toggle a hardware rfkill
input device).

> the damage it would do to an API which already, uh, seems to be  
> frequently misunderstood.

That is an understatement...  Hell, I probably am the one more acquinted
with the current rfkill API, and I still end up getting confused by it...

It really could benefit of a fine comb and code flow diagram analysis to
validate everything and catch bugs like the one I described above (which
*seems* to exist, I haven't tested for it yet, and I might be mistaken).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
