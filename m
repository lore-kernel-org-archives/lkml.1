Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbZD0XbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbZD0XbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 19:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756472AbZD0Xaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 19:30:52 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:38714 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbZD0Xav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 19:30:51 -0400
Date: Mon, 27 Apr 2009 16:30:47 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: use dmi check in apic_is_clustered with 64bit
Message-ID: <20090427233047.GB6377@localdomain>
References: <49F5532A.5000802@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F5532A.5000802@kernel.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 11:39:38PM -0700, Yinghai Lu wrote:
>
>will have system with 2 and more sockets 8cores/2thread.
>do treat them as multi chassis.
>
>use dmi check instead.
>
>[ Impact: do not make unstable TSC on wrongly ]
>
>Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>

The patch looks good.
Just one minor observation -- apic_is_clustered_box()
is used only to check if tscs are synced.  It is not used elsewhere. Since
the routine is not actually checking if the box uses clustered apic --
rather the routine is used to determine if tsc's are synced are not, the name
could be changed appropriately I guess?

...
>+}
>+
>+/*
>+ * apic_is_clustered_box() -- Check if we can expect good TSC
>+ *
>+ * Thus far, the major user of this is IBM's Summit2 series:
>+ * Clustered boxes may have un-synced TSC problems if they are
>+ * multi-chassis.
>+ * Use DMI to check them
>+ */
>+__cpuinit int apic_is_clustered_box(void)
>+{
>+	dmi_check_multi();
>+	if (multi)
> 		return 1;
> 
>+	if (!is_vsmp_box())
>+		return 0;
>+
> 	/*
>-	 * If clusters > 2, then should be multi-chassis.
>-	 * May have to revisit this when multi-core + hyperthreaded CPUs come
>-	 * out, but AFAIK this will work even for them.
>+	 * ScaleMP vSMPowered boxes have one cluster per board and TSCs are
>+	 * not guaranteed to be synced between boards
> 	 */
>-	return (clusters > 2);
>+	if (apic_cluster_num() > 1)
>+		return 1;
>+
>+	return 0;
> }

...
