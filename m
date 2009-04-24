Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbZDXGQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbZDXGQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757768AbZDXGQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:16:41 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48686 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758025AbZDXGQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:16:39 -0400
Message-ID: <49F15922.5090704@jp.fujitsu.com>
Date: Fri, 24 Apr 2009 15:16:02 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] [3/4] x86: MCE: Improve mce_get_rip
References: <20090407506.675031434@firstfloor.org>	 <20090407150656.43E161D046D@basil.firstfloor.org>	 <49DC5D11.4060505@jp.fujitsu.com> <1240479833.6842.554.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1240479833.6842.554.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> Add some description for the patch, hope that to be more clear.
> 
> Best Regards,
> Huang Ying
> --------------------------------------------->
> mce_get_rip() is used to get IP when MCE is generated, usually from
> the stack. But the IP on the stack is not always valid.
> MCG_STATUS_RIPV indicates program can restart from the IP on the stack,
> so if it is set, the IP is valid. MCG_STATUS_EIPV indicate IP on the
> stack is directly associated with the error, so if it is set, the IP
> is valid too.
> 
> In current implementation, no IP will be returned (and then reported)
> if MCG_STATUS_RIPV is not set and MCG_STATUS_EIPV is set. This patch
> fixes this issue by returning IP on the stack when MCG_STATUS_EIPV is
> set.
> 
> In some CPU, a MSR (rip_msr) provides another way to get IP when MCE
> is generated. This is used by mce_get_rip() too.
> 
> There is no MSR for CS, in current implementation, if rip_msr is used
> to get IP, reported CS is set to 0. But in fact, the CS on the stack
> can be trusted if MCG_STATUS_RIPV or MCG_STATUS_EIPV is set. This
> patch fixes this issue by keeping reported CS when rip_msr is used.

So the bug is in short:
 In some cases no IP/CS reported even there were valid records.
Right?

Then in other words it will mean lost of error information, that is not
good for error investigation.

One question is: if (RIPV,EIPV) = (0,0), then is the IP on the stack
really invalid value, or is it still point IP when MCE is generated?
I suppose it is not invalid.  If a processor encounters MCE and if it
is not sure what happened, then it will store the IP on the stack,
indicating neither of flags.

If this supposition is correct, the best way is pick the value on
the stack unconditionally, and record valid flags together.


Thanks,
H.Seto

