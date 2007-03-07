Return-Path: <linux-kernel-owner+w=401wt.eu-S1422747AbXCGRJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422747AbXCGRJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422746AbXCGRJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:09:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:64096 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422745AbXCGRJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:09:29 -0500
Date: Wed, 7 Mar 2007 18:09:09 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Jean Delvare <khali@linux-fr.org>
cc: Bodo Eggert <7eggert@gmx.de>, David Hubbard <david.c.hubbard@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
       linux-acpi@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf@atrpms.net
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
In-Reply-To: <20070307101758.8cf2c53d.khali@linux-fr.org>
Message-ID: <Pine.LNX.4.58.0703071806340.2556@be1.lrz>
References: <7PvLN-1cj-3@gated-at.bofh.it> <7TEGV-6Jy-39@gated-at.bofh.it>
 <7TUBX-6TN-5@gated-at.bofh.it> <7UeqX-4QO-17@gated-at.bofh.it>
 <7UeqZ-4QO-27@gated-at.bofh.it> <7UgM5-np-1@gated-at.bofh.it>
 <7UgM8-np-11@gated-at.bofh.it> <7UnaS-2xP-9@gated-at.bofh.it>
 <7UnkC-2JB-9@gated-at.bofh.it> <7Uzcd-49u-3@gated-at.bofh.it>
 <7UEEN-4xi-3@gated-at.bofh.it> <E1HODgC-0000h8-Vc@be1.lrz>
 <20070306161935.025a3ec1.khali@linux-fr.org> <Pine.LNX.4.58.0703061804360.2988@be1.lrz>
 <20070307101758.8cf2c53d.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX18tnCFFUbvd3/CcP7Ytngi9Lp4hMEgRP75T/M1
 GwUnlqDRcGUfZFyk0Ua7k7yTSI46iZfaeIEa1ae/bnKb1Nm9l2
 Hwnj76tI/mXlWN65WaRIA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007, Jean Delvare wrote:
> On Tue, 6 Mar 2007 21:40:19 +0100 (CET), Bodo Eggert wrote:

> > 1) I asume port allocations or ACPI foreign port acces to be rare, so
> >    there would be little impact on (un)registering hardware. Off cause
> >    there are some long ACPI calls (like reading the battery?), in these
> >    cases it might be beneficial to release the global allocation lock
> >    after gaining exclusive access to the driver's port range. (This can
> >    only be done if the device driver is loaded.)
> 
> The problem is that the rarity of ACPI foreign port access doesn't
> matter much, as you have to do all the tests first to find out that it
> was a foreign port, and I suspect that these tests will cost more than
> taking the lock itself.

Testing for the internal ranges can be done by searching a list of about
five ranges, that should be not much slower than taking an uncontended
lock, and very much faster than waiting for smbus to finish it's current
task in case the lock is contended. I'm more concerned about driver
(un)loading being slowed down by ACPI.

[...]
> We may be able to workaround the inter-driver exclusion though, if we
> use a semaphore initialized to N, have ACPI take N, but other drivers
> take just one. This would let ACPI be exclusive with all the other
> drivers, but drivers themselves could otherwise run concurrently. That
> being said, we do not appear to have the required primitives to take
> more than 1 semaphore resource at once at the moment, so we'd need to
> do that first.

worst case I can imagine: IDE/graphic stalles while ACPI takes a second to
read the battery state.

-- 
Top 100 things you don't want the sysadmin to say:
82. Where's the DIR command?
