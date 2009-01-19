Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbZASDLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbZASDLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 22:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757636AbZASDLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 22:11:42 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55956 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538AbZASDLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 22:11:40 -0500
Message-ID: <4973EF64.2050404@jp.fujitsu.com>
Date: Mon, 19 Jan 2009 12:11:32 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       "Barnes, Jesse" <jesse.barnes@intel.com>, shaohua.li@intel.com
Subject: Re: ACPI hotplug panic with current git head
References: <1231604250.3642.33.camel@localhost.localdomain>	 <alpine.LFD.2.00.0901121604380.5859@localhost.localdomain>	 <1231807693.27151.21.camel@localhost.localdomain>	 <1232046108.5966.57.camel@localhost.localdomain>	 <alpine.LFD.2.00.0901151421110.4737@localhost.localdomain>	 <1232049269.5966.64.camel@localhost.localdomain>	 <1232050347.5966.66.camel@localhost.localdomain>	 <4970242C.4010404@jp.fujitsu.com>	 <1232115546.3224.5.camel@localhost.localdomain>	 <4973D2EE.3060203@jp.fujitsu.com> <1232328216.3247.68.camel@localhost.localdomain>
In-Reply-To: <1232328216.3247.68.camel@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------060904000901020406040300"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060904000901020406040300
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

James Bottomley wrote:
> On Mon, 2009-01-19 at 10:10 +0900, Kenji Kaneshige wrote:
>> James Bottomley wrote:
>>> On Fri, 2009-01-16 at 15:07 +0900, Kenji Kaneshige wrote:
>>>>> It looks like acpi_pci_get_bridge_handle() is returning NULL, so this is
>>>>> the fix that works for me.
>>>>>
>>>> I'm sorry for troubling you, and thank you for your patience.
>>>>
>>>> The patch seems to avoid the kernel panic, but I still don't know
>>>> why acpi_pci_get_bridge_handle() returns NULL here. I assumed
>>>> it should return non-NULL value here. So I'd like to investigate
>>>> it more.
>>> Sure, Len and I couldn't work out why it was returning NULL on this box
>>> (other than that perhaps it doesn't have an ACPI entry).  The two
>>> offending busses which trigger this are the two internal ones (which
>>> aren't hotplug).  The layout of the box is:
>>>
>>> sparkweed:~# lspci -t
>>> -+-[0000:0c]---00.0
>>>  +-[0000:0a]---00.0
>>>  +-[0000:08]---00.0
>>>  +-[0000:06]---00.0
>>>  +-[0000:04]---00.0
>>>  +-[0000:02]---00.0
>>>  +-[0000:01]-+-00.0
>>>  |           +-01.0
>>>  |           +-01.1
>>>  |           \-02.0
>>>  \-[0000:00]-+-00.0
>>>              +-01.0
>>>              +-03.0
>>>              +-03.1
>>>              +-03.2
>>>              +-0f.0
>>>              +-0f.1
>>>              \-0f.3
>>> sparkweed:~# lspci   
>>> 00:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 02)
>>> 00:01.0 VGA compatible controller: ATI Technologies Inc Radeon RV100 QY
>>> [Radeon 7000/VE]
>>> 00:03.0 USB Controller: NEC Corporation USB (rev 43)
>>> 00:03.1 USB Controller: NEC Corporation USB (rev 43)
>>> 00:03.2 USB Controller: NEC Corporation USB 2.0 (rev 04)
>>> 00:0f.0 Host bridge: Broadcom CSB6 South Bridge (rev a0)
>>> 00:0f.1 IDE interface: Broadcom CSB6 RAID/IDE Controller (rev a0)
>>> 00:0f.3 ISA bridge: Broadcom GCLE-2 Host Bridge
>>> 01:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 02)
>>> 01:01.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5704
>>> Gigabit Ethernet (rev 10)
>>> 01:01.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5704
>>> Gigabit Ethernet (rev 10)
>>> 01:02.0 SCSI storage controller: Adaptec AIC-9410W SAS (Razor ASIC
>>> non-RAID) (rev 08)
>>> 02:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 02)
>>> 04:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 02)
>>> 06:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 02)
>>> 08:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 02)
>>> 0a:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 02)
>>> 0c:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 02)
>>>
>>> And when I annotate the problem, the two busses returning NULL are
>>> 0000:00 and 0000:01
>>>
>> Thank you very much for the information. It seems there are
>> something special in the data structure of host bridge for
>> 0000:00 and 0000:01.
> 
> Yes, len speculates the non hotplug buses are missing some acpi entries.
> 
>> I'm making a debug patch now and will send it to you as soon
>> as possible. I'm sorry to trouble you, but could you try it
>> later.
> 
> Sure ... I'm travelling this week, but the machine is usually remotely
> accessible.
> 

