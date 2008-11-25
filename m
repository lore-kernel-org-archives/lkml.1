Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYKYSma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYKYSma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 13:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbYKYSmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 13:42:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:24970 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbYKYSmS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 13:42:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,665,1220252400"; 
   d="scan'208";a="407958765"
From: "Moore, Robert" <robert.moore@intel.com>
To: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>
Date: Tue, 25 Nov 2008 10:41:49 -0800
Subject: RE: acpi_evaluate_integer broken by design
Thread-Topic: acpi_evaluate_integer broken by design
Thread-Index: AclO7XDaLVb4yUkFS0WNgnAc0dL4NAAP/zqQ
Message-ID: <4911F71203A09E4D9981D27F9D8308580DBD2E11@orsmsx503.amr.corp.intel.com>
References: <20081125110508.GA1943@elf.ucw.cz>
In-Reply-To: <20081125110508.GA1943@elf.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree, it should be allocated on the stack, like it is most everywhere else.


>-----Original Message-----
>From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
>owner@vger.kernel.org] On Behalf Of Pavel Machek
>Sent: Tuesday, November 25, 2008 3:05 AM
>To: kernel list; ACPI mailing list; Brown, Len
>Subject: acpi_evaluate_integer broken by design
>
>
>Now I know why I had strange "scheduling in atomic" problems:
>acpi_evaluate_integer() does malloc(..., irqs_disabled() ? GFP_ATOMIC
>: GFP_KERNEL)... which is (of course) broken.
>
>There's no way to reliably tell if we need GFP_ATOMIC or not from
>code, this one for example fails to detect spinlocks held.
>
>Fortunately, allocation seems small enough to be done on stack.
>
>Signed-off-by: Pavel Machek <pavel@suse.cz>
>
>diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
>index e827be3..f844941 100644
>--- a/drivers/acpi/utils.c
>+++ b/drivers/acpi/utils.c
>@@ -259,34 +259,26 @@ acpi_evaluate_integer(acpi_handle handle
> 		      struct acpi_object_list *arguments, unsigned long long
>*data)
> {
> 	acpi_status status = AE_OK;
>-	union acpi_object *element;
>+	union acpi_object element;
> 	struct acpi_buffer buffer = { 0, NULL };
>
>-
> 	if (!data)
> 		return AE_BAD_PARAMETER;
>
>-	element = kzalloc(sizeof(union acpi_object), irqs_disabled() ?
>GFP_ATOMIC: GFP_KERNEL);
>-	if (!element)
>-		return AE_NO_MEMORY;
>-
> 	buffer.length = sizeof(union acpi_object);
>-	buffer.pointer = element;
>+	buffer.pointer = &element;
> 	status = acpi_evaluate_object(handle, pathname, arguments, &buffer);
> 	if (ACPI_FAILURE(status)) {
> 		acpi_util_eval_error(handle, pathname, status);
>-		kfree(element);
> 		return status;
> 	}
>
>-	if (element->type != ACPI_TYPE_INTEGER) {
>+	if (element.type != ACPI_TYPE_INTEGER) {
> 		acpi_util_eval_error(handle, pathname, AE_BAD_DATA);
>-		kfree(element);
> 		return AE_BAD_DATA;
> 	}
>
>-	*data = element->integer.value;
>-	kfree(element);
>+	*data = element.integer.value;
>
> 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Return value [%llu]\n", *data));
>
>
>
>
>--
>(english) http://www.livejournal.com/~pavelmachek
>(cesky, pictures)
>http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>--
>To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
