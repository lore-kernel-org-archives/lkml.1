Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbYKEKuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbYKEKuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 05:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbYKEKub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 05:50:31 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:48802 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbYKEKua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 05:50:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RVa+q6yAP4QdKHtADroMvquP3UtLb3dy+GkpU6MydhqPa0fevRLXmQ0xuVq499ITVy
         qUw+fEeU8bq5DKHPjxIt2bZqhNZrlNZpst3Ao2jwd24KWu2dc2/Dsug/ssH70PzBYcB9
         ixhVL/OXd1Z+Swc8JfoABDAPOI4w4MLFsfedA=
Message-ID: <c62985530811050250u638c8f95j7d80a13f834b06bf@mail.gmail.com>
Date: Wed, 5 Nov 2008 11:50:29 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing: use raw spinlocks instead of spinlocks
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081104120355.GA19969@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490E3F73.1000405@gmail.com>
	 <alpine.DEB.1.10.0811021940030.32371@gandalf.stny.rr.com>
	 <20081103064647.GA4826@elte.hu>
	 <c62985530811031803o6909518ax137d42189dcff0de@mail.gmail.com>
	 <20081104094341.GO23790@elte.hu>
	 <c62985530811040314o13394d43t201ae3fc2f1304be@mail.gmail.com>
	 <20081104120355.GA19969@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/4 Ingo Molnar <mingo@elte.hu>:
> just make sure normal printk is totally silent. (otherwise you get
> double lines on the console plus no reduction in recursion risk)
>
> i usually add a return; hack to kernel/printk.c:printk(), to make sure
> it never executes anything. (and add a notrace to it as well) Maybe we
> could even make this dependent on early_printk=...,keep.

Thanks for your help!

I tried the earlyprintk=vga,keep and I thought that the normal printk
output would
be replaced by early_printk output but that's not the case...
So I replaced the content of printk by this of early_printk and it worked.
But it seems that after the setting of the console, the early_printk
doesn't work anymore.

Should I disable something else? I haven't any console=.... parameter
but I guess I missed
something there...

But, I set the parameter nmi_watchdog=2 (I didn't know I had to start
explicitly the nmi watchdog)
and at last... I had my backtraces :-)

All these backtraces were related to time function. And one of the
special things of the time functions
is that they often manipulate 64 bits numbers. Actually I totally
forgot that a function could return a
long long, so I had to save edx register in the return handler to
restore it in its end because 64 bits
numbers are returned as a couple into eax and edx in x86-32.

So the main problem is now solved. But it remains a last (but more
rare) deadlock somewhere. I don't
know why at this time and the nmi watchdog doesn't tell anything. So I
will have to use early_printk
to see the last functions traced. But the problem is that it doesn't
print on the console...
