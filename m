Return-Path: <linux-kernel-owner+w=401wt.eu-S938743AbXHMWLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938743AbXHMWLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 18:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761423AbXHMWLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 18:11:12 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:53905 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752922AbXHMWLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 18:11:10 -0400
Message-ID: <46C0D6DB.7090703@suse.de>
Date: Tue, 14 Aug 2007 02:10:35 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Sergey Dolgov <solkaa@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       Len Brown <len.brown@intel.com>, Norbert Preining <preining@logic.at>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Henrique de Moraes Holshuh <hmh@hmh.eng.br>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3 regression and bisection query
References: <Pine.LNX.4.64.0708131905280.13982@blonde.wat.veritas.com> <20070813212204.GA2645@slk.laptop>
In-Reply-To: <20070813212204.GA2645@slk.laptop>
Content-Type: multipart/mixed;
 boundary="------------040807020604090304020908"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040807020604090304020908
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Sergey Dolgov wrote:
> On Mon, Aug 13, 2007 at 07:44:48PM +0100, Hugh Dickins wrote:
>
>   
>> Git bisection (with manual fixups to i386 mmiocfg horror, thanks
>> for drawing attention to that in your changelog) accuses Alexey's
>> ACPI: EC: If ECDT is not found, look up EC in DSDT
>> cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b
>> and if I revert that along with Len's subsequent
>> ACPI: EC: fix build warning
>> 52fe4bdf40bc07498c5f7935551774e8f8458190
>> then I have Fn-F4 suspending to RAM again.
>>
>>     
>
> I've also noticed a regression since -rc2 in battery status reporting
> on my HP nx7300 laptop: the output of
>
>     cat /proc/acpi/battery/C1BE/state
>
> does not change after this file has been read for the the first time;
> for exaple, the line "charging state: charged" does not change to
> "charging state: discharging" upon unplugging the power cord.
>
> Reverting the above 2 commits fixes this issue for me.
>
> --
> Sergey
>   
Function to register query methods (means by which EC talks to ACPI)
was deleted by mistake.

Could you please try the attached patch?

Sorry for all the trouble, and thanks for bisect.
Alex.

--------------040807020604090304020908
Content-Type: text/plain;
 name="acpi-ec-fix-regression"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="acpi-ec-fix-regression"

ACPI: EC: Fix regression

From: Alexey Starikovskiy <astarikivskiy@suse.de>

Undelete call to register query methods. 

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 drivers/acpi/ec.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 2300d81..56bee9e 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -652,6 +652,19 @@ static struct acpi_ec *make_acpi_ec(void)
 }
 
 static acpi_status
+acpi_ec_register_query_methods(acpi_handle handle, u32 level,
+			       void *context, void **return_value)
+{
+	struct acpi_namespace_node *node = handle;
+	struct acpi_ec *ec = context;
+	int value = 0;
+	if (sscanf(node->name.ascii, "_Q%x", &value) == 1) {
+		acpi_ec_add_query_handler(ec, value, handle, NULL, NULL);
+	}
+	return AE_OK;
+}
+
+static acpi_status
 ec_parse_device(acpi_handle handle, u32 Level, void *context, void **retval)
 {
 	acpi_status status;
@@ -668,6 +681,10 @@ ec_parse_device(acpi_handle handle, u32 Level, void *context, void **retval)
 	if (ACPI_FAILURE(status))
 		return status;
 
+	/* Find and register all query methods */
+	acpi_walk_namespace(ACPI_TYPE_METHOD, handle, 1,
+			    acpi_ec_register_query_methods, ec, NULL);
+
 	/* Use the global lock for all EC transactions? */
 	acpi_evaluate_integer(handle, "_GLK", NULL, &ec->global_lock);
 

--------------040807020604090304020908--
