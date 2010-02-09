Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab0BITax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:30:53 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41243 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab0BITav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:30:51 -0500
Message-ID: <4B71B7D9.9040501@cs.wisc.edu>
Date: Tue, 09 Feb 2010 13:30:33 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Tao Ma <tao.ma@oracle.com>
CC: open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: lockdep warning for iscsi in 2.6.33-rc6
References: <4B7107CF.3060703@oracle.com>
In-Reply-To: <4B7107CF.3060703@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2010 12:59 AM, Tao Ma wrote:
> Hi Mike,
> I meet with a lockdep warning for iscsi in 2.6.33-rc6.
> the lockdep is attached.
>

If the lockdep output is saying that there is a problem with the iscsi 
host taking its mutex then the scsi host mutex, I think that might be a 
mistake in the lockdep detection. We always take the iscsi host mutex 
then take the scsi host mutex.

Could it get confused if we are scanning two hosts at the same time? If 
it is just looking at if a lock is being taken then it would look like 
host1 has its ihost->mutex and then took its shost->mutex, but then 
host2 could start to get scanned at the same time, and it is going to 
take its ihost->mutex. It would then look like we are trying to grab a 
ihost->mutex while holding a shost->mutex. However, the mutexs are not 
global and they are different instances of the mutex because each host 
has its own.

If that is not the problem, maybe it has something to do with some sysfs 
lock and ata doing scanning while iscsi is.
