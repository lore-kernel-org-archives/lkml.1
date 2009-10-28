Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZJ1RMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZJ1RMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbZJ1RMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:12:44 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:16874 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbZJ1RMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:12:43 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAD4Y6EqrR7Hu/2dsb2JhbADCQJgxhD8E
X-IronPort-AV: E=Sophos;i="4.44,641,1249257600"; 
   d="scan'208";a="262840397"
From: Roland Dreier <rdreier@cisco.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86, mce: disable MCE if cpu has no MCE banks
References: <adaeip473qt.fsf@cisco.com> <4AE74D25.8090901@sgi.com>
	<4AE75DB9.3040702@sgi.com> <4AE7C396.7040109@jp.fujitsu.com>
	<4AE7D59D.9070307@linux.intel.com> <4AE7E40F.20602@jp.fujitsu.com>
	<4AE7E931.6040703@linux.intel.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 28 Oct 2009 10:12:47 -0700
In-Reply-To: <4AE7E931.6040703@linux.intel.com> (Andi Kleen's message of "Wed,
	28 Oct 2009 07:48:17 +0100")
Message-ID: <ada8wevtpbk.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Oct 2009 17:12:47.0732 (UTC) FILETIME=[DF39C340:01CA57F1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Perhaps they could be also compressed a bit like SRAT.

Seems like a good idea... but I wonder what the best way to represent
things is.  For example I have a 2-socket Nehalem system that shows:

 2 times:  MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
 6 times:  MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
 8 times:  MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8

presumably the first line is once per package, the next line is for the
first sibling in all the other cores in a package, and the last line is
for the SMT siblings of all the cores.

But would we want to accumulate all the different combinations of banks
along with a CPU mask and then print something like:

 CPUs 0 4: MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
 CPUs 1 2 3 5 6 7: MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
 CPUs 8 9 10 11 12 13 14 15: MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8

of course output like that is going to lead to super-long lines on a
64-thread system.

Also I'm not sure of a clean way to implement this; unlike the SRAT
stuff, we need to deal with CPU hotplug so all this at best could be
__cpuinitdata, ie we can't discard it in most configs.

However the "MCA banks" output definitely is annoying on a 64-thread
system -- the amount of output is far greater than the utility of said
output.  So ideas on the best way to reduce this would be appreciated.

Thanks,
  Roland
