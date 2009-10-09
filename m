Return-Path: <linux-kernel-owner+w=401wt.eu-S1760352AbZJIJAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760352AbZJIJAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759180AbZJIJAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:00:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403AbZJIJAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:00:44 -0400
Message-ID: <4ACEFC26.3000603@redhat.com>
Date: Fri, 09 Oct 2009 17:02:30 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, Ben Woodard <bwoodard@llnl.gov>,
       akpm@linux-foundation.org, Brian Behlendorf <behlendorf1@llnl.gov>
Subject: Re: [Patch v4] rwsem: fix rwsem_is_locked() bugs
References: <20091008092632.7101.62229.sendpatchset@localhost.localdomain> <19121.1254998734@redhat.com>
In-Reply-To: <19121.1254998734@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Amerigo Wang <amwang@redhat.com> wrote:
> 
>> rwsem_is_locked() tests ->activity without locks, so we should always
>> keep ->activity consistent. However, the code in __rwsem_do_wake()
>> breaks this rule, it updates ->activity after _all_ readers waken up,
>> this may give some reader a wrong ->activity value, thus cause
>> rwsem_is_locked() behaves wrong.
>>
>> Quote from Andrew:
>>
>> "
>> - we have one or more processes sleeping in down_read(), waiting for access.
>>
>> - we wake one or more processes up without altering ->activity
>>
>> - they start to run and they do rwsem_is_locked().  This incorrectly
>>   returns "false", because the waker process is still crunching away in
>>   __rwsem_do_wake().
>>
>> - the waker now alters ->activity, but it was too late.
>> "
>>
>> So we need get a spinlock to protect this. And rwsem_is_locked()
>> should not block, thus we use spin_trylock.
>>
>> Reported-by: Brian Behlendorf <behlendorf1@llnl.gov>
>> Cc: Ben Woodard <bwoodard@llnl.gov>
>> Cc: David Howells <dhowells@redhat.com>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
> I'd say the comment in __rwsem_do_wake() is unnecessary, but other than
> that...


The reason why I added it is to show that we have considered that
case already. :) If you have strong opinions to remove it, I can
update the patch.

> 
> Acked-by: David Howells <dhowells@redhat.com>


Thanks!
