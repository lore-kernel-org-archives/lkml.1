Return-Path: <linux-kernel-owner+w=401wt.eu-S936281AbXLRAqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936281AbXLRAqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbXLRAqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:46:31 -0500
Received: from mga10.intel.com ([192.55.52.92]:12144 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753009AbXLRAqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:46:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,178,1196668800"; 
   d="scan'208";a="445825366"
Message-ID: <476716BD.7060807@linux.intel.com>
Date: Mon, 17 Dec 2007 16:39:25 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       protasnb@gmail.com, tytso@thunk.org
Subject: Re: Top kernel oopses/warnings this week
References: <4762CF8C.90808@linux.intel.com> <20071217172331.GA23070@elte.hu> <20071217133631.5bbc5842@laptopd505.fenrus.org> <12c511ca0712171458n1bc05b40nab6b4b7c92433c8d@mail.gmail.com> <476703A4.7000401@linux.intel.com> <12c511ca0712171526h242a7de8vadec78cd48747bd@mail.gmail.com> <20071217154727.404e4bc4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712171607370.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712171607370.21557@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 17 Dec 2007, Arjan van de Ven wrote:
>> +char *get_boot_uuid(void)
>> +{
>> +	static char target[38];
>> +	unsigned char *uuid;
>> +
>> +	if (sysctl_bootid[8] == 0)
>> +		generate_random_uuid(sysctl_bootid);
>> +	/* sysctl_bootid is signed, to print we need unsigned .. */
>> +	uuid = sysctl_bootid;
>> +
>> +	if (target[0] == 0) {
>> +		sprintf(target, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
>> +			"%02x%02x%02x%02x%02x%02x",
> 
> Why isn't *everything* inside that "if (target[0] == 0" check?

the sysctl_bootid is shared with the /proc exposed bootid, so I need to generate it the same way

> I'd _also_ suggest that you'd actually try to avoid that horrid sequence 
> of "%02x..", and instead just make sure that sysctl_bootid[] is 4-byte 
> aligned, and then you can do
> 
> 	sprintf("%08x-%04x-%04x-%04x-%04x%08x",
> 		ntohl(0[(u32 *)uuid]),
> 		ntohs(2[(u16 *)uuid]),
> 		ntohs(3[(u16 *)uuid]),
> 		ntohs(4[(u16 *)uuid]),
> 		ntohs(5[(u16 *)uuid]),
> 		ntohl(3[(u32 *)uuid]));
> 
> which also gets bonus points for being totally unreadable, and thus 100% 
> in the spirit of uuid's.

again.. this is for compatibility with /proc/sys/kernel/random/boot_id .. the code 10 lines below my patch is identical and does
the %02x stuff... I didn't make that up, I just copied that to get the same output.
I can deviate for cleanup... but I can see some value of being the same format and same data.


