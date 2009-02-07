Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbZBGQr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbZBGQr3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 11:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZBGQrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 11:47:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:56013 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbZBGQrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 11:47:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,397,1231142400"; 
   d="scan'208";a="429110556"
Date: Sat, 7 Feb 2009 08:47:07 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       "thomas@linux-os.sc.intel.com" <thomas@linux-os.sc.intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Add clflush before monitor for Intel 7400 series - v2
Message-ID: <20090207164707.GA19149@linux-os.sc.intel.com>
References: <20090207004728.GA17586@linux-os.sc.intel.com> <20090207140245.1e91a88f@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090207140245.1e91a88f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 06:02:45AM -0800, Alan Cox wrote:
> On Fri, 6 Feb 2009 16:47:29 -0800
> "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:
> 
> > 
> > 
> > For Intel 7400 series CPUs, the recommendation is to use a clflush on the
> > monitored address just before monitor and mwait pair [1]. This clflush makes
> > sure that there are no false wakeups from mwait when the monitored address
> > was recently written to.
> 
> Given our mwait usages will very quickly go back to sleep in such a case
> and it would almost certainly be one sleep only is this really worth the
> effort ?

Yes. If we only consider the CPU idle behavior, we really do not need the
patch as we will go back to idle. But, there are other factors:
- drivers/idle/i7300_idle.c  which tries to save memory power based on CPU
  idle time. It gets confused with these short idles.
- cpuidle menu governor  These platforms may also support more than one C-state.
  C1 and CC3. So, we will go through the C-state policy in menu governor, which
  again looks at idle time and may end up taking wrong decisions due to these
  short idles.

We can make the above code to be more clever, to ignore short idles. But, this
patch seems to be the easier and clean way as the errata is only in a particular
CPU model.

Thanks,
Venki
