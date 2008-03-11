Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbYCKNmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbYCKNmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 09:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYCKNmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 09:42:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbYCKNml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 09:42:41 -0400
Date: Tue, 11 Mar 2008 09:29:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: chandru@in.ibm.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jdmason@kudzu.us,
       Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [RFC] [Patch] calgary iommu: Use the first kernel's tce tables
	in kdump
Message-ID: <20080311132921.GA10828@redhat.com>
References: <1191962414.24134.68.camel@chandru> <20071009210623.GK4335@rhun.haifa.ibm.com> <20071010053057.GA24434@in.ibm.com> <20071014054110.GB4399@rhun.haifa.ibm.com> <20071015062919.GA4598@in.ibm.com> <476F4064.8010601@in.ibm.com> <47D5359D.5000909@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D5359D.5000909@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 06:50:29PM +0530, Chandru wrote:

[..]
> -       specified_table_size = determine_tce_table_size(end_pfn * 
> PAGE_SIZE);
> +       max_pfn = is_kdump_kernel() ? saved_max_pfn : end_pfn ;
> +       specified_table_size = determine_tce_table_size(max_pfn * 
> PAGE_SIZE);
>
>        for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
>                struct calgary_bus_info *info = &bus_info[bus];
> @@ -1411,10 +1480,16 @@ void __init detect_calgary(void)
>
>                if (calgary_bus_has_devices(bus, pci_device) ||
>                    translate_empty_slots) {
> -                       tbl = alloc_tce_table();
> -                       if (!tbl)
> -                               goto cleanup;
> -                       info->tce_space = tbl;
> +                       /*
> +                        * If this is a kdump kernel find and use
> +                        * the tce tables from first kernel
> +                        */
> +                       if (!is_kdump_kernel()) {
> +                               tbl = alloc_tce_table();
> +                               if (!tbl)
> +                                       goto cleanup;
> +                               info->tce_space = tbl;
> +                       }

Hi Chandru,

- How do we make sure that previous kernel's TCE tables are not
  overwritten
  by new kernel (In case previous kernel allocated TCE tables in first
  640 KB?)

- How do we make sure that when new kernel tries to setup an entry in
  TCE table, then it does not try to clear up an existing entry which is
  still in use?

Did you try the Muli suggestion of ignoring DMA error in exception
handler? What happens if I setup new table and try to switch to new
table? Some sort of error will occur. Can't we modify the handler and
ignore it for kdump case and move on?

Thanks
Vivek
