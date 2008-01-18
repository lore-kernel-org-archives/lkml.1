Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbYARHc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbYARHc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 02:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYARHct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 02:32:49 -0500
Received: from gw.goop.org ([64.81.55.164]:40353 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbYARHcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 02:32:48 -0500
Message-ID: <4790561E.9040508@goop.org>
Date: Thu, 17 Jan 2008 23:32:46 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: xming <xmingske@gmail.com>
CC: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Cannot boot xen DomU > 2.6.23.1
References: <519a8b110801170813h96b8f2by795e6d8b72a00ba4@mail.gmail.com>	 <478F8D22.60004@goop.org> <519a8b110801171113y20a3bedfg446e29a30712a26d@mail.gmail.com>
In-Reply-To: <519a8b110801171113y20a3bedfg446e29a30712a26d@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xming wrote:
> The symptom is (with a lot of subjective judgment) when there is a lot (or
> too quick) output on the console of the domU (hvc0 connected with either
> "xm crea file.cfg -c" or "xm cons id") the whole PV domU hangs. It will
> really hang at random places, sometimes right after init and sometime
> after I logged in and just generate some ouput (on hvc0) like "find /". IIRC
> I have never seen a hang before init.
>   

OK, I misunderstood your original report to mean that something was 
complaining about "too much" output.  You're saying that lots of console 
output seems to lock the domain.

I've had a report about heavy disk IO seems to lock up as well.  Perhaps 
they're both related to high event rates.  Do you think you could try an 
IO-intensive workload to see if you can get a similar lockup?

When the domain is locked up, what does /usr/lib/xen/bin/xenctx say?

Hm.  Rather than backing out the structure-change patch, could you try 
this workaround:

diff -r be3ca4e0e19e arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c	Thu Jan 17 14:25:07 2008 -0800
+++ b/arch/x86/xen/enlighten.c	Thu Jan 17 16:37:42 2008 -0800
@@ -95,7 +95,7 @@ struct shared_info *HYPERVISOR_shared_in
  *
  * 0: not available, 1: available
  */
-static int have_vcpu_info_placement = 1;
+static int have_vcpu_info_placement = 0;
 
 static void __init xen_vcpu_setup(int cpu)
 {


Reverting the structure shape could cause crashes or random data 
corruption, but it has the side-effect of disabling the vpu_info 
structure placement mechanism.  This patch disables it cleanly.

Thanks,
    J
