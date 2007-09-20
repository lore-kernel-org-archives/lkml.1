Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbXITIlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbXITIlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbXITIlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:41:24 -0400
Received: from sacred.ru ([62.205.161.221]:50786 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbXITIlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:41:24 -0400
Message-ID: <46F23198.6070004@openvz.org>
Date: Thu, 20 Sep 2007 12:38:48 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Fix potential OOPS in generic_setlease()
References: <46F1317D.6010309@openvz.org> <20070919193001.GH5946@fieldses.org>
In-Reply-To: <20070919193001.GH5946@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 20 Sep 2007 12:41:10 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Wed, Sep 19, 2007 at 06:26:05PM +0400, Pavel Emelyanov wrote:
>> This code is run under lock_kernel(), which is dropped during
>> sleeping operations, so the following race is possible:
>>
>> CPU1:                                CPU2:
>>   vfs_setlease();                    vfs_setlease();
>>   lock_kernel();
>>                                      lock_kernel(); /* spin */
>>   generic_setlease():
>>     ...
>>     for (before = ...)
>>     /* here we found some lease after
>>      * which we will insert the new one
>>      */
>>     fl = locks_alloc_lock();
>>     /* go to sleep in this allocation and
>>      * drop the BKL
>>      */
>>                                      generic_setlease():
>>                                        ...
>>                                        for (before = ...)
>>                                        /* here we find the "before" pointing
>>                                         * at the one we found on CPU1
>>                                         */
>>                                       ->fl_change(my_before, arg);
>>                                               lease_modify();
>>                                                      locks_free_lock();
>>                                                      /* and we freed it */
>>                                      ...
>>                                      unlock_kernel();
>>    locks_insert_lock(before, fl);
>>    /* OOPS! We have just tried to add the lease
>>     * at the tail of already removed one
>>     */
> 
> Thanks for spotting this!
> 
> But--careful-- it looks like "fl" is also used as a temporary variable
> in a loop between the new and old location of that allocation.  Isn't
> that a bug?

OOPS! Good catch, thanks. I will resend the patch shortly.
