Return-Path: <linux-kernel-owner+w=401wt.eu-S1761431AbZEGKqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761431AbZEGKqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 06:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZEGKpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 06:45:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52058 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbZEGKpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 06:45:51 -0400
Message-ID: <4A02BB96.8070103@redhat.com>
Date: Thu, 07 May 2009 13:44:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Matthew Wilcox <matthew@wil.cx>, Sheng Yang <sheng@linux.intel.com>,
       kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] msi-x: let drivers retry when not enough vectors
References: <20090507082841.GA31751@redhat.com>	 <200905071651.24970.sheng@linux.intel.com>	 <20090507092731.GH8112@parisc-linux.org>	 <200905071740.16190.sheng@linux.intel.com>	 <20090507095302.GI8112@parisc-linux.org> <1241691830.24385.6.camel@concordia>
In-Reply-To: <1241691830.24385.6.camel@concordia>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman wrote:
> Not to mention that there's no guarantee that you'll get as many
> interrupts as the device supports, so you should really be coding to
> cope with that anyway. Like the example in MSI-HOWTO.txt:
>
> 197 static int foo_driver_enable_msix(struct foo_adapter *adapter, int nvec)
> 198 {
> 199         while (nvec >= FOO_DRIVER_MINIMUM_NVEC) {
> 200                 rc = pci_enable_msix(adapter->pdev,
> 201                                      adapter->msix_entries, nvec);
> 202                 if (rc > 0)
> 203                         nvec = rc;
> 204                 else
> 205                         return rc;
> 206         }
> 207 
> 208         return -ENOSPC;
> 209 }
>
> So I agree, this patch is an improvement.
>   

I imagine this loop is present in many drivers.  So why not add a helper

static int pci_enable_msix_min(struct foo_adapter *adapter, int min_nvec)
{
	int nvec = 2048;

        while (nvec >= min_nvec) {
                rc = pci_enable_msix(adapter->pdev,
                                     adapter->msix_entries, nvec);
                if (rc == 0)
                        return nvec;
                else if (rc > 0)
                        nvec = rc;
                else
                        return rc;
        }
        return -ENOSPC;
}



-- 
error compiling committee.c: too many arguments to function

