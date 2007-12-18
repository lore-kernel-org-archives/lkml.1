Return-Path: <linux-kernel-owner+w=401wt.eu-S936364AbXLRAc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936364AbXLRAc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763038AbXLRAcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:32:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32823 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761109AbXLRAcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:32:17 -0500
Date: Mon, 17 Dec 2007 16:21:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       protasnb@gmail.com, tytso@thunk.org
Subject: Re: Top kernel oopses/warnings this week
In-Reply-To: <20071217154727.404e4bc4@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.0.9999.0712171607370.21557@woody.linux-foundation.org>
References: <4762CF8C.90808@linux.intel.com> <20071217172331.GA23070@elte.hu> <20071217133631.5bbc5842@laptopd505.fenrus.org> <12c511ca0712171458n1bc05b40nab6b4b7c92433c8d@mail.gmail.com> <476703A4.7000401@linux.intel.com> <12c511ca0712171526h242a7de8vadec78cd48747bd@mail.gmail.com>
 <20071217154727.404e4bc4@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Dec 2007, Arjan van de Ven wrote:
>
> +char *get_boot_uuid(void)
> +{
> +	static char target[38];
> +	unsigned char *uuid;
> +
> +	if (sysctl_bootid[8] == 0)
> +		generate_random_uuid(sysctl_bootid);
> +	/* sysctl_bootid is signed, to print we need unsigned .. */
> +	uuid = sysctl_bootid;
> +
> +	if (target[0] == 0) {
> +		sprintf(target, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
> +			"%02x%02x%02x%02x%02x%02x",

Why isn't *everything* inside that "if (target[0] == 0" check?

IOW, that function should look something like

	const char *get_boot_uuid(void)
	{
		static char target[38];

		if (!target[0])
			fill_boot_uid(target)
		return target;
	}

which also allows you to clean it up a bit.

I'd _also_ suggest that you'd actually try to avoid that horrid sequence 
of "%02x..", and instead just make sure that sysctl_bootid[] is 4-byte 
aligned, and then you can do

	sprintf("%08x-%04x-%04x-%04x-%04x%08x",
		ntohl(0[(u32 *)uuid]),
		ntohs(2[(u16 *)uuid]),
		ntohs(3[(u16 *)uuid]),
		ntohs(4[(u16 *)uuid]),
		ntohs(5[(u16 *)uuid]),
		ntohl(3[(u32 *)uuid]));

which also gets bonus points for being totally unreadable, and thus 100% 
in the spirit of uuid's.

		Linus
