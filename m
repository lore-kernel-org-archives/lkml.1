Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbYLWDGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbYLWDGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 22:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYLWDG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 22:06:29 -0500
Received: from mail.windriver.com ([147.11.1.11]:62555 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbYLWDG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 22:06:28 -0500
Message-ID: <49505341.6010304@windriver.com>
Date: Tue, 23 Dec 2008 10:56:01 +0800
From: Harry Ciao <qingtao.cao@windriver.com>
Reply-To: qingtao.cao@windriver.com
Organization: Wind River, CDC
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net,
       Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 1/1] EDAC: fix edac core deadlock when removing a device
References: <1229576958-8037-1-git-send-email-qingtao.cao@windriver.com>	<1229576958-8037-2-git-send-email-qingtao.cao@windriver.com> <20081218144342.4f033416.akpm@linux-foundation.org>
In-Reply-To: <20081218144342.4f033416.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Dec 2008 03:07:23.0526 (UTC) FILETIME=[93996A60:01C964AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks for your response!

I think the change to edac_device_workq_function() is necessary, because 
edac_device_workq_teardown()'s call to cancel_delayed_work() won't 
ensure that the work won't be running, that's why it has to go on to 
call flush_workqueue() when cancel_delayed_work() returns zero, when the 
work has been added to edac_workqueue already, so the whole 
edac_workqueue has to be flushed to make sure this work completes before 
the edac device it belongs to could be safely removed.

I also add a printk to edac_device_workq_function():

static void edac_device_workq_function(struct work_struct *work_req)
{
struct delayed_work *d_work = (struct delayed_work *)work_req;
struct edac_device_ctl_info *edac_dev = to_edac_device_ctl_work(d_work);

mutex_lock(&device_ctls_mutex);

/* If we are being removed, bail out immediately */
if (edac_dev->op_state == OP_OFFLINE) {
printk(KERN_CRIT "+++HARRY+++ edac device is being removed, bail out 
from work!\n");
mutex_unlock(&device_ctls_mutex);
return;
}

/* Only poll controllers that are running polled and have a check */
if ((edac_dev->op_state == OP_RUNNING_POLL) &&
(edac_dev->edac_check != NULL)) {
edac_dev->edac_check(edac_dev);
}

mutex_unlock(&device_ctls_mutex);
...

and do a test to run pairs of insmod/rmmod about 10 times, as you could 
see from below logs that 2/10 chances that the work is running by 
edac_poller worker thread:

root@localhost:/root> insmod mv64x60_edac.ko
root@localhost:/root> rmmod mv64x60_edac.ko
root@localhost:/root> insmod mv64x60_edac.ko
root@localhost:/root> rmmod mv64x60_edac.ko
root@localhost:/root> insmod mv64x60_edac.ko
root@localhost:/root> rmmod mv64x60_edac.ko
root@localhost:/root> insmod mv64x60_edac.ko
root@localhost:/root> rmmod mv64x60_edac.ko
root@localhost:/root> insmod mv64x60_edac.ko
root@localhost:/root> rmmod mv64x60_edac.ko
+++HARRY+++ edac device is being removed, bail out from work!
root@localhost:/root> insmod mv64x60_edac.ko
root@localhost:/root> rmmod mv64x60_edac.ko
root@localhost:/root> insmod mv64x60_edac.ko
root@localhost:/root> rmmod mv64x60_edac.ko
root@localhost:/root> insmod mv64x60_edac.ko
root@localhost:/root> rmmod mv64x60_edac.ko
+++HARRY+++ edac device is being removed, bail out from work!
root@localhost:/root> insmod mv64x60_edac.ko
root@localhost:/root> rmmod mv64x60_edac.ko
root@localhost:/root> insmod mv64x60_edac.ko
root@localhost:/root> rmmod mv64x60_edac.ko
root@localhost:/root>

So edac_device_workq_function() should bail out immediately if the edac 
device that current work belongs to is being removed.

Best regards and Merry Chrismas!

Harry


Andrew Morton 写道:
> On Thu, 18 Dec 2008 13:09:18 +0800
> Harry Ciao <qingtao.cao@windriver.com> wrote:
>
>   
>> To remove an edac device, all pending work must be complete. At that point, 
>> it is safe to remove the edac_dev structure.
>>
>> If the pending work is not properly cleared and proper care is not taken 
>> when waiting for it's completion, the following stack trace result:
>>
>> ...
>>
>> --- a/drivers/edac/edac_device.c
>> +++ b/drivers/edac/edac_device.c
>> @@ -394,6 +394,12 @@ static void edac_device_workq_function(struct work_struct *work_req)
>>  
>>  	mutex_lock(&device_ctls_mutex);
>>  
>> +	/* If we are being removed, bail out immediately */
>> +	if (edac_dev->op_state == OP_OFFLINE) {
>> +		mutex_unlock(&device_ctls_mutex);
>> +		return;
>> +	}
>> +
>>  	/* Only poll controllers that are running polled and have a check */
>>  	if ((edac_dev->op_state == OP_RUNNING_POLL) &&
>>  		(edac_dev->edac_check != NULL)) {
>> @@ -585,14 +591,14 @@ struct edac_device_ctl_info *edac_device_del_device(struct device *dev)
>>  	/* mark this instance as OFFLINE */
>>  	edac_dev->op_state = OP_OFFLINE;
>>  
>> -	/* clear workq processing on this instance */
>> -	edac_device_workq_teardown(edac_dev);
>> -
>>  	/* deregister from global list */
>>  	del_edac_device_from_global_list(edac_dev);
>>  
>>  	mutex_unlock(&device_ctls_mutex);
>>  
>> +	/* clear workq processing on this instance */
>> +	edac_device_workq_teardown(edac_dev);
>> +
>>  	/* Tear down the sysfs entries for this instance */
>>  	edac_device_remove_sysfs(edac_dev);
>>  
>>     
>
> Is the change to edac_device_workq_function() necessary? 
> edac_device_workq_teardown()'s call to cancel_delayed_work() will
> ensure that edac_device_workq_function() isn't running.
>
> Incidentally, edac_device_workq_teardown() is an open-coded
> cancel_delayed_work_sync().
>
>
>   

