Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbZGLI4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbZGLI4G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 04:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZGLIzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 04:55:55 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:3977
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751656AbZGLIzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 04:55:54 -0400
Message-ID: <4A59A517.1080605@panasas.com>
Date: Sun, 12 Jul 2009 11:55:51 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 3/4] fs: new truncate sequence
References: <20090707144823.GE2714@wotan.suse.de> <20090707145820.GA9976@infradead.org> <20090707150257.GG2714@wotan.suse.de> <20090707150758.GA18075@infradead.org> <20090707154809.GH2714@wotan.suse.de> <20090707163042.GA14947@infradead.org> <20090708063225.GL2714@wotan.suse.de> <20090708104701.GA31419@infradead.org> <20090708123412.GQ2714@wotan.suse.de> <4A54C435.1000503@panasas.com> <20090709075100.GU2714@wotan.suse.de>
In-Reply-To: <20090709075100.GU2714@wotan.suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jul 2009 08:55:53.0762 (UTC) FILETIME=[9019F820:01CA02CE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2009 10:51 AM, Nick Piggin wrote:
> On Wed, Jul 08, 2009 at 07:07:17PM +0300, Boaz Harrosh wrote:
>> On 07/08/2009 03:34 PM, Nick Piggin wrote:
>>> On Wed, Jul 08, 2009 at 06:47:01AM -0400, Christoph Hellwig wrote:
>>> Index: linux-2.6/fs/attr.c
>>> ===================================================================
>>> --- linux-2.6.orig/fs/attr.c
>>> +++ linux-2.6/fs/attr.c
>>> @@ -112,7 +112,12 @@ int inode_setattr(struct inode * inode,
>>>  
>>>  	if (ia_valid & ATTR_SIZE &&
>>>  	    attr->ia_size != i_size_read(inode)) {
>>> -		int error = vmtruncate(inode, attr->ia_size);
>>> +		int error;
>>> +
>>> +		if (inode->i_op->new_truncate)
>>> +			error = simple_setsize(inode, attr->ia_size);
>> I don't understand this branch.
>> If a filesystem has been converted to set "i_op->new_truncate=true"
>> then it must have been converted to intersect ->setattr and has set
>> the i_size (And needs to clear ATTR_SIZE, why?)
>>
>> All other cases of systems not converted, or systems that do not have
>> ->truncate will fall to the "else" part.
>>
>> before the removal of i_op->new_truncate you will need to do something
>> with the systems that do not have ->truncate which will be a 
>> .setattr = simple_setattr or something
>>
>> So I don't understand this conditional
> 
> inode_setattr *is* our "simple_setattr".
> 

I wish you would split it.

one - helper to be called by converted file systems
      (Which just ignores the ATTR_SIZE)
second - to be set into .setattr which does the simple_setsize + above.

More clear for FS users like me (and that ugly unmask of ATTR_SIZE)

or it's just me?

Thanks
Boaz
