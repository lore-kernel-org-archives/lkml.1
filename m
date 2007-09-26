Return-Path: <linux-kernel-owner+w=401wt.eu-S1763260AbXIZVP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763260AbXIZVP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760686AbXIZVPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:15:51 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:40881 "EHLO
	outbound2-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244AbXIZVPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:15:49 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Wed, 26 Sep 2007 15:15:58 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Joerg Pommnitz" <pommnitz@yahoo.com>, cebbert@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Regression in 2.6.23-pre Was: Problems with 2.6.23-rc6 on
 AMD Geode LX800
Message-ID: <20070926211558.GB14877@cosmic.amd.com>
References: <637040.99806.qm@web51411.mail.re2.yahoo.com>
 <46FA6858.5060908@zytor.com> <20070926154106.GG7582@cosmic.amd.com>
 <46FAAFA7.50106@zytor.com> <20070926205825.GA14877@cosmic.amd.com>
 <46FAC958.9000501@zytor.com>
MIME-Version: 1.0
In-Reply-To: <46FAC958.9000501@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 26 Sep 2007 21:15:39.0125 (UTC)
 FILETIME=[6344A250:01C80082]
X-WSS-ID: 6AE4147113S396572-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/09/07 14:04 -0700, H. Peter Anvin wrote:
> Jordan Crouse wrote:
> > On 26/09/07 12:14 -0700, H. Peter Anvin wrote:
> >> Please try the following debug patch to let us know what is going on.
> >>
> >> 	-hpa
> > 
> >> diff --git a/arch/i386/boot/memory.c b/arch/i386/boot/memory.c
> >> index 1a2e62d..a0ccf29 100644
> >> --- a/arch/i386/boot/memory.c
> >> +++ b/arch/i386/boot/memory.c
> >> @@ -33,6 +33,12 @@ static int detect_memory_e820(void)
> >>  		      "=m" (*desc)
> >>  		    : "D" (desc), "a" (0xe820));
> >>  
> >> +		printf("e820: err %d id 0x%08x next %u %08x:%08x %u\n",
> >> +		       err, id, next,
> >> +		       (unsigned int)desc->addr,
> >> +		       (unsigned int)desc->size,
> >> +		       desc->type);
> >> +
> >>  		if (err || id != SMAP)
> >>  			break;
> > 
> > Okay, we have clarity.   Here is the output
> > 
> > e820: err 0 id 0x534d4150 next 15476 00000000:0009fc00 1
> > e820: err 0 id 0x534d4150 next 15496 0009fc00:00000400 2
> > e820: err 0 id 0x534d4150 next 15516 000e0000:00020000 2
> > e820: err 0 id 0x0e7b0000 next 11536 00100000:0e6b0000 1
> > 
> > In the last entry,  id is obviously wrong (it should be 'SMAP' or
> > 0x534d4150).  This is the BIOS bug.
> > 
> > Here's the reason why this bothers us now.  In the old assembly code,
> > if the returned ID wasn't equal to 'SMAP', we jumped straight to the e801
> > code.  In the new code in memory.c, if id != SMAP, we break out of the
> > int15 loop, and return boot_params.e820_entries, which in our case is
> > 3.  detect_memory() considers this to be successful, and no attempt to
> > parse e801 is made.
> > 
> > So thats where the problem is - in the old code with the buggy BIOS, we
> > punted to reading the e801 information, and that was enough to keep us 
> > going.   In the new code, we allow a partial table to be used, and we
> > blow up.
> > 
> > Attached is a patch to fix this - it returns -1 on error, and only sets
> > boot_params.e820_entries to be non-zero if we have something useful
> > in it.  This punts the detection to the e801 code, which then is
> > then successful.
> > 
> > This fixes the problem with the DB800, and so it probably should
> > with the other Geode platforms affected by this.
> > 
> > Many thanks to hpa for the guiding hand.
> > 
> 
> This patch is obviously wrong.  There are a lot of e820 BIOSen out there
> that terminate with CF=1, and that is a legitimate termination condition
> for e820.  Now, as far as what to do when id != SMAP, it probably is
> still the right thing to do; since the BOS vendor couldn't get something
> that elementary correct, we shouldn't trust the data.
> 
> I'll write up a corrected patch.

Hmm - the old code seems to fail to e801 when CF was set too:

	int     $0x15                           # make the call
	jc      bail820                         # fall to e801 if it fails

	cmpl    $SMAP, %eax                     # check the return is `SMAP'
	jne     bail820                         # fall to e801 if it fails

Thats not to say that the old code was correct, mind you.  Failing on a
bad ID and returning without error on a set CF seems to be good to me.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


