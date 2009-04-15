Return-Path: <linux-kernel-owner+w=401wt.eu-S1758511AbZDOIQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511AbZDOIQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbZDOIPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:15:50 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:23401 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZDOIPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:15:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GHgHqzVe+TBV1A3xb6CV18UY4Hnz8VZpHLy8wIXCB309hYCnY3JfQwHwqThluX8eIl
         E86fGi1h3CNgJoC/6XOpvbg/d0+dNRAvFew+X8xGX9Q6KS5IC/j98IQhKstkU3bsTUgq
         BR9x6xvKTXoy6B7jrQep4OgdWiUJh+vAshLho=
Date: Wed, 15 Apr 2009 12:45:34 +0430
From: Ali Gholami Rudi <ali@rudi.ir>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       Mike Travis <travis@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mm-commits@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Dave Jones <davej@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
Message-ID: <20090415081534.GA2894@lilem.mirepesht>
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org> <4609.1239456126@turing-police.cc.vt.edu> <alpine.LFD.2.00.0904130847500.4583@localhost.localdomain> <20090413171853.GA4601@elte.hu> <20090413102749.4ca3a217.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413102749.4ca3a217.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-04-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In today's tip (v2.6.30-rc2), when my cpu is idle (and the ondemand
governor correctly uses the lowest frequency) the temperature of my CPU
rises to above 50^C till the fan turns on (it used to be about 40^C
before).  Git bisect points to this patch:

  commit 01599fca6758d2cd133e78f87426fc851c9ea725
  Author: Andrew Morton <akpm@linux-foundation.org>
  Date:   Mon Apr 13 10:27:49 2009 -0700
  
      cpufreq: use smp_call_function_[single|many]() in acpi-cpufreq.c
      
      Atttempting to rid us of the problematic work_on_cpu().  Just use
      smp_call_fuction_single() here.
      
      This repairs a 10% sysbench(oltp)+mysql regression which Mike reported,
      due to
      
        commit 6b44003e5ca66a3fffeb5bc90f40ada2c4340896
        Author: Andrew Morton <akpm@linux-foundation.org>
        Date:   Thu Apr 9 09:50:37 2009 -0600
      
            work_on_cpu(): rewrite it to create a kernel thread on demand
      
      It seems that the kernel calls these acpi-cpufreq functions at a quite
      high frequency.
      
      Valdis Kletnieks also reports that this causes 70-90 forks per second on
      his hardware.
      
      Cc: Valdis.Kletnieks@vt.edu
      Cc: Rusty Russell <rusty@rustcorp.com.au>
      Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
      Cc: Len Brown <len.brown@intel.com>
      Cc: Zhao Yakui <yakui.zhao@intel.com>
      Acked-by: Dave Jones <davej@redhat.com>
      Cc: Thomas Gleixner <tglx@linutronix.de>
      Tested-by: Mike Galbraith <efault@gmx.de>
      Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
      Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
      Acked-by: Ingo Molnar <mingo@elte.hu>
      [ Made it use smp_call_function_many() instead of looping over cpu's
        with smp_call_function_single()    - Linus ]
      Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Should I include more info?

Regards,
Ali
