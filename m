Return-Path: <linux-kernel-owner+w=401wt.eu-S933158AbZFQMev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158AbZFQMev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765266AbZFQMem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:34:42 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:56514 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758379AbZFQMel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:34:41 -0400
X-Sasl-enc: IXNDxyx4pkvynE3JVc2xNeYqscOdTv/Kqigkm/I27JP6 1245242083
Date: Wed, 17 Jun 2009 09:34:40 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Joerg Platte <jplatte@naasa.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30] Kernel bug with dock driver
Message-ID: <20090617123440.GA400@khazad-dum.debian.net>
References: <200906142100.48621.jplatte@naasa.net> <200906150936.41983.jplatte@naasa.net> <20090615202928.GA28319@khazad-dum.debian.net> <200906161125.00685.jplatte@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906161125.00685.jplatte@naasa.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Joerg Platte wrote:
> Pid: 52, comm: kacpi_notify Not tainted (2.6.30 #1) 2373G1G
> EIP: 0060:[<c01df5fa>] EFLAGS: 00010286 CPU: 0
> EIP is at strcpy+0xe/0x1b
> EAX: f302482c EBX: f3024800 ECX: f302482c EDX: 00000000
> ESI: 00000000 EDI: f302482c EBP: f70a4f34 ESP: f70a4f28
>  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> Process kacpi_notify (pid: 52, ti=f70a4000 task=f704c980 task.ti=f70a4000)
> Stack:
>  f3024800 f3024814 f3024844 f70a4f64 c01fc898 010a4f54 00000000 f70c2879
>  00000004 f30e83c0 f3024818 00000014 f97c8132 f69b2600 00000000 f70a4f70
>  f97c814e 00000000 f70a4f7c f97c8023 f7070460 f70a4f8c c020199d f4e37ee0
> Call Trace:
>  [<c01fc898>] ? acpi_bus_generate_netlink_event+0x140/0x199
>  [<f97c8132>] ? bay_notify+0x0/0x1f [thinkpad_acpi]

Bay notify does this:

static void bay_notify(struct ibm_struct *ibm, u32 event)
{
	acpi_bus_generate_proc_event(ibm->acpi->device, event, 0);
	acpi_bus_generate_netlink_event(ibm->acpi->device->pnp.device_class,
					  dev_name(&ibm->acpi->device->dev),
					  event, 0);
}

If it causes a NULL derreference, it means someone has changed API and did
NOT change all callsites.  It is that simple.

Joerg, please apply this patch, and report the results...  WARNING: you will
not get bay events from thinkpad-acpi, so be careful to not remove from the
bay a device that is still active...


diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 912be65..03e4d16 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -4556,6 +4556,14 @@ static int __init bay_init(struct ibm_init_struct *iibm)
 
 static void bay_notify(struct ibm_struct *ibm, u32 event)
 {
+	if (WARN(!ibm, TPACPI_ERR "ibm is NULL\n"))
+		return;
+	if (WARN(!ibm->acpi->device, TPACPI_ERR "ibm->acpi->device is NULL\n"))
+		return;
+	if (WARN(!ibm->acpi->device->pnp.device_class, TPACPI_ERR "ibm->acpi->device->pnp.device_class is NULL\n"))
+		return;
+	if (WARN(!dev_name(&ibm->acpi->device->dev), TPACPI_ERR "dev_name() is returning NULL\n"))
+		return;
 	acpi_bus_generate_proc_event(ibm->acpi->device, event, 0);
 	acpi_bus_generate_netlink_event(ibm->acpi->device->pnp.device_class,
 					  dev_name(&ibm->acpi->device->dev),


-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
