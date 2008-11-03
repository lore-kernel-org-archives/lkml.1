Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbYKCTGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbYKCTGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbYKCTG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:06:27 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:34195 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752740AbYKCTG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:06:26 -0500
X-Sasl-enc: 5VdEsOkVd+J1fYdLCx1NmP+lTCqXBUmPaVlKUc2VTVvj 1225739183
Date: Mon, 3 Nov 2008 17:06:17 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: rfkill, stupid question #6
Message-ID: <20081103190617.GE2417@khazad-dum.debian.net>
References: <20081102130655.GA12766@srcf.ucam.org> <20081103141628.GB31078@khazad-dum.debian.net> <20081103141836.GA31894@srcf.ucam.org> <490F0ACC.4000808@tuffmail.co.uk> <20081103145145.GD31078@khazad-dum.debian.net> <20081103145543.GA496@srcf.ucam.org> <20081103150229.GF31078@khazad-dum.debian.net> <20081103150843.GA1107@srcf.ucam.org> <20081103163311.GA2417@khazad-dum.debian.net> <490F3C44.7080504@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490F3C44.7080504@tuffmail.co.uk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2008, Alan Jenkins wrote:
> I have one more question.  I read that if a STATE_SOFT_BLOCKED request
> is made when the hardware is in STATE_HARD_BLOCKED, the rfkill driver is
> expected to "double block".

If it can do so, yes.  It makes for marginally better use interaction.

> If the hard block is later cleared, the driver is expected to call
> rfkill_force_state(SOFT_BLOCKED).  The SOFT_BLOCKED state can then be
> cleared as normal.

Exactly.

> But if there is an UNBLOCK request in the double-blocked state, the
> rfkill core will reject it and preserve the  double-blocked state.  Is
> this intended, or a known issue?

It is intended.  The user wants to unblock the radio (not "prepare it to
unblock when I release the hardware rfkill line by doing something else"),
so we have to error it out.

And, frankly, I don't very much like the idea of the core returning a
-EPERM and yet having done a call toggle_radio(UNBLOCK).   Not to mention
it is yet another border condition for the hook API.

So, if something took the pains to cause a double block, we require
explicit unblocking AFTER the hardware rfkill lines are released (i.e. the
device goes from HARD to SOFT blocked).

BUT I don't feel strongly about it, so if someone wants to change that, I
won't stand in the way.

> Wouldn't it be simpler to use a bitmask so that the rfkill core can at
> least represent this double-blocked state?  I guess the problem would be
> how to shoehorn it into the sysfs interface.

The core doesn't care, and doesn't have to in order to implement such a
thing.  The drivers track it separately.

The two problems is that it can be REALLY confusing for the end user, and
that it requires a ABI change.  I don't know if it is worth it, I just know
I am not going to be the one doing it :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
