Return-Path: <linux-kernel-owner+w=401wt.eu-S1764944AbXHOOes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764944AbXHOOes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758911AbXHOOeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:34:25 -0400
Received: from smtpout.mac.com ([17.250.248.184]:55549 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758670AbXHOOeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:34:24 -0400
In-Reply-To: <Pine.LNX.4.64.0708151604360.15707@fbirervta.pbzchgretzou.qr>
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org> <20070814232107.GA4265@aurum.uhlenkott.net> <Pine.LNX.4.64.0708150928200.19270@fbirervta.pbzchgretzou.qr> <46C2BB60.6010909@gmail.com> <Pine.LNX.4.64.0708151113410.19270@fbirervta.pbzchgretzou.qr> <46C2CE42.4010303@gmail.com> <Pine.LNX.4.64.0708151217120.5639@fbirervta.pbzchgretzou.qr> <5D056606-6284-4331-98DB-77123816D5B8@mac.com> <Pine.LNX.4.64.0708151604360.15707@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <912C3FD2-3B6D-4328-8485-657F63CC6552@mac.com>
Cc: Rene Herman <rene.herman@gmail.com>,
       Jason Uhlenkott <jasonuhl@jasonuhl.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: kfree(0) - ok?
Date: Wed, 15 Aug 2007 10:34:10 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 15, 2007, at 10:06:49, Jan Engelhardt wrote:
> On Aug 15 2007 09:58, Kyle Moffett wrote:
>> Irrespective of whatever the standard says, EVERY platform and  
>> compiler anybody makes nowadays has a NULL pointer value with all  
>> bits clear.  Theoretically the standard allows otherwise, but such  
>> a decision would break so much code.  Linux especially, we rely on  
>> the uninitialized data to have all bits clear and we depend on  
>> that producing NULL pointers; if a NULL pointer was not bitwise  
>> exactly 0 then the test "if (some_ptr != NULL)" would fail and we  
>> would start dereferencing garbage.
>
> But if kmalloc returns NULL on failure, then testing for NULL  
> (irrespective of being 0 or 0xDEADBEEF) is ok.  What would actually  
> concern me then is what "if (!some_ptr)" would do. Probably not the  
> right thing.

Well, what I was referring to is:

static struct foo *some_ptr;

/* Assumes that $SOME_LOCK is held */
int initialize_foo_module()
{
	if (!some_ptr) {
		some_ptr = kmalloc(sizeof(*some_ptr));
		if (!some_ptr)
			return -ENOMEM;

		/* ... */
	}

	/* ... */
}


We initialize all of the static data to all-bits-clear zeros during  
kernel init.  Any platform on which the binary representations of  
"(unsigned long)0" and "(void *)0" are different (even in length, due  
to other issues) will not run the Linux kernel as it stands today.

And as to the sizeof(unsigned long) == sizeof(void *) issue, please  
remember that every Linux compiler is either ILP32 (int, long, and  
pointer are 32-bit) or LP64 (int is 32-bit and long/pointer are 64- 
bit).  We sort of fundamentally rely on these properties in code all  
over the place.

So yes the Linux kernel "breaks the standard" in a bunch of places,  
but on the other hand we're not your average software and we don't  
have to worry about building on an LLP64 compiler (Windows 64-bit and  
some UNIXes) or other strangeness.

Cheers,
Kyle Moffett

