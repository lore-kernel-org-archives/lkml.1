Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbZDLLdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbZDLLdg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 07:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbZDLLd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 07:33:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbZDLLdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 07:33:25 -0400
References: <20090411141754.45F7B16080@e179.suse.de> <20090411174905.GH6822@linux.vnet.ibm.com>
Message-Id: <627226E3-0AC6-4B25-A338-EA65F6C85BFF@suse.de>
From: Jan Blunck <jblunck@suse.de>
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20090411174905.GH6822@linux.vnet.ibm.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (5G77)
Mime-Version: 1.0 (iPhone Mail 5G77)
Subject: Re: [PATCH] atomic: Only take lock when the counter drops to zero on UP as well
Date: Sun, 12 Apr 2009 13:32:54 +0200
Cc: Nick Piggin <npiggin@suse.de>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.04.2009 um 19:49 schrieb "Paul E. McKenney" <paulmck@linux.vnet.ibm.com 
 >:

> On Fri, Apr 10, 2009 at 06:13:57PM +0200, Jan Blunck wrote:
>> I think it is wrong to unconditionally take the lock before calling
>> atomic_dec_and_test() in _atomic_dec_and_lock(). This will deadlock  
>> in
>> situation where it is known that the counter will not reach zero  
>> (e.g. holding
>> another reference to the same object) but the lock is already taken.
>
> The thought of calling _atomic_dec_and_lock() when you already hold  
> the
> lock really really scares me.
>
> Could you please give an example where you need to do this?
>

There is a part of the union mount patches that needs to do a  
union_put() (which itself includes a path_put() that uses  
atomic_dec_and_lock() in mntput() ). Since it is changing the  
namespace I need to hold the vfsmount lock. I know that the mnt's  
count > 1 since it is a parent of the mnt I'm changing in the mount  
tree. I could possibly delay the union_put().

In general this let's atomic_dec_and_lock() behave similar on SMP and  
UP. Remember that this already works with CONFIG_SMP as before Nick's  
patch.


>                            Thanx, Paul
>
>> Signed-off-by: Jan Blunck <jblunck@suse.de>
>> ---
>> lib/dec_and_lock.c |    3 +--
>> 1 files changed, 1 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/dec_and_lock.c b/lib/dec_and_lock.c
>> index a65c314..e73822a 100644
>> --- a/lib/dec_and_lock.c
>> +++ b/lib/dec_and_lock.c
>> @@ -19,11 +19,10 @@
>>  */
>> int _atomic_dec_and_lock(atomic_t *atomic, spinlock_t *lock)
>> {
>> -#ifdef CONFIG_SMP
>>    /* Subtract 1 from counter unless that drops it to 0 (ie. it was  
>> 1) */
>>    if (atomic_add_unless(atomic, -1, 1))
>>        return 0;
>> -#endif
>> +
>>    /* Otherwise do it the slow way */
>>    spin_lock(lock);
>>    if (atomic_dec_and_test(atomic))
>> -- 
>> 1.6.0.2
>>
