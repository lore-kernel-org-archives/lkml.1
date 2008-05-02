Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbYEBJTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbYEBJTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 05:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbYEBJTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 05:19:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:18761 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbYEBJTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 05:19:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eLCYA9R8oc0LYNRJmCsFSZTBApdMP4w0Ai0EssXrBYMsuAD7Cwmrc7bqL5uefvLxTEJesDlx2mBabHXiNTkggCjWCQvCZmRg5TG6Y/YSjRMdeBC91ObtdEhZKmgUAdWq8IPWAtRdA/b5qHmx3z9KTAl8lopeirDqjuR7c+7hE9s=
Message-ID: <86802c440805020219t73a8ae52ue7b15cfa36ac64de@mail.gmail.com>
Date: Fri, 2 May 2008 02:19:34 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] fix x86 DMI checks for PCI quirks
Cc: "Matt Domsch" <Matt_Domsch@dell.com>, akpm@linux-foundation.org,
       jgarzik@pobox.com, muli@il.ibm.com, davej@redhat.com,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bunk@kernel.org,
       linux-bugs@dell.com, linux-kernel@vger.kernel.org, greg@kroah.com,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <20080502074432.GA1372@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080502025427.GA23757@auslistsprd01.us.dell.com>
	 <20080502074432.GA1372@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2008 at 12:44 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Matt Domsch <Matt_Domsch@dell.com> wrote:
>
>  > fix x86 DMI checks for PCI quirks
>  >
>  > http://bugzilla.kernel.org/show_bug.cgi?id=10583
>  > https://bugzilla.redhat.com/show_bug.cgi?id=444791
>  >
>  > Since git commit 08f1c192c3c32797068bfe97738babb3295bbf42 (between
>  > kernels 2.6.22 and 2.6.23), arch/x86/pci/acpi.c has not called
>  > pcibios_scan_root(), which would have called
>  > arch/x86/pci/common.c:dmi_check_system().  This has prevented the
>  > quirks listed in pciprobe_dmi_table[] from being checked and
>  > appropriate action taken.
>
>  ugh ...
>
>
>  > This manifests itself in several Dell and HP servers not automatically
>  > having the pci=bfsort option be applied, as well as Samsung X20 and
>  > Compaq EVO N800c systems needing pci=assign-all-busses was no longer
>  > automatically applied.
>  >
>  > This patch moves the DMI tests into its own file, arch/x86/pci/dmi.c,
>  > and invokes them via subsys_initcall() before pci_acpi_init(),
>  > pci_legacy_init(), and pcibios_init() are called, which may rely upon
>  > these tests having been executed.
>
>  Jesse Barnes (new PCI maintainer) Cc:-ed.
>
>  i'm wondering how we could avoid such mishaps in the future. This was
>  broken from 2.6.23 through 2.6.25 - way too long. Perhaps we should
>  create a known signature of the device tree in user-space, and somehow
>  warn if the kernel changes it? Could this somehow be put into the
>  kernel?
>

please check the patch in x86.git, it should do the same thing, but
put the call in pci_access_init...

commit 9817aa147000086bc11b571620ecc1c73a4a614b
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Mon Apr 14 15:40:37 2008 -0700

    x86 PCI: call dmi_check_pciprobe()

    this change:

    | commit 08f1c192c3c32797068bfe97738babb3295bbf42
    | Author: Muli Ben-Yehuda <muli@il.ibm.com>
    | Date:   Sun Jul 22 00:23:39 2007 +0300
    |
    |    x86-64: introduce struct pci_sysdata to facilitate sharing of ->sysdata
    |
    |    This patch introduces struct pci_sysdata to x86 and x86-64, and
    |    converts the existing two users (NUMA, Calgary) to use it.
    |
    |    This lays the groundwork for having other users of sysdata, such as
    |    the PCI domains work.
    |
    |    The Calgary bits are tested, the NUMA bits just look ok.

    replaces pcibios_scan_root with pci_scan_bus_parented...

    but in pcibios_scan_root we have a DMI check:

        dmi_check_system(pciprobe_dmi_table);

    when when have several peer root buses this could be called multiple
    times (which is bad), so move that call to pci_access_init().

    Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
