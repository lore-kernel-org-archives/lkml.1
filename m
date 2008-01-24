Return-Path: <linux-kernel-owner+w=401wt.eu-S1758988AbYAXUpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988AbYAXUpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758222AbYAXUiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:38:25 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44834 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758330AbYAXUiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:38:22 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>,
       Andreas Herrmann3 <andreas.herrmann3@amd.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug fixes
References: <20080116023955.597433000@intel.com>
	<20080116185748.GA11244@alberich.amd.com>
	<20080116203328.GA17869@linux-os.sc.intel.com>
	<20080117191211.GA12631@alberich.amd.com>
	<20080117203600.GB27778@elte.hu>
	<20080117210301.GC12631@alberich.amd.com>
	<20080117211308.GA7858@elte.hu>
	<20080117213131.GA25389@linux-os.sc.intel.com>
	<478FCAD8.2020904@zytor.com>
Date: Thu, 24 Jan 2008 13:22:19 -0700
In-Reply-To: <478FCAD8.2020904@zytor.com> (H. Peter Anvin's message of "Thu,
	17 Jan 2008 16:38:32 -0500")
Message-ID: <m1lk6fht38.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Siddha, Suresh B wrote:
>>
>> But then, this will cause an attribute conflicit. Old one was specifying
>> WB in PAT (ioremap with noflags) and the new ioremap specifies UC.
>>
>> As Linus mentioned, main problem is to figure out the correct attribute
>> for ioremap() which doesn't specify the actual attribute to be used.
>>
>> One mechanism to fix the issue generically (somewhat atleast) is to use
>> MTRR's and figure out the default MTRR attribute for that physical address
>> and use it for ioremap().
>>
>
> This is the matrix the CPU uses when combining MTRR and PAT behaviour. It
> probably makes sense to mimic:
>
>    | WB  WT  WC  UC
> ---+---------------
> WB | WB  WT  WC  UC
> WT | WT  WT  UC  UC
> WC | WC  UC  WC  UC
> UC | UC  UC  UC  UC
>
> With the current PAT encoding:
>
> WB = 00
> WT = 01
> WC = 10
> UC = 11
>
> ... this is simply a bitwise OR.  This makes sense, since one of the bits denies
> delaying writes (WT, UC), and the other denies delaying reads (WC, UC).

Almost.  There is a specific case and important where MTRR UC + page table WC == WC.

But yes.  For ioremap where we are WB + MTRR == MTRR we need to request the
same attributes as the e820 map, to get the attribute checking correct.

Eric
