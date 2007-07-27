Return-Path: <linux-kernel-owner+w=401wt.eu-S935747AbXG0BWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935747AbXG0BWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 21:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761005AbXG0BWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 21:22:37 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:52544 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759616AbXG0BWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 21:22:36 -0400
Date: Fri, 27 Jul 2007 02:22:34 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] AGP fixes for 2.6.23-rc1
Message-ID: <Pine.LNX.4.64.0707270206580.9484@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'agp-patches' branch from
git://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git agp-patches

It contains one very important fix from Nick for AGP hangs with the 
nopage/pfn/flush stuff.. it also contains some minor docs changes and one 
coverity fix.

Dave.

  Documentation/kernel-parameters.txt |    7 +++++++
  drivers/char/agp/Kconfig            |    2 +-
  drivers/char/agp/ati-agp.c          |    9 ++-------
  drivers/char/agp/generic.c          |    2 --
  drivers/char/agp/intel-agp.c        |   19 ++++++++++++-------
  drivers/char/agp/sgi-agp.c          |    1 -
  6 files changed, 22 insertions(+), 18 deletions(-)

commit f191f144079b0083c6fa7d01a4acbd7263fb5032
Author: Alan Hourihane <alanh@fairlite.demon.co.uk>
Date:   Fri Jul 27 10:56:43 2007 +1000

     agp: AMD AGP is used on UP1100 & UP1500 alpha boxen

     Signed-off-by: Dave Airlie <airlied@redhat.com>

commit dde4787642ee3cb85aef80bdade04b6f8ddc3df8
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Thu Jul 26 09:18:09 2007 +0800

     intel_agp: really fix 945/965GME

     Fix some missing places to check with device id info, which
     should probe the device gart correctly.

     Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
     Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a51b34593f691a0837d752a1394dcee19483c607
Author: Nick Piggin <npiggin@suse.de>
Date:   Wed Jul 25 13:19:22 2007 +0200

     agp: don't lock pages

     AGP should not need to lock pages. They are not protecting any race
     because there is no lock_page calls, only SetPageLocked.

     This is causing hangs with d00806b183152af6d24f46f0c33f14162ca1262a.

     Signed-off-by: Nick Piggin <npiggin@suse.de>
     Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c99c108ac362f5cc37f79fad7e9897bd9d033bcc
Author: Chuck Ebbert <cebbert@redhat.com>
Date:   Fri Jul 27 10:46:20 2007 +1000

     AGP: document boot options

     Add documentation for AGP boot options.

     Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
     Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 190644e180794208bc638179f4d5940fe419bf9c
Author: Jesper Juhl <jesper.juhl@gmail.com>
Date:   Sat Jul 21 17:39:11 2007 +0200

     Fix "use after free" / "double free" bug in ati_create_gatt_pages / ati_free_gatt_pages

     Hi,

     Coverity spotted a "use after free" bug in
     drivers/char/agp/ati-agp.c::ati_create_gatt_pages().

     The same one that was in
       drivers/char/agp/amd-k7-agp.c::amd_create_gatt_pages()

     The problem is this:
            If "entry = kzalloc(sizeof(struct ati_page_map), GFP_KERNEL);"
     fails, then there's a loop in the function to free all entries
     allocated so far and break out of the allocation loop. That in itself
     is pretty sane, but then the (now freed) 'tables' is assigned to
     ati_generic_private.gatt_pages and 'retval' is set to -ENOMEM which
     causes ati_free_gatt_pages(); to be called at the end of the function.
     The problem with this is that ati_free_gatt_pages() will then loop
     'ati_generic_private.num_tables' times and try to free each entry in
     tables[] - this is bad since tables has already been freed and
     furthermore it will call kfree(tables) at the end - a double free.

     This patch removes the freeing loop in ati_create_gatt_pages() and
     instead relies entirely on the call to ati_free_gatt_pages() to free
     everything we allocated in case of an error. It also sets
     ati_generic_private.num_tables to the actual number of entries
     allocated instead of just using the value passed in from the caller -
     this ensures that ati_free_gatt_pages() will only attempt to free
     stuff that was actually allocated.

     Note: I'm in no way intimate with this code and I have no way to
     actually test this patch (besides compile test it), so while I've
     tried to be careful in reading the code and make sure the patch
     does the right thing an ACK from someone who actually knows the
     code in-depth would be very much appreciated.

     Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
     Signed-off-by: Dave Airlie <airlied@linux.ie>

