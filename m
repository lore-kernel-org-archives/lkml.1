Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbYB0XqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbYB0XqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbYB0XqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:46:03 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:34373 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbYB0XqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:46:01 -0500
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: Roland Dreier <rdreier@cisco.com>, Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 27 Feb 2008 23:44:57 +0000
Subject: RE: hpwdt oops in clflush_cache_range
Thread-Topic: hpwdt oops in clflush_cache_range
Thread-Index: Ach5hjq76AneOrgPSzebcsSJ3XcvOgAFCy4A
Message-ID: <E14D1C2A44812C4F9C3ED321127EDF6505829D59DF@G3W0854.americas.hpqcorp.net>
References: <adad4qiwcmz.fsf@cisco.com>
	<alpine.LFD.1.00.0802271913050.7583@apollo.tec.linutronix.de>
	<ada1w6y1bzk.fsf@cisco.com>
	<alpine.LFD.1.00.0802272011130.7583@apollo.tec.linutronix.de>
	<20080227203655.GA30054@elte.hu>
	<alpine.LFD.1.00.0802272140050.7583@apollo.tec.linutronix.de>
	<alpine.LFD.1.00.0802272155190.7583@apollo.tec.linutronix.de>
 <ada3areyu7x.fsf@cisco.com>
In-Reply-To: <ada3areyu7x.fsf@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did I read correctly that this was on a Debian OS? Looks like I need to jump in and see what is different about Debian because I haven't seen such an issue on RedHat 5.

Yes, the driver was made specifically for G5 (and newer) systems. I will set a system up here and figure out what's wrong as soon as I am sure it is Debian.


Thanks,
Tom

-----Original Message-----
From: Roland Dreier [mailto:rdreier@cisco.com]
Sent: Wednesday, February 27, 2008 3:18 PM
To: Thomas Gleixner
Cc: Ingo Molnar; linux-kernel@vger.kernel.org; Mingarelli, Thomas
Subject: Re: hpwdt oops in clflush_cache_range

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
