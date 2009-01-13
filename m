Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbZAMGrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbZAMGrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbZAMGrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:47:23 -0500
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:60060 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZAMGrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:47:22 -0500
Message-ID: <496C38F4.7090900@freemail.hu>
Date: Tue, 13 Jan 2009 07:47:16 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
CC: Subrata Modak <subrata@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
       ltp-list@lists.sourceforge.net,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [LTP] block: how shall register_blkdev() work?
References: <496AE365.2000606@freemail.hu> <1231745940.5014.27.camel@subratamodak.linux.ibm.com> <20090112162620.GD1806@suse.de> <496C3195.6040002@freemail.hu> <20090113062444.GA2560@suse.de>
In-Reply-To: <20090113062444.GA2560@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail00a.mail.t-online.hu 32722; Body=8 Fuz1=8
	Fuz2=8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Jan 13, 2009 at 07:15:49AM +0100, Németh Márton wrote:
>> Hi,
>> Greg KH wrote:
>>> On Mon, Jan 12, 2009 at 01:09:00PM +0530, Subrata Modak wrote:
>>>> Greh,
>>>>
>>>> Can you please help us in reviewing the following definition.
>>> Hm, why me?  I didn't write this code...
>> I couldn't find any note about the original author in the block/genhd.c and
>> I haven't received any answer from Jens Axboe, yet, who is mentioned in
>> the MAINTAINERS file as the maintainer of the Block layer. Maybe
>> you know somebody I should ask?
> 
> Al Viro?  LKML?

I added to the To/Cc list.
Thank you for your time to giving me valuable comments on this topic.

>>>>> +/**
>>>>> + * register_blkdev - register a new block device
>>>>> + *
>>>>> + * @major: [in] the requested major device number [1..255]. If
>>>>> + *         @major=0, try to allocate any unused major number.
>>>>> + * @name: [in] the name of the new block device
>>> What's with the [in] marking?  Is that a new kerneldoc markup?
>> I wanted to express that these parameters are inputs for the register_blkdev()
>> function.
> 
> But that is not used in any of the rest of the kernel, as they are
> easily surmised.  Don't add new markings that are not part of the
> standard please.

OK.

>>>>> + * ??? The @name must be unique within the system. ???
>>>>> + * OR: ??? You can use any zero terminated @name string. Note, however, if
>>>>> + *         you use a name which is already used it might mask the previous
>>>>> + *         device. ???
>>>>> + *
>>>>> + * Returns the allocated major number [1..255] or the return value is
>>>>> + * a negative error code if the wanted @major number is not available
>>>>> + * or there is no more major nubmers available when @major=0.
>>>>> + *
>>>>> + * ??? What does the return value 0 mean?
>>> Usually it means success, like almost all other api calls within the
>>> kernel.
>> Here is my new version:
>>
>> --- linux-2.6.28/block/genhd.c.orig	2008-12-25 00:26:37.000000000 +0100
>> +++ linux-2.6.28/block/genhd.c	2009-01-13 07:11:51.000000000 +0100
>> @@ -244,6 +244,25 @@ void blkdev_show(struct seq_file *seqf,
>>  }
>>  #endif /* CONFIG_PROC_FS */
>>
>> +/**
>> + * register_blkdev - register a new block device
>> + *
>> + * @major: [in] the requested major device number [1..255]. If
>> + *         @major=0, try to allocate any unused major number.
>> + * @name: [in] the name of the new block device
> 
> Drop the [in].
> 
> add, "as a zero terminated string" to the end of the @name description.
> 
>> + * ??? The @name must be unique within the system. ???
> 
> That's good enough.
> 
>> + * OR: ??? You can use any zero terminated @name string. Note, however, if
>> + *         you use a name which is already used it might mask the previous
>> + *         device.
> 
> "might"?  Don't you know from the code what it does if you pass a
> duplicate name in?

OK, this is not an exact documentation, rather a question. My goal is to find
out from the people what they *think* this function shall work and not how the
actual code works.

In case of testing it is essential what is the base of my test case. If I based
my test case on the source code I would test whether the compiler produces
good code or not. But my goal is different: to find out whether the function
works as the developers expect to work. If I try to find out this I can gain
that I can found possible differences between the code and the developer's
expectation.

My next version looks as follows. I still would like to find out what do
you *think* shall happen if the caller specifies a name which was already occupied
before:

--- linux-2.6.28/block/genhd.c.orig	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/block/genhd.c	2009-01-13 07:37:37.000000000 +0100
@@ -244,6 +244,23 @@ void blkdev_show(struct seq_file *seqf,
 }
 #endif /* CONFIG_PROC_FS */

+/**
+ * register_blkdev - register a new block device
+ *
+ * @major: the requested major device number [1..255]. If @major=0, try to
+ *         allocate any unused major number.
+ * @name: the name of the new block device as a zero terminated string
+ *
+ * The @name must be unique within the system.
+ * ??? If you specify an already used name an error code will be returned. ???
+ *
+ * The return value depends on the @major input parameter.
+ *  - if a major device number was requested in range [1..255] then the
+ *    function returns zero on success, or a negative error code
+ *  - if any unused major number was requested with @major=0 parameter
+ *    then the return value is the allocated major number in range
+ *    [1..255] or a negative error code otherwise
+ */
 int register_blkdev(unsigned int major, const char *name)
 {
 	struct blk_major_name **n, *p;

Regards,

	Márton Németh
