Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbYFLKGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbYFLKGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 06:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbYFLKGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 06:06:15 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34900 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753452AbYFLKGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:06:14 -0400
Date: Thu, 12 Jun 2008 05:06:09 -0500
From: Paul Jackson <pj@sgi.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       Bernhard Walle <bwalle@suse.de>, Johannes Weiner <hannes@saeurebad.de>,
       "Huang, Ying" <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>
Subject: Confusions with reserve_early, reserve_bootmem, e820, efi, ... on
 x86_64
Message-Id: <20080612050609.88a8cf7f.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard, Johannes, Huang, and Yinghai:

I am running into some complications with reserve_bootmem vs
reserve_early, and a reserve_early of "EFI memmap" in the
efi_reserve_early() routine conflicting with reserve_early of
"BIOS reserved" in reserve_ebda_region().

This is on x86_64 arch, using Ingo's x86-latest, with possibly
still buggy EFI firmware in a lab system I'm helping to develop.

I have three concerns:

 1) The find_overlapped_early() check called from reserve_early is
    failing on my lab system , causing panic, when it tries to
    register "EFI memmap" at addresses <0xe0660, 0xe0778> that
    overlaps with the "BIOS reserved" early reserve at addresses
    <0x9f000, 0x100000>

 2) I'm a bit puzzled and concerned when I notice that what had been
    two separate reserve_ebda_region() routines, one for x86 32 and
    one for x86 64 have now become one routine -- the problem being
    that the earlier pair of these two reserve_ebda_region() routines
    were not the same.  They differed by their last line:

	--- /tmp/pj32   2008-06-12 02:09:03.414709042 -0700
	+++ /tmp/pj64   2008-06-12 02:08:42.458348590 -0700
	@@ -33,5 +33,5 @@ static void __init reserve_ebda_region(v
	                lowmem = 0x9f000;
	
	        /* reserve all memory between lowmem and the 1MB mark */
	-       reserve_bootmem(lowmem, 0x100000 - lowmem, BOOTMEM_DEFAULT);
	+       reserve_early(lowmem, 0x100000, "BIOS reserved");
	 }

    Perhaps this is fine ... I was just surprised to see what was
    essentially a change for the x86 32 side from reserve_bootmem(),
    to what is now called in both cases, reserve_early()

 3) Most likely my real problem is with my the EFI firmware on my
    lab system that is still under development.  It might be setting
    up addresses incorrectly.  However I am unable to make sense of
    the several patches in this area over the last week.

    I am unsure if what is there now should work, or whether my
    concern (1) above might indicate a still outstanding issue with
    the current code.

If anything I stated as fact above is incorrect, then I apologize.
I'm not entirely sure I have my details correct here.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
