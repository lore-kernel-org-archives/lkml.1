Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYKDKz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYKDKz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 05:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYKDKzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 05:55:14 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:42156 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbYKDKzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 05:55:12 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
       "Koyama, Yoshiya" <Yoshiya.Koyama@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-fsdevel@vger.kernel.org
References: <19f34abd0810251014s7968557br38e43aa0b9cdcf09@mail.gmail.com>
	<200810252241.53601.rjw@sisk.pl> <m163nggvhq.fsf@frodo.ebiederm.org>
	<19f34abd0810261408w61b1e2dbvb9a0e16ce5a10022@mail.gmail.com>
	<19f34abd0811040139t8334502i7a5d8501c5fe95ac@mail.gmail.com>
	<20081104100050.GA10398@x200.localdomain>
Date: Tue, 04 Nov 2008 02:54:35 -0800
In-Reply-To: <20081104100050.GA10398@x200.localdomain> (Alexey Dobriyan's
	message of "Tue, 4 Nov 2008 13:00:50 +0300")
Message-ID: <m1hc6nbw2c.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexey Dobriyan <adobriyan@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XMLngstWrd_00 words over 45 charachters don't exist
	*  0.8 XMLngstWrd_01 words over 55 charachters don't exist
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  1.0 XMLngstWrd_02 words over 65 charachters don't exist
	*  1.5 XMLngstWrd_03 words over 75 charachters don't exist
Subject: Re: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data to userspace
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

> On Tue, Nov 04, 2008 at 10:39:19AM +0100, Vegard Nossum wrote:
>> # uname -a
>> Linux ubuntu 2.6.28-rc2-next-20081031 #60 SMP Sat Nov 1 13:19:49 CET
>> 2008 i686 GNU/Linux
>> # prelink -mRf /sbin/udevd
>> # ./a.out /proc/4764/exe
>> warning: /proc/4764/exe: got return value 38, expected 11
>> 2f7362696e2f756465766400fffffffffdfffffffffffff7ffffbfff202864656c6574656429
>> /sbin/udevd                  (deleted)
>
> reproduced
>
> As I said previously, kmemcheck rocks (slowly). :-)

It is reproducible here as well.  At least to the point of the
strange readlink length.

prelink generates a new executable and renames it on top
of the old executable.  So I'm guessing something on the unlink
and rename path is what is giving us the strange length.

Hmm.  The string: '/sbin/udevd.#prelink#.J9NyXV (deleted)'
is 38 bytes long...   So I'm guessing d_move is doing something
wrong and we are not seeing the name string we expect.

Why do we see /sbin/udevd and not /sbin/udevd.#prelink#.J9NyXV 
after d_move.  It looks like both names are short enough that
they are inline.

Oh.  I see.  switch_names when both names are internal,
does a memcpy of the new name to the target name,
but it doesn't do anything with the source name.
Then later we swap the name lengths.

So the length on the dentry no longer matches the data
we put in the buffer.

Certainly not a resource leak or any kind of deadlock.
And the length is right.  But it is an information leak.

I suppose a clever person could figure out how to steal
information that way.

The nice fix would be to keep the old length in this case,
so we don't have a name mangled because someone renamed
on top of us.  But that is inconsistent.


Eric

