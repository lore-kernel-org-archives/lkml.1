Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbYFVQs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbYFVQs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 12:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYFVQsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 12:48:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:52808 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYFVQsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 12:48:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=df9LOhHvHwKrpKpIkOu8HwbEZExBofbUC00LnacWoXK05rXFkFQPXKxcpsA0t08JB5
         sybozmNilV6Zh7KWItpV+LiDIj91uHQlPnwhAHbEiIIObc3qQYTnB+8gXtsxk3vp9KO9
         pDQWw4v38lR2SPTd58if4js0BaqeU7Xi1Zlqg=
Date: Sun, 22 Jun 2008 18:47:17 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Cedric Bregardis <cedric.bregardis@free.fr>,
       Jean-Christian Hassler <jhassler@free.fr>
Cc: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: oops in Audiowerk2 ALSA driver
Message-ID: <20080622164443.GA7208@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
There's a race between registration routine and interrupt handler in aw2 driver
which manifested as oops on some box [1].

When snd_aw2_create calls request_irq chip data are not yet fully initialized.
If interrupt raises before snd_aw2_create call snd_aw2_saa7146_setup, driver may
oops or read/write other port than its own. (chip->base_addr is initialized in
snd_aw2_saa7146_setup, but is used in snd_aw2_saa7146_interrupt via READREG/WRITEREG)

The simple fix would be to move call to snd_aw2_saa7146_setup before request_irq,
but snd_aw2_saa7146_setup enables interrupts...

PS: I don't have this hardware.

Marcin

[1] http://kerneloops.org/guilty.php?guilty=snd_aw2_saa7146_interrupt&version=2.6.26-rc&start=1703936&end=1736703&class=oops
