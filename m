Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbZDFPTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbZDFPTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbZDFPTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:19:05 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45917 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZDFPTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:19:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=LpT/Wb8gQSunWSKVi3a3BYFT7sNlkIr/lHNhoY0thjg0bvKFCspBK4mEwGBkKI0Nor
         LwYH1J3I0LdXSd1IUgNT4SuBM+qxSnkdoJzdcto+D/2RHWpXcjvuIKXVsOQT3MUuNQaB
         wI/OR6dMM7WymZkM9nnKXP1GGfHaXK/iUa68Q=
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Sujith <Sujith.Manoharan@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: ath9k becon loss messages
References: <1238923439.4120.9.camel@localhost.localdomain>
	<200904061217.31134.mb@bu3sch.de> <87tz52xepy.fsf@litku.valot.fi>
	<200904061251.10965.helmut.schaa@gmail.com>
	<da94abde0904060405k280b3094jc20d0f7a4e6e759d@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 06 Apr 2009 18:18:56 +0300
In-Reply-To: <da94abde0904060405k280b3094jc20d0f7a4e6e759d@mail.gmail.com> (Kalle Valo's message of "Mon\, 6 Apr 2009 14\:05\:46 +0300")
Message-ID: <87iqlhdd3z.fsf@litku.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kalle Valo <kalle.valo@iki.fi> writes:

> On Mon, Apr 6, 2009 at 1:51 PM, Helmut Schaa
> <helmut.schaa@googlemail.com> wrote:
>
>> Maybe this issue could be
>> avoided by making the beacon loss detection smarter then just checking if no
>> beacon was received within the last two seconds.
>
> Definitely the beacon loss logic should be smarter, but I think that
> should be improved separately. I just have tried to do small changes
> at a time to avoid regressions and I didn't even consider improving
> the beacon loss logic.

I reverted my beacon filter patches but added a similar "beacon loss"
message. With iwl3945 I was able to reproduce the problem even by just
associating to an AP and issuing 'iwlist wlan0 scan':

Apr  6 15:09:31 tikku kernel: [ 3692.544221] beacon loss (reverted version)
Apr  6 15:09:46 tikku kernel: [ 3707.654520] beacon loss (reverted version)
Apr  6 15:09:53 tikku kernel: [ 3714.314057] beacon loss (reverted version)

So the good news is that this is not a new regression, the problem just
appeared because of the new printk I added to my beacon filtering
patches.

I'm suffering from flu right now (damn the finnish weather), but I tried
to investigate this a bit. The problem happens when mac80211 does not
receive anything for two seconds while scanning. For example, at my home
there are only few APs and scanning takes a long time due to 11a support
in iwl3945, so I can reproduce the problem easily.

I'm working on implementing a proper fix, but due to my condition it
might take few days before I'm able to finish it. But in the mean time,
Michael's patch, changing the "beacon loss" messages visible only when
CONFIG_MAC80211_VERBOSE_DEBUG is enabled, is the way to go forward. The
message is useful for developers (eg. we found this bug because of the
message), but it's better that users don't see it. I would like to have
the patch for 2.6.30.

When I'm able to implement the proper fix, I think it should first have
proper testing in wireles-testing before pushing it to mainline. So
maybe the proper fix is 2.6.31 material, just to be on the safe side
here.

John, what do you think?

-- 
Kalle Valo
