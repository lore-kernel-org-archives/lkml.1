Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbYEZRBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbYEZRBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 13:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbYEZRBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 13:01:38 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:60323 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750984AbYEZRBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 13:01:38 -0400
Message-ID: <483AECEF.9030509@gawab.com>
Date: Mon, 26 May 2008 10:01:35 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080522)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Oops in mac80211 with 2.6.26-rc3 triggered playing a video
References: <483A3F91.6020403@gawab.com> <19f34abd0805260049j621c882r970444b65e384355@mail.gmail.com>
In-Reply-To: <19f34abd0805260049j621c882r970444b65e384355@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> The code decodes to:
>
>   1d:   f3 a5                   rep movsl %ds:(%esi),%es:(%edi)
>   1f:   89 c1                   mov    %eax,%ecx
>   21:   83 e1 03                and    $0x3,%ecx
>   24:   74 02                   je     0x28
>   26:   f3 a4                   rep movsb %ds:(%esi),%es:(%edi)
>   28:   8b 5d d0                mov    -0x30(%ebp),%ebx
>    0:   8b 9b 90 00 00 00       mov    0x90(%ebx),%ebx <---- BAM!
>    6:   85 db                   test   %ebx,%ebx
>    8:   89 5d d8                mov    %ebx,-0x28(%ebp)
>    b:   0f 84 6d 03 00 00       je     0x37e
>   11:   8b 7d cc                mov    -0x34(%ebp),%edi
>   14:   8b                      .byte 0x8b
>
> Recompiling net/mac80211/mlme.c gives me that this happens on line 675.
>
> ieee80211_compatible_rates net/mac80211/mlme.c:675
> ieee80211_send_assoc net/mac80211/mlme.c:767
> ieee80211_associate net/mac80211/mlme.c:955
>
> So it is in fact compatible_rates() that crashes (but hidden in your
> Oops because of heavy inlining).
>
> So looking at the latest changelog in linus/master, we have this change:
>
> commit 0d580a774b3682b8b2b5c89ab9b813d149ef28e7
> Author: Helmut Schaa <hschaa@suse.de>
> Date:   Tue May 20 09:56:37 2008 +0200
>
>     mac80211: fix NULL pointer dereference in ieee80211_compatible_rates
>
>     Fix a possible NULL pointer dereference in ieee80211_compatible_rates
>     introduced in the patch "mac80211: fix association with some APs". If no bss
>     is available just use all supported rates in the association request.
>
>     Signed-off-by: Helmut Schaa <hschaa@suse.de>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> So does applying/cherry-picking that fix your problem? (Patch
> attached, but not inlined.)
>
> Vegard
I'll try that patch (probably just doing a git pull). But since the oops 
is hard to trigger, it will take a while to test, and make sure that 
fixed the problem.

How did you "decode" the oops and find what file and line number that 
had the problem?
I tried to follow Documentation/oops-tracing.txt but I didn't know where 
to start.

Justin Madru
