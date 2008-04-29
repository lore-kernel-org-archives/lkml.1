Return-Path: <linux-kernel-owner+w=401wt.eu-S1759363AbYD2Mlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbYD2Mlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbYD2MlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:41:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631AbYD2MlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:41:23 -0400
Date: Tue, 29 Apr 2008 05:40:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jesse.barnes@intel.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Mika Fischer <mika.fischer@zoopnet.de>, balajirrao@gmail.com,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Message-Id: <20080429054045.09d8a911.akpm@linux-foundation.org>
In-Reply-To: <20080429103741.GL23198@elte.hu>
References: <200801192045.17291.yinghai.lu@sun.com>
	<48159ECF.9020004@googlemail.com>
	<20080428135351.GF3973@elte.hu>
	<200804280909.06561.jesse.barnes@intel.com>
	<20080429103741.GL23198@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 12:37:41 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> +static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
> +{
> +	/* allocate attribute structure, piggyback attribute name */
> +	int name_len = write_combine ? 13 : 10;
> +	struct bin_attribute *res_attr;
> +	int retval;
> +
> +	res_attr = kzalloc(sizeof(*res_attr) + name_len, GFP_ATOMIC);

That (retained from current code) GFP_ATOMIC cannot be necessary.

> +	if (res_attr) {
> +		char *res_attr_name = (char *)(res_attr + 1);
> +
> +		if (write_combine) {
> +			pdev->res_attr_wc[num] = res_attr;
> +			sprintf(res_attr_name, "resource%d_wc", num);
> +			res_attr->mmap = pci_mmap_resource_wc;
> +		} else {
> +			pdev->res_attr[num] = res_attr;
> +			sprintf(res_attr_name, "resource%d", num);
> +			res_attr->mmap = pci_mmap_resource_uc;
> +		}
> +		res_attr->attr.name = res_attr_name;
> +		res_attr->attr.mode = S_IRUSR | S_IWUSR;
> +		res_attr->size = pci_resource_len(pdev, num);
> +		res_attr->private = &pdev->resource[num];
> +		retval = sysfs_create_bin_file(&pdev->dev.kobj, res_attr);

Because of this.

> +	} else
> +		retval = -ENOMEM;
> +
> +	return retval;
> +}
