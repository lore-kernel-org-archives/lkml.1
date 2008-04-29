Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbYD2WY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbYD2WY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbYD2WYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:24:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753634AbYD2WYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:24:45 -0400
Date: Tue, 29 Apr 2008 15:24:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: jesse.barnes@intel.com, torvalds@linux-foundation.org,
       nix.or.die@googlemail.com, yhlu.kernel@gmail.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mika.fischer@zoopnet.de,
       balajirrao@gmail.com, andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [patch] PCI: export resource_wc in pci sysfs
Message-Id: <20080429152413.66bcc83a.akpm@linux-foundation.org>
In-Reply-To: <20080429220345.GF2302@elte.hu>
References: <200801192045.17291.yinghai.lu@sun.com>
	<200804280909.06561.jesse.barnes@intel.com>
	<20080429103741.GL23198@elte.hu>
	<200804290852.17618.jesse.barnes@intel.com>
	<20080429220345.GF2302@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 00:03:46 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> +static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
> +{
> +	/* allocate attribute structure, piggyback attribute name */
> +	int name_len = write_combine ? 13 : 10;
> +	struct bin_attribute *res_attr;
> +	int retval;
> +
> +	res_attr = kzalloc(sizeof(*res_attr) + name_len, GFP_ATOMIC);
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
> +	} else
> +		retval = -ENOMEM;
> +
> +	return retval;
> +}

That GFP_ATOMIC should be switched to GFP_KERNEL.

Do we reeeeeeeely need to pull this
tack-the-string-onto-the-end-of-the-struct stunt?  If we didn't do that,
this code could then be taught about kasprintf() and things like that "? 
13 : 10" could be thankfully laid to rest.


