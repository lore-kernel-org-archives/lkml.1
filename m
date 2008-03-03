Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbYCCWrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbYCCWrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYCCWq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:46:56 -0500
Received: from hu-out-0506.google.com ([72.14.214.238]:2609 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbYCCWqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:46:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=M5aMz3VfhWhWsomuzNI4dT7ssfJwML0E7jUjPWuupO2CR0Hsb9gRmbCXpofObkboOAGT1uQeyHcirzFNRmLZ6oAtKqiUnWg3vErr27Kde/9QTEVkYJV99idsndExkld/Bbi5e5QjWWAc4M7kJzA3TCDXtpDFQGbq2yohdNiP21A=
Message-ID: <12c511ca0803031446h48c5ab27w51fb87e5b0ae966e@mail.gmail.com>
Date: Mon, 3 Mar 2008 14:46:52 -0800
From: "Tony Luck" <tony.luck@intel.com>
To: "Ard -kwaak- van Breemen" <ard@telegraafnet.nl>
Subject: Re: [PATCH 2.6.20-rc2-git1] start_kernel: Test if irq's got enabled early, barf, and disable them again
Cc: "Andrew Morton" <akpm@osdl.org>, "Greg KH" <greg@kroah.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Chuck Ebbert" <76306.1226@compuserve.com>,
       "Yinghai Lu" <yinghai.lu@amd.com>, take@libero.it, agalanin@mera.ru,
       linux-kernel@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, sfr@canb.auug.org.au
In-Reply-To: <20061230194607.GT912@telegraafnet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20061222082248.GY31882@telegraafnet.nl>
	 <20061222144134.GH31882@telegraafnet.nl>
	 <20061222154234.GI31882@telegraafnet.nl>
	 <20061228155148.f5469729.akpm@osdl.org>
	 <20061229125108.GK912@telegraafnet.nl>
	 <20061229132759.GL912@telegraafnet.nl>
	 <20061229141058.GM912@telegraafnet.nl>
	 <20061229150132.GN912@telegraafnet.nl>
	 <20061229154251.GR912@telegraafnet.nl>
	 <20061230194607.GT912@telegraafnet.nl>
X-Google-Sender-Auth: cb095c47f43b1338
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  +               printk(KERN_WARNING "start_kernel(): bug: interrupts were enabled *very* early, fixing it\n");

I built and booted the next-20080303 tag from linux-next and
found the above warning in my console log on ia64 (this is
new ... I've never seen this message before, even though
this patch was applied January 2007).

Hunting this down, I found the enabler was the lock_kernel() call
on line 536 of init/main.c ... doesn't than happen to other archs
too?  We get into the first call to lock_kernel() with current->lock_depth
set to -1, so we call down(&kernel_sem) ... which does spin_lock_irq()
and then spin_unlock_irq() ... leaving interrupts enabled.

What else changed to make this suddenly kick out now? It
doesn't happen from a build from Linus' tree.

-Tony
