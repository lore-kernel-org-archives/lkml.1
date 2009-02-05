Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZBEU4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZBEU4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbZBEU4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:56:03 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:42887 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbZBEU4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:56:01 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakesh Jain <shjain@akamai.com>, ShakeshJain@akamai.com,
       linux-kernel@vger.kernel.org, juhlenko@akamai.com,
       Alexey Dobriyan <adobriyan@gmail.com>
References: <20090204084022.GB14071@akamai.com>
	<20090205122941.17805ff1.akpm@linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 05 Feb 2009 12:55:56 -0800
In-Reply-To: <20090205122941.17805ff1.akpm@linux-foundation.org> (Andrew Morton's message of "Thu\, 5 Feb 2009 12\:29\:41 -0800")
Message-ID: <m1zlh0txgj.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.180.49.163;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.180.49.163
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, adobriyan@gmail.com, juhlenko@akamai.com, linux-kernel@vger.kernel.org, ShakeshJain@akamai.com, shjain@akamai.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] sysctl: min-max range check is broken
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 4 Feb 2009 00:40:22 -0800
> Shakesh Jain <shjain@akamai.com>, ShakeshJain@akamai.com wrote:
>
>> do_proc_dointvec_minmax_conv() which gets callled from
>> proc_dointvec_minmax proc_handler doesn't increment the pointer to
>> the 'min' (extra1) and 'max' (extra2) after each range check which
>> results in doing the check against same set of min and max values.
>> 
>> This breaks the range checking for those sysctl's where you can
>> write multiple values to /proc with each variable having its own range
>> specification.

I just did a quick grep for .extra1 and I don't see anywhere we use
the code as described.

>> It seems to be implemented for the sysctl() system call strategy in
>> sysctl_intvec() where min and max are treated as arrays.

Yep.  There is an inconsistency here.  Given how sysctl is used and
tested, and the fact I could not find where it appears that anyone is
passing an array into min/max I would say that the proc version is
correct and the sysctl version is wrong.

The untested patch below looks like it will fix the this.

I don't know if there are any cases where we use minmax with an array
of integers but I don't see the point of using an array of minmax
values at this point.  For the original sysctl design it may have made
some sense.  New code should be one value per file.

Eric



diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 790f9d7..4050ce1 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2916,9 +2916,9 @@ int sysctl_intvec(struct ctl_table *table,
 			int value;
 			if (get_user(value, vec + i))
 				return -EFAULT;
-			if (min && value < min[i])
+			if (min && value < *min)
 				return -EINVAL;
-			if (max && value > max[i])
+			if (max && value > *max)
 				return -EINVAL;
 		}
 	}
