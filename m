Return-Path: <linux-kernel-owner+w=401wt.eu-S1759073AbZDEKYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073AbZDEKYo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 06:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbZDEKYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 06:24:32 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:7941 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756495AbZDEKYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 06:24:30 -0400
Message-ID: <49D88650.9050400@panasas.com>
Date: Sun, 05 Apr 2009 13:22:08 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: open-osd mailing-list <osd-dev@open-osd.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
References: <20090402015455.GA14087@havoc.gtf.org> <49D4AF12.40708@panasas.com> <49D5D921.6080904@garzik.org>
In-Reply-To: <49D5D921.6080904@garzik.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Apr 2009 10:24:27.0823 (UTC) FILETIME=[B30BD3F0:01C9B5D8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2009 12:38 PM, Jeff Garzik wrote:
> Boaz Harrosh wrote:
>> I have taken that to my heart and will submit patches for that, next week.
>> Including a complimentary patch to this driver. These changes are only
>> intended for 2.6.31 though.
> 
> Consolidation of common code should occur after osdblk is in one of: 
> open-osd.git, scsi-misc.git, or linux-2.6.git.
> 
> That way, the code movement can be consolidated into a single changeset, 
> touching exofs, osdblk and libosd all at the same time...
> 	-exofs code
> 	-osdblk code
> 	+libosd code
> 
> 

Yes my plan exactly. I'll do it on my linux-open-osd tree and push it
through the exofs branch in the next Kernel (2.6.31)

>> I also want to add a small utility that can manage objects, create, size,
>> remove, and mount as a complimentary wrapper for this driver is "osdblk"
>> a good name for such utility?
> 
> osdblk intentionally maintains -zero- metadata on its own.  Therefore, 
> this utility you propose can be completely generic.  You could call it 
> "osdobjutil", because it need not be tied to the osdblk driver.
> 
> The osdblk driver needs the following from the utility:
> 
> - create object of specified size
> 
> - delete object
> 
> and optionally:
> - resize object to new size
> 

In that case then I have on Q, an "osd" application that will support
the full osd API set through command line, like:
usage: osd create|remove|read|write|append|flush... \
	--obj=par_id,obj_id \
	[--set_attr=page_no,attr_no,set_attr_file] \
	[--get_attr=page_no,attr_no,set_attr_file] \
	[--file=in_out_file] \
	...

I intend to fully support any functionality available by the library.
the osd_ktests should be duplicatable in bash

> There is no need for a mount operation, because this is handled through 
> class_osdblk_add()
> 
> 
<snip>
>>> +static void osdblk_osd_complete(struct osd_request *or, void *private)
>>> +{
>>> +	struct osdblk_request *orq = private;
>>> +	struct osd_sense_info osi;
>>> +	int ret = osd_req_decode_sense(or, &osi);
>>> +
>>> +	if (ret)
>>> +		ret = -EIO;
>>> +
>>> +	osd_end_request(or);
>>> +	osdblk_end_request(orq->osdev, orq, ret);
>> should be reversed, very bad things will happen otherwise
>>
>> +	osdblk_end_request(orq->osdev, orq, ret);
>> +	osd_end_request(or);
> 
> Perhaps you are confusing two different 'struct request' in use?
> 
> 	- struct request, passed to osdblk for execution
> 	- struct request, used by libosd to pass commands
> 
> The object lifetime of the struct request stored in 'orq' is longer than 
> the lifetime of the osd_request:
> 
> 	1) block layer passes 'rq' to osdblk
> 	2) osdblk creates new 'or', passes 'or' to libosd
> 	3) libosd calls osdblk completion function
> 	4) osdblk completes 'or'
> 	5) osdblk completes 'rq'
> 
> As you can see, the object lifetime of 'or' is entirely within 'rq'.
> 
> 

Yes I was confused exactly as you described, thanks grate stuff.

> 
> 
>> What can I say, great stuff.
>>
>> OSD is a very clean API, that makes whole subsystems look trivial.
> 
> I appreciate it, thanks for the review.
> 
> 	Jeff

Thank you Jeff for doing this
Boaz
