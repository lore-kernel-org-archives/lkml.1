Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbYAQVvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbYAQVvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759604AbYAQVtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:49:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34211 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759550AbYAQVtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:49:17 -0500
Message-ID: <478FCAD8.2020904@zytor.com>
Date: Thu, 17 Jan 2008 16:38:32 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Andreas Herrmann3 <andreas.herrmann3@amd.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug fixes
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com> <20080116203328.GA17869@linux-os.sc.intel.com> <20080117191211.GA12631@alberich.amd.com> <20080117203600.GB27778@elte.hu> <20080117210301.GC12631@alberich.amd.com> <20080117211308.GA7858@elte.hu> <20080117213131.GA25389@linux-os.sc.intel.com>
In-Reply-To: <20080117213131.GA25389@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Siddha, Suresh B wrote:
> 
> But then, this will cause an attribute conflicit. Old one was specifying
> WB in PAT (ioremap with noflags) and the new ioremap specifies UC.
> 
> As Linus mentioned, main problem is to figure out the correct attribute
> for ioremap() which doesn't specify the actual attribute to be used.
> 
> One mechanism to fix the issue generically (somewhat atleast) is to use
> MTRR's and figure out the default MTRR attribute for that physical address
> and use it for ioremap().
> 

This is the matrix the CPU uses when combining MTRR and PAT behaviour. 
It probably makes sense to mimic:

    | WB  WT  WC  UC
---+---------------
WB | WB  WT  WC  UC
WT | WT  WT  UC  UC
WC | WC  UC  WC  UC
UC | UC  UC  UC  UC

With the current PAT encoding:

WB = 00
WT = 01
WC = 10
UC = 11

... this is simply a bitwise OR.  This makes sense, since one of the 
bits denies delaying writes (WT, UC), and the other denies delaying 
reads (WC, UC).

	-hpa
