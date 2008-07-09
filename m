Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbYGIAsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbYGIAsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 20:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbYGIAr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 20:47:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:5052 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYGIAr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 20:47:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=o62lgkMOot1o6N/DnkUtLxK8OqngrumRibqKu3DgMNdTcj7QxpnrTlR6IRSYoh/Rp6
         sEiixPUpKTrAFWDl6hyYu/11awy8XnBW8i9udxzHNt1R/2HFux7QhuUZQiKNJsC+XBbH
         5Kfzi1pmS9R2g5EP0tVvvgckQFufvsCa439vE=
Message-ID: <86802c440807081747i6000d9a5kf3153d319cd85fda@mail.gmail.com>
Date: Tue, 8 Jul 2008 17:47:56 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: [patch] tip/x86_64: fix e820 merge issue which broke max_pfn_mapped
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080708230837.GD1678@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080708230837.GD1678@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2008 at 4:08 PM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> With out this 64bit tip/master doesn't boot using ACPI on my system.
> ---
>
> max_pfn_mapped should include all e820 entries.
> The direct mapping extends to max_pfn_mapped, so that we can directly access
> apertures, ACPI and other tables without having to play with fixmaps.
>
> With this, my system with 1GB memory boots fine with ACPI enabled.
>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---

please check

[PATCH] x86: introduce page_size_mask for 64bit
http://lkml.org/lkml/2008/7/8/49
[PATCH] x86: not overmap than end in init_memory_mapping - 64bit
http://lkml.org/lkml/2008/7/8/50

with this patch, on system that support gbpages
change
last_map_addr: 1080000000 end: 1078000000
to
last_map_addr: 1078000000 end: 1078000000

/sys/kernel/debug/kernel_page_tables
0xffff881040000000-0xffff881074400000         836M     RW         PSE GLB NX pmd
0xffff881074400000-0xffff8810744b0000         704K     RW             GLB NX pte
0xffff8810744b0000-0xffff8810744c0000          64K     RW     PCD     GLB NX pte
0xffff8810744c0000-0xffff881074600000        1280K     RW             GLB NX pte
0xffff881074600000-0xffff881080000000         186M     RW         PSE
GLB NX pmd ---> wrong
0xffff881080000000-0xffff888000000000         446G                           pud
0xffff888000000000-0xffffc20000000000       58880G                           pgd
===>
0xffff881040000000-0xffff881074400000         836M     RW         PSE GLB NX pmd
0xffff881074400000-0xffff8810744a0000         640K     RW             GLB NX pte
0xffff8810744a0000-0xffff8810744b0000          64K     RW     PCD     GLB NX pte
0xffff8810744b0000-0xffff881074600000        1344K     RW             GLB NX pte
0xffff881074600000-0xffff881078000000          58M     RW         PSE GLB NX pmd
0xffff881078000000-0xffff881080000000         128M                           pmd
0xffff881080000000-0xffff888000000000         446G                           pud
0xffff888000000000-0xffffc20000000000       58880G                           pgd

YH
