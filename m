Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYKKFk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYKKFk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 00:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYKKFkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 00:40:18 -0500
Received: from mail.queued.net ([207.210.101.209]:4530 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYKKFkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 00:40:16 -0500
Date: Sun, 9 Nov 2008 07:40:57 -0800
From: Andres Salomon <dilinger@queued.net>
To: Jeremy Katz <katzj@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, dtor@mail.ru
Subject: [PATCH] psmouse: OLPC: fix incorrect validate_byte check
Message-ID: <20081109074057.769a1c83@debxo>
In-Reply-To: <1226345007.10798.188.camel@aglarond.local>
References: <1226093165.10798.19.camel@aglarond.local>
	<20081107033652.5f44001a@debxo>
	<1226345007.10798.188.camel@aglarond.local>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hm, you're right; does this patch fix it?  (Sorry for the top-posting,
folks)




The validate_byte check logic was backwards; it should return true for
an *invalid* packet.  Thanks to Jeremy Katz for spotting this one.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/input/mouse/hgpk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/mouse/hgpk.c b/drivers/input/mouse/hgpk.c
index e82d342..88f04bf 100644
--- a/drivers/input/mouse/hgpk.c
+++ b/drivers/input/mouse/hgpk.c
@@ -125,7 +125,7 @@ static void hgpk_spewing_hack(struct psmouse *psmouse,
  */
 static int hgpk_validate_byte(unsigned char *packet)
 {
-	return (packet[0] & 0x0C) == 0x08;
+	return (packet[0] & 0x0C) != 0x08;
 }
 
 static void hgpk_process_packet(struct psmouse *psmouse)
-- 
1.5.6.5




On Mon, 10 Nov 2008 14:23:27 -0500
Jeremy Katz <katzj@redhat.com> wrote:

> I'm seeing it and someone else is across different XOs, so I don't
> think it's hardware.  And I'm seeing it even if I don't touch the
> touchpad at all
> 
> Looking through the diffs, the only thing that isn't certainly
> cosmetic is the attached and applying it fixes things.  I haven't
> split to see which of the two chunks is the actual fix yet, but will
> probably try to do so later if I can avoid other fires popping up.
> 
> Jeremy
> 
> On Fri, 2008-11-07 at 03:36 -0800, Andres Salomon wrote:
> > Hi,
> > 
> > Either you're seeing transient errors that are occurring due to
> > hardware problems (and thus have nothing to do with the updated
> > driver/kernel), or the miscalibration detection is being triggered
> > accidentally.  Once the touchpad starts recalibrating, it will
> > continue until you've removed your fingers from the touchpad for a
> > few seconds.. so, if it starts doing that, just remove your hands
> > and within a few secs it should be fixed.
> > 
> > 
> > On Fri, 07 Nov 2008 16:26:05 -0500
> > Jeremy Katz <katzj@redhat.com> wrote:
> > 
> > > Hey -- I backported what you sent upstream for the OLPC touchpad
> > > support to the Fedora 2.6.27.x kernel and while it identifies
> > > fine, I see boatloads of
> > >   psmouse serio1: >100px jump detected (0,227)
> > >   psmouse serio1: hgpk_process_byte: (1) 09 f9 08
> > >   psmouse.c: HGPK at isa0060/serio1/input lost sync at byte 1
> > >   psmouse.c: HGPK at isa0060/serio1/input0 - driver resynched.
> > > in dmesg and the mouse cursor just jumps around pretty much
> > > uncontrollably
> > > 
> > > The only thing I'm seeing in the diff between olpc-2.6 and what's
> > > now upstream that might be relevant is the different conditions
> > > for hgpk_validate_byte().  But before I go grafting things
> > > together, I figured it was worth asking if you knew of anything
> > > specific to look at.
> > > 
> > > Thanks,
> > > 
> > > Jeremy
> > > 
