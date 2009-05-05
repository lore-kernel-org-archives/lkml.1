Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZEEHvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZEEHvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 03:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZEEHvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 03:51:33 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44275 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbZEEHvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 03:51:32 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Matt Mackall <mpm@selenic.com>
References: <20090504125114.5e391564@chukar>
	<alpine.LFD.2.01.0905041159480.4983@localhost.localdomain>
	<20090504125124.0f469970@infradead.org>
	<m1vdogbows.fsf@fess.ebiederm.org>
	<alpine.LFD.2.01.0905041514350.4983@localhost.localdomain>
	<alpine.LFD.2.01.0905041646240.4983@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 05 May 2009 00:51:24 -0700
In-Reply-To: <alpine.LFD.2.01.0905041646240.4983@localhost.localdomain> (Linus Torvalds's message of "Mon\, 4 May 2009 16\:54\:06 -0700 \(PDT\)")
Message-ID: <m1r5z40yyr.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: torvalds@linux-foundation.org, mpm@selenic.com, greg@kroah.com, akpm@linux-foundation.org, mingo@redhat.com, roland@redhat.com, alan@lxorguk.ukuu.org.uk, eparis@redhat.com, linux-security-module@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, security@kernel.org, jake@lwn.net, arjan@infradead.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4951]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged processes
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, 4 May 2009, Linus Torvalds wrote:
>> 
>> Quite frankly, the way "get_random_bytes()" works now (it does a _full_ 
>> sha thing every time), I think it's insane overkill. But I do have to 
>> admit that our current "get_random_int()" is insane _underkill_.
>
> Actually, I don't think "get_random_int()" is underkill per se (it does 
> that half md4 transform to try to hide the source of the data), but the 
> data itself is simply not modified at all, and the buffers aren't updated 
> in between rounds.
>
> In fact "secure_ip_id()" (which it uses) explicityl does that private 
> hash[] array so that the mixing that "half_md4_transform()" does do will 
> _not_ be saved for the next round - so the next round will always start 
> from the same keyptr "secret" state.
>
> I think.
>
> If that wasn't the case, and we actually kept mixing up the end result 
> back into the next iteration, I suspect the current "get_random_int()" 
> wouldn't be _nearly_ as bad as it is now. 
>
> Or maybe I'm missing some part of the transform, and we do mix the values 
> back as we do that "get_random_int()". I just don't see it. And if I'm 
> right, then I think _that_ is the real weakness of our current 
> get_random_int().

Yes, not mixing the result back (which would give us some kind of
pseudo random number generator) is the problem.

secure_ip_id, looks to be a very different kind of thing.  A seed
that is reused periodically.  Ultimately those values do change.

For the state we are mixing back into I expect we want it to be
per cpu so we don't need locks and avoid  cache line ping pongs
when we mix the state back.

I haven't seen Matts patch and couldn't find it when I did a quick
look so I don't have any idea there.

Eric
