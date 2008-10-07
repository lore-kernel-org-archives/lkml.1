Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbYJGVuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbYJGVuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbYJGVui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:50:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:14079 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbYJGVuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:50:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,375,1220252400"; 
   d="scan'208";a="345128368"
Date: Tue, 7 Oct 2008 14:49:20 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Add clflush before monitor for Intel 7400 series
Message-ID: <20081007214920.GA17439@linux-os.sc.intel.com>
References: <20081007210056.GA5802@linux-os.sc.intel.com> <48EBCFF8.6050500@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EBCFF8.6050500@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 02:09:12PM -0700, H. Peter Anvin wrote:
> Venki Pallipadi wrote:
> > For Intel 7400 series CPUs, the recommendation is to use a clflush on the
> > monitored address just before monitor and mwait pair [1]. This clflush makes
> > sure that there are no false wakeups from mwait when the monitored address
> > was recently written to.
> >
> > [1] "MONITOR/MWAIT Recommendations for Intel Xeon Processor 7400 series"
> > section in specification update document of 7400 series
> > http://download.intel.com/design/xeon/specupdt/32033601.pdf
> >
> > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> 
> This seems very expensive.  It really makes me wonder if it wouldn't
> just be better to either declare monitor/mwait non-functional on this
> chip, or make sure that mwaits can handle false wakeups.
> 

mwait can handle false wakeups. Today we wake backup all the way and find
out there is nothing to do and go back to idle. And second time around this
false wakeup does not happen as we do not write to monitored address in the
interim. The problem we saw was the places where we try to look at how
long each idle period was and take power management decision for the next idle.
Such algorithms get confused with false wakeups.

Yes. Other alternative is to disable mwaits altogether on these CPUs. I can
send a patch to do that. But, the patch will be somewhat more complicated
as kernel advertises the MWAIT capability to firmware with a ACPI _PDC method
and BIOS has to then give IO port based C2 for us to use in such case.
Avoiding mwait just for C1 is easy though.

Thanks,
Venki 
