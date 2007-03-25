Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbXCYVeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbXCYVeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 17:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932778AbXCYVeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 17:34:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:54744 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750AbXCYVef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 17:34:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YPSB3MKSqmMKmUZGeTCmMcACckE51U3TiXC7PcZuIuSkR+yUsfhsvh/0ssRFnroyG47GWrjQxvrGL6Qg0ZCJG3mzN2MqjYOdmCmGDphekdpPYXlU8xlkz9NR4cImdXtlIxB15b0P9l3IdQEHdtngKn96gF+XqzJZo7xWQO+d9VM=
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       Tino Keitel <tino.keitel@gmx.de>, Bob Moore <robert.moore@intel.com>,
       lenb@kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070323185022.GQ752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185022.GQ752@stusta.de>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 25 Mar 2007 23:34:14 +0200
Message-Id: <1174858456.5550.32.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 23 mars 2007 à 19:50 +0100, Adrian Bunk a écrit :
> Subject    : MacMini: doesn't come out of suspend to ram
> References : http://lkml.org/lkml/2007/3/21/374
> Submitter  : Frédéric RISS <frederic.riss@gmail.com>
>              Tino Keitel <tino.keitel@gmx.de>
> Caused-By  : Bob Moore <robert.moore@intel.com>
>              commit c5a7156959e89b32260ad6072bbf5077bcdfbeee
> Status     : unknown

I spent some time this weekend investigating this issue more thoroughly.
In fact the regression caused by this commit has been corrected by
f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38 (ACPI: Disable wake GPEs only
once.)  

However, as I pointed out in the initial report, the MacMini doesn't
come out of suspend to ram because a commit in another merged patchset
broke it. I tracked it down to:

commit e9e2cdb412412326c4827fc78ba27f410d837e6e
parent 79bf2bb335b85db25d27421c798595a2fa2a0e82 
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Feb 16 01:28:04 2007 -0800

    [PATCH] clockevents: i386 drivers
    
This patch has already been mentioned in regression reports, but AFAICS
not related to suspend issues.

To be totally clear about what works and what doesn't:

79bf2bb335b85db25d27421c798595a2fa2a0e82 
   + cherry-pick f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38  ==> works

e9e2cdb412412326c4827fc78ba27f410d837e6e
   + cherry-pick f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38  ==> broken

To try to get more information, I commented the call to
do_suspend_lowlevel in drivers/acpi/sleep/main.c and used
CONFIG_DISABLE_CONSOLE_SUSPEND. Interestingly, the suspend/resume cycle
completes correctly in this mode.

Fred.

