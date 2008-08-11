Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbYHKNeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbYHKNeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 09:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbYHKNeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 09:34:11 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:39600 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbYHKNeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 09:34:09 -0400
Message-ID: <43117.166.70.238.45.1218460302.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <20080811130256.GB28030@redhat.com>
References: <20080807200659.GJ24801@one.firstfloor.org>
    <23175.1218148134@ocs10w> <20080808011500.GA531@redhat.com>
    <20080808022916.GM24801@one.firstfloor.org>
    <20080808132953.GB3840@redhat.com>
    <20080808180303.GB9038@one.firstfloor.org>
    <20080811130256.GB28030@redhat.com>
Date: Mon, 11 Aug 2008 07:11:42 -0600 (MDT)
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: "Vivek Goyal" <vgoyal@redhat.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, "Keith Owens" <kaos@ocs.com.au>,
       "Jay Lan" <jlan@sgi.com>, "Christoph Lameter" <cl@linux-foundation.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Josh Boyer" <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       "Takenori Nagano" <t-nagano@ah.jp.nec.com>,
       "Bernhard Walle" <bwalle@suse.de>
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I found a problem with APIC NMI support which seems to affect all the
debuggers, but appears machine specific -- at least I can reproduce it
with all of the modules MDB, KDB, and KGDB modules on my ACER 2410 dual
core laptop.  It explains the mysterious hangs I would see in KDB all the
time on SMP systems.

The call:

send_IPI_allbutself(vector)

will hard hang an on ACER laptop with dual core processors if issued while
any one of the processors are actively inside an INT 1 handler, then take
a SECOND NMI inside of this path, and nest.   It hangs the requesting
(focus) processor during nested interrupts if a target processor is A)
inside an INT 1 exception B) takes an NMI interrupt C) returns from the
NMI back into the INT1 D) receives a second NMI.

I am aware that a second NMI will not propagate to a processor currently
servicing an NMI until the processor sees an IRET instruction (at least
this is how intel worked years back).

I have not been able to reproduce it on the Xeon based motherboards.  I
have seen the APIC bus hang this way on my other OS project -- when the
APIC was programmed incorrectly, and assume it must be a bug in the APIC,
how the APIC is programmed by Linux, etc.

I am coding around the problem to prevent such convoluted nesting levels
in MDB (this was from testing) but this was the final test for enabling
SSB and all the fixes before I post and rc3 patch series which really
cleanup up the code, and there's a mystery with send_IPI_allbutself().

Jeff

