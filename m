Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab0BOEfm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 23:35:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:43246 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab0BOEfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 23:35:39 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Dave Chinner <david@fromorbit.com>, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH v2] Make VM_MAX_READAHEAD a kernel parameter
Date: Mon, 15 Feb 2010 10:06:37 +0530
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Ankit Jain <radical@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
References: <201002091659.27037.knikanth@suse.de> <201002111715.04411.knikanth@suse.de> <20100214213724.GA28392@discord.disaster>
In-Reply-To: <20100214213724.GA28392@discord.disaster>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002151006.37294.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 February 2010 03:07:24 Dave Chinner wrote:
> On Thu, Feb 11, 2010 at 05:15:03PM +0530, Nikanth Karthikesan wrote:
> > On Thursday 11 February 2010 16:45:24 Ankit Jain wrote:
> > > > +static int __init readahead(char *str)
> > > > +{
> > > > +       if (!str)
> > > > +               return -EINVAL;
> > > > +       vm_max_readahead_kb = memparse(str, &str) / 1024ULL;
> > >
> > > Just wondering, shouldn't you check whether the str had a valid value
> > > [memparse (str, &next); next > str ..] and if it didn't, then use the
> > > DEFAULT_VM_MAX_READAHEAD ? Otherwise, incase of a invalid
> > > value, the readahead value will become zero.
> >
> > Thanks for the review. Here is the fixed patch that checks whether all of
> > the parameters value is consumed.
> >
> > Thanks
> > Nikanth
> >
> > From: Nikanth Karthikesan <knikanth@suse.de>
> >
> > Add new kernel parameter "readahead", which would be used instead of the
> > value of VM_MAX_READAHEAD. If the parameter is not specified, the default
> > of 128kb would be used.
> >
> > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> >
> > ---
> >
> > diff --git a/Documentation/kernel-parameters.txt
> > b/Documentation/kernel-parameters.txt index 736d456..354e6f1 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -2148,6 +2148,8 @@ and is between 256 and 4096 characters. It is
> > defined in the file Format: <reboot_mode>[,<reboot_mode2>[,...]]
> >  			See arch/*/kernel/reboot.c or arch/*/kernel/process.c
> >
> > +	readahead=	Default readahead value for block devices.
> > +
> 
> I think the description should define the units (kb) and valid value
> ranges e.g. page size to something not excessive - say 65536kb.  The
> above description is, IMO, useless without refering to the source to
> find out this information....
> 

The parameter can be specified with/without any suffix(k/m/g) that memparse() 
helper function can accept. So it can take 1M, 1024k, 1050620. I checked other 
parameters that use memparse() to get similar values and they didn't document 
it. May be this should be described here.

> [snip]
> 
> > @@ -249,6 +250,24 @@ static int __init loglevel(char *str)
> >
> >  early_param("loglevel", loglevel);
> >
> > +static int __init readahead(char *str)
> > +{
> > +	unsigned long readahead_kb;
> > +
> > +	if (!str)
> > +		return -EINVAL;
> > +	readahead_kb = memparse(str, &str) / 1024ULL;
> > +	if (*str != '\0')
> > +		return -EINVAL;
>  		
> And readahead_kb needs to be validated against the range of
> valid values here.
> 

I didn't want to impose artificial restrictions. I think Wu's patch set would 
be adding some restrictions, like minimum readahead. He could fix it when he 
modifies the patch to include in his patch set.

> > +
> > +	vm_max_readahead_kb = readahead_kb;
> > +	default_backing_dev_info.ra_pages = vm_max_readahead_kb
> > +						* 1024 / PAGE_CACHE_SIZE;
> > +	return 0;
> > +}
> > +
> > +early_param("readahead", readahead);
> > +
> 

Thanks for reviewing.

Thanks
Nikanth
