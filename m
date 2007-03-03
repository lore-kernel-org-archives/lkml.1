Return-Path: <linux-kernel-owner+w=401wt.eu-S1030637AbXCCPrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030637AbXCCPrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 10:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030665AbXCCPrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 10:47:24 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:33122 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030637AbXCCPrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 10:47:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OnfDD2BkEDDJ7vfFC8FLbJskLmpyCILjFx+j2n/75WdMTAH0gKKeRKNTFTCwC9fuFOdJQiWdGtvRxwQtyxJx89WAfiZatAAHhlgWD+0+RimwU0lkw/xHnpQ9oJulEzFfybdJ9VWp893ttfg5bDCaxKjXlGdxVi/Lh7OWkDoFvlM=
Message-ID: <4dfa50520703030747g3c887f5bxe25caefd1723c635@mail.gmail.com>
Date: Sat, 3 Mar 2007 08:47:21 -0700
From: "David Hubbard" <david.c.hubbard@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>, "Pavel Machek" <pavel@ucw.cz>,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
       linux-acpi@vger.kernel.org, "Chuck Ebbert" <cebbert@redhat.com>,
       Rudolf@atrpms.net
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
In-Reply-To: <20070303105316.d51e032d.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45D6DDCE.5050803@assembler.cz> <20070228213803.GA4877@ucw.cz>
	 <20070301152655.f232db64.khali@linux-fr.org>
	 <20070302114023.GD2163@elf.ucw.cz>
	 <20070302114747.GB1212@srcf.ucam.org>
	 <20070302151055.d2665d66.khali@linux-fr.org>
	 <20070302141840.GA3441@srcf.ucam.org>
	 <20070302220454.a0c66d04.khali@linux-fr.org>
	 <20070302211251.GA10035@srcf.ucam.org>
	 <20070303105316.d51e032d.khali@linux-fr.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> Is there anything preventing us from doing such a walk and pre-allocate
> all the I/O ranges? I am not familiar with the ACPI code at all, would
> you possibly propose a patch doing that?

Here's a random idea -- what do you think of it?

ACPI already allocates some I/O ranges, which was a surprise to me:

> My machine looks like this:
>
> 1000-107f : 0000:00:1f.0
>  1000-1003 : ACPI PM1a_EVT_BLK
>  1004-1005 : ACPI PM1a_CNT_BLK
>  1008-100b : ACPI PM_TMR
>  1010-1015 : ACPI CPU throttle
>  1020-1020 : ACPI PM2_CNT_BLK
>  1028-102b : ACPI GPE0_BLK
>  102c-102f : ACPI GPE1_BLK

For I/O and memory that ACPI accesses and has not reserved, the AML
interpreter could allocate at run-time.

I'm not sure how to implement exactly. For example, it would be bad to
have a /proc/ioports that had a lot of single ports allocated, for
example:
1000-107f : 0000:00:1f.0
 1000-1000 : ACPI PM1a_EVT_BLK
 1001-1001 : ACPI PM1a_EVT_BLK
 1002-1002 : ACPI PM1a_EVT_BLK
 1003-1003 : ACPI PM1a_EVT_BLK

Thus the AML interpreter would need to have some reasonable
intelligence when allocating regions. Conflict resolution would also
be more difficult, e.g. if a hwmon driver was loaded first and then
acpi as a module, ACPI could not allocate the region. Maybe run-time
allocating won't work.

And then, how would ACPI release a region after it has used it? The
easiest method would be to never release anything used even once.

Thoughts?

David
