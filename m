Return-Path: <linux-kernel-owner+w=401wt.eu-S1762450AbYJKSjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762450AbYJKSjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 14:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbYJKSjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 14:39:06 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:57260 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752317AbYJKSjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 14:39:04 -0400
Message-ID: <48F0F2C6.6030000@suse.de>
Date: Sat, 11 Oct 2008 22:39:02 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: acpi-test tree on eeepc: EC error message on second resume
References: <48F0DB0C.7060201@tuffmail.co.uk> <200810111909.48897.rjw@sisk.pl> <48F0DE8C.6040309@tuffmail.co.uk> <200810111953.04610.rjw@sisk.pl> <48F0ED3A.9010001@tuffmail.co.uk>
In-Reply-To: <48F0ED3A.9010001@tuffmail.co.uk>
Content-Type: multipart/mixed;
 boundary="------------090706040509040101030907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090706040509040101030907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Alan Jenkins wrote:
> I think I found the problem.  The "input buffer empty" wait depends on
> "interrupt mode" to work properly, and we don't immediately enable the
> interrupt on resume.  The wait should have a polling fallback anyway, to
> be consistent with the other transaction waits.
> 
> Alan
Yep, I think something like attached patch may help:

Thanks,
Alex.

--------------090706040509040101030907
Content-Type: text/x-diff;
 name="2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.patch"

ACPI: EC: Check for IBF=0 once again after timeout

From: Alexey Starikovskiy <astarikovskiy@suse.de>

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---
 drivers/acpi/ec.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 69f5f78..f2902c1 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -318,7 +318,8 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t,
 		}
 	}
 	if (!wait_event_timeout(ec->wait, ec_check_ibf0(ec),
-				msecs_to_jiffies(ACPI_EC_DELAY))) {
+				msecs_to_jiffies(ACPI_EC_DELAY)) &&
+	    !ec_check_ibf0(ec)) {
 		pr_err(PREFIX "input buffer is not empty, "
 				"aborting transaction\n");
 		status = -ETIME;

--------------090706040509040101030907--
