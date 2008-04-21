Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbYDUB4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbYDUB4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 21:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYDUB4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 21:56:05 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:17992 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbYDUB4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 21:56:04 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Dave Olson <dave.olson@qlogic.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ralph Campbell <ralph.campbell@qlogic.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [GIT PULL] please pull infiniband.git
References: <adaskxkh6s2.fsf@cisco.com> <20080419081614.GA2437@elte.hu>
	<adaod86aq9j.fsf@cisco.com>
	<alpine.LFD.1.00.0804190817280.21302@topaz.pathscale.com>
	<adafxthbz8p.fsf@cisco.com>
	<alpine.LFD.1.00.0804200746310.6811@topaz.pathscale.com>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 20 Apr 2008 18:55:23 -0700
In-Reply-To: <alpine.LFD.1.00.0804200746310.6811@topaz.pathscale.com> (Dave
	Olson's message of "Sun, 20 Apr 2008 07:47:56 -0700 (PDT)")
Message-ID: <aday7789dkk.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Apr 2008 01:55:24.0141 (UTC) FILETIME=[C36D11D0:01C8A352]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > | Not sure I really follow this response... ipath_driver.c has
 > | 
 > | 	case PCI_DEVICE_ID_INFINIPATH_7220:
 > | #ifndef CONFIG_PCI_MSI
 > | 		ipath_dbg("CONFIG_PCI_MSI is not enabled, "
 > | 			  "using IntX for unit %u\n", dd->ipath_unit);
 > | #endif
 > | 		ipath_init_iba7220_funcs(dd);
 > | 		break;
 > | 
 > | so clearly ipath_init_iba7220_funcs() was intended to be built and used
 > | even if CONFIG_PCI_MSI was not defined.  From the code it looks like all
 > | should work fine if PCI_MSI is not set, so I don't know what you mean
 > | about conditional checks.
 > 
 > Actually, it wasn't.  It was a late cleanup for another problem, and
 > we didn't worry about the other issue, and should have.

Sorry, I still don't follow.  What is the antecedent of "it"?  What was
"the other issue"?

I'm not sure I know the right fix for the build breakage.  It seems
there are two possibilities:

 - build the iba7220 support unconditionally (the patch I posted).

 - change the case statement I quoted above so that the
   ipath_init_iba7220_funcs() call is inside the #ifdef block (and add
   an error message if CONFIG_PCI_MSI is not defined, as for the 6120
   block in the same case statement).

Since it seems iba7220 works with INTx interrupts, the first choice
makes the most sense to me.

And since all the pci_msi functions have stubs that just fail
unconditionally if CONFIG_PCI_MSI is not defined, it seems we can remove
the #ifdef CONFIG_PCI_MSI from the iba7220 files.

And given that at least some device support works even if neither
PCI_MSI nor HT_IRQ is defined, then it makes sense to me to remove that
Kconfig dependency.

If I have something wrong, please let me know.

 - R.
