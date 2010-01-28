Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093Ab0A1N0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab0A1N0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 08:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755681Ab0A1N0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 08:26:17 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:42565 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab0A1N0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 08:26:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xop//TNlRD9TLIhQXI6Fy/UgOZVc7JzfKyt5XQTmku1TSh/4wubneyBh0rOnNf9T6D
         6pwEdyuT94UzRfTj/0MxngbDDEalIZHDqA5cMLTsHW9XhVWAsG1DTHxns9Z2asIoYHVR
         kpc3cdMzd1QkZAKcIxtstA/nlrcKtDe3zFjjY=
MIME-Version: 1.0
In-Reply-To: <201001281253.54878.paul@codesourcery.com>
References: <201001281253.54878.paul@codesourcery.com>
Date: Thu, 28 Jan 2010 14:26:14 +0100
Message-ID: <71cd59b01001280526m54ddbd82t7803629a2149fa2c@mail.gmail.com>
Subject: Re: [PATCH] EeePC 1005PE rfkill fix
From: Corentin Chary <corentin.chary@gmail.com>
To: Paul Brook <paul@codesourcery.com>
Cc: acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux acpi <linux-acpi@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 1:53 PM, Paul Brook <paul@codesourcery.com> wrote:
> The EeePC 1005PE has the wireless card on PCI bus 2.
>
> Signed-off-by: Paul Brook <paul@codesourcery.com>
> ---
> Same as before, but without mail client mangling the patch.
>
> I couldn't figure out a smart way of figuring out the correct bus, so I
> hardcoded the device name. lspci and acpi dumps available at
> http://www.pbrook80.webspace.virginmedia.com/
>
> My guess is that the 1005HA is configured similarly, however I don't have
> hardware to test. The preceding comments imply that the 1005HA does not
> require the pci hotplug bits. On my 1005PE the hotplug bits are definitely
> required (the device stops responding when the rfkill is activated), we just
> need to make sure we disable the right bus. PCI bus 1 contains the wired
> Ethernet controller.
>
>  drivers/platform/x86/eeepc-laptop.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index e2be6bb..6b53701 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -161,6 +161,7 @@ struct eeepc_laptop {
>                                           by this BIOS */
>        bool cpufv_disabled;
>        bool hotplug_disabled;
> +       int hotplug_bus;
>        u16 event_count[128];           /* count for each event */
>
>        struct platform_device *platform_device;
> @@ -585,9 +586,10 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc)
>        mutex_lock(&eeepc->hotplug_lock);
>
>        if (eeepc->hotplug_slot) {
> -               bus = pci_find_bus(0, 1);
> +               bus = pci_find_bus(0, eeepc->hotplug_bus);
>                if (!bus) {
> -                       pr_warning("Unable to find PCI bus 1?\n");
> +                       pr_warning("Unable to find PCI bus %d?\n",
> +                                  eeepc->hotplug_bus);
>                        goto out_unlock;
>                }
>
> @@ -695,7 +697,7 @@ static struct hotplug_slot_ops eeepc_hotplug_slot_ops = {
>  static int eeepc_setup_pci_hotplug(struct eeepc_laptop *eeepc)
>  {
>        int ret = -ENOMEM;
> -       struct pci_bus *bus = pci_find_bus(0, 1);
> +       struct pci_bus *bus = pci_find_bus(0, eeepc->hotplug_bus);
>
>        if (!bus) {
>                pr_err("Unable to find wifi PCI bus\n");
> @@ -1281,6 +1283,13 @@ static void eeepc_dmi_check(struct eeepc_laptop *eeepc)
>                eeepc->hotplug_disabled = true;
>                pr_info("wlan hotplug disabled\n");
>        }
> +
> +       /* The eeepc 1005PE has the wireless chip on the second PCIe bus.  */
> +       if (strcmp(model, "1005PE") == 0) {
> +           eeepc->hotplug_bus = 2;
> +       } else {
> +           eeepc->hotplug_bus = 1;
> +       }
>  }
>
>  static void cmsg_quirk(struct eeepc_laptop *eeepc, int cm, const char *name)
> --
> 1.6.6

Hi Paul,
First did you try your patch with an updated bios ?
It's weird that 1005HA and 1005PE don't have the same behavior :/.
Any objection about this patch someone ?
If not, I'll add it to acpi4asus tree, but it may not be included in 2.6.33.
Thanks,

-- 
Corentin Chary
http://xf.iksaif.net