I appreciate your kindness.

I'm sending the debug patch against 2.6.29-rc1 below. I'm also
sending it as an attachment. It also contains the code to prevent
the kernel panic from you. Please note that you will see two
WARN_ON(1) messages with the patch. Those are shown by my debug
patch.

Could you try it and send me the whole dmsg output?

Thanks,
Kenji Kaneshige

 drivers/pci/hotplug/acpiphp_glue.c |   18 ++++++++++++++++++
 include/linux/pci-acpi.h           |   25 ++++++++++++++++++++++---
 2 files changed, 40 insertions(+), 3 deletions(-)

Index: linux-2.6.29-rc1/include/linux/pci-acpi.h
===================================================================
--- linux-2.6.29-rc1.orig/include/linux/pci-acpi.h	2008-12-01 22:59:52.000000000 +0900
+++ linux-2.6.29-rc1/include/linux/pci-acpi.h	2009-01-19 10:27:13.000000000 +0900
@@ -65,9 +65,28 @@
 {
 	int seg = pci_domain_nr(pbus), busnr = pbus->number;
 	struct pci_dev *bridge = pbus->self;
-	if (bridge)
-		return DEVICE_ACPI_HANDLE(&(bridge->dev));
-	return acpi_get_pci_rootbridge_handle(seg, busnr);
+	acpi_handle handle;
+	char objname[64] = "<NULL>";
+	struct acpi_buffer buffer = { .length = sizeof(objname),
+				      .pointer = objname };
+
+	printk(KERN_INFO "%s: bridge(pbus->self) = %p, pbus->parent = %p\n",
+	       __func__, bridge, pbus->parent);
+
+	if (bridge) {
+		printk(KERN_INFO "%s: handle the bridge as PtoP.\n", __func__);
+		handle = DEVICE_ACPI_HANDLE(&(bridge->dev));
+	} else {
+		printk(KERN_INFO "%s: handle the bridge as root.\n", __func__);
+		handle = acpi_get_pci_rootbridge_handle(seg, busnr);
+	}
+
+	if (handle)
+		acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
+	printk(KERN_INFO "%s: ACPI handle of the bridge for %04x:%02x: %p %s\n",
+	       __func__, seg, busnr, handle, objname);
+
+	return handle;
 }
 #else
 #if !defined(AE_ERROR)
Index: linux-2.6.29-rc1/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-2.6.29-rc1.orig/drivers/pci/hotplug/acpiphp_glue.c	2008-12-01 22:59:46.000000000 +0900
+++ linux-2.6.29-rc1/drivers/pci/hotplug/acpiphp_glue.c	2009-01-19 10:32:05.000000000 +0900
@@ -266,6 +266,12 @@
 	int found = acpi_pci_detect_ejectable(pbus);
 	if (!found) {
 		acpi_handle bridge_handle = acpi_pci_get_bridge_handle(pbus);
+		if (!bridge_handle) {
+			printk(KERN_INFO
+			       "%s: NULL handle returned!!!\n", __func__);
+			WARN_ON(1);
+			return 0;
+		}
 		acpi_walk_namespace(ACPI_TYPE_DEVICE, bridge_handle, (u32)1,
 				    is_pci_dock_device, (void *)&found, NULL);
 	}
@@ -459,6 +465,9 @@
 	int device, function;
 	struct pci_dev *dev;
 	struct pci_bus *pci_bus = context;
+	char objname[64];
+	struct acpi_buffer buffer = { .length = sizeof(objname),
+				      .pointer = objname };
 
 	status = acpi_get_handle(handle, "_ADR", &dummy_handle);
 	if (ACPI_FAILURE(status))
