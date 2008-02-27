Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbYB0VSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbYB0VSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYB0VR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:17:59 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:38647 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYB0VR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:17:58 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: Re: hpwdt oops in clflush_cache_range
X-Message-Flag: Warning: May contain useful information
References: <adad4qiwcmz.fsf@cisco.com>
	<alpine.LFD.1.00.0802271913050.7583@apollo.tec.linutronix.de>
	<ada1w6y1bzk.fsf@cisco.com>
	<alpine.LFD.1.00.0802272011130.7583@apollo.tec.linutronix.de>
	<20080227203655.GA30054@elte.hu>
	<alpine.LFD.1.00.0802272140050.7583@apollo.tec.linutronix.de>
	<alpine.LFD.1.00.0802272155190.7583@apollo.tec.linutronix.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 27 Feb 2008 13:17:54 -0800
In-Reply-To: <alpine.LFD.1.00.0802272155190.7583@apollo.tec.linutronix.de> (Thomas Gleixner's message of "Wed, 27 Feb 2008 21:59:26 +0100 (CET)")
Message-ID: <ada3areyu7x.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Feb 2008 21:17:54.0839 (UTC) FILETIME=[37C67270:01C87986]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Where is my brown paperbag ? I know that GCC _is_ stupid, but I never
 > remember.

Original patch actually worked fine and trapped the problem.

I also instrumented the driver, and the problem is coming from the code:

		/*
		 * Now we will check:
		 * - SMBIOS checksum must be 0
		 * - intermediate anchor should be _DMI_
		 * - intermediate checksum should be 0
		 */
		if ((bios_checksum(p, length)) &&
		    (strncmp((char *)eps->intermediate_anchor, "_DMI_",
		             sizeof(eps->intermediate_anchor)) == 0) &&
		    (bios_checksum(p+0x10, 15))) {
			buf = ioremap(eps->table_address, eps->table_length);
			if (buf == NULL)
				return -ENODEV;

the ioremap there is trying to remap 0x7b6 bytes at an address of
0x240047000ee000 -- either the BIOS data is bogus or the driver is
getting at it the wrong way.

Thomas (Mingarelli) -- this is on an HPDL380 G5 with pretty up-to-date
firmware (if it's not the latest, I'm only missing an update that came
out in the last month).  Should hpwdt work on this system?  Any debug
info that would be helpful?

 - R.
