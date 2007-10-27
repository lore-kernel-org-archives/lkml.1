Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbXJ0NqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbXJ0NqX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 09:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbXJ0NqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 09:46:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:30819 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbXJ0NqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 09:46:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=U0LnI96JRyXPvKaVWKyVQ4eTjCJMzexcN7oL0KUpLtXg4bSulqnOEyQ//pynIzv85/RwMri/JW5gr2w+d6jCRQ494DiXlaWjGgQBhwhCjTvo0AEpFh8dMZtErPU6eLB1DYMvFAm47Xc5djtihI2c+SMg08c+17RB95LRzg7yB44=
Message-ID: <4723410E.1010208@gmail.com>
Date: Sat, 27 Oct 2007 17:45:50 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frans Pop <elendil@planet.nl>
Subject: Re: [2.624-rc1 regression] lost battery information
References: <200710262024.06012.arvidjaar@mail.ru> <200710262215.42939.arvidjaar@mail.ru> <472232D3.6000807@gmail.com> <200710271122.49344.arvidjaar@mail.ru>
In-Reply-To: <200710271122.49344.arvidjaar@mail.ru>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------050600080705020706060800"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050600080705020706060800
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andrey,
Please try the attached patch. I choose to do snprintf() instead of direct copy,
as your previous message showed empty OEM type.

Thanks,
Alex.
Andrey Borzenkov wrote:
> On Friday 26 October 2007, Alexey Starikovskiy wrote:
>> Your cat's "Bad address" means -EFAULT, according to "man errno".
>> Please apply this patch to see what exactly failed...
> 
> 
> 
> [ 1191.471572] ACPI: element[12]->type = 1, expected string
> [ 1196.640065] ACPI: element[12]->type = 1, expected string
> [ 1199.479773] ACPI: element[12]->type = 1, expected string
> [ 1199.745435] ACPI: element[12]->type = 1, expected string
> 
> it is "OEM type". For reference here is _BIF from my DSDT:
> 
>              Method (_BIF, 0, NotSerialized)
>             {
>                 Name (BUFF, Package (0x0D) {})
>                 Store (0x00, Index (BUFF, 0x00))
>                 Store (\_SB.MEM.BDV2, Local2)
>                 Multiply (\_SB.MEM.BDC2, Local2, Local0)
>                 Divide (Local0, 0x03E8, Local1, Local0)
>                 Store (Local0, Index (BUFF, 0x01))
>                 Multiply (\_SB.MEM.BLF2, Local2, Local0)
>                 Divide (Local0, 0x03E8, Local1, Local0)
>                 Store (Local0, Index (BUFF, 0x02))
>                 Store (\_SB.MEM.BTC2, Index (BUFF, 0x03))
>                 Store (\_SB.MEM.BDV2, Index (BUFF, 0x04))
>                 Multiply (\_SB.MEM.BCW2, Local2, Local0)
>                 Divide (Local0, 0x03E8, Local1, Local0)
>                 Store (Local0, Index (BUFF, 0x05))
>                 Multiply (\_SB.MEM.BCL2, Local2, Local0)
>                 Divide (Local0, 0x03E8, Local1, Local0)
>                 Store (Local0, Index (BUFF, 0x06))
>                 Multiply (\_SB.MEM.BG12, Local2, Local0)
>                 Divide (Local0, 0x03E8, Local1, Local0)
>                 Store (Local0, Index (BUFF, 0x07))
>                 Multiply (\_SB.MEM.BG22, Local2, Local0)
>                 Divide (Local0, 0x03E8, Local1, Local0)
>                 Store (Local0, Index (BUFF, 0x08))
>                 Store (\_SB.MEM.BMN2, Index (BUFF, 0x09))
>                 Store (\_SB.MEM.BSN2, Index (BUFF, 0x0A))
>                 Store (\_SB.MEM.BTP2, Index (BUFF, 0x0B))
>                 Store (\_SB.MEM.BOI2, Index (BUFF, 0x0C))
>                 Return (BUFF)
>             }
> 
> This is behaviour change. Previous battery.c used generic acpi_extract_package 
> which allowed (allows) for object of type integer when string is requested:
> 
>                 case ACPI_TYPE_INTEGER:
>                         switch (format_string[i]) {
>                         case 'N':
>                                 size_required += sizeof(acpi_integer);
>                                 tail_offset += sizeof(acpi_integer);
>                                 break;
>                         case 'S':
>                                 size_required +=
>                                     sizeof(char *) + sizeof(acpi_integer) +
>                                     sizeof(char);
>                                 tail_offset += sizeof(char *);
>                                 break;
> 
> while current battery.c:extract_package fails:
> 
>                 if (offsets[i].mode) {
>                         if (element->type != ACPI_TYPE_STRING &&
>                             element->type != ACPI_TYPE_BUFFER) {
> printk (KERN_ERR PREFIX "element[%d]->type = %x, expected string\n", i, 
> element->type);
>                                 return -EFAULT;
>                         }
> 
> well, while it could be BIOS fault this happily worked before ... This is 
> obviously also the reason why I do not have anything in /sys
> 
> Fans, could you check whether you have the same issue using test patch?


--------------050600080705020706060800
Content-Type: text/x-diff;
 name="battery_allow_extract_string_from_integer.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="battery_allow_extract_string_from_integer.patch"

ACPI: Battery: Allow extract string from integer

From: Alexey Starikovskiy <astarikovskiy@suse.de>

Some machines return integer instead of expected string.

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 drivers/acpi/battery.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 02a396d..6841358 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -260,7 +260,7 @@ static int extract_package(struct acpi_battery *battery,
 			   union acpi_object *package,
 			   struct acpi_offsets *offsets, int num)
 {
-	int i, *x;
+	int i;
 	union acpi_object *element;
 	if (package->type != ACPI_TYPE_PACKAGE)
 		return -EFAULT;
@@ -269,16 +269,20 @@ static int extract_package(struct acpi_battery *battery,
 			return -EFAULT;
 		element = &package->package.elements[i];
 		if (offsets[i].mode) {
-			if (element->type != ACPI_TYPE_STRING &&
-			    element->type != ACPI_TYPE_BUFFER)
-				return -EFAULT;
-			strncpy((u8 *)battery + offsets[i].offset,
-				element->string.pointer, 32);
+			u8 *ptr = (u8 *)battery + offsets[i].offset;
+			if (element->type == ACPI_TYPE_STRING ||
+			    element->type == ACPI_TYPE_BUFFER)
+				strncpy(ptr, element->string.pointer, 32);
+			else if (element->type == ACPI_TYPE_INTEGER) {
+				snprintf(ptr, 32, "%lld",
+					element->integer.value);
+			} else return -EFAULT;
 		} else {
-			if (element->type != ACPI_TYPE_INTEGER)
-				return -EFAULT;
-			x = (int *)((u8 *)battery + offsets[i].offset);
-			*x = element->integer.value;
+			if (element->type == ACPI_TYPE_INTEGER) {
+				int *x = (int *)((u8 *)battery +
+						offsets[i].offset);
+				*x = element->integer.value;
+			} else return -EFAULT;
 		}
 	}
 	return 0;

--------------050600080705020706060800--
