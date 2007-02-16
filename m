Return-Path: <linux-kernel-owner+w=401wt.eu-S1423303AbXBPGDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423303AbXBPGDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423304AbXBPGDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:03:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52065 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423303AbXBPGDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:03:08 -0500
Date: Thu, 15 Feb 2007 22:01:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Len Brown" <lenb@kernel.org>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: e1000_intr in request_irq faults in 2.6.20-git
Message-Id: <20070215220152.d137f86b.akpm@linux-foundation.org>
In-Reply-To: <36D9DB17C6DE9E40B059440DB8D95F5201E997BA@orsmsx418.amr.corp.intel.com>
References: <m1y7mzhw7b.fsf@ebiederm.dsl.xmission.com>
	<36D9DB17C6DE9E40B059440DB8D95F5201E997BA@orsmsx418.amr.corp.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 18:10:53 -0800 "Brandeburg, Jesse" <jesse.brandeburg@intel.com> wrote:

> @@ -1431,6 +1427,10 @@ e1000_open(struct net_device *netdev)
>                 e1000_update_mng_vlan(adapter);
>         }
> 
> +       err = e1000_request_irq(adapter);
> +       if (err)
> +               goto err_req_irq;
> +
>         /* If AMT is enabled, let the firmware know that the network
>          * interface is now open */
>         if (adapter->hw.mac_type == e1000_82573 &&
> @@ -1439,10 +1439,11 @@ e1000_open(struct net_device *netdev)
> 
>         return E1000_SUCCESS;
> 
> +err_req_irq:
> +       e1000_down(adapter);
> +       e1000_free_irq(adapter);
>  err_up:

We don't want that e1000_free_irq(adapter) in the error path.
