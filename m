Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbYIJS6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbYIJS6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 14:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbYIJS6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 14:58:45 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:49470 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYIJS6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 14:58:45 -0400
Message-ID: <48C8182F.5090008@cs.columbia.edu>
Date: Wed, 10 Sep 2008 14:55:43 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: containers@lists.linux-foundation.org, jeremy@goop.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC v4][PATCH 9/9] File descriprtors (restore)
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>	 <1220946154-15174-10-git-send-email-orenl@cs.columbia.edu>	 <1220977581.23386.216.camel@nimitz>  <48C727B6.9000700@cs.columbia.edu> <1221062969.6781.5.camel@nimitz>
In-Reply-To: <1221062969.6781.5.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dave Hansen wrote:
> On Tue, 2008-09-09 at 21:49 -0400, Oren Laadan wrote:
>> Dave Hansen wrote:
>>> On Tue, 2008-09-09 at 03:42 -0400, Oren Laadan wrote:
>>>> +static int cr_close_all_fds(struct files_struct *files)
>>>> +{
>>>> +       int *fdtable;
>>>> +       int n;
>>>> +
>>>> +       do {
>>>> +               n = cr_scan_fds(files, &fdtable);
>>>> +               if (n < 0)
>>>> +                       return n;
>>>> +               while (n--)
>>>> +                       sys_close(fdtable[n]);
>>>> +               kfree(fdtable);
>>>> +       } while (n != -1);
>>>> +
>>>> +       return 0;
>>>> +}
>>> This needs to use an ERR_PTR().  It will save using the double-pointer.
>> I suppose you refer to the call to cr_scan_fds(): either 'fdtable'
>> or 'n' will have to pass-by-reference. Is it that you prefer it to be
>> 	fdtable = cr_scan_fds(files, &n);
>> ?
> 
> I was misreading the use of 'n'.  Can you really not use close_files()
> for this operation?  You'd need to add some locking around it, but I
> think it does what you need here.

I thought about that. However, close_files() assumes that the files_struct
will be discarded thereafter, so it does not reset ->fd_open->fd_bits[] bits,
does not adjust ->next_fd field, and does not use rcu_assign_pointer(). And
then, even if we adjust, we'll have to watch future differences between
sys_close() and close_files(), so using sys_close() is more future-proof.

Besides, cr_scan_fds() is used by the checkpoint logic already, so it's easy
to reuse for restart as well.

Oren.
