Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbZFOEhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbZFOEhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 00:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbZFOEhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 00:37:37 -0400
Received: from mga05.intel.com ([192.55.52.89]:65101 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751078AbZFOEhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 00:37:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,220,1243839600"; 
   d="scan'208";a="699332829"
Subject: Re: [PATCH V4: 3/3] pci: Provide Multiple Error Received support
	on AER
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <1245038460.19708.125.camel@grinch>
References: <1244776118.2560.321.camel@ymzhang>
	 <1244844988.19708.115.camel@grinch>  <1245030458.2560.343.camel@ymzhang>
	 <1245038460.19708.125.camel@grinch>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 15 Jun 2009 12:37:41 +0800
Message-Id: <1245040661.2560.347.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 04:01 +0000, Andrew Patterson wrote:
> On Mon, 2009-06-15 at 09:47 +0800, Zhang, Yanmin wrote:
> > On Fri, 2009-06-12 at 22:16 +0000, Andrew Patterson wrote:
> > > On Fri, 2009-06-12 at 11:08 +0800, Zhang, Yanmin wrote:
> > > > ﻿﻿﻿﻿﻿When a root port receive the same errors more than once before kernel
> > > >  process them, the Multiple Error Messages Received flags are set by
> > > > hardware. Because root port could only save one kind of correctable
> > > > error source id and another uncorrectable error source id at the same
> > > > time, so the second message sender id is lost if the 2 messages are
> > > > sent from 2 different devices. Below patch searches all devices under
> > > > the root port when multiple messages are received.
> > > > 
> > > > ﻿﻿﻿﻿Signed-off-by: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>
> > > > 
> > > > +	for (i = 0; i < e_info->error_dev_num; i ++) {
> > > checkpatch reports:
> > > ERROR: space prohibited before that '++' (ctx:WxB)
> > > #154: FILE: drivers/pci/pcie/aer/aerdrv_core.c:751:
> > > +	for (i = 0; i < e_info->error_dev_num; i +
> > I will change it.
> > 
> > > 
> > > 
> > > > +		if (e_info->dev[i] == NULL)
> > > again		  if (!e_info->dev[i])
> > Will do.
> > 
> > > 
> > > You could also put this check in the for loop.
> > I planed to, but one guy helped me test it within a guest OS on XEN and
> > reported a weired oops of guest OS. She said useing ﻿e_info->error_dev_num
> > could avoid the oops.
> 
> I think something like:
> 
>   for (i = 0; i < e_info->error_dev_num && e_info->dev[i]; i++)
> 
> is functionally equivalent.
I changed it.

> 
> > 
> > > 
> > > 
> > > > +			break;
> > > > +
> > > > +		if (get_device_error_info(e_info->dev[i], e_info) ==
> > > > +				AER_SUCCESS) {
> > > > +			aer_print_error(e_info->dev[i], e_info);
> > > > +			handle_error_source(p_device,
> > > > +					e_info->dev[i],
> > > > +					e_info);
> > > > +		}
> > > > +	}
> > > > +}
> > > > +
> > > >  /**
> > > >   * aer_isr_one_error - consume an error detected by root port
> > > >   * @p_device: pointer to error root port service device
> > > > @@ -747,18 +804,7 @@ static void aer_isr_one_error(struct pci
> > > >  			e_info->flags |= AER_MULTI_ERROR_VALID_FLAG;
> > > >  
> > > >  		find_source_device(p_device->port, e_info);
> > > > -		if (e_info->dev == NULL) {
> > > > -			printk(KERN_DEBUG "%s->can't find device of ID%04x\n",
> > > > -				__func__, e_info->id);
> > > > -			continue;
> > > > -		}
> > > > -		if (get_device_error_info(e_info->dev, e_info) ==
> > > > -				AER_SUCCESS) {
> > > > -			aer_print_error(e_info->dev, e_info);
> > > > -			handle_error_source(p_device,
> > > > -				e_info->dev,
> > > > -				e_info);
> > > > -		}
> > > > +		aer_process_err_devices(p_device, e_info);
> > > >  	}
> > > >  
> > > >  	kfree(e_info);
> > > > diff -Nraup linux-2.6_next_aernoid/drivers/pci/pcie/aer/aerdrv.h linux-2.6_next_aermultierror/drivers/pci/pcie/aer/aerdrv.h
> > > > --- linux-2.6_next_aernoid/drivers/pci/pcie/aer/aerdrv.h	2009-06-12 05:39:24.000000000 +0800
> > > > +++ linux-2.6_next_aermultierror/drivers/pci/pcie/aer/aerdrv.h	2009-06-12 05:45:15.000000000 +0800
> > > > @@ -57,8 +57,10 @@ struct header_log_regs {
> > > >  	unsigned int dw3;
> > > >  };
> > > >  
> > > > +#define AER_MAX_MULTI_ERR_DEVICES	5
> > > Is this number arbitrary or in the spec somewhere?
> > It's arbitrary and not spec. 
> 
> I suspected so.
> 
> > The startpoint is it's very rare that there are more
> > than 5 devices under the same root port reporting errors at the same time. 
> 
> Agreed.
> 
> > It's hard
> > to say number 5 is the best. I just don't want the array is big.
> 
> I don't have a problem with that decision. But you might add a comment
> saying so, e.g.,
> 
> #define AER_MAX_MULTI_ERR_DEVICES	5    /* Not likely to have more */
Added.

Thanks Andrew.

