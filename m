Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbYIWS7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbYIWS7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYIWS73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:59:29 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:40422 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbYIWS72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:59:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=tu1aIdJQw0Dtsrid+ZBi+du/Ie0p5Gyl6uw6ps5sq/7U9ghnAemeVq8enYWO4Akero
         Qsl02NuHpXV1haTLCjooJ+S7w4COE4idqO5xV1WO25lCRGmUEP6K8iwl/BNWwAtPu3X0
         pOl4evQlECFjXs9zZ2NJHhfq3EPV6cviM/o0o=
Message-ID: <86802c440809231159x69883d44y26bbd491b6504a0f@mail.gmail.com>
Date: Tue, 23 Sep 2008 11:59:26 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Jack Steiner" <steiner@sgi.com>
Subject: Re: [PATCH] - Add early detection of UV system types
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <20080923182817.GA6335@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080923182817.GA6335@sgi.com>
X-Google-Sender-Auth: 7b09a0348c122bd2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 11:28 AM, Jack Steiner <steiner@sgi.com> wrote:
> Portions of system boot needs to know if a system is a UV system prior
> to genapic initialization. This patch adds a call from acpi_boot_table_init()
> to the UV code to parse the MADT to determine if the system is a UV system.
>
> Signed-off-by: Jack Steiner <steiner@sgi.com>
>
> ---
>  arch/x86/kernel/acpi/boot.c      |    4 ++++
>  arch/x86/kernel/genx2apic_uv_x.c |   21 ++++++++++++---------
>  arch/x86/mm/srat_64.c            |    2 +-
>  include/asm-x86/genapic_64.h     |    2 ++
>  4 files changed, 19 insertions(+), 10 deletions(-)
>
> Index: linux/arch/x86/kernel/acpi/boot.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/acpi/boot.c      2008-09-23 12:55:15.000000000 -0500
> +++ linux/arch/x86/kernel/acpi/boot.c   2008-09-23 12:55:19.000000000 -0500
> @@ -1667,6 +1667,10 @@ int __init acpi_boot_table_init(void)
>
>        acpi_table_parse(ACPI_SIG_BOOT, acpi_parse_sbf);
>
> +#ifdef CONFIG_X86_64
> +       acpi_table_parse(ACPI_SIG_MADT, uv_early_madt_oem_check);
> +#endif
> +
>        /*
>         * blacklist may disable ACPI entirely
>         */

you don't need to that.

please call early_acpi_boot_init instead

sth like

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 3d677b5..7ead2aa 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -997,6 +997,8 @@ void __init setup_arch(char **cmdline_p)
         */
        acpi_boot_table_init();

+       early_acpi_boot_init();
+
 #ifdef CONFIG_ACPI_NUMA
        /*
         * Parse SRAT to discover nodes.

YH
