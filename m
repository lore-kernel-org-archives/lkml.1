Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbYGQSzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbYGQSzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757468AbYGQSy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:54:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:20540 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758691AbYGQSy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:54:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=tKeRT+5f3zjFkpje/ZxWI9IWI1MorXO6S9mINRHgO+I7qILpCEi+iFmPAANk7Vsf0T
         2YXL9FGBHMGsz2fOmCoQm8qz/LucbFKHzyFw1e3UsivLN1TnVjrjarNyXfcHBp75Qh5z
         0e+rWDgdU6PXuB6kgUC8dx2vtRy8kCiUttTuk=
Message-ID: <487F9592.1060003@tuffmail.co.uk>
Date: Thu, 17 Jul 2008 19:55:14 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] acpi: Avoid dropping rapid hotkey events (or other GPEs)
 on Asus EeePC
References: <487D23C3.5070301@student.cs.york.ac.uk> <487F58B6.5040309@suse.de> <487F6D2E.2040501@tuffmail.co.uk> <487F772C.1070806@suse.de>
In-Reply-To: <487F772C.1070806@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Starikovskiy wrote:
> Alan Jenkins wrote:
>> Alexey Starikovskiy wrote:
>>> Hi Alan,
>>>
>>> Could you please test if your patch works with the last patch in
>>> #10919?
>>>
>>> Thanks,
>>> Alex.
>> Vacuously so.
>>
>> My patch still applies, but #10919 makes it obsolete.
> Not so, there are two polls in ec.c, first is poll for change in
> status register,
> which gave the name to the mode, and still exists; the other is for event
> in embedded controller, which was introduced to properly solve #9998,
> and part of
> it is removed by patch in #10919.
>>  My patch fixed a
>> bug that shows up in polling mode.  #10919 kills polling mode.
>
>>
>> I've tested v2.6.26 + #10919 and it works fine (except for spamming the
>> kernel log - please read my Bugzilla comment).
>>
>>
>> It appears that interrupt mode suffered from a race which is very
>> similar to my original problem.  If two GPE interrupts arrive before the
>> workqueue runs, then the second interrupt will be ignored because
>> EC_FLAGS_QUERY_PENDING is still set.  This will happen with any EC if
>> interrupts are very close together, right?
> The notion of queue in embedded controller is new, it was never
> mentioned in
> ACPI spec, so the driver was written with assumption that new query
> interrupt should
> not arrive before we service previous one. There is even a chart in
> how interrupts
> should occur near the EC query command...
>>
>> I think my patch also fixes this theoretical problem.
> I think, this is not a theoretical problem, but the problem we've
> tried to solve in
> #9998, #10724, and so on.
>> But I'd rather
>> you took over on this.  I was already confused by ec.c in v2.6.26, and
>> with #10919 I understand it even less.  E.g. why is
>> ec_switch_to_poll_mode() still present; what does it do now do_ec_poll()
>> is removed?
> See above, I still disable EC GPE for the time than we have pending
> query,
> so we better not wait for it to check the status register
>>
>> I'm happy to work on this with you, but I'd need to be able understand
>> the code first :-(.
> Well, with this patch of yours, I guess, we will not have too many
> problems in EC left :-)

OK, I'm happy now.

However, I'm now worried that I broke the semantics for
EC_FLAGS_QUERY_PENDING.  In my patch it gets cleared after the first
query, even though I'm running queries in a loop until nothing is left. 
It doesn't cause a problem in my patch, but it's unclean and might cause
confusion later on.  It'd be better to clear it after the loop has
completed.

Can I fix my patch?  If you ACK the new code below, then I'll resend
with a proper changelog, S-o-B, CC's from the -mm mail (including
stable@kernel.org) and grovel to akpm, etc.

You're latest (quieter) work still applies on top and works fine.

Thanks
Alan

---

From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Tested-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 5622aee..2a42392 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -230,8 +230,7 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec, u8 command,
 			       "finish-write timeout, command = %d\n", command);
 			goto end;
 		}
-	} else if (command == ACPI_EC_COMMAND_QUERY)
-		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
+	}
 
 	for (; rdata_len > 0; --rdata_len) {
 		result = acpi_ec_wait(ec, ACPI_EC_EVENT_OBF_1, force_poll);
@@ -459,14 +458,10 @@ void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit)
 
 EXPORT_SYMBOL_GPL(acpi_ec_remove_query_handler);
 
-static void acpi_ec_gpe_query(void *ec_cxt)
+static void acpi_ec_gpe_run_handler(struct acpi_ec *ec, u8 value)
 {
-	struct acpi_ec *ec = ec_cxt;
-	u8 value = 0;
 	struct acpi_ec_query_handler *handler, copy;
 
-	if (!ec || acpi_ec_query(ec, &value))
-		return;
 	mutex_lock(&ec->lock);
 	list_for_each_entry(handler, &ec->list, node) {
 		if (value == handler->query_bit) {
@@ -484,6 +479,20 @@ static void acpi_ec_gpe_query(void *ec_cxt)
 	mutex_unlock(&ec->lock);
 }
 
+static void acpi_ec_gpe_query(void *ec_cxt)
+{
+	struct acpi_ec *ec = ec_cxt;
+	u8 value = 0;
+
+	if (!ec)
+		return;
+
+	while (acpi_ec_query(ec, &value) != 0)
+		acpi_ec_gpe_run_handler(ec, value);
+
+	clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
+}
+
 static u32 acpi_ec_gpe_handler(void *data)
 {
 	acpi_status status = AE_OK;



