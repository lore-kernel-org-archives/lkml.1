Return-Path: <linux-kernel-owner+w=401wt.eu-S1752975AbYJ1JHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbYJ1JHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 05:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYJ1JHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 05:07:44 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:31403 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYJ1JHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 05:07:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Pc5xy2s35HTuM8PabauXeve+P77uEO4SCml1pIaBxfwq5w5DUGDd2yXXGMHXqAsSO3
         CeDlSDAniaw9PQKyeCAsrEZ3Uhw8fU9WxN3MLi/bu5wmEsImQhgsO49sw/irpvLTaj9F
         ZoqCejF2E24fL0aNyT03grJXUNOsAhEXnZLWE=
Message-ID: <e785a1360810280207p1c162decs5a70b8915ea08476@mail.gmail.com>
Date: Tue, 28 Oct 2008 11:07:40 +0200
From: "Jouni Malinen" <jkmalinen@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: USB problem on x86_64: nommu_map_single() issue?
Cc: "Nicolas Bareil" <nico@chdir.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, "Joerg Roedel" <joerg.roedel@amd.com>,
       "Ingo Molnar" <mingo@elte.hu>, j@w1.fi
In-Reply-To: <200810141300.29502.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081014072045.GA1252@sd-5945.dedibox.fr>
	 <200810141148.48220.oliver@neukum.org>
	 <20081014104500.GB1252@sd-5945.dedibox.fr>
	 <200810141300.29502.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 1:00 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Dienstag, 14. Oktober 2008 12:45:00 schrieb Nicolas Bareil:
>> On Tue, Oct 14, 2008 at 11:48:47AM +0200, Oliver Neukum wrote:
>> > > On 2.6.27, I can't use any USB device (mass storage, mouse) anymore on my x86_64 system, the devices
>> > > are not detected: lsusb returns nothing except the hub.
>> >
>> > Is this a regression? Did it work on earlier kernels?
>>
>> Yes this is a regression: USB works in 2.6.26.x with (almost) the same configuration.
>
> This a an IOMMU problem, not really a USB problem. Can you bisect the problem?

It looks like I'm seeing something similar with the current
linux-2.6.git. However, in my case, 2.6.27 seemed to work and I
started seeing this only after the 2.6.27 release (though, git bisect
ended up in 2.6.27-rc3). In addition, I'm seeing way more issues than
just USB dying (both wired and wireless networking were hosed; r8169
was returning random memory or all zeroes in the payload of the
frames, etc.).

After a painful git bisect (two other bugs that prevented boot and
some build issues in the tested commits) the first bad commit turned
out to be cf169702ba6928cee9d4f4adf3e932b643b8db7a (see below; author
cc'ed). This is only adding a new PCI device id, so the commit itself
seems to just trigger the issue somewhere else.

I've verified that I can get rid of the nommu_map_single() messages by
reverting this patch (i.e., made kernel not find the northbridge) with
the current linux-2.6.git head. Obviously, that does not sound like a
proper fix here. Would anyone have any idea on what is the real issue
here or what could be done to find it?

I'm seeing this issue on a HP Pavilion dv5 laptop that has AMD Turion
X2 Ultra Dual-Core Mobile ZM-80. lspci shows the PCI id that was added
(1022:1303). mem=2G works around the problem. pci_swiotlb_init() did
not set swiotlb to 1, but hardcoding it to 1 there did not help
either.


$ git bisect bad
cf169702ba6928cee9d4f4adf3e932b643b8db7a is first bad commit
commit cf169702ba6928cee9d4f4adf3e932b643b8db7a
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Tue Sep 2 13:13:40 2008 +0200

    x86, gart: add detection of AMD family 0x11 northbridges

    This patch adds the detection of the northbridges in the AMD family 0x11
    processors. It also fixes the magic numbers there while changing this code.

    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

:040000 040000 183c03461f96be8bbf96cb51bae9bb0fb93dae89
58638c91f03393225f3c48cb12476466f9c5e2be M	arch

----------------------------- arch/x86/kernel/k8.c -----------------------------
index 7377ccb..304d8ba 100644
@@ -16,8 +16,9 @@ EXPORT_SYMBOL(num_k8_northbridges);
 static u32 *flush_words;

 struct pci_device_id k8_nb_ids[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1103) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1203) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_11H_NB_MISC) },
 	{}
 };
 EXPORT_SYMBOL(k8_nb_ids);


- Jouni
