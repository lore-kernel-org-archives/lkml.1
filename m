Return-Path: <linux-kernel-owner+w=401wt.eu-S1762692AbYJKT0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762692AbYJKT0u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 15:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759597AbYJKT0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 15:26:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59076 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759230AbYJKT0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 15:26:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: acpi-test tree on eeepc: EC error message on second resume
Date: Sat, 11 Oct 2008 21:30:57 +0200
User-Agent: KMail/1.9.9
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux acpi <linux-acpi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <48F0DB0C.7060201@tuffmail.co.uk> <48F0ED3A.9010001@tuffmail.co.uk> <48F0F2C6.6030000@suse.de>
In-Reply-To: <48F0F2C6.6030000@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810112130.57757.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 11 of October 2008, Alexey Starikovskiy wrote:
> Alan Jenkins wrote:
> > I think I found the problem.  The "input buffer empty" wait depends on
> > "interrupt mode" to work properly, and we don't immediately enable the
> > interrupt on resume.  The wait should have a polling fallback anyway, to
> > be consistent with the other transaction waits.
> > 
> > Alan
> Yep, I think something like attached patch may help:

[Can you please append patches instead of or apart from attaching them?
That would make it easier to comment them.]

if (!wait_event_timeout(ec->wait, ec_check_ibf0(ec),
-                               msecs_to_jiffies(ACPI_EC_DELAY))) {
+                               msecs_to_jiffies(ACPI_EC_DELAY)) &&
+           !ec_check_ibf0(ec)) {

Shouldn't this go under the spinlock?  Surely it can race with the GPE handler.

                pr_err(PREFIX "input buffer is not empty, "
                                "aborting transaction\n");

Thanks,
Rafael
