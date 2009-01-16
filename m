Return-Path: <linux-kernel-owner+w=401wt.eu-S1758354AbZAPD7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354AbZAPD7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 22:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbZAPD7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 22:59:14 -0500
Received: from sandeen.net ([209.173.210.139]:24172 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbZAPD7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 22:59:13 -0500
Message-ID: <4970060E.3080306@sandeen.net>
Date: Thu, 15 Jan 2009 21:59:10 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, t-sato@yk.jp.nec.com
Subject: Re: [PATCH] Allow SysRq emergency sync to thaw frozen filesystems
References: <496EB639.6090800@redhat.com> <20090115162031.a512232b.akpm@linux-foundation.org> <497003CC.8030503@redhat.com>
In-Reply-To: <497003CC.8030503@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Andrew Morton wrote:
>> On Wed, 14 Jan 2009 22:06:17 -0600
>> Eric Sandeen <sandeen@redhat.com> wrote:

...

>>> Index: linux-2.6/drivers/char/sysrq.c
>>> ===================================================================
>>> --- linux-2.6.orig/drivers/char/sysrq.c
>>> +++ linux-2.6/drivers/char/sysrq.c
>>> @@ -151,6 +151,7 @@ static struct sysrq_key_op sysrq_reboot_
>>>  
>>>  static void sysrq_handle_sync(int key, struct tty_struct *tty)
>>>  {
>>> +	emergency_thaw();
>>>  	emergency_sync();
>>>  }
>> Kind of weird.   The thaw will happen after/during the sync().
> 
> oh, hrm.  Maybe I didn't think enough about how it's handed off to
> pdflush; I could rearrange if that makes sense?  Or maybe handing to
> pdflush is wrong, it was just so convenient....
> 
>> I guess that if the sync is blocked on a frozen fs then things will
>> sort themselves out.
>>
>> otoh, if all the pdflush threads are blocked on frozen filesystems
>> (possible?) then the emergency_thaw() simply won't do anything.
> 
> Hm, maybe possible... I'll have to think about that.

Oh, actually, I'd think not.  If the freeze was done properly by the
filesystem, all data was flushed, the fs was quiesced, and new IO was
blocked.  pdflush should never be visiting these...

In fact emergency sync is kind of orthogonal to emergency thaw, anything
which needs a thaw should never actually need a sync.

-Eric

> Thanks,
> -Eric

