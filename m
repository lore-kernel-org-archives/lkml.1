Return-Path: <linux-kernel-owner+w=401wt.eu-S933564AbXCaDM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564AbXCaDM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 23:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933573AbXCaDM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 23:12:57 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:22690 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933564AbXCaDM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 23:12:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=b2cckzoPqk2X3OqxAD8ai5ATXP5oVYoy1OmhrLjBgjx1JlmkVj03fNotjVqz64Nin2Fd7wYSxC7Sb+pAhEme7Vdk+WddhriuBuGW96AUDH6Kc6OPawaPgx6jvXGxC8G9ch0UpLFycscGuUplYUyiQ4bETRLIyglF7cMt074d+7I=
Message-ID: <460DD1B0.4080605@gmail.com>
Date: Sat, 31 Mar 2007 12:12:48 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: gregkh@suse.de, hugh@veritas.com, dmitry.torokhov@gmail.com,
       oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
References: <460CDBA6.5030608@gmail.com>	<20070330151926.18fc12a0@gondolin.boeblingen.de.ibm.com>	<460D0E78.3040200@gmail.com>	<20070330154042.4c7deb72@gondolin.boeblingen.de.ibm.com>	<460D178F.4000500@gmail.com>	<20070330165251.7beffc7c@gondolin.boeblingen.de.ibm.com>	<460D27E3.2050602@gmail.com> <20070330213101.7aa7babf@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070330213101.7aa7babf@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Sat, 31 Mar 2007 00:08:19 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> (3) make sure all existing kobjects are released by module exit function.
>>
>> For example, let's say there is a hypothetical disk device /dev/dk0
>> driven by a hypothetical driver mydrv.  /dev/dk0 is represented like the
>> following in the sysfs tree.
>>
>> /sys/devices/pci0000:00/0000:00:1f.0/dk0/{myknob0,myknob1}
>>
>> Owner of both attrs myknob0 and myknob1 is mydrv and opening either
>> increases the reference counts of dk0 and mydrv and closing does the
>> opposite.
>>
>> * When there is no opener of either knob and the /dev/dk0 isn't used by
>> anyone.  Reference count of dk0 is 1, mydrv 0.
> 
> Hm, but as long as dk0 is registered, it can be looked up and someone
> could get a reference on it.

Yeah, exactly.  That's why any getting any kobject reference backed by a
module must be accompanied by try_module_get().

int mydrv_get_dk(struct dk *dk)
{
	rc = try_module_get(mydrv);
	if (rc)
		return rc;
	kobject_get(&dk->kobj);
	return 0;
}

>> * User issues rmmod mydrv.  As mydrv's reference count is zero, unload
>> proceeds and mydrv's exit function is called.
>>
>> * mydrv's exit function looks like the following.
>>
>>   mydrv_exit()
>>   {
>> 	sysfs_remove_file(dk0, myknob0);
>> 	sysfs_remove_file(dk1, myknob1);
>> 	device_del(dk0);
>> 	deinit controller;
>> 	release all resources;
>>   }
>>
>> The device_del(dk0) drops dk0's reference count to zero and its
>> ->release is invoked immediately.
> 
> And here is the problem if someone else still has a reference. The
> module will be unloaded, but ->release will not be called until the
> "someone else" gives up the reference...

Exactly, in that case, module reference count must not be zero.  You and
I are saying the same thing.  Why are we running in circle?

-- 
tejun