@@ -478,6 +487,9 @@
 	if (!dev || !dev->subordinate)
 		goto out;
 
+	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
+	printk(KERN_INFO "%s: Detecting slots under PtoP bridge (%s)\n",
+	       __func__, objname);
 	/* check if this bridge has ejectable slots */
 	if ((detect_ejectable_slots(dev->subordinate) > 0)) {
 		dbg("found PCI-to-PCI bridge at PCI %s\n", pci_name(dev));
@@ -504,6 +516,9 @@
 	int seg, bus;
 	acpi_handle dummy_handle;
 	struct pci_bus *pci_bus;
+	char objname[64];
+	struct acpi_buffer buffer = { .length = sizeof(objname),
+				      .pointer = objname };
 
 	/* if the bridge doesn't have _STA, we assume it is always there */
 	status = acpi_get_handle(handle, "_STA", &dummy_handle);
@@ -539,6 +554,9 @@
 		return 0;
 	}
 
+	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
+	printk(KERN_INFO "%s: Detecting slots under root bridge (%s)\n",
+	       __func__, objname);
 	/* check if this bridge has ejectable slots */
 	if (detect_ejectable_slots(pci_bus) > 0) {
 		dbg("found PCI host-bus bridge with hot-pluggable slots\n");


--------------060904000901020406040300
Content-Type: text/plain;
 name="debug.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="debug.patch"

IGRyaXZlcnMvcGNpL2hvdHBsdWcvYWNwaXBocF9nbHVlLmMgfCAgIDE4ICsrKysrKysrKysr
KysrKysrKwogaW5jbHVkZS9saW51eC9wY2ktYWNwaS5oICAgICAgICAgICB8ICAgMjUgKysr
KysrKysrKysrKysrKysrKysrKy0tLQogMiBmaWxlcyBjaGFuZ2VkLCA0MCBpbnNlcnRpb25z
KCspLCAzIGRlbGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4LTIuNi4yOS1yYzEvaW5jbHVkZS9s
aW51eC9wY2ktYWNwaS5oCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi4yOS1yYzEub3Jp
Zy9pbmNsdWRlL2xpbnV4L3BjaS1hY3BpLmgJMjAwOC0xMi0wMSAyMjo1OTo1Mi4wMDAwMDAw
MDAgKzA5MDAKKysrIGxpbnV4LTIuNi4yOS1yYzEvaW5jbHVkZS9saW51eC9wY2ktYWNwaS5o
CTIwMDktMDEtMTkgMTA6Mjc6MTMuMDAwMDAwMDAwICswOTAwCkBAIC02NSw5ICs2NSwyOCBA
QAogewogCWludCBzZWcgPSBwY2lfZG9tYWluX25yKHBidXMpLCBidXNuciA9IHBidXMtPm51
bWJlcjsKIAlzdHJ1Y3QgcGNpX2RldiAqYnJpZGdlID0gcGJ1cy0+c2VsZjsKLQlpZiAoYnJp
ZGdlKQotCQlyZXR1cm4gREVWSUNFX0FDUElfSEFORExFKCYoYnJpZGdlLT5kZXYpKTsKLQly
ZXR1cm4gYWNwaV9nZXRfcGNpX3Jvb3RicmlkZ2VfaGFuZGxlKHNlZywgYnVzbnIpOworCWFj
cGlfaGFuZGxlIGhhbmRsZTsKKwljaGFyIG9iam5hbWVbNjRdID0gIjxOVUxMPiI7CisJc3Ry
dWN0IGFjcGlfYnVmZmVyIGJ1ZmZlciA9IHsgLmxlbmd0aCA9IHNpemVvZihvYmpuYW1lKSwK
KwkJCQkgICAgICAucG9pbnRlciA9IG9iam5hbWUgfTsKKworCXByaW50ayhLRVJOX0lORk8g
IiVzOiBicmlkZ2UocGJ1cy0+c2VsZikgPSAlcCwgcGJ1cy0+cGFyZW50ID0gJXBcbiIsCisJ
ICAgICAgIF9fZnVuY19fLCBicmlkZ2UsIHBidXMtPnBhcmVudCk7CisKKwlpZiAoYnJpZGdl
KSB7CisJCXByaW50ayhLRVJOX0lORk8gIiVzOiBoYW5kbGUgdGhlIGJyaWRnZSBhcyBQdG9Q
LlxuIiwgX19mdW5jX18pOworCQloYW5kbGUgPSBERVZJQ0VfQUNQSV9IQU5ETEUoJihicmlk
Z2UtPmRldikpOworCX0gZWxzZSB7CisJCXByaW50ayhLRVJOX0lORk8gIiVzOiBoYW5kbGUg
dGhlIGJyaWRnZSBhcyByb290LlxuIiwgX19mdW5jX18pOworCQloYW5kbGUgPSBhY3BpX2dl
dF9wY2lfcm9vdGJyaWRnZV9oYW5kbGUoc2VnLCBidXNucik7CisJfQorCisJaWYgKGhhbmRs
ZSkKKwkJYWNwaV9nZXRfbmFtZShoYW5kbGUsIEFDUElfRlVMTF9QQVRITkFNRSwgJmJ1ZmZl
cik7CisJcHJpbnRrKEtFUk5fSU5GTyAiJXM6IEFDUEkgaGFuZGxlIG9mIHRoZSBicmlkZ2Ug
Zm9yICUwNHg6JTAyeDogJXAgJXNcbiIsCisJICAgICAgIF9fZnVuY19fLCBzZWcsIGJ1c25y
LCBoYW5kbGUsIG9iam5hbWUpOworCisJcmV0dXJuIGhhbmRsZTsKIH0KICNlbHNlCiAjaWYg
IWRlZmluZWQoQUVfRVJST1IpCkluZGV4OiBsaW51eC0yLjYuMjktcmMxL2RyaXZlcnMvcGNp
L2hvdHBsdWcvYWNwaXBocF9nbHVlLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42LjI5
LXJjMS5vcmlnL2RyaXZlcnMvcGNpL2hvdHBsdWcvYWNwaXBocF9nbHVlLmMJMjAwOC0xMi0w
MSAyMjo1OTo0Ni4wMDAwMDAwMDAgKzA5MDAKKysrIGxpbnV4LTIuNi4yOS1yYzEvZHJpdmVy
cy9wY2kvaG90cGx1Zy9hY3BpcGhwX2dsdWUuYwkyMDA5LTAxLTE5IDEwOjMyOjA1LjAwMDAw
MDAwMCArMDkwMApAQCAtMjY2LDYgKzI2NiwxMiBAQAogCWludCBmb3VuZCA9IGFjcGlfcGNp
X2RldGVjdF9lamVjdGFibGUocGJ1cyk7CiAJaWYgKCFmb3VuZCkgewogCQlhY3BpX2hhbmRs
ZSBicmlkZ2VfaGFuZGxlID0gYWNwaV9wY2lfZ2V0X2JyaWRnZV9oYW5kbGUocGJ1cyk7CisJ
CWlmICghYnJpZGdlX2hhbmRsZSkgeworCQkJcHJpbnRrKEtFUk5fSU5GTworCQkJICAgICAg
ICIlczogTlVMTCBoYW5kbGUgcmV0dXJuZWQhISFcbiIsIF9fZnVuY19fKTsKKwkJCVdBUk5f
T04oMSk7CisJCQlyZXR1cm4gMDsKKwkJfQogCQlhY3BpX3dhbGtfbmFtZXNwYWNlKEFDUElf
VFlQRV9ERVZJQ0UsIGJyaWRnZV9oYW5kbGUsICh1MzIpMSwKIAkJCQkgICAgaXNfcGNpX2Rv
Y2tfZGV2aWNlLCAodm9pZCAqKSZmb3VuZCwgTlVMTCk7CiAJfQpAQCAtNDU5LDYgKzQ2NSw5
IEBACiAJaW50IGRldmljZSwgZnVuY3Rpb247CiAJc3RydWN0IHBjaV9kZXYgKmRldjsKIAlz
dHJ1Y3QgcGNpX2J1cyAqcGNpX2J1cyA9IGNvbnRleHQ7CisJY2hhciBvYmpuYW1lWzY0XTsK
KwlzdHJ1Y3QgYWNwaV9idWZmZXIgYnVmZmVyID0geyAubGVuZ3RoID0gc2l6ZW9mKG9iam5h
bWUpLAorCQkJCSAgICAgIC5wb2ludGVyID0gb2JqbmFtZSB9OwogCiAJc3RhdHVzID0gYWNw
aV9nZXRfaGFuZGxlKGhhbmRsZSwgIl9BRFIiLCAmZHVtbXlfaGFuZGxlKTsKIAlpZiAoQUNQ
SV9GQUlMVVJFKHN0YXR1cykpCkBAIC00NzgsNiArNDg3LDkgQEAKIAlpZiAoIWRldiB8fCAh
ZGV2LT5zdWJvcmRpbmF0ZSkKIAkJZ290byBvdXQ7CiAKKwlhY3BpX2dldF9uYW1lKGhhbmRs
ZSwgQUNQSV9GVUxMX1BBVEhOQU1FLCAmYnVmZmVyKTsKKwlwcmludGsoS0VSTl9JTkZPICIl
czogRGV0ZWN0aW5nIHNsb3RzIHVuZGVyIFB0b1AgYnJpZGdlICglcylcbiIsCisJICAgICAg
IF9fZnVuY19fLCBvYmpuYW1lKTsKIAkvKiBjaGVjayBpZiB0aGlzIGJyaWRnZSBoYXMgZWpl
Y3RhYmxlIHNsb3RzICovCiAJaWYgKChkZXRlY3RfZWplY3RhYmxlX3Nsb3RzKGRldi0+c3Vi
b3JkaW5hdGUpID4gMCkpIHsKIAkJZGJnKCJmb3VuZCBQQ0ktdG8tUENJIGJyaWRnZSBhdCBQ
Q0kgJXNcbiIsIHBjaV9uYW1lKGRldikpOwpAQCAtNTA0LDYgKzUxNiw5IEBACiAJaW50IHNl
ZywgYnVzOwogCWFjcGlfaGFuZGxlIGR1bW15X2hhbmRsZTsKIAlzdHJ1Y3QgcGNpX2J1cyAq
cGNpX2J1czsKKwljaGFyIG9iam5hbWVbNjRdOworCXN0cnVjdCBhY3BpX2J1ZmZlciBidWZm
ZXIgPSB7IC5sZW5ndGggPSBzaXplb2Yob2JqbmFtZSksCisJCQkJICAgICAgLnBvaW50ZXIg
PSBvYmpuYW1lIH07CiAKIAkvKiBpZiB0aGUgYnJpZGdlIGRvZXNuJ3QgaGF2ZSBfU1RBLCB3
ZSBhc3N1bWUgaXQgaXMgYWx3YXlzIHRoZXJlICovCiAJc3RhdHVzID0gYWNwaV9nZXRfaGFu
ZGxlKGhhbmRsZSwgIl9TVEEiLCAmZHVtbXlfaGFuZGxlKTsKQEAgLTUzOSw2ICs1NTQsOSBA
QAogCQlyZXR1cm4gMDsKIAl9CiAKKwlhY3BpX2dldF9uYW1lKGhhbmRsZSwgQUNQSV9GVUxM
X1BBVEhOQU1FLCAmYnVmZmVyKTsKKwlwcmludGsoS0VSTl9JTkZPICIlczogRGV0ZWN0aW5n
IHNsb3RzIHVuZGVyIHJvb3QgYnJpZGdlICglcylcbiIsCisJICAgICAgIF9fZnVuY19fLCBv
YmpuYW1lKTsKIAkvKiBjaGVjayBpZiB0aGlzIGJyaWRnZSBoYXMgZWplY3RhYmxlIHNsb3Rz
ICovCiAJaWYgKGRldGVjdF9lamVjdGFibGVfc2xvdHMocGNpX2J1cykgPiAwKSB7CiAJCWRi
ZygiZm91bmQgUENJIGhvc3QtYnVzIGJyaWRnZSB3aXRoIGhvdC1wbHVnZ2FibGUgc2xvdHNc
biIpOwo=
--------------060904000901020406040300--

