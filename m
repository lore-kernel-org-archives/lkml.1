Return-Path: <linux-kernel-owner+w=401wt.eu-S964780AbXCaDPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780AbXCaDPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 23:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964834AbXCaDPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 23:15:16 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:6044 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964804AbXCaDPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 23:15:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=QnKm8L4f/6JRw1eoG/BudVEwKa6HG9V9bzQUJCuYMivTOJGaQX5+yDF1j/pU5CLnDf08h8sf+ja/6j0nBnNEwWaD4avQ6FKyoFzoavxkNlj3+Azwt/o1ehc1R1MNVyYcHM6G9UdQHLnFDb/IlErCUP52jjS46n1KjJp53/1Fuac=
Message-ID: <460DD236.4030804@gmail.com>
Date: Sat, 31 Mar 2007 12:15:02 +0900
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
References: <460CDBA6.5030608@gmail.com>	<20070330151926.18fc12a0@gondolin.boeblingen.de.ibm.com>	<460D0E78.3040200@gmail.com>	<20070330154042.4c7deb72@gondolin.boeblingen.de.ibm.com>	<460D178F.4000500@gmail.com>	<20070330165251.7beffc7c@gondolin.boeblingen.de.ibm.com>	<460D27E3.2050602@gmail.com> <20070330213101.7aa7babf@gondolin.boeblingen.de.ibm.com> <460DD1B0.4080605@gmail.com>
In-Reply-To: <460DD1B0.4080605@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Cornelia Huck wrote:
>> On Sat, 31 Mar 2007 00:08:19 +0900,
>> Tejun Heo <htejun@gmail.com> wrote:
>>
>>> (3) make sure all existing kobjects are released by module exit function.
>>>
>>> For example, let's say there is a hypothetical disk device /dev/dk0
>>> driven by a hypothetical driver mydrv.  /dev/dk0 is represented like the
>>> following in the sysfs tree.
>>>
>>> /sys/devices/pci0000:00/0000:00:1f.0/dk0/{myknob0,myknob1}
>>>
>>> Owner of both attrs myknob0 and myknob1 is mydrv and opening either
>>> increases the reference counts of dk0 and mydrv and closing does the
>>> opposite.
>>>
>>> * When there is no opener of either knob and the /dev/dk0 isn't used by
>>> anyone.  Reference count of dk0 is 1, mydrv 0.
>> Hm, but as long as dk0 is registered, it can be looked up and someone
>> could get a reference on it.
> 
> Yeah, exactly.  That's why any getting any kobject reference backed by a
> module must be accompanied by try_module_get().
> 
> int mydrv_get_dk(struct dk *dk)
> {
> 	rc = try_module_get(mydrv);
> 	if (rc)
> 		return rc;
> 	kobject_get(&dk->kobj);
> 	return 0;
> }

And one more thing just in case.  In the above code, try_module_get()
and kobject_get() must be and is atomic w.r.t. try_stop_module().
That's why we do the following.

  stop_machine_run(__try_stop_module, &sref, NR_CPUS);.

-- 
tejun
